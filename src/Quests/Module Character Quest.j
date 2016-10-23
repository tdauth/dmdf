library ModuleQuestsCharacterQuest requires Asl, StructGameCharacter

	/**
	 * \brief Module for all character quests which provides a method to get a character's corresponding instance of the quest.
	 * Implement this module in every character quest struct to provide its methods for the struct.
	 *
	 * \note Use \ref ModuleQuest for shared quests instead.
	 */
	module CharacterQuest
		private static thistype array m_characterQuest[12] /// @todo MapData.maxPlayers

		/**
		 * Initializes all character quest instances for all playing characters.
		 * This should be called in some map initialization process before accessing the quest.
		 * After calling this \ref characterQuest() can be called for all playing characters.
		 */
		public static method initQuest takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					set thistype.m_characterQuest[i] = thistype.create.evaluate(ACharacter.playerCharacter(Player(i)))
					// use the required quest column for information only
					call thistype.m_characterQuest[i].setIsRequired(false)
					call Character(ACharacter.playerCharacter(Player(i))).addQuest(thistype.m_characterQuest[i])
				endif
				set i = i + 1
			endloop
		endmethod

		public static method playerIdQuest takes integer id returns thistype
			return thistype.m_characterQuest[id]
		endmethod

		public static method playerQuest takes player whichPlayer returns thistype
			return thistype.playerIdQuest(GetPlayerId(whichPlayer))
		endmethod

		public static method characterQuest takes ACharacter character returns thistype
			return thistype.playerQuest(character.player())
		endmethod
	endmodule

endlibrary