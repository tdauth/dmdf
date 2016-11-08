library StructMapTalksTalkMother requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkMother extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_food
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoConditionHi takes AInfo info, ACharacter character returns boolean
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemTalk).isNew()
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Mutter!", "Hello Mother!"), null)
			call speech(info, character, true, tre("Hallo, mein Sohn. Ich weiß du möchtest sobald wie möglich aufbrechen, doch kann ich dich noch um einen kleinen Gefallen bitten?", "Hello, my son. I know you want to start off as soon as possible but can I ask you for a small favor?"), null)
			call speech(info, character, false, tre("Wenn es unbedingt sein muss.", "If it must be."), null)
			call speech(info, character, true, tre("Also, wie sprichst du denn mit deiner Mutter? Könntest du mir noch einige Waren bei Hans besorgen? Ich habe gerade keine Zeit dafür.", "So, is that the way you talk to your mother? Could you bring me some goods from Hans? I'm busy at the moment."), null)
			call speech(info, character, false, tre("Na gut.", "Fine."), null)

			call QuestMother.characterQuest(character).questItem(QuestMother.questItemTalk).setState(QuestMother.stateCompleted)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGoods).setState(QuestMother.stateNew)
			call QuestMother.characterQuest(character).displayState()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionFood takes AInfo info, ACharacter character returns boolean
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemBring).isNew() and character.inventory().totalItemTypeCharges('I016') >= 3 and character.inventory().totalItemTypeCharges('I03O') >= 4
		endmethod

		private static method infoActionFood takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			local integer i = 0
			call speech(info, character, false, tre("Hier sind die Waren.", "There you have your goods."), null)
			call speech(info, character, true, tr("Ich danke dir mein Sohn! Immerhin bist du noch zuverlässig. Nun lasse ich dich schließlich gehen, auch wenn es mir das Herz bricht. Pass auf dich auf und denke daran, unser Hof läuft schlecht. Etwas mehr Goldmünzen könnte ich gut gebrauchen."), null)
			call speech(info, character, true, tr("Mögen die Götter dich beschützen und pass gut auf dich auf! ... Ach so, sei doch bitte so lieb und sag Gotlinde noch Lebwohl, so wie es sich gehört."), null)
			call speech(info, character, false, tre("Mutter, ich ...", "Mother, I ..."), null)
			call speech(info, character, true, tr("Nun mach schon. Ach und nimm diesen Brief mit dir mein Sohn. Er soll dich an deine arme Mutter erinnern."), null)

			set i = 0
			loop
				exitwhen (i == 3)
				call character.inventory().removeItemType('I016')
				set i = i + 1
			endloop

			set i = 0
			loop
				exitwhen (i == 4)
				call character.inventory().removeItemType('I03O')
				set i = i + 1
			endloop

			call QuestMother.characterQuest(character).questItem(QuestMother.questItemBring).setState(QuestMother.stateCompleted)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).setState(QuestMother.stateNew)
			call QuestMother.characterQuest(character).displayState()

			call character.giveItem('I061')

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.mother(), thistype.startPageAction)
			call this.setName(tre("Mutter", "Mother"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo Mutter!", "Hello mother!"))
			set this.m_food = this.addInfo(false, false, thistype.infoConditionFood, thistype.infoActionFood, tre("Hier sind die Waren.", "There you have your goods."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary