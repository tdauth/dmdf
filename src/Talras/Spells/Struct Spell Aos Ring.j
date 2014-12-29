/// Item
library StructMapSpellsSpellAosRing requires Asl, StructGameClasses, StructMapMapAos, StructSpellsSpellMetamorphosis

	/**
	 * Used for rings of Haldar and Baldar. There should be an two instances per class for the two brothers in \ref initMapCharacterSpells().
	 */
	struct SpellAosRingMetamorphosis extends SpellMetamorphosis
		private boolean m_baldar
		
		/**
		 * Returns the morphed unit type id depending on the character's class.
		 */
		public method getUnitTypeIdHaldar takes nothing returns integer
			if (this.character().class() == Classes.cleric()) then
				return 'H00V'
			elseif (this.character().class() == Classes.necromancer()) then
				return 'H00W'
			elseif (this.character().class() == Classes.druid()) then
				return 'H00X'
			elseif (this.character().class() == Classes.knight()) then
				return 'H00Y'
			elseif (this.character().class() == Classes.dragonSlayer()) then
				return 'H00Z'
			elseif (this.character().class() == Classes.ranger()) then
				return 'H010'
			elseif (this.character().class() == Classes.elementalMage()) then
				return 'H011'
			elseif (this.character().class() == Classes.astralModifier()) then
				return 'H00U'
			elseif (this.character().class() == Classes.illusionist()) then
				return 'H013'
			elseif (this.character().class() == Classes.wizard()) then
				return 'H012'
			endif
			
			return 0
		endmethod
		
		/**
		 * Returns the morphed unit type id depending on the character's class.
		 */
		public method getUnitTypeIdBaldar takes nothing returns integer
			if (this.character().class() == Classes.cleric()) then
				return 'H00L'
			elseif (this.character().class() == Classes.necromancer()) then
				return 'H00M'
			elseif (this.character().class() == Classes.druid()) then
				return 'H00N'
			elseif (this.character().class() == Classes.knight()) then
				return 'H00O'
			elseif (this.character().class() == Classes.dragonSlayer()) then
				return 'H00P'
			elseif (this.character().class() == Classes.ranger()) then
				return 'H00Q'
			elseif (this.character().class() == Classes.elementalMage()) then
				return 'H00R'
			elseif (this.character().class() == Classes.astralModifier()) then
				return 'H00C'
			elseif (this.character().class() == Classes.illusionist()) then
				return 'H00S'
			elseif (this.character().class() == Classes.wizard()) then
				return 'H00T'
			endif
			
			return 0
		endmethod
		
		// Called with .evaluate()
		public stub method canMorph takes nothing returns boolean
			if (not Aos.areaContainsCharacter(this.character())) then
				debug call Print("Area does not contain character!")
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie müssen sich in der Trommelhöhle befinden, um diesen Zauber wirken zu können."))
				
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

		public static method create takes Character character, integer abilityId, boolean baldar returns thistype
			local thistype this = thistype.allocate(character, abilityId)
			set this.m_baldar = baldar
			if (baldar) then
				call this.setUnitTypeId(this.getUnitTypeIdBaldar())
			else
				call this.setUnitTypeId(this.getUnitTypeIdHaldar())
			endif
			call this.setOrderString("metamorphosis")
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct
	
	struct SpellAosRing extends ASpell
		private SpellAosRingMetamorphosis m_metamorphosis
		
		public static method create takes Character character, integer abilityId, boolean baldar returns thistype
			local thistype this = thistype.allocate(character, abilityId, 0, 0, 0, EVENT_UNIT_SPELL_CHANNEL)
			set this.m_metamorphosis = SpellAosRingMetamorphosis.create(character, abilityId, baldar)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call this.m_metamorphosis.destroy()
			set this.m_metamorphosis = 0
		endmethod
	endstruct

endlibrary