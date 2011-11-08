/// Druid
library StructSpellsSpellBearForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellBearForm extends SpellMetamorphosis
		public static constant integer abilityId = 'A09H'
		public static constant integer favouriteAbilityId = 'A096'
		public static constant integer maxLevel = 5
		private static constant integer lifeAbilityId = 'A09Q'
		private static constant integer damageAbilityId = 'A09R'
		
		public stub method onMorph takes nothing returns nothing
			call super.onMorph()
			debug call Print("Bear Form: Morph!")
			call SetUnitAbilityLevel(this.character().unit(), thistype.lifeAbilityId, Character(this.character()).realSpellLevels()[thistype.abilityId])
			call SetUnitAbilityLevel(this.character().unit(), thistype.damageAbilityId, Character(this.character()).realSpellLevels()[thistype.abilityId])
		endmethod
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.setUnitTypeId('H00I')
			call this.setCastTime(0.0)

			return this
		endmethod
	endstruct

endlibrary