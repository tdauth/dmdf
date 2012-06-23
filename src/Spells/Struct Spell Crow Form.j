/// Druid
library StructSpellsSpellCrowForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellCrowForm extends SpellMetamorphosis
		public static constant integer abilityId = 'A091'
		public static constant integer favouriteAbilityId = 'A092'
		public static constant integer maxLevel = 5
		private static constant integer manaAbilityId = 'A093'
		private static constant integer armorAbilityId = 'A094'
		
		public stub method onMorph takes nothing returns nothing
			call super.onMorph()
			debug call Print("Crow Form: Morph!")
			call SetUnitAbilityLevel(this.character().unit(), thistype.manaAbilityId, Character(this.character()).realSpellLevels()[thistype.abilityId])
			call SetUnitAbilityLevel(this.character().unit(), thistype.armorAbilityId, Character(this.character()).realSpellLevels()[thistype.abilityId])
		endmethod
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.setUnitTypeId('H00G')
			call this.setCastTime(0.0)

			return this
		endmethod
	endstruct

endlibrary