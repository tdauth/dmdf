/// All Classes
library StructSpellsSpellAttributeBonus requires Asl, StructGameClasses, StructGameSpell

	struct SpellAttributeBonus extends Spell
		public static constant integer abilityId = 'A1QX'
		public static constant integer favouriteAbilityId = 'A1QY'
		public static constant integer classSelectionAbilityId = 'A1QZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1R0'
		public static constant integer maxLevel = 100

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, 0, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.setIsPassive(true)
			call this.setIsHidden(true)
			call this.addGrimoireEntries.evaluate() // New OpLimit
			
			return this
		endmethod
		
		private method addGrimoireEntries takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxLevel)
				call this.addGrimoireEntry('A1QZ', 'A1R0')
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary