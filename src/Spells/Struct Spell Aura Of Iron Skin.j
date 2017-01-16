/// Knight
library StructSpellsSpellAuraOfIronSkin requires Asl, StructGameClasses, StructGameSpell

	struct SpellAuraOfIronSkin extends Spell
		public static constant integer abilityId = 'A029'
		public static constant integer favouriteAbilityId = 'A038'
		public static constant integer classSelectionAbilityId = 'A0PP'
		public static constant integer classSelectionGrimoireAbilityId = 'A0PQ'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A0PP', 'A0PQ')
			call this.addGrimoireEntry('A134', 'A139')
			call this.addGrimoireEntry('A135', 'A13A')
			call this.addGrimoireEntry('A136', 'A13B')
			call this.addGrimoireEntry('A137', 'A13C')
			call this.addGrimoireEntry('A138', 'A13D')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary