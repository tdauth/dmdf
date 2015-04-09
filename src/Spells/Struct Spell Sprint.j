/// Ranger
library StructSpellsSpellSprint requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Waldläufer sprintet und erhöht sein Bewegungstempo 3 + X Sekunden lang um 80 %.
	struct SpellSprint extends Spell
		public static constant integer abilityId = 'A01M'
		public static constant integer favouriteAbilityId = 'A03U'
		public static constant integer maxLevel = 5
		private static constant real timeStartLevel = 2
		private static constant real timeLevelValue = 3.0

		private method action takes nothing returns nothing
			local unit target = this.character().unit()
			local real time = thistype.timeStartLevel + thistype.timeLevelValue * this.level()
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
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A10W', 'A111')
			call this.addGrimoireEntry('A10X', 'A112')
			call this.addGrimoireEntry('A10Y', 'A113')
			call this.addGrimoireEntry('A10Z', 'A114')
			call this.addGrimoireEntry('A110', 'A115')
			
			return this
		endmethod
	endstruct

endlibrary