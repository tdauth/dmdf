/// Item
library StructMapSpellsSpellAosRing requires Asl, StructMapMapAos

	/**
	 * Used for rings of Haldar and Baldar. There should be an two instances per class for the two brothers in \ref initMapCharacterSpells().
	 */
	struct SpellAosRing extends ASpell
		private boolean m_baldar

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			debug call Print("CAST ACTION")
			if (not Aos.areaContainsCharacter(this.character())) then
				debug call Print("Area does not contain character!")
				call IssueImmediateOrder(caster, "stop")
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie müssen sich in der Trommelhöhle befinden, um diesen Zauber wirken zu können."))
				set caster = null
				return
			endif
			if (this.m_baldar) then
				// shouldn't happen
				if (Aos.haldarContainsCharacter(this.character())) then
					debug call Print("Character is already in Haldar's group -> something is going wrongly.")
					call IssueImmediateOrder(caster, "stop")
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie befinden sich bereits in Haldars Gruppe."))
					set caster = null
					return
				endif
				if (Aos.baldarContainsCharacter(this.character())) then
					debug call Print("Leaves Baldar with ability id: " + I2S(this.ability()))
					call Aos.characterLeavesBaldar(this.character())
					call TriggerSleepAction(0.0) // REQUIRED!!!
					call Character(this.character()).restoreUnit()
				else
					debug call Print("Joins Baldar with character " + I2S(this.character()) + " and ability id: " + I2S(this.ability()))
					call Aos.characterJoinsBaldar(this.character())
					call Character(this.character()).morph(this.ability())
				endif
			else
				// shouldn't happen
				if (Aos.baldarContainsCharacter(this.character())) then
					debug call Print("Character is already in Baldar's group -> something is going wrongly.")
					call IssueImmediateOrder(caster, "stop")
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie befinden sich bereits in Baldars Gruppe."))
					set caster = null
					return
				endif
				if (Aos.haldarContainsCharacter(this.character())) then
					debug call Print("Leaves Haldar.")
					call Aos.characterLeavesHaldar(this.character())
					call TriggerSleepAction(0.0) // REQUIRED!!!
					call Character(this.character()).restoreUnit()
				else
					debug call Print("Joins Haldar with character " + I2S(this.character()) + ".")
					call Aos.characterJoinsHaldar(this.character())
					call Character(this.character()).morph(this.ability())
				endif
			endif
			set caster = null
		endmethod

		public static method create takes Character character, integer abilityId, boolean baldar returns thistype
			local thistype this = thistype.allocate(character, abilityId, 0, 0, thistype.action)
			set this.m_baldar = baldar
			return this
		endmethod
	endstruct

endlibrary