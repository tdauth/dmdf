/// Elemental Mage
library StructSpellsSpellInferno requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Auf dem Boden unter dem Magier entsteht ein Flammenmeer, das Gegner für X/Sekunde verbrennt.
	struct SpellInferno extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01A'
		public static constant integer favouriteAbilityId = 'A03N'
		public static constant integer classSelectionAbilityId = 'A1LR'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LS'
		public static constant integer maxLevel = 5
		private static constant real time = 6.0
		private static constant real radius = 400.0
		private static constant real damageStartValue = 20.0
		private static constant real damageLevelValue = 10.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local real time = thistype.time
			local group targets = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local unit firstOfGroup
			local real damage = thistype.damageStartValue + thistype.damageLevelValue * this.level()
			local real newDamage
			loop
				exitwhen (time <= 0.0 or AUnitSpell.allyTargetLoopCondition(caster))
				call GroupEnumUnitsInRange(targets, GetUnitX(caster), GetUnitY(caster), thistype.radius, filter)
				loop
					exitwhen (IsUnitGroupEmptyBJ(targets))
					set firstOfGroup = FirstOfGroupSave(targets)
					if (GetUnitAllianceStateToUnit(caster, firstOfGroup) == bj_ALLIANCE_UNALLIED) then
						//Zeit vergeht - Schaden neu berechnen
						set newDamage = damage + damage * SpellElementalMageDamageSpell(this).damageBonusFactor()
						call UnitDamageTargetBJ(caster, firstOfGroup, newDamage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
						call ShowBashTextTagForPlayer(null, GetWidgetX(firstOfGroup), GetWidgetY(firstOfGroup), R2I(newDamage))
					endif
					call GroupRemoveUnit(targets, firstOfGroup)
					set firstOfGroup = null
				endloop
				call GroupClear(targets)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyGroup(targets)
			set targets = null
			call DestroyFilter(filter)
			set filter = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEventDamageSpell(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			call this.addGrimoireEntry('A1LR', 'A1LS')
			call this.addGrimoireEntry('A0KF', 'A0KK')
			call this.addGrimoireEntry('A0KG', 'A0KL')
			call this.addGrimoireEntry('A0KH', 'A0KM')
			call this.addGrimoireEntry('A0KI', 'A0KN')
			call this.addGrimoireEntry('A0KJ', 'A0KO')

			return this
		endmethod
	endstruct

endlibrary