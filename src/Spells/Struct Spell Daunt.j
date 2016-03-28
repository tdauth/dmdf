/// Dragon Slayer
library StructSpellsSpellDaunt requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Verringert die Angriffsgeschwindigkeit für 7 Sekunden um X %. 1 Minute Abklingzeit.
	struct SpellDaunt extends Spell
		public static constant integer abilityId = 'A05Q'
		public static constant integer favouriteAbilityId = 'A05R'
		public static constant integer classSelectionAbilityId = 'A1K1'
		public static constant integer classSelectionGrimoireAbilityId = 'A1K2'
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
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1K1', 'A1K2')
			call this.addGrimoireEntry('A14X', 'A152')
			call this.addGrimoireEntry('A14Y', 'A153')
			call this.addGrimoireEntry('A14Z', 'A154')
			call this.addGrimoireEntry('A150', 'A155')
			call this.addGrimoireEntry('A151', 'A156')
			
			return this
		endmethod
	endstruct

endlibrary