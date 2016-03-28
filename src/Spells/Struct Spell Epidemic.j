/// Necromancer
library StructSpellsSpellEpidemic requires Asl, StructGameClasses, StructGameSpell

	/// Alle Gegner im Einflussbereich erleiden alle 2 Sekunden X Punkte Schaden. Stirbt ein Gegner durch diese Fähigkeit, so breitet sich der Effekt auf weitere Gegner im Umkreis aus.
	struct SpellEpidemic extends Spell
		public static constant integer abilityId = 'A13N'
		public static constant integer favouriteAbilityId = 'A13O'
		public static constant integer classSelectionAbilityId = 'A1KP'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KQ'
		public static constant integer maxLevel = 1
		private static constant real time = 30.0
		private static constant real interval = 2.0
		private static constant real damage = 50.0
		private static constant real range = 600.0
		private static constant integer damageStartValue = 5
		private static constant integer damageLevelFactor = 5
		private trigger m_deathTrigger
		private AGroup m_targets
		
		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit) and not IsUnitType(filterUnit, UNIT_TYPE_MECHANICAL)
			set filterUnit = null
			return result
		endmethod
		
		private static method checkTarget takes unit caster, unit target returns boolean
			return GetUnitAllianceStateToUnit(caster, target) == bj_ALLIANCE_UNALLIED and not IsUnitSpellImmune(target) and not IsUnitDeadBJ(target)
		endmethod
		
		private method targets takes unit caster, real x, real y returns AGroup
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local integer i
			local unit target
			call GroupEnumUnitsInRange(targetGroup, x, y, thistype.range, filter)
			if (not IsUnitGroupEmptyBJ(targetGroup)) then
				call targets.addGroup(targetGroup, true, false) //destroys the group
				set targetGroup = null
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					if (not thistype.checkTarget(caster, target)) then
						call targets.units().erase(i)
					else
						set i = i + 1
					endif
					set target = null
				endloop
			else
				call DestroyGroup(targetGroup)
				set targetGroup = null
			endif
			call DestroyFilter(filter)
			set filter = null
			
			return targets
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets(GetTriggerUnit(), GetSpellTargetX(), GetSpellTargetY())
			local boolean result = not targets.units().isEmpty()
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine gültigen Ziele im Gebiet.", "No valid targets in area."))
			endif
			call targets.destroy()
			
			return result
		endmethod

		private method action takes nothing returns nothing
			local real damage = thistype.damage
			local real time = thistype.time
			local integer i
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, GetTriggerUnit(), "origin")
			if (this.m_targets != 0) then
				call this.m_targets.destroy()
			endif
			set this.m_targets = this.targets(GetTriggerUnit(), GetSpellTargetX(), GetSpellTargetY())
			loop
				exitwhen (time <= 0.0)
				set i = 0
				loop
					exitwhen (i == this.m_targets.units().size())
					if (thistype.checkTarget(GetTriggerUnit(), this.m_targets.units()[i])) then
						call DestroyEffect(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, this.m_targets.units()[i], "origin"))
						call UnitDamageTargetBJ(GetTriggerUnit(), this.m_targets.units()[i], damage, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL)
						call ShowBashTextTagForPlayer(null, GetUnitX(this.m_targets.units()[i]), GetUnitY(this.m_targets.units()[i]), R2I(damage))
						set i = i + 1
					else
						call this.m_targets.units().erase(i)
					endif
				endloop
				call TriggerSleepAction(thistype.interval)
				set time = time - thistype.interval
			endloop
			call this.m_targets.destroy()
			set this.m_targets = 0
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod
		
		private static method triggerConditionDeath takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return this.m_targets != 0 and this.m_targets.units().contains(GetTriggerUnit())
		endmethod
		
		private static method triggerActionDeath takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AGroup newTargets = this.targets(this.character().unit(), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
			if (not newTargets.units().isEmpty()) then
				/*
				 * Even if the spell has ended the targets can be added since they won't be recognized by the time action anymore.
				 * In the next cast m_targets will be destroyed anyway so it is safe to always add the new targets.
				 */
				call this.m_targets.addOther(newTargets)
			endif
			call newTargets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEvent(character, Classes.necromancer(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call DmdfHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
			set this.m_targets = 0
			
			call this.addGrimoireEntry('A1KP', 'A1KQ')
			call this.addGrimoireEntry('A13P', 'A13Q')
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null
			if (this.m_targets != 0) then
				call this.m_targets.destroy()
			endif
		endmethod
	endstruct

endlibrary