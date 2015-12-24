library ModuleQuestsCharacterQuest requires Asl

	module CharacterQuest
		private static thistype array m_characterQuest[12] /// @todo MapData.maxPlayers

		public static method initQuest takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					set thistype.m_characterQuest[i] = thistype.create.evaluate(ACharacter.playerCharacter(Player(i)))
					call Character(ACharacter.playerCharacter(Player(i))).addQuest.evaluate(thistype.m_characterQuest[i])
				endif
				set i = i + 1
			endloop
		endmethod

		public static method characterQuest takes ACharacter character returns thistype
			local player whichPlayer = character.player()
			local integer playerId = GetPlayerId(whichPlayer)
			set whichPlayer = null
			return thistype.m_characterQuest[playerId]
		endmethod
	endmodule

endlibrary