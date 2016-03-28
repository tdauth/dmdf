/// Wizard
library StructSpellsSpellAbsorbation requires Asl, StructGameClasses, StructGameSpell

	/// Ultimatum 1: Passiv. Immer wenn ein gegnerischer Zauber im Umkreis von X gewirkt wird, stellt der Zauberer 5% seines und 2% des Manas von Verbündeten in diesem Umkreis wieder her.
	struct SpellAbsorbation extends Spell
		public static constant integer abilityId = 'A03C'
		public static constant integer favouriteAbilityId = 'A03D'
		public static constant integer classSelectionAbilityId = 'A1J6'
		public static constant integer classSelectionGrimoireAbilityId = 'A1J7'
		public static constant integer maxLevel = 1
		private static constant integer buffId = 'B00I'
		private static constant real range = 800.0
		private static constant real selfManaValue = 0.05
		private static constant real otherManaValue = 0.02
		private trigger m_spellTrigger

		private static method triggerConditionSpell takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, 0)
			local boolean result = this.level() > 0 and GetUnitAllianceStateToUnit(this.character().unit(), GetTriggerUnit()) != bj_ALLIANCE_ALLIED and GetDistanceBetweenUnits(this.character().unit(), GetTriggerUnit(), 0.0, 0.0) <= thistype.range
			//debug call Print("Running condition of spell \"Absorbation\".")
			//debug if (result) then
			//	debug call Print("Result is true.")
			//debug else
			//	debug call Print("Result is false.")
			//debug endif
			set triggeringTrigger = null
			return result
		endmethod

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		private static method triggerActionSpell takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, 0)
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local real mana
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local unit firstOfGroup
			local AEffectVector effects = AEffectVector.create()
			local integer i
			debug call Print("Running absorbation effect")
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			set mana = GetUnitState(caster, UNIT_STATE_MAX_MANA) * thistype.selfManaValue
			call SetUnitState(caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MANA) + mana)
			debug call Print("Getting " + R2S(mana) + " mana.")
			call Spell.showManaTextTag(caster, mana)
			loop
				exitwhen (IsUnitGroupEmptyBJ(targetGroup))
				set firstOfGroup = FirstOfGroupSave(targetGroup)
				if (GetUnitAllianceStateToUnit(caster, firstOfGroup) == bj_ALLIANCE_ALLIED and GetUnitState(firstOfGroup, UNIT_STATE_MAX_MANA) > 0.0 and firstOfGroup != caster) then
					set mana = GetUnitState(firstOfGroup, UNIT_STATE_MAX_MANA) * thistype.otherManaValue
					debug call Print(GetUnitName(firstOfGroup) + " gets " + R2S(mana) + " mana.")
					call SetUnitState(firstOfGroup, UNIT_STATE_MANA, GetUnitState(firstOfGroup, UNIT_STATE_MANA) + mana)
					call Spell.showManaTextTag(firstOfGroup, mana)
					call effects.pushBack(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, firstOfGroup, "chest"))
				endif
				call GroupRemoveUnit(targetGroup, firstOfGroup)
				set firstOfGroup = null
			endloop
			call TriggerSleepAction(1.0)
			debug call Print("Absorbation destruction.")
			set i = effects.backIndex()
			loop
				exitwhen (i < 0)
				call DestroyEffect(effects.back())
				call effects.popBack()
				set i = i - 1
			endloop
			set triggeringTrigger = null
			set caster = null
			call DestroyGroup(targetGroup)
			set targetGroup = null
			call effects.destroy()
		endmethod

		private method createCastTrigger takes nothing returns nothing
			set this.m_spellTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_spellTrigger, EVENT_PLAYER_UNIT_SPELL_EFFECT)
			call TriggerAddCondition(this.m_spellTrigger, Condition(function thistype.triggerConditionSpell))
			call TriggerAddAction(this.m_spellTrigger, function thistype.triggerActionSpell)
			call DmdfHashTable.global().setHandleInteger(this.m_spellTrigger, 0, this)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.createCastTrigger()
			call this.addGrimoireEntry('A1J6', 'A1J7')
			call this.addGrimoireEntry('A0C4', 'A0C5')
			
			call this.setIsPassive(true)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_spellTrigger)
			set this.m_spellTrigger = null
		endmethod
	endstruct

endlibrary