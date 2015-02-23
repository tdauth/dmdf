/// Necromancer
library StructSpellsSpellMasterOfNecromancy requires Asl, StructGameClasses, StructGameSpell

	struct SpellMasterOfNecromancy extends Spell
		public static constant integer abilityId = 'A0SG'
		public static constant integer favouriteAbilityId = 'A0SH'
		public static constant integer maxLevel = 5
		
		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			call SetPlayerTechResearched(this.character().player(), 'R009', level)
			call SetPlayerTechResearched(this.character().player(), 'R008', level)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0SI', 'A0SN')
			call this.addGrimoireEntry('A0SJ', 'A0SO')
			call this.addGrimoireEntry('A0SK', 'A0SP')
			call this.addGrimoireEntry('A0SL', 'A0SQ')
			call this.addGrimoireEntry('A0SM', 'A0SR')
			
			return this
		endmethod
	endstruct

endlibrary