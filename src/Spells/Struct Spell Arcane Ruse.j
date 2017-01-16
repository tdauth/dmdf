/// Wizard
library StructSpellsSpellArcaneRuse requires Asl, StructGameClasses, StructGameSpell

	/// Grundzauber: Entfernt einen postitiven Zauberverstärker eines Gegners und überträgt ihn auf einen Verbündeten oder entfernt einen negativen Zauberverstärker eines Verbündeten und überträgt ihn auf einen Gegner im Umkreis von X.
	struct SpellArcaneRuse extends Spell
		public static constant integer abilityId = 'A08Z'
		public static constant integer favouriteAbilityId = 'A090'
		public static constant integer classSelectionAbilityId = 'A06E'
		public static constant integer classSelectionGrimoireAbilityId = 'A06F'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.wizard(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A06E', 'A06F')
			call this.addGrimoireEntry('A10K', 'A10L')

			return this
		endmethod
	endstruct

endlibrary