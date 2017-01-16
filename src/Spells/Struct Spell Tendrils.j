/// Druid
library StructSpellsSpellTendrils requires Asl, StructGameClasses, StructGameSpell

	struct SpellTendrils extends Spell
		public static constant integer abilityId = 'A0DG'
		public static constant integer favouriteAbilityId = 'A0E2'
		public static constant integer classSelectionAbilityId = 'A1O9'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OA'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1O9', 'A1OA')
			call this.addGrimoireEntry('A0E3', 'A0E8')
			call this.addGrimoireEntry('A0E4', 'A0E9')
			call this.addGrimoireEntry('A0E5', 'A0EA')
			call this.addGrimoireEntry('A0E6', 'A0EB')
			call this.addGrimoireEntry('A0E7', 'A0EC')

			return this
		endmethod
	endstruct

endlibrary