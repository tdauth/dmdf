library StructMapTalksTalkMother requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkMother extends Talk
		public static constant integer goldCoins = 50
		private boolean array m_hasAlreadyAskedAfterTraveling[12] /// TODO use bj_MAX_PLAYERS
		private AInfo m_hi
		private AInfo m_food
		private AInfo m_back
		private AInfo m_exit

		private AInfo m_gold
		private AInfo m_goldBack

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
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemTalk).isNew()
		endmethod

		private static method infoActionHi takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Mutter!", "Hello Mother!"), null)
			call speech(info, character, true, tre("Hallo, mein Sohn. Ich weiß du möchtest sobald wie möglich aufbrechen, doch kann ich dich noch um einen kleinen Gefallen bitten?", "Hello, my son. I know you want to start off as soon as possible but can I ask you for a small favor?"), gg_snd_Mother02)
			call speech(info, character, false, tre("Wenn es unbedingt sein muss.", "If it must be."), null)
			call speech(info, character, true, tre("Also, wie sprichst du denn mit deiner Mutter?! Könntest du mir noch einige Waren bei Hans besorgen? Ich habe gerade keine Zeit dafür.", "So, is that the way you talk to your mother?! Could you bring me some goods from Hans? I'm busy at the moment."), gg_snd_Mother03)
			call speech(info, character, false, tre("Na gut.", "Fine."), null)
			call speech(info, character, true, tre("Sehr gut, hier hast du ein paar Goldmünzen. Besorge mir drei Laibe Brot und vier Äpfel.", "Very good, here you have a few gold coins. Get three loaves of bread and four apples."), gg_snd_Mother04)
			call character.addGold(30)

			call QuestMother.characterQuest(character).questItem(QuestMother.questItemTalk).setState(QuestMother.stateCompleted)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGoods).setState(QuestMother.stateNew)
			call QuestMother.characterQuest(character).displayState()

			call character.displayHint(tre("Falls Ihnen Goldmünzen fehlen, können Sie Pflanzen einsammeln und bei Hans verkaufen.", "If you do not have gold coins, you can pick up plants and sell them to Hans."))

			call this.showStartPage(character)
		endmethod

		private static method infoConditionFood takes AInfo info, ACharacter character returns boolean
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemBring).isNew() and character.inventory().totalItemTypeCharges('I016') >= QuestMother.maxBread and character.inventory().totalItemTypeCharges('I03O') >= QuestMother.maxApples
		endmethod

		private static method infoActionFood takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			local integer i = 0
			call speech(info, character, false, tre("Hier sind die Waren.", "There you have your goods."), null)
			call speech(info, character, true, tre("Ich danke dir mein Sohn! Immerhin bist du noch zuverlässig. Nun lasse ich dich schließlich gehen, auch wenn es mir das Herz bricht. Pass auf dich auf und denke daran, unser Gasthof läuft schlecht. Etwas mehr Goldmünzen könnte ich gut gebrauchen.", "I thank you my son! After all, you're still reliable. Now I'll let you go, even if it breaks my heart. Take care of yourself and remember that our inn runs badly. I could use a little more gold coins."), gg_snd_Mother05)
			call speech(info, character, true, tre("Mögen die Götter dich beschützen und pass gut auf dich auf! ... Ach so, sei doch bitte so lieb und sag Gotlinde noch Lebwohl, so wie es sich gehört.", "May the gods protect you and take good care of you! ... Oh, please be so kind and tell Gotlinde good-bye, as it is."), gg_snd_Mother06)
			call speech(info, character, false, tre("Mutter, ich ...", "Mother, I ..."), null)
			call speech(info, character, true, tre("Nun mach schon. Ach und nimm diesen Brief mit dir mein Sohn. Er soll dich an deine arme Mutter erinnern.", "Come on. Oh and take this letter with you my son. It shall remind you of your poor mother."), gg_snd_Mother07)

			set i = 0
			loop
				exitwhen (i == QuestMother.maxBread)
				call character.inventory().removeItemType('I016')
				set i = i + 1
			endloop

			set i = 0
			loop
				exitwhen (i == QuestMother.maxApples)
				call character.inventory().removeItemType('I03O')
				set i = i + 1
			endloop

			call QuestMother.characterQuest(character).questItem(QuestMother.questItemBring).setState(QuestMother.stateCompleted)
			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).setState(QuestMother.stateNew)
			call QuestMother.characterQuest(character).displayState()

			call character.giveItem('I061')

			call this.showStartPage(character)
		endmethod

		private static method infoConditionBack takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return MapData.traveled.evaluate() and not this.hasAlreadyAskedAfterTraveling(character.player())
		endmethod

		private static method infoActionBack takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call this.setHasAlreadyAskedAfterTraveling(character.player(), true)
			call speech(info, character, false, tre("Da bin ich wieder.", "Here I am."), null)
			call speech(info, character, true, tre("Mein Sohn! Den Göttern sei Dank, du bist gesund zurückgekehrt. Hier nimm diesen Kuchen, den ich für dich gebacken habe.", "My son! Thank the gods, you have returned safely. Here take this cake which I baked for you."), gg_snd_Mother08)
			// Apfelkuchen geben
			call character.giveItem('I07F')
			call speech(info, character, true, tre("Sprich, hast du zufällig ein paar Goldmünzen für unseren Gasthof mitgebracht?", "Say, did you bring a few gold coins for our inn?"), gg_snd_Mother09)

			call this.showRange(this.m_gold.index(), this.m_goldBack.index(), character)
		endmethod

		private static method infoConditionGold takes AInfo info, Character character returns boolean
			return GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) >= thistype.goldCoins
		endmethod

		private static method infoActionGold takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			if (thistype.infoConditionGold(info, character)) then
				call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) - thistype.goldCoins)
				call speech(info, character, false, tre("Hier sind 50 Goldmünzen.", "Here you have 50 gold coins."), null)
				call speech(info, character, true, tre("Das freut mich aber, mein Sohn. Ich bin stolz auf dich. Bald können wir unseren Gasthof ausbauen, zu einem stattlichen Gebäude.", "That pleases me, my son. I'm proud of you. Soon we will be able to expand our inn into an imposing building."), gg_snd_Mother10)
				// TODO some effect!
			else
				call speech(info, character, false, tre("Leider nicht.", "Unfortunately not."), null)
				call speech(info, character, true, tre("Schade, sehr schade.", "Too bad, very sad."), gg_snd_Mother11)
			endif

			call this.showStartPage(character)
		endmethod

		private static method infoActionGoldBack takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Leider nicht.", "Unfortunately not."), null)
			call speech(info, character, true, tre("Schade, sehr schade.", "Too bad, very sad."), null)
			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.mother(), thistype.startPageAction)
			call this.setName(tre("Mutter", "Mother"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo Mutter!", "Hello mother!"))
			set this.m_food = this.addInfo(false, false, thistype.infoConditionFood, thistype.infoActionFood, tre("Hier sind die Waren.", "There you have your goods."))
			set this.m_back = this.addInfo(true, false, thistype.infoConditionBack, thistype.infoActionBack, tre("Da bin ich wieder.", "Here I am."))
			set this.m_exit = this.addExitButton()

			set this.m_gold = this.addInfo(true, false, thistype.infoConditionGold, thistype.infoActionGold, tre("Hier sind 50 Goldmünzen.", "Here you have 50 gold coins."))
			set this.m_goldBack = this.addInfo(true, false, 0, thistype.infoActionGoldBack, tre("Leider nicht.", "Unfortunately not."))

			return this
		endmethod

		implement Talk
	endstruct

endlibrary