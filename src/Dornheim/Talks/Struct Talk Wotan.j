library StructMapTalksTalkWotan requires Asl, StructMapMapNpcs, StructMapQuestsQuestShitOnTheThrone, StructMapQuestsQuestTheChildren

	struct TalkWotan extends Talk
		private AInfo m_hi
		private AInfo m_howAreYou
		private AInfo m_shit
		private AInfo m_house
		private AInfo m_rescue
		private AInfo m_sacrifice
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Ich grüße dich, Wotan."), null)
			call speech(info, character, true, tr("Du bist derjenige, der aufbricht, in eine andere Welt."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionHowAreYou takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionHowAreYou takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Ist alles in Ordnung?"), null)
			call speech(info, character, true, tr("Ich bin der Geist der stets verneint, doch andern als ihr Herr erscheint."), null)
			call speech(info, character, false, tr("Alles klar!"), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionShit takes AInfo info, ACharacter character returns boolean
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			return characterQuest.questItem(QuestShitOnTheThrone.questItemPlaceShit).isCompleted() and characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).isNew()
		endmethod

		private static method infoActionShit takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			call speech(info, character, false, tr("Wie sitzt es sich auf dem Thron?"), null)
			call speech(info, character, true, tr("Wer hat es gewagt meinen Thron mit dieser Wurst zu beflecken? Möge der Frevler hervortreten auf dass ich ihn verzaubere, in ein elendes Huhn!"), null)
			call speech(info, character, true, tr("Sprich, wer ist es, der mir dieses braune Gemisch unter meinem Arsch platzierte!"), null)
			call speech(info, character, false, tr("Ich weiß nicht wovon du sprichst."), null)
			call speech(info, character, true, tr("Ich warne dich! Denk ja nicht, dass jede Tat vergessen ist, wenn du wiederkehrst!"), null)

			call characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).complete()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionHouse takes AInfo info, ACharacter character returns boolean
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			return characterQuest.questItem(QuestTheChildren.questItemDiscover).isCompleted() and characterQuest.questItem(QuestTheChildren.questItemTalkToWotan).isNew()
		endmethod

		private static method infoActionHouse takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			local effect whichEffect = null

			call speech(info, character, false, tr("Ich war im Obergeschoss deines Hauses."), null)
			call speech(info, character, true, tr("Neeeiiin! Wie konntest du nur?"), null)
			call speech(info, character, false, tr("Was zur Hölle hast du dort getrieben?"), null)

			call speech(info, character, true, tr("Hölle? Die Hölle ist mein neues Zuhause!"), null)

			// Wotan verwandelt sich in Mephisto.
			// These two lines of code do the passive transformation to another unit type.
			call UnitAddAbility(Npcs.wotan(), 'A1VC')
			call UnitRemoveAbility(Npcs.wotan(), 'A1VC')
			set whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdx", Npcs.wotan(), "origin")

			call speech(info, character, true, tr("Ich werde die Kinder opfern und mit Hilfe ihrer Seelen den dunklen Fürsten der Dämonen herbeirufen!"), null)
			call speech(info, character, false, tr("Welche Kinder?"), null)
			call speech(info, character, false, tr("Geh nun und lass mich allein. Der Untergang ist nahe!"), null)

			call characterQuest.questItem(QuestTheChildren.questItemTalkToWotan).setState(QuestTheChildren.stateCompleted)
			call characterQuest.questItem(QuestTheChildren.questItemSacrifice).setState(QuestTheChildren.stateNew)
			call characterQuest.questItem(QuestTheChildren.questItemRescue).setState(QuestTheChildren.stateNew)
			call characterQuest.displayState()

			call character.giveQuestItem('I07G')

			call DestroyEffect(whichEffect)
			set whichEffect = null

			call this.showStartPage(character)
		endmethod

		private static method infoConditionRescue takes AInfo info, ACharacter character returns boolean
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			return characterQuest.questItem(QuestTheChildren.questItemRescue).isCompleted() and characterQuest.isNew()
		endmethod

		private static method infoActionRescue takes AInfo info, Character character returns nothing
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Ich habe die Kinder gerettet."), null)
			call speech(info, character, true, tr("Verflucht seist du! Wie konntest du mir das antun? Der Fürst wird mich bestrafen."), null)
			call speech(info, character, false, tr("..."), null)
			call character.xpBonus(30, tr("Rechtschaffenheit"))

			call characterQuest.complete()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionSacrifice takes AInfo info, ACharacter character returns boolean
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			return characterQuest.questItem(QuestTheChildren.questItemSacrifice).isCompleted() and characterQuest.isNew()
		endmethod

		private static method infoActionSacrifice takes AInfo info, Character character returns nothing
			local QuestTheChildren characterQuest = QuestTheChildren.characterQuest(character)
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Ich habe die Kinder geopfert."), null)
			call speech(info, character, true, tr("Gut gemacht. Du bist nun ebenfalls ein Diener der Hölle. Ich überreiche dir diese Belohnung."), null)
			call speech(info, character, false, tr("Nimm dich in Acht vor jenen, die uns nicht verstehen. Sonst werden sie dich jagen und verbrennen!"), null)
			call character.giveItem('I07C')
			call character.giveItem('I07C')
			call character.giveItem('I07C')
			call character.giveItem('I07C')

			call characterQuest.complete()

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.wotan(), thistype.startPageAction)
			call this.setName(tre("Wotan", "Wotan"))

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Ich grüße dich, Wotan."))
			set this.m_howAreYou = this.addInfo(false, false, thistype.infoConditionHowAreYou, thistype.infoActionHowAreYou, tr("Ist alles in Ordnung?"))
			set this.m_shit = this.addInfo(false, false, thistype.infoConditionShit, thistype.infoActionShit, tr("Wie sitzt es sich auf dem Thron?"))
			set this.m_house = this.addInfo(false, false, thistype.infoConditionHouse, thistype.infoActionHouse, tr("Ich war im Obergeschoss deines Hauses."))
			set this.m_rescue = this.addInfo(false, false, thistype.infoConditionRescue, thistype.infoActionRescue, tr("Ich habe die Kinder gerettet."))
			set this.m_sacrifice = this.addInfo(false, false, thistype.infoConditionSacrifice, thistype.infoActionSacrifice, tr("Ich habe die Kinder geopfert."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
		
		implement Talk
	endstruct

endlibrary