/// Item
library StructMapSpellsSpellBaldarsRingAstralModifier requires Asl, StructMapMapAos

	struct SpellBaldarsRingAstralModifier extends ASpell
		private static constant integer abilityId = 'A04V'
		private static constant integer normalUnitTypeId = 'H005'
		private static constant integer morphedUnitTypeId = 'H00C'

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
			// shouldn't happen
			if (Aos.haldarContainsCharacter(this.character())) then
				debug call Print("Character is already in Haldar's group -> something is going wrongly.")
				call IssueImmediateOrder(caster, "stop")
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie befinden sich bereits in Haldars Gruppe."))
				set caster = null
				return
			endif
			if (Aos.baldarContainsCharacter(this.character())) then
				debug call Print("Leaves Baldar.")
				call Aos.characterLeavesBaldar(this.character())
				call TriggerSleepAction(0.0) // REQUIRED!!!
				call Character(this.character()).restoreUnit()
			else
				debug call Print("Joins Baldar with character " + I2S(this.character()) + ".")
				call Aos.characterJoinsBaldar(this.character())
				call Character(this.character()).morph(thistype.abilityId)
			endif
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.abilityId, 0, 0, thistype.action)
			return this
		endmethod
	endstruct

endlibrary