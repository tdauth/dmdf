/// Necromancer
library StructSpellsSpellAncestorPact requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Nekromant regeneriert sein Leben und Mana mit Hilfe eines Kadavers. Wandelt X% des ursprünglichen Lebens des Ziels zu Leben und Y% zu Mana um.
	*/
	struct SpellAncestorPact extends Spell
		public static constant integer abilityId = 'A08N'
		public static constant integer favouriteAbilityId = 'A08I'
		public static constant integer maxLevel = 5
		private static constant real targetRadius = 200.0
		private static constant integer lifePercentage = 20
		private static constant integer lifePercentageLevelValue = 15 // ab Stufe 1
		private static constant integer manaPercentage = 10
		private static constant integer manaPercentageLevelValue = 8 // ab Stufe 1

		private static method unitFilter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit())
		endmethod

		public method onCastAction takes nothing returns nothing
			local AGroup unitGroup = AGroup.create()
			local unit target
			local real life
			local real mana
			call unitGroup.addUnitsInRangeCounted(GetSpellTargetX(), GetSpellTargetY(), thistype.targetRadius, Filter(function thistype.unitFilter), 1)
			if (unitGroup.units().empty()) then
				call unitGroup.destroy()
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
				return
			endif
			set target = unitGroup.units()[0]
			set life = (thistype.lifePercentage + (this.level() - 1) * thistype.lifePercentageLevelValue) * 100 / GetUnitState(target, UNIT_STATE_MAX_LIFE)
			set life = RMinBJ(life, GetUnitMissingLife(this.character().unit()))
			set mana = (thistype.manaPercentage + (this.level() - 1) * thistype.manaPercentageLevelValue) * 100 / GetUnitState(target, UNIT_STATE_MAX_MANA)
			set mana = RMinBJ(mana, GetUnitMissingMana(this.character().unit()))
			call SetUnitLifeBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_LIFE) + life)
			call SetUnitManaBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_MANA) + mana)
			call thistype.showLifeTextTag(this.character().unit(), life)
			call thistype.showManaTextTag(this.character().unit(), mana)
			call unitGroup.destroy()
			call RemoveUnit(target)
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary