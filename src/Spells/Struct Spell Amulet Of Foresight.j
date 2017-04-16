library StructSpellsSpellAmuletOfForesight requires Asl

	/**
	* Wird das Amulett auf einen Gegner angewandt, so teilt dieser seine Sicht 40 Sekunden lang mit dem Träger. Stirbt der Träger während dieser Zeit, so wird dem Spieler die Sicht entzogen.
	*/
	struct SpellAmuletOfForesight extends ASpell
		public static constant integer abilityId = 'A08Y'
		private static constant real time = 40.0

		private method action takes nothing returns nothing
			local effect targetEffect = AddSpellEffectTargetByIdForPlayer(this.character().player(), thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetUnit(), "origin")
			local real i = thistype.time
			debug call Print("Amulet of Foresight: Share vision.")
			call UnitShareVision(GetSpellTargetUnit(), this.character().player(), true)
			loop
				exitwhen (i <= 0 or AUnitSpell.enemyTargetLoopConditionResistant(GetSpellTargetUnit()) or IsUnitDeadBJ(this.character().unit())) /// \todo Create buff and check for buff removal!
				call TriggerSleepAction(1.0)
				debug call Print("Amulet of Foresight: Wait 1 second.")
				set i = i - 1.0
			endloop
			debug call Print("Amulet of Foresight: Remove vision.")
			call UnitShareVision(GetSpellTargetUnit(), this.character().player(), false)
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, 0, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true)
		endmethod
	endstruct

endlibrary