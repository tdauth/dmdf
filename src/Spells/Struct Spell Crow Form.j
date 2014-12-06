/// Druid
library StructSpellsSpellCrowForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellCrowForm extends SpellMetamorphosis
		public static constant integer abilityId = 'A091'
		public static constant integer favouriteAbilityId = 'A092'
		public static constant integer maxLevel = 5
		private static constant integer manaAbilityId = 'A093'
		private static constant integer armorAbilityId = 'A094'

		public stub method onMorph takes nothing returns nothing
			local integer level
			call super.onMorph()
			set level = Character(this.character()).realSpellLevels().integerByInteger(0, thistype.abilityId)
			debug call Print("Crow Form: Morph! Level: " + I2S(level))
			call SetUnitAbilityLevel(this.character().unit(), thistype.manaAbilityId, level)
			call SetUnitAbilityLevel(this.character().unit(), thistype.armorAbilityId, level)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.setUnitTypeId('H00G')

			return this
		endmethod
	endstruct

endlibrary