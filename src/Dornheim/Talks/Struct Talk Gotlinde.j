library StructMapTalksTalkGotlinde requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkGotlinde extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_exit

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
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem('I06I')
			elseif (character.class() == Classes.druid()) then
				// simple druid staff
				call character.giveItem('I06J')
			else
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem(ItemTypes.lightWoodenShield().itemType())
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
			call speech(info, character, true, tre("Hallo, ich höre du brichst auf.", "Hello, I've heard you start off."), null)
			call speech(info, character, false, tre("Ja, ich wollte mich von dir verabschieden.", "Yes, I wanted to say goodbye to you."), null)
			call speech(info, character, true, tre("Ach, das ist aber nett von dir. Pass auf, ich habe hier noch etwas für dich. Ich wünsche dir viel Glück auf deiner Reise und pass gut auf dich auf!", "Ah, that is nice of you. Look, I have something for you. I wish you good luck on your journey and take care of yourself!"), null)
			call speech(info, character, false, tre("Danke, das werde ich.", "Thank you, I will."), null)

			call thistype.createClassItems(character)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).complete()
			call MapData.enableZoneTalras.evaluate()

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.gotlinde(), thistype.startPageAction)
			call this.setName(tre("Gotlinde", "Gotlinde"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo Gotlinde!", "Hello Gotlinde!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary