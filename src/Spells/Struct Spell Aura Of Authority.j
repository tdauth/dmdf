/// Knight
library StructSpellsSpellAuraOfAuthority requires Asl, StructGameClasses, StructGameSpell

	struct SpellAuraOfAuthority extends Spell
		public static constant integer abilityId = 'A0MH'
		public static constant integer favouriteAbilityId = 'A0MI'
		public static constant integer classSelectionAbilityId = 'A0PN'
		public static constant integer classSelectionGrimoireAbilityId = 'A0PO'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A0PN', 'A0PO')
			call this.addGrimoireEntry('A0MJ', 'A0MO')
			call this.addGrimoireEntry('A0MK', 'A0MP')
			call this.addGrimoireEntry('A0ML', 'A0MQ')
			call this.addGrimoireEntry('A0MM', 'A0MR')
			call this.addGrimoireEntry('A0MN', 'A0MS')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary