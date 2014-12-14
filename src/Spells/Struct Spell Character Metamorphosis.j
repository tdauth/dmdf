/// Metamorphosis
library StructSpellsSpellCharacterMetamorphosis requires Asl, StructSpellsSpellMetamorphosis

	/**
	 * \brief Generic abstract spell for metamorphosis.
	 * 
	 * Uses \ref EVENT_UNIT_SPELL_CHANNEL to be executed before the unit is morphed to successfully store the inventory items.
	 * 
	 * Besides it uses \ref EVENT_UNIT_HERO_REVIVE_FINISH to unmorph the character when being revived unmorphed.
	 * 
	 * \note All morph spells need a short delay in which \ref Character#morph() can be called which stores spells and items safely!
	 */
	struct SpellMetamorphosis extends ASpell
		private integer m_unitTypeId
		private trigger m_channelTrigger
		private trigger m_revivalTrigger
		private boolean m_isMorphed
		
		public method setUnitTypeId takes integer unitTypeId returns nothing
			set this.m_unitTypeId = unitTypeId
		endmethod
		
		public method unitTypeId takes nothing returns integer
			return this.m_unitTypeId
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		// Called with .evaluate()
		public stub method canMorph takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		// Called with .evaluate()
		public stub method canRestore takes nothing returns boolean
			return false
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
		endmethod
		
		public static method waitForRestoration takes unit whichUnit, integer unitTypeId returns nothing
			loop
				debug call Print("Checking if unit is no more: " + GetObjectName(unitTypeId) + ": " + I2S(unitTypeId))
				exitwhen (GetUnitTypeId(whichUnit) != unitTypeId)
				call TriggerSleepAction(1.0)
			endloop
		endmethod
		
		public static method waitForMorph takes unit whichUnit, integer unitTypeId returns nothing
			loop
				exitwhen (GetUnitTypeId(whichUnit) == unitTypeId)
				call TriggerSleepAction(1.0)
			endloop
		endmethod
		
		private static method triggerConditionStart takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			debug call Print("Condition Start. Waiting for spell: " + GetObjectName(this.ability()))
			return GetSpellAbilityId() == this.ability()
		endmethod
		
		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			// morph
			if (not Character(this.character()).isMorphed()) then
				if (this.canMorph.evaluate()) then
					debug call Print("Morph with spell: " + GetAbilityName(this.ability()))
					debug if (GetUnitTypeId(this.character().unit()) == this.unitTypeId()) then
						debug call Print("Error: Already morphed!")
					debug endif
					call Character(this.character()).morph(this.ability())
					call this.onMorph.execute()
				else
					call IssueImmediateOrder(this.character().unit(), "stop")
				endif
			// restore
			else
				if (this.canRestore.evaluate()) then
					debug call Print("Waiting for restoration")
					call thistype.waitForRestoration(this.character().unit(), this.unitTypeId())
					debug call Print("Restore from morph with spell: "  + GetAbilityName(this.ability()))
					call Character(this.character()).restoreUnit()
					call this.onRestore.execute()
				else
					call IssueImmediateOrder(this.character().unit(), "stop")
				endif
			endif
		endmethod
		
		private static method triggerConditionRevival takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			debug call Print("Revival!")
			return this.isMorphed()
		endmethod
		
		public static method create takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction  returns thistype
			local thistype this = thistype.allocate(character, class, spellType, maxLevel, abilityId, favouriteAbility, upgradeAction, castCondition, castAction)
			set this.m_unitTypeId = 0
			
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterUnitEvent(this.m_channelTrigger, this.character().unit(), EVENT_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionStart))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, "this", this)
			
			// unmorph unit if it is being revived and has been morphed
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_revivalTrigger, this.character().unit(), EVENT_UNIT_HERO_REVIVE_FINISH)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_channelTrigger)
			set this.m_channelTrigger = null
			call AHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
		endmethod
	endstruct

endlibrary