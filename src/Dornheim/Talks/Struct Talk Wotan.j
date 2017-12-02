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
			call speech(info, character, false, tre("Ich grüße dich, Wotan.", "I greet you Wotan."), null)
			call speech(info, character, true, tre("Du bist derjenige, der aufbricht, in eine andere Welt.", "You are the one who starts off into another world."), gg_snd_Wotan1)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionHowAreYou takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionHowAreYou takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Ist alles in Ordnung?", "Is everything ok?"), null)
			call speech(info, character, true, tre("Ich bin der Geist der stets verneint, doch andern als ihr Herr erscheint.", "I am the spirit of ever denying, but others as their lord appears."), gg_snd_Wotan2)
			call speech(info, character, false, tre("Alles klar!", "All right!"), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionShit takes AInfo info, ACharacter character returns boolean
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			return characterQuest.questItem(QuestShitOnTheThrone.questItemPlaceShit).isCompleted() and characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).isNew()
		endmethod

		private static method infoActionShit takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			call speech(info, character, false, tre("Wie sitzt es sich auf dem Thron?", "How does it sit on the throne?"), null)
			call speech(info, character, true, tre("Wer hat es gewagt meinen Thron mit dieser Wurst zu beflecken? Möge der Frevler hervortreten auf dass ich ihn verzaubere, in ein elendes Huhn!", "Who dared to stain my throne with this sausage? May the wicked stand up, that I may enchant him into a miserable chicken!"), gg_snd_Wotan3)
			call speech(info, character, true, tre("Sprich, wer ist es, der mir dieses braune Gemisch unter meinem Arsch platzierte!", "Say, who is it, who placed this brown mixture under my ass!"), gg_snd_Wotan4)
			call speech(info, character, false, tre("Ich weiß nicht wovon du sprichst.", "I don't know what you are talking about."), null)
			call speech(info, character, true, tre("Ich warne dich! Denk ja nicht, dass jede Tat vergessen ist, wenn du wiederkehrst!", "I warn you! Do not think that every act is forgotten when you return!"), gg_snd_Wotan5)

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

			call speech(info, character, false, tre("Ich war im Obergeschoss deines Hauses.", "I was on the first floor of your house."), null)
			call speech(info, character, true, tre("Neeeiiin! Wie konntest du nur?", "Noooo! How could you?"), gg_snd_Wotan6)
			call speech(info, character, false, tre("Was zur Hölle hast du dort getrieben?", "What the hell did you do there?"), null)

			call speech(info, character, true, tre("Hölle? Die Hölle ist mein neues Zuhause!", "Hell? Hell is my new home!"), gg_snd_Wotan7)

			// Wotan verwandelt sich in Mephisto.
			// These two lines of code do the passive transformation to another unit type.
			call UnitAddAbility(Npcs.wotan(), 'A1VC')
			call UnitRemoveAbility(Npcs.wotan(), 'A1VC')
			call UnitAddAbility(Npcs.wotan(), 'A19X')
			call UnitAddAbility(Npcs.wotan(), 'Asud') // sell units
			set whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdx", Npcs.wotan(), "origin")

			call speech(info, character, true, tre("Ich werde die Kinder opfern und mit Hilfe ihrer Seelen den dunklen Fürsten der Dämonen herbeirufen!", "I will sacrifice my children and use their souls to summon the dark prince of demons!"), gg_snd_Wotan8)
			call speech(info, character, false, tre("Welche Kinder?", "What children?"), null)
			call speech(info, character, false, tre("Geh nun und lass mich allein. Der Untergang ist nahe!", "Now go and leave me alone. The downfall is near!"), gg_snd_Wotan9)

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

			call speech(info, character, false, tre("Ich habe die Kinder gerettet.", "I saved the children."), null)
			call speech(info, character, true, tre("Verflucht seist du! Wie konntest du mir das antun? Der Fürst wird mich bestrafen.", "Cursed are you! How could you do this to me? The prince will punish me."), gg_snd_Wotan10)
			call speech(info, character, false, tre("...", "..."), null)
			call character.xpBonus(30, tre("Rechtschaffenheit", "Righteousness"))

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

			call speech(info, character, false, tre("Ich habe die Kinder geopfert.", "I have sacrified the children."), null)
			call speech(info, character, true, tre("Gut gemacht. Du bist nun ebenfalls ein Diener der Hölle. Ich überreiche dir diese Belohnung.", "Well done. You are now also a servant of hell. I'll give you this reward."), gg_snd_Wotan11)
			call speech(info, character, false, tre("Nimm dich in Acht vor jenen, die uns nicht verstehen. Sonst werden sie dich jagen und verbrennen!", "Beware of those who do not understand us. Otherwise, they will hunt you and burn you!"), gg_snd_Wotan12)
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
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Ich grüße dich, Wotan.", "I greet you Wotan."))
			set this.m_howAreYou = this.addInfo(false, false, thistype.infoConditionHowAreYou, thistype.infoActionHowAreYou, tre("Ist alles in Ordnung?", "Is everything ok?"))
			set this.m_shit = this.addInfo(false, false, thistype.infoConditionShit, thistype.infoActionShit, tre("Wie sitzt es sich auf dem Thron?", "How does it sit on the throne?"))
			set this.m_house = this.addInfo(false, false, thistype.infoConditionHouse, thistype.infoActionHouse, tre("Ich war im Obergeschoss deines Hauses.", "I was on the first floor of your house."))
			set this.m_rescue = this.addInfo(false, false, thistype.infoConditionRescue, thistype.infoActionRescue, tre("Ich habe die Kinder gerettet.", "I saved the children."))
			set this.m_sacrifice = this.addInfo(false, false, thistype.infoConditionSacrifice, thistype.infoActionSacrifice, tre("Ich habe die Kinder geopfert.", "I have sacrified the children."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary