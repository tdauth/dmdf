/// Ranger
library StructSpellsSpellSprint requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Waldläufer sprintet und erhöht sein Bewegungstempo 3 + X Sekunden lang um 80 %.
	struct SpellSprint extends Spell
		public static constant integer abilityId = 'A01M'
		public static constant integer favouriteAbilityId = 'A03U'
		public static constant integer maxLevel = 5
		private static constant real timeConstant = 3.0
		private static constant real timeLevelSummand = 4.0

		private method action takes nothing returns nothing
			local unit target = this.character().unit()
			local real time = thistype.timeConstant + thistype.timeLevelSummand
			local real bonus = Game.addUnitMoveSpeed(target, GetUnitMoveSpeed(target) * 0.80)
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
			return thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary