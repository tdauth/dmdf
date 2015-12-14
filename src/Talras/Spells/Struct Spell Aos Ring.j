/// Item
library StructMapSpellsSpellAosRing requires Asl, StructGameClasses, StructMapMapAos, StructSpellsSpellMetamorphosis

	/**
	 * Used for rings of Haldar and Baldar. There should be an two instances per class for the two brothers in \ref initMapCharacterSpells().
	 */
	struct SpellAosRing extends SpellMetamorphosis
		private boolean m_baldar

		// Called with .evaluate()
		public stub method canMorph takes nothing returns boolean
			if (not Aos.areaContainsCharacter(this.character())) then
				debug call Print("Area does not contain character!")
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Sie müssen sich in der Trommelhöhle befinden, um diesen Zauber wirken zu können.", "You have to be in the Drum Cave to be able to cast this spell."))
				
				return false
			endif
			
			return true
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
			if (this.m_baldar) then
				call Aos.characterJoinsBaldar(this.character())
			else
				call Aos.characterJoinsHaldar(this.character())
			endif
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
			if (Aos.baldarContainsCharacter(this.character())) then
				call Aos.characterLeavesBaldar(this.character())
			else
				call Aos.characterLeavesHaldar(this.character())
			endif
		endmethod

		public static method create takes Character character, integer abilityId, integer morphAbiliyId, integer unmorphAbilityId, boolean baldar returns thistype
			local thistype this = thistype.allocate(character, abilityId, morphAbiliyId, unmorphAbilityId)
			call this.setDisableGrimoire(false)
			set this.m_baldar = baldar
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary