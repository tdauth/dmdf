/// Druid
library StructSpellsSpellBearForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellBearForm extends SpellMetamorphosis
		public static constant integer abilityId = 'A09H'
		public static constant integer favouriteAbilityId = 'A09S'
		public static constant integer maxLevel = 5
		private static constant integer lifeAbilityId = 'A09Q'
		private static constant integer damageAbilityId = 'A09R'

		public stub method onMorph takes nothing returns nothing
			local integer level
			call super.onMorph()
			set level = Character(this.character()).realSpellLevels().integerByInteger(0, thistype.abilityId)
			debug call Print("Bear Form: Morph! Level: " + I2S(level))
			call SetUnitAbilityLevel(this.character().unit(), thistype.lifeAbilityId, level)
			call SetUnitAbilityLevel(this.character().unit(), thistype.damageAbilityId, level)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.setUnitTypeId('H00I')

			return this
		endmethod
	endstruct

endlibrary