/// This library contains the \ref ASpell struct which is used for character spells.
library AStructSystemsCharacterSpell requires optional ALibraryCoreDebugMisc, AStructCoreEnvironmentUnitSpell, AStructCoreGeneralHashTable, ALibraryCoreEnvironmentUnit, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterCharacter

	/**
	 * \brief Adapts \ref ASpell to \ref AUnitSpell by calling the stub methods.
	 * \note Whenever a stub method is added to \ref AUnitSpell, it has to be adapted here or otherwise it won't work with \ref ASpell.
	 */
	private struct AUnitSpellCharacterAdapter extends AUnitSpell
		private ASpell m_spell

		public stub method setLevel takes unit whichUnit, integer level returns nothing
			call super.setLevel(whichUnit, level)
			call this.m_spell.setLevel.evaluate(level)
		endmethod

		/**
		 * Called via .execute() when the hero ability is upgraded.
		 */
		public stub method onUpgradeAction takes nothing returns nothing
			call super.onUpgradeAction()
			call this.m_spell.onUpgradeAction.execute()
		endmethod

		/**
		 * Called by .evaluate().
		 * If this does not return true the spell cast is canceled.
		 * By default this evaluates the \ref castCondition().
		 */
		public stub method onCastCondition takes nothing returns boolean
			local boolean result = super.onCastCondition()
			return result and this.m_spell.onCastCondition.evaluate()
		endmethod

		/**
		 * Called by .execute().
		 * By default this executes the \ref castAction().
		 */
		public stub method onCastAction takes nothing returns nothing
			call super.onCastAction()
			call this.m_spell.onCastAction.execute()
		endmethod

		public static method create takes ASpell spell, integer usedAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction, playerunitevent castEvent, boolean useUpgradeTrigger, boolean useChannelTrigger, boolean useCastTrigger returns thistype
			local thistype this = thistype.allocate(usedAbility, upgradeAction, castCondition, castAction, castEvent, useUpgradeTrigger, useChannelTrigger, useCastTrigger)
			// construction members
			set this.m_spell = spell

			return this
		endmethod
	endstruct

	/**
	 * \brief Represents exactly one spell which belongs to one character.
	 * Since multi inheritance is not supported, \ref AUnitSpellCharacterAdapter has to be adapted that \ref AAbstractCharacterSystem can be inherited.
	 * It works with a two way adapter pattern. This struct calls the methods of \ref AUnitSpell for the struct \ref AAbstractCharacterSystem.
	 * The struct \ref AUnitSpellCharacterAdapter calls the method of this struct for \ref AUnitSpell.
	 * \note This struct adapts \ref AUnitSpell to a character system which means it works as spell for the character's unit only.
	 */
	struct ASpell extends AAbstractCharacterSystem
		// construction members
		private AUnitSpellCharacterAdapter m_unitSpell

		//! runtextmacro optional A_STRUCT_DEBUG("\"ASpell\"")

		// construction members

		public method unitSpell takes nothing returns AUnitSpellCharacterAdapter
			return this.m_unitSpell
		endmethod

		/**
		 * Wrapper methods for \ref AUnitSpell.
		 * The methods help to use \ref ASpell like an instance of the type \ref AUnitSpell.
		 *\{
		 */
		public method ability takes nothing returns integer
			return this.unitSpell().ability()
		endmethod

		public method level takes nothing returns integer
			return this.unitSpell().level(this.character().unit())
		endmethod

		public method name takes nothing returns string
			return this.unitSpell().name()
		endmethod

		public method add takes nothing returns nothing
			call this.unitSpell().add(this.character().unit())
		endmethod

		public method remove takes nothing returns nothing
			call this.unitSpell().remove(this.character().unit())
		endmethod
		/**
		 * \}
		 */

		// methods

		public stub method setLevel takes integer level returns nothing
		endmethod

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.store(cache, missionKey, labelPrefix)
			call this.m_unitSpell.store(cache, missionKey, labelPrefix)
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.restore(cache, missionKey, labelPrefix)
			call this.m_unitSpell.restore(cache, missionKey, labelPrefix)
		endmethod

		public stub method enable takes nothing returns nothing
			call super.enable()
			call this.m_unitSpell.enable()
		endmethod

		public stub method disable takes nothing returns nothing
			call super.disable()
			call this.m_unitSpell.disable()
		endmethod

		/**
		 * Called via .execute() when the hero ability is upgraded.
		 */
		public stub method onUpgradeAction takes nothing returns nothing
		endmethod

		/**
		 * Called by .evaluate().
		 * If this does not return true the spell cast is canceled.
		 * By default this evaluates the \ref castCondition().
		 */
		public stub method onCastCondition takes nothing returns boolean
			return GetTriggerUnit() == this.character().unit()
		endmethod

		/**
		 * Called by .execute().
		 * By default this executes the \ref castAction().
		 */
		public stub method onCastAction takes nothing returns nothing
		endmethod

		/**
		 * \param character Used character. Only the unit of the character can cast this spell.
		 * \param usedAbility The ability which has to be casted by the unit of the character to run the cast action and which has to be skilled for the unit of the character to run the teach action.
		 * \param castEvent Use EVENT_PLAYER_UNIT_SPELL_CHANNEL for regular spells since event data such as GetSpellTargetX() does work with this event. In other cases such as removing the cast ability EVENT_PLAYER_UNIT_SPELL_ENDCAST is recommended but event data does not work with this one.
		 * \param useUpgradeTrigger If this value is false, no upgrade trigger is created, so the upgradeAction or the method \ref onUpgradeAction() is never called. Do always set this to false if the ability is NOT a hero ability.
		 * \param useCastTrigger If this value is false, no cast trigger is created, so the \ref castAction() or the method \ref onCastAction() is never called. Do always set this to false if the spell doesn't require custom code to save performance and memory.
		 */
		public static method create takes ACharacter character, integer usedAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction, playerunitevent castEvent, boolean useUpgradeTrigger, boolean useCastTrigger returns thistype
			local thistype this = thistype.allocate(character)
			// construction members
			// Always use the channel trigger, otherwise it is not checked for the character unit!
			set this.m_unitSpell = AUnitSpellCharacterAdapter.create(this, usedAbility, upgradeAction, castCondition, castAction, castEvent, useUpgradeTrigger, true, useCastTrigger)

			call character.addSpell(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// TODO slow!
			call this.character().removeSpell(this)

			call this.m_unitSpell.destroy()
		endmethod
	endstruct

endlibrary