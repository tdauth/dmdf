library StructGameGrimoireSpell requires Asl, StructGameCharacter

	/**
	 * \brief A grimoire spell is a spell which represents a specific action button in the grimoire. Other than \ref Spell it is not a class spell.
	 */
	struct GrimoireSpell extends ASpell
		private Grimoire m_grimoire
		private integer m_grimoireAbility

		/**
		 * Reopens the grimoire by reopening the spell book ability of the grimoire.
		 * This is necessary whenever it is closed by Warcraft III which happens for some actions.
		 */
		public method reopenGrimoire takes nothing returns nothing
			// TODO if trigger player is not owner of the character!
			// the trigger player is the player who issues the order/ability not necessarily the owner
			// there fore only re open the grimoire if there is a trigger player
			if (GetTriggerPlayer() != null) then
				call ForceUIKeyBJ(GetTriggerPlayer(), Grimoire.shortcut) // WORKAROUND: whenever an ability is being removed it closes grimoire
			endif
		endmethod

		public method grimoire takes nothing returns Grimoire
			return this.m_grimoire
		endmethod

		public method grimoireAbility takes nothing returns integer
			return this.m_grimoireAbility
		endmethod

		public method isShown takes unit whichUnit returns boolean
			return GetUnitAbilityLevel(whichUnit, this.grimoireAbility()) > 0
		endmethod

		public method show takes unit whichUnit returns nothing
			if (this.isShown(whichUnit)) then
				return
			endif

			call UnitAddAbility(whichUnit, this.grimoireAbility())
			call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), this.grimoireAbility(), false)
			call SetUnitAbilityLevel(whichUnit, this.unitSpell().ability(), 1)
			call this.enable()
		endmethod

		public method hide takes unit whichUnit returns nothing
			if (not this.isShown(whichUnit)) then
				return
			endif

			call this.disable() // disable to prevent casts if some spells have the same id (spell book)
			call UnitRemoveAbility(whichUnit, this.grimoireAbility())
		endmethod

		public stub method onCastCondition takes nothing returns boolean
			return this.character().isMovable()
		endmethod

		public stub method onCastAction takes nothing returns nothing
			call super.onCastAction()
		endmethod

		public static method create takes Grimoire grimoire, integer abilityId, integer grimoireAbility returns thistype
			/*
			 * Use EVENT_PLAYER_UNIT_SPELL_ENDCAST to prevent any null GetAbilityId() calls when the ability is removed before running trigger events.
			 * Since the grimoire buttons do not need any event data like GetSpellTargetX() this event is just okay.
			 */
			local thistype this = thistype.allocate(grimoire.character.evaluate(), abilityId, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_ENDCAST, false, true)
			set this.m_grimoire = grimoire
			set this.m_grimoireAbility = grimoireAbility

			return this
		endmethod
	endstruct

endlibrary