/// Cleric
library StructSpellsSpellConversion requires Asl, StructGameClasses, StructGameSpell

	/// Bekehrt eine gegnerische Einheit 30 Sekunden lang. Bezauberung.
	struct SpellConversion extends Spell
		public static constant integer abilityId = 'A0PZ'
		public static constant integer favouriteAbilityId = 'A0Q0'
		public static constant integer classSelectionAbilityId = 'A0Q1'
		public static constant integer classSelectionGrimoireAbilityId = 'A0Q6'
		public static constant integer buffId = 'B02F'
		public static constant integer maxLevel = 5
		
		private method action takes nothing returns nothing
			call UnitApplyTimedLife(GetSpellTargetUnit(), thistype.buffId, 30.0)
		endmethod
		

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A0Q1', 'A0Q6')
			call this.addGrimoireEntry('A0Q2', 'A0Q7')
			call this.addGrimoireEntry('A0Q3', 'A0Q8')
			call this.addGrimoireEntry('A0Q4', 'A0Q9')
			call this.addGrimoireEntry('A0Q5', 'A0QA')
			
			return this
		endmethod
	endstruct

endlibrary