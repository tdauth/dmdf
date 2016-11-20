library StructMapTalksTalkBrogo requires Asl, StructMapMapNpcs

	struct TalkBrogo extends Talk
		private static constant integer experienceBonus = 50
		private static constant integer catUnitTypeId = 'n00B'
		private static constant integer maxCats = 5
		// members
		private AUnitVector m_cats
		private integer array m_playerCatCount[12] /// @todo @member MapSettings.maxPlayers(), vJass bug
		private boolean array m_playerHasTalkedTo[12] /// @todo @member MapSettings.maxPlayers(), vJass bug
		private AInfo m_hi
		private AInfo m_hereIsACat

		public method playerHasTalkedTo takes player whichPlayer returns boolean
			return this.m_playerHasTalkedTo[GetPlayerId(whichPlayer)]
		endmethod

		public method characterHasTalkedTo takes ACharacter character returns boolean
			return this.playerHasTalkedTo(character.player())
		endmethod

		private method countCats takes player owner returns integer
			local group units = GetUnitsOfPlayerAndTypeId(owner, thistype.catUnitTypeId)
			local integer result = CountUnitsInGroup(units)
			call DestroyGroup(units)
			set units = null
			return result
		endmethod

		private method addCat takes unit cat returns integer
			local player owner = GetOwningPlayer(cat)
			local player newOwner = Player(PLAYER_NEUTRAL_PASSIVE)
			debug if (this.m_playerCatCount[GetPlayerId(owner)] == thistype.maxCats) then
				debug call Print("Cats maximum has already been reached.")
			debug endif
			call SetUnitOwner(cat, newOwner, true)
			call SetUnitInvulnerable(cat, true)
			call IssueTargetOrder(cat, "move", gg_unit_n020_0012)
			call this.m_cats.pushBack(cat)
			set this.m_playerCatCount[GetPlayerId(owner)] = this.m_playerCatCount[GetPlayerId(owner)] + 1
			set owner = null
			set newOwner = null
			return this.m_cats.backIndex()
		endmethod

		private method addCats takes player owner returns nothing
			local group units = GetUnitsOfPlayerAndTypeId(owner, thistype.catUnitTypeId)
			local AGroup unitGroup = AGroup.create()
			call unitGroup.addGroup(units, true, false)
			loop
				exitwhen (unitGroup.units().empty() or this.m_playerCatCount[GetPlayerId(owner)] == thistype.maxCats)
				call this.addCat(unitGroup.units().back())
				call unitGroup.units().popBack()
			endloop
			set units = null
			call unitGroup.destroy()
		endmethod

		private method cats takes nothing returns integer
			return this.m_cats.size()
		endmethod

		private method characterHasReachedMaximum takes ACharacter character, integer newCats returns boolean
			return this.m_playerCatCount[GetPlayerId(character.player())] + newCats >= thistype.maxCats
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(4, character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			set this.m_playerHasTalkedTo[GetPlayerId(character.player())] = true
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Katze?", "Cat?"), gg_snd_Brogo1)
			call speech(info, character, false, tre("Äh, was ist los?", "Uh, what is going on?"), null)
			call speech(info, character, true, tre("Katze?", "Cat?"), gg_snd_Brogo2)
			call speech(info, character, false, tre("Was ist mit der?", "What's with her?"), null)
			call speech(info, character, true, tre("Du hast Katze?", "You have cat?"), gg_snd_Brogo3)
			call speech(info, character, false, tre("Hm?", "Hm?"), null)
			call speech(info, character, true, tre("Brogo mag Katzen. Katzen zum Streicheln da. Brogo mag streicheln. Du bringst Katzen zu Brogo, dann Brogo glücklich.", "Brogo likes cats. Cats exist for stroking. Brogo likes stroke. You bring cats to Brogo, then Brogo happy."), gg_snd_Brogo4)
			call QuestCatsForBrogo.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		/// Katzen sind normale kaufbare Einheiten, welche vom Käuferspieler gesteuert werden können. Sie werden an Brogo übergeben und stehen am besten um ihn herum (Katzenflut und so).
		private static method giveCatsToBrogo takes AInfo info, Character character returns nothing
			local thistype talk = thistype(info.talk())
			local integer countedCats = talk.countCats(character.player())
			debug call Print("Count cats: " + I2S(countedCats))
			// (Ist Brogos erste Katze)
			if (talk.cats() == 0) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, character, true, tre("Toll, Katze, her damit. Brogo will streicheln!", "Great, cat, bring her on. Brogo wants to stroke!"), gg_snd_Brogo5)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, character, true, tre("Toll, Katzen, her damit. Brogo will streicheln!", "Great, cats, bring them on. Brogo wants to stroke!"), gg_snd_Brogo6)
				endif
				call character.addExperience(thistype.experienceBonus, true)
				call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tre("Erfahrungsbonus +%i", "Experience Bonus +%i"), thistype.experienceBonus))
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(tre("%s hat den Katzenbonus erhalten", "%s received the Cat Bonus"), character.name()))
			// (Brogo hat schon Katzen, egal von welchem Charakter)
			else
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, character, true, tre("Toll, noch eine Katze.", "Great, another cat."), gg_snd_Brogo7)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, character, true, tre("Toll, noch mehr Katzen.", "Great, even more cats."), gg_snd_Brogo8)
				endif
			endif
			// (Brogos Maximalanzahl der geschenkten Katzen erreicht)
			if (talk.characterHasReachedMaximum(character, countedCats)) then
				call speech(info, character, true, tre("Jetzt aber genug Katzen. Brogo gibt dir Belohnung und dankt dir für Katzen.", "But enough cats now. Brogo gives you reward and thanks you for cats."), gg_snd_Brogo10) // TODO split gg_snd_Brogo10
				call speech(info, character, true, tre("Belohnung ist Waffe von Troll. Brogo hat getötet viele Trolle. Trolle böser als Katzen.", "Reward is weapon of troll. Brogo has killed many trolls. Trolls worse than cats."), gg_snd_Brogo10)
				call QuestCatsForBrogo.characterQuest(character).questItem(0).complete()
				call character.giveItem('I062')
			// (Brogos Maximalanzahl der geschenkten Katzen noch nicht erreicht)
			else
				call speech(info, character, true, tre("Streicheln macht Brogo Spaß. Brogo will aber noch mehr Katzen.", "Stroking is fun to Brogo. But Brogo wants more cats."), gg_snd_Brogo9)
			endif
			call talk.addCats(character.player())
		endmethod

		// (Auftrag „Katzen für Brogo“ ist aktiv und Charakter hat eine Katze)
		private static method infoConditionQuestCatsForBrogoIsActive takes AInfo info, ACharacter character returns boolean
			return QuestCatsForBrogo.characterQuest(character).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats(character.player()) == 1
		endmethod

		// Hier hast du eine Katze.
		private static method infoActionHereIsACat takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier hast du eine Katze.", "Here you have a cat."), null)
			call thistype.giveCatsToBrogo(info, character)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Katzen für Brogo“ aktiv und Charakter hat mehrere Katzen)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return QuestCatsForBrogo.characterQuest(character).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats(character.player()) > 1
		endmethod

		// Hier hast du ein paar Katzen.
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier hast du ein paar Katzen.", "Here you have a couple of cats."), null)
			call thistype.giveCatsToBrogo(info, character)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Bist du irgendwie verblödet?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Bist du irgendwie verblödet?", "Are you somehow stupid?"), null)
			call speech(info, character, true, tre("Nein! Brogo ist schlau. Tanka sagt immer zu Brogo: „Brogo ganz schlau, weil Brogo nicht dumm.“.", "No! Brogo is smart. Tanka says always to Brogo \"Brogo quite clever because Brogo not stupid.\"."), gg_snd_Brogo11)
			call speech(info, character, false, tre("Ach so.", "Ah."), null)
			call speech(info, character, true, tre("Brogo braucht jetzt seine Ruhe. Brogo muss Feuer beobachten. Feuer bewegt sich. Brogo passt auf, dass Feuer nicht abhaut. Brogo ist mutiger Wächter von Feuer.", "Brogo now needs his rest. Brogo must observe fire. Fire moves. Brogo takes care that fire not leaving. Brogo is courageous guardin of fire."), gg_snd_Brogo12)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.brogo(), thistype.startPageAction)
			local integer i = 0
			// members
			set this.m_cats = AUnitVector.create()
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_playerCatCount[i] = 0
				set this.m_playerHasTalkedTo[i] = false
				set i = i + 1
			endloop

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo.", "Hello.")) // 0
			set this.m_hereIsACat = this.addInfo(true, false, thistype.infoConditionQuestCatsForBrogoIsActive, thistype.infoActionHereIsACat, tre("Hier hast du eine Katze.", "Here you have a cat.")) // 1
			call this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tre("Hier hast du ein paar Katzen.", "Here you have a couple of cats.")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Bist du irgendwie verblödet?", "Are you somehow stupid?")) // 3
			call this.addExitButton() // 4

			return this
		endmethod

		private method onDestroy takes nothing returns nothing
			call this.m_cats.destroy()
		endmethod

		implement Talk
	endstruct

endlibrary
