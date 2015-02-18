/// Cleric
library StructSpellsSpellRecovery requires Asl, StructGameClasses, StructGameSpell

	/**
	* Heilt ein befreundetes Ziel 10 Sekunden lang um X Lebenspunkte pro Sekunde.
	* Insgesamt etwas mehr geheilt als Linderung.
	*/
	struct SpellRecovery extends Spell
		public static constant integer abilityId = 'A06A'
		public static constant integer favouriteAbilityId = 'A06B'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A0P9', 'A0PE')
			call this.addGrimoireEntry('A0PA', 'A0PF')
			call this.addGrimoireEntry('A0PB', 'A0PG')
			call this.addGrimoireEntry('A0PC', 'A0PH')
			call this.addGrimoireEntry('A0PD', 'A0PI')
			
			return this
		endmethod
	endstruct

endlibrary