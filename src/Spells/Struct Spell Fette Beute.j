/// Spell from Ricman
library StructSpellsSpellFetteBeute requires Asl, StructGameSpell

	struct SpellFetteBeute extends Spell
		public static constant integer abilityId = 'A1PG'
		public static constant integer favouriteAbilityId = 'A1P1'
		public static constant integer maxLevel = 1
		private static constant integer gold = 50

		private method action takes nothing returns nothing
			local effect whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl", this.character().unit(), "overhead")
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call Bounty(Player(i), GetUnitX(Character.playerCharacter(Player(i)).unit()), GetUnitY(Character.playerCharacter(Player(i)).unit()), thistype.gold)
					call SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD) + thistype.gold)
				endif
				set i = i + 1
			endloop
			call TriggerSleepAction(2.0)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, 0, thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1P2', 'A1P3')
			call this.addGrimoireEntry('A1P4', 'A1P5')

			return this
		endmethod
	endstruct

endlibrary