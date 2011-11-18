/// Dragon Slayer
library StructSpellsSpellDaunt requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Verringert die Angriffsgeschwindigkeit für 7 Sekunden um X %. 1 Minute Abklingzeit.
	struct SpellDaunt extends Spell
		public static constant integer abilityId = 'A05Q'
		public static constant integer favouriteAbilityId = 'A05R'
		public static constant integer maxLevel = 5
		private static constant real time = 7.0
		private static constant real levelValue = 0.10

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local real time = thistype.time
			local real bonus = Game.addUnitMoveSpeed(target, -1 * GetUnitMoveSpeed(target) * thistype.levelValue * this.level())
			call Spell.showMoveSpeedTextTag(target, bonus)
			debug call Print("Bonus: " + R2S(bonus))
			loop
				exitwhen (time <= 0.0)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call Game.removeUnitMoveSpeed(target, bonus)
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary