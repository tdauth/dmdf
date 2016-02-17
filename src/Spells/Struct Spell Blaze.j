/// Elemental Mage
library StructSpellsSpellBlaze requires Asl, StructSpellsSpellElementalMageDamageSpell

	// Feuersbrunst
	struct SpellBlaze extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01E'
		public static constant integer favouriteAbilityId = 'A03L'
		public static constant integer classSelectionAbilityId = 'A0U1'
		public static constant integer classSelectionGrimoireAbilityId = 'A0U6'
		public static constant integer maxLevel = 5
		private static constant real radius = 300.0
		private static constant real damageStartValue = 20.0
		private static constant real damageLevelValue = 10.0
		private static constant real damageLevelBonus = 2.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod
		
		private method targets takes nothing returns AGroup
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local integer i
			local unit target
			call GroupEnumUnitsInRange(targetGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.radius, filter)
			call targets.addGroup(targetGroup, true, false)
			set i = 0
			loop
				exitwhen (i == targets.units().size())
				set target = targets.units().at(i)
				if (GetUnitAllianceStateToUnit(caster, target) == bj_ALLIANCE_UNALLIED) then
					set i = i + 1
				else
					call targets.units().erase(i)
				endif
				set target = null
			endloop
			
			set caster = null
			set targetGroup = null
			call DestroyFilter(filter)
			set filter = null
			
			return targets
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets()
			local boolean result = not targets.units().isEmpty()
			
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine gültigen Ziele.", "No valid targets."))
			endif
			
			call targets.destroy()
			
			return result
		endmethod

		/// Eine Feuersbrunst erfasst ein Gebiet mit einem Durchmesser von 30 Metern und fügt Feinden in diesem Gebiet X Punkte Schaden plus Y Punkte Schaden für jeden Gegner, den sie erfasst, zu. 3 Minuten Abklingzeit.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AGroup targets = this.targets()
			local AEffectVector spellEffects = AEffectVector.create()
			local unit target
			local real damage = thistype.damageStartValue + this.level() * thistype.damageLevelValue + this.level() * thistype.damageLevelBonus * targets.units().size()
			local integer i = 0
			loop
				exitwhen (i == targets.units().size())
				set target = targets.units().at(i)
				call UnitDamageTargetBJ(caster, target, damage + this.damageBonusFactor() * damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
				call ShowBashTextTagForPlayer(null, GetWidgetX(target), GetWidgetY(target), R2I(damage))
				call spellEffects.pushBack(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest"))
				set target = null
				set i = i + 1
			endloop
			call TriggerSleepAction(1.0)
			set i = spellEffects.backIndex()
			loop
				exitwhen (i < 0)
				call DestroyEffect(spellEffects[i])
				call spellEffects.popBack()
				set i = i - 1
			endloop
			call targets.destroy()
			call spellEffects.destroy()
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEventDamageSpell(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			call this.addGrimoireEntry('A0U1', 'A0U6')
			call this.addGrimoireEntry('A0U2', 'A0U7')
			call this.addGrimoireEntry('A0U3', 'A0U8')
			call this.addGrimoireEntry('A0U4', 'A0U9')
			call this.addGrimoireEntry('A0U5', 'A0UA')
			
			return this
		endmethod
	endstruct

endlibrary