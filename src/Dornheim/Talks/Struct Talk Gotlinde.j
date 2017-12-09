library StructMapTalksTalkGotlinde requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkGotlinde extends Talk
		private boolean array m_hasAlreadyAskedAfterTraveling[12] /// TODO use bj_MAX_PLAYERS
		private AInfo m_hi
		private AInfo m_back
		private AInfo m_exit

		public method setHasAlreadyAskedAfterTravelingForAllPlayers takes boolean hasAlreadyAskedAfterTraveling returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_hasAlreadyAskedAfterTraveling[i] = hasAlreadyAskedAfterTraveling
				set i = i + 1
			endloop
		endmethod

		public method setHasAlreadyAskedAfterTraveling takes player whichPlayer, boolean hasAlreadyAskedAfterTraveling returns nothing
			set this.m_hasAlreadyAskedAfterTraveling[GetPlayerId(whichPlayer)] = hasAlreadyAskedAfterTraveling
		endmethod

		public method hasAlreadyAskedAfterTraveling takes player whichPlayer returns boolean
			return this.m_hasAlreadyAskedAfterTraveling[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoConditionHi takes AInfo info, ACharacter character returns boolean
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).isNew()
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		private static method createClassItems takes Character character returns nothing
			local integer i = 0
			if (character.class() == Classes.ranger()) then
				// Hunting Bow
				call character.giveItem('I020')
			elseif (character.class() == Classes.cleric() or character.class() == Classes.necromancer() or character.class() == Classes.elementalMage() or character.class() == Classes.wizard()) then
				// Haunted Staff
				call character.giveItem('I03V')
			elseif (character.class() == Classes.dragonSlayer()) then
				// sword and morning star
				call character.giveItem(ItemTypes.shortword().itemTypeId())
				call character.giveItem('I06I')
			elseif (character.class() == Classes.druid()) then
				// simple druid staff
				call character.giveItem('I06J')
			else
				call character.giveItem(ItemTypes.shortword().itemTypeId())
				call character.giveItem(ItemTypes.lightWoodenShield().itemTypeId())
			endif

			set i = 0
			loop
				exitwhen (i == 10)
				call character.giveItem('I00A')
				call character.giveItem('I00D')
				set i = i + 1
			endloop
		endmethod

		private static method infoActionHi takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Gotlinde!", "Hello Gotlinde!"), null)
			call speech(info, character, true, tre("Hallo, ich höre du brichst auf.", "Hello, I've heard you start off."), gg_snd_Gotlinde1)
			call speech(info, character, false, tre("Ja, ich wollte mich von dir verabschieden.", "Yes, I wanted to say goodbye to you."), null)
			call speech(info, character, true, tre("Ach, das ist aber nett von dir. Pass auf, ich habe hier noch etwas für dich. Ich wünsche dir viel Glück auf deiner Reise und pass gut auf dich auf!", "Ah, that is nice of you. Look, I have something for you. I wish you good luck on your journey and take care of yourself!"), gg_snd_Gotlinde2)
			call speech(info, character, false, tre("Danke, das werde ich.", "Thank you, I will."), null)

			call thistype.createClassItems(character)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).complete()
			call MapData.enableZoneTalras.evaluate()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionBack takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return MapData.traveled.evaluate() and not this.hasAlreadyAskedAfterTraveling(character.player())
		endmethod

		private static method infoActionBack takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call this.setHasAlreadyAskedAfterTraveling(character.player(), true)
			call speech(info, character, false,  tre("Ich bin zurück.", "I am back."), null)
			call speech(info, character, true, tre("Da bist du ja wieder! Ich habe so oft an dich gedacht .... Du auch an mich?", "There you are again! I've thought of you so much ... you too of me?"), gg_snd_Gotlinde9)
			call speech(info, character, true, tre("Sag, hast du mir etwas mitgebracht von deiner Reise?", "Tell me, did you bring me something from your journey?"), gg_snd_Gotlinde10)
			// TODO let the player choose to give her something

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.gotlinde(), thistype.startPageAction)
			call this.setName(tre("Gotlinde", "Gotlinde"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo Gotlinde!", "Hello Gotlinde!"))
			set this.m_back = this.addInfo(true, false, thistype.infoConditionBack, thistype.infoActionBack, tre("Ich bin zurück.", "I am back."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary