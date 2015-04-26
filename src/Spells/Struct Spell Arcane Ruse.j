/// Wizard
library StructSpellsSpellArcaneRuse requires Asl, StructGameClasses, StructGameSpell

	/// Grundzauber: Entfernt einen postitiven Zauberverstärker eines Gegners und überträgt ihn auf einen Verbündeten oder entfernt einen negativen Zauberverstärker eines Verbündeten und überträgt ihn auf einen Gegner im Umkreis von X.
	struct SpellArcaneRuse extends Spell
		public static constant integer abilityId = 'A08Z'
		public static constant integer favouriteAbilityId = 'A090'
		public static constant integer classSelectionAbilityId = 'A10K'
		public static constant integer classSelectionGrimoireAbilityId = 'A10L'
		public static constant integer maxLevel = 1
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A10K', 'A10L')
			
			return this
		endmethod
	endstruct

endlibrary