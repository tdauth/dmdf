/// Knight
library StructSpellsSpellLivingWill requires Asl, StructGameClasses, StructGameSpell

	/// Der Ritter kann 5 Sekunden nach seinem Tod mit 50% seiner Lebensnenergie wiederauferstehen. 15 Minuten Abklingzeit.
	struct SpellLivingWill extends Spell
		public static constant integer abilityId = 'A01N'
		public static constant integer favouriteAbilityId = 'A03R'
		public static constant integer maxLevel = 1
		private static constant real spellTime = 5.0
		private static constant real hitPointsPercentageAmount = 50.0

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			call TriggerSleepAction(5.0)
			call SetUnitLifePercentBJ(target, thistype.hitPointsPercentageAmount)
			set target = null
		endmethod

		public static method create takes ACharacter character returns SpellLivingWill
			return thistype.allocate(character, Classes.knight(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary