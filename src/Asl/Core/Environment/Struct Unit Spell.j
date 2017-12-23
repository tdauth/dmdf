/// This library contains the \ref AUnitSpell structure which is used for custom unit spells.
library AStructCoreEnvironmentUnitSpell requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreEnvironmentUnit

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellUpgradeAction takes AUnitSpell spell, integer level returns nothing

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellCastCondition takes AUnitSpell spell returns boolean

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellCastAction takes AUnitSpell spell returns nothing

	/**
	 * \brief This struct represents exactly one spell which can be cast by any unit on the map and has a specific ability ID.
	 *
	 * It allows to define custom callbacks for the upgrade and cast events.
	 * The unit event for casting the spell can be specified on construction.
	 *
	 * The condition \ref onCastCondition() is evaluated when the event \ref EVENT_PLAYER_UNIT_SPELL_CHANNEL is fired since the casting unit has to be stopped before it uses
	 the mana for the spell, if the spell cannot be cast.
	 *
	 * When the user-specified event is fired and the condtion returned true before, the action \ref onCastAction() is executed.
	 *
	 * You can specify in the constructor which kind of callbacks you want to use. If you disable one, no trigger will be created which safes some performance and memory.
	 *
	 * \todo Fix that sometimes the mana is used although the unit is stopped (The Power of Fire).
	 */
	struct AUnitSpell
		// construction members
		private integer m_ability
		private AUnitSpellUpgradeAction m_upgradeAction
		private AUnitSpellCastCondition m_castCondition
		private AUnitSpellCastAction m_castAction
		// members
		/**
		 * This trigger is called when the hero ability is skilled.
		 * It only works if the ability is a hero ability.
		 */
		private trigger m_upgradeTrigger
		/**
		 * The channel trigger is used to check the condition first and stop the unit if the condition is not fullfilled.
		 * In this case \ref m_canCast is set to false and therefore the cast trigger blocks the action. It is important that the channel trigger
		 * is always run before the cast trigger since the cast trigger might have the same event.
		 */
		private trigger m_channelTrigger
		private trigger m_castTrigger
		/*
		 * Flag which stores if the spell can even be cast.
		 * This flag is set on the channel event from the condition.
		 * It is checked in the cast trigger.
		 */
		private boolean m_canCast
		/**
		 * Flag which stores if the channel trigger has already been run for a check. This is required for debugging to check whether the condition is always checked before or not.
		 */
		debug private boolean m_checkedCondition

		//! runtextmacro optional A_STRUCT_DEBUG("\"AUnitSpell\"")

		// construction members

		/**
		 * \return Returns the corresponding ability ID which has been specified on construction.
		 */
		public method ability takes nothing returns integer
			return this.m_ability
		endmethod

		public method upgradeAction takes nothing returns AUnitSpellUpgradeAction
			return this.m_upgradeAction
		endmethod

		public method castCondition takes nothing returns AUnitSpellCastCondition
			return this.m_castCondition
		endmethod

		public method castAction takes nothing returns AUnitSpellCastAction
			return this.m_castAction
		endmethod

		// convenience methods

		/**
		 * \return Returns the name of the corresponding ability.
		 */
		public method name takes nothing returns string
			return GetObjectName(this.m_ability)
		endmethod

		public method increaseLevel takes unit whichUnit returns nothing
			call IncUnitAbilityLevel(whichUnit, this.m_ability)
		endmethod

		public method decreaseLevel takes unit whichUnit returns nothing
			call DecUnitAbilityLevel(whichUnit, this.m_ability)
		endmethod

		/**
		 * Sets the spell's ability level to \p level.
		 * Can be overwritten as stub method to change the behaviour.
		 */
		public stub method setLevel takes unit whichUnit, integer level returns nothing
			call SetUnitAbilityLevel(whichUnit, this.m_ability, level)
		endmethod

		public method level takes unit whichUnit returns integer
			return GetUnitAbilityLevel(whichUnit, this.m_ability)
		endmethod

		/**
		 * Adds the corresponding ability \ref ability() to the unit.
		 */
		public method add takes unit whichUnit returns boolean
			return UnitAddAbility(whichUnit, this.m_ability)
		endmethod

		/**
		 * Removes the corresponding ability \ref ability() from the unit.
		 */
		public method remove takes unit whichUnit returns boolean
			return UnitRemoveAbility(whichUnit, this.m_ability)
		endmethod

		// methods

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call StoreInteger(cache, missionKey, labelPrefix + "Ability", this.m_ability)
			call StoreInteger(cache, missionKey, labelPrefix + "UpgradeAction", this.m_upgradeAction)
			call StoreInteger(cache, missionKey, labelPrefix + "CastCondition", this.m_castCondition)
			call StoreInteger(cache, missionKey, labelPrefix + "CastAction", this.m_castAction)
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			set this.m_ability = GetStoredInteger(cache, missionKey, labelPrefix + "Ability")
			set this.m_upgradeAction = GetStoredInteger(cache, missionKey, labelPrefix + "UpgradeAction")
			set this.m_castCondition = GetStoredInteger(cache, missionKey, labelPrefix + "CastCondition")
			set this.m_castAction = GetStoredInteger(cache, missionKey, labelPrefix + "CastAction")
		endmethod

		/**
		 * Enables upgrading, channeling and casting if triggers do exist.
		 */
		public method enable takes nothing returns nothing
			if (this.m_upgradeTrigger != null) then
				call EnableTrigger(this.m_upgradeTrigger)
			endif
			if (this.m_channelTrigger != null) then
				call EnableTrigger(this.m_channelTrigger)
			endif
			if (this.m_castTrigger != null) then
				call EnableTrigger(this.m_castTrigger)
			endif
		endmethod

		public method disable takes nothing returns nothing
			if (this.m_upgradeTrigger != null) then
				call DisableTrigger(this.m_upgradeTrigger)
			endif
			if (this.m_channelTrigger != null) then
				call DisableTrigger(this.m_channelTrigger)
			endif
			if (this.m_castTrigger != null) then
				call DisableTrigger(this.m_castTrigger)
			endif
		endmethod

		/**
		 * Called via .execute() when the hero ability is upgraded.
		 */
		public stub method onUpgradeAction takes nothing returns nothing
			if (this.m_upgradeAction != 0) then
				call this.m_upgradeAction.execute(this, GetLearnedSkillLevel())
			endif
		endmethod

		/**
		 * Called by .evaluate().
		 * If this does not return true the spell cast is canceled.
		 * By default this evaluates the \ref castCondition().
		 */
		public stub method onCastCondition takes nothing returns boolean
			return (this.m_castCondition == 0 or this.m_castCondition.evaluate(this))
		endmethod

		/**
		 * Called by .execute().
		 * By default this executes the \ref castAction().
		 */
		public stub method onCastAction takes nothing returns nothing
			if (this.m_castAction != 0) then
				debug call Print("Running action (is not zero).")
				call this.m_castAction.execute(this)
			endif
		endmethod

		private static method triggerConditionRightAbility takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return (GetLearnedSkill() == this.m_ability)
		endmethod

		private static method triggerActionUpgrade takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.onUpgradeAction.execute()
		endmethod

		/// \todo upgradeAction won't be called correctly
		private method createUpgradeTrigger takes nothing returns nothing
			set this.m_upgradeTrigger = CreateTrigger()
			// TODO support repick by replacing event
			call TriggerRegisterAnyUnitEventBJ(this.m_upgradeTrigger, EVENT_PLAYER_HERO_SKILL)
			call TriggerAddCondition(this.m_upgradeTrigger, Condition(function thistype.triggerConditionRightAbility))
			call TriggerAddAction(this.m_upgradeTrigger, function thistype.triggerActionUpgrade)
			call AHashTable.global().setHandleInteger(this.m_upgradeTrigger, 0, this)
		endmethod

		private method checkForAbility takes nothing returns boolean
			return GetSpellAbilityId() != null and GetSpellAbilityId() == this.m_ability
		endmethod

		private static method triggerConditionChannel takes nothing returns boolean
			local thistype this = thistype(AHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local boolean result = this.checkForAbility()
			set this.m_canCast = result
			if (result) then
				set result = this.onCastCondition()
				set this.m_canCast = result
				debug set this.m_checkedCondition = this.m_castTrigger != null // Only set this flag if the cast trigger is also run and clears it again.
				if (not result) then
					/*
					 * Stopping the caster in the condition of a trigger with the event EVENT_PLAYER_UNIT_SPELL_CHANNEL will abort the spell before using mana for the spell.
					 */
					call IssueImmediateOrder(GetTriggerUnit(), "stop")
					debug call Print("Stop: " + GetAbilityName(this.ability()))
					debug call Print("This means that the condition is false")
				endif
			endif
			return false
		endmethod

		private method createChannelTrigger takes nothing returns nothing
			set this.m_channelTrigger = CreateTrigger()
			// never use ENDCAST since GetSpellTargetX() etc. won't work anymore
			call TriggerRegisterAnyUnitEventBJ(this.m_channelTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionChannel))
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, 0, this)
		endmethod

		private static method triggerConditionCast takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = this.checkForAbility()
			if (result) then
				debug if (this.m_canCast) then
					debug call this.print("Can cast")
				debug else
					debug call this.print("Cannot cast")
				debug endif
				debug if (not this.m_checkedCondition) then
					// The condition should always be checked before.
					debug call this.print("Warning: Condition has not been checked before!")
				debug endif
				debug set this.m_checkedCondition = false // Reset the flag.

				return this.m_canCast
			endif
			return result
		endmethod

		private static method triggerActionCast takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.onCastAction.execute()
		endmethod

		private method createCastTrigger takes playerunitevent castEvent returns nothing
			set this.m_castTrigger = CreateTrigger()
			// never use ENDCAST since GetSpellTargetX() etc. won't work anymore
			call TriggerRegisterAnyUnitEventBJ(this.m_castTrigger, castEvent)
			call TriggerAddCondition(this.m_castTrigger, Condition(function thistype.triggerConditionCast))
			call TriggerAddAction(this.m_castTrigger, function thistype.triggerActionCast)
			call AHashTable.global().setHandleInteger(this.m_castTrigger, 0, this)
		endmethod

		/**
		 * \param usedAbility The ability which has to be casted by any unit to run the cast action and which has to be skilled for the unit to run the teach action.
		 * \param castEvent Use EVENT_PLAYER_UNIT_SPELL_CHANNEL for regular spells since event data such as GetSpellTargetX() does work with this event. In other cases such as removing the cast ability EVENT_PLAYER_UNIT_SPELL_ENDCAST is recommended but event data does not work with this one.
		 * \param useUpgradeTrigger If this value is false, no upgrade trigger is created, so the upgradeAction or the method \ref onUpgradeAction() is never called. Do always set this to false if the ability is NOT a hero ability.
		 * \param useChannelTrigger If this value is false, no channel trigger is created, so the \ref castCondition() or the method \ref onCastCondition() is never called. Do always set this to false if the spell doesn't require custom code to save performance and memory.
		 * \param useCastTrigger If this value is false, no cast trigger is created, so the \ref castAction() or the method \ref onCastAction() is never called. Do always set this to false if the spell doesn't require custom code to save performance and memory.
		 */
		public static method create takes integer usedAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction, playerunitevent castEvent, boolean useUpgradeTrigger, boolean useChannelTrigger, boolean useCastTrigger returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_ability = usedAbility
			set this.m_upgradeAction = upgradeAction
			set this.m_castCondition = castCondition
			set this.m_castAction = castAction
			// members
			set this.m_canCast = false
			debug set this.m_checkedCondition = false

			if (useUpgradeTrigger) then
				call this.createUpgradeTrigger()
			endif
			if (useChannelTrigger) then
				// conditions have always to be checked on a channel event that the spell order can be stopped before mana consumption and cooldown!
				call this.createChannelTrigger()
			endif
			if (useCastTrigger) then
				call this.createCastTrigger(castEvent)
			endif

			return this
		endmethod

		private method destroyUpgradeTrigger takes nothing returns nothing
			if (this.m_upgradeTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_upgradeTrigger)
				set this.m_upgradeTrigger = null
			endif
		endmethod

		private method destroyChannelTrigger takes nothing returns nothing
			if (this.m_channelTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_channelTrigger)
				set this.m_channelTrigger = null
			endif
		endmethod

		private method destroyCastTrigger takes nothing returns nothing
			if (this.m_castTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_castTrigger)
				set this.m_castTrigger = null
			endif
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.destroyUpgradeTrigger()
			call this.destroyChannelTrigger()
			call this.destroyCastTrigger()
		endmethod

		/**
		 * Static helper methods for target conditions in loops.
		 * \{
		 * This static method can be used in an exitwhen() statement to determine when to stop the loop on an enemy target \p target.
		 * When the target gets killed or becomes spell immune spell effects have to stop.
		 * This should be used for negative effects.
		 * For positive effects on allies you can use \ref allyTargetLoopCondition().
		 */
		public static method enemyTargetLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target) or IsUnitSpellImmune(target)
		endmethod

		public static method enemyTargetLoopConditionResistant takes unit target returns boolean
			return thistype.enemyTargetLoopCondition(target) or IsUnitSpellResistant(target)
		endmethod

		public static method allyTargetLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target)
		endmethod

		public static method allyChannelLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target) or IsUnitType(target, UNIT_TYPE_STUNNED)
		endmethod
		/**
		 * \}
		 */
	endstruct

endlibrary