library StructMapTalksTalkBrogo requires Asl, StructMapMapNpcs

	struct TalkBrogo extends ATalk
		private static constant integer experienceBonus = 50
		private static constant integer catUnitTypeId = 'n00B'
		private static constant integer maxCats = 5
		// members
		private AUnitVector m_cats
		private integer array m_playerCatCount[6] /// @todo @member MapData.maxPlayers, vJass bug
		private boolean array m_playerHasTalkedTo[6] /// @todo @member MapData.maxPlayers, vJass bug
		private AInfo m_hi
		private AInfo m_hereIsACat

		implement Talk

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
			local player owner = character.player()
			local boolean result = this.m_playerCatCount[GetPlayerId(owner)] + newCats >= thistype.maxCats
			set owner = null
			return result
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(4, character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			set thistype(info.talk()).m_playerHasTalkedTo[GetPlayerId(character.player())] = true
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Katze?"), null)
			call speech(info, character, false, tr("Äh, was ist los?"), null)
			call speech(info, character, true, tr("Katze?"), null)
			call speech(info, character, false, tr("Was ist mit der?"), null)
			call speech(info, character, true, tr("Du hast Katze?"), null)
			call speech(info, character, false, tr("Hm?"), null)
			call speech(info, character, true, tr("Brogo mag Katzen. Katzen zum Streicheln da. Brogo mag streicheln. Du bringst Katzen zu Brogo, dann Brogo glücklich."), null)
			call QuestCatsForBrogo.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		/// @todo Katzen sind normale kaufbare Einheiten, welche vom Käuferspieler gesteuert werden können. Sie werden an Brogo übergeben und stehen am besten um ihn herum (Katzenflut und so).
		private static method giveCatsToBrogo takes AInfo info, ACharacter character returns nothing
			local thistype talk = info.talk()
			local integer countedCats = talk.countCats(character.player())
			// (Ist Brogos erste Katze)
			if (talk.cats() == 0) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, character, true, tr("Toll, Katze, her damit. Brogo will streicheln!"), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, character, true, tr("Toll, Katzen, her damit. Brogo will streicheln!"), null)
				endif
				call character.addExperience(thistype.experienceBonus, true)
				call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Erfahrungsbonus +%i"), thistype.experienceBonus))
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(tr("%s hat den Katzenbonus erhalten"), character.name()))
			// (Brogo hat schon Katzen, egal von welchem Charakter und Charakter hat noch nicht die Maximalanzahl seiner geschenkten Katzen erreicht)
			elseif (not talk.characterHasReachedMaximum(character, countedCats)) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, character, true, tr("Toll, noch eine Katze."), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, character, true, tr("Toll, noch mehr Katzen."), null)
				endif
				call speech(info, character, true, tr("Streicheln macht Brogo Spaß. Brogo will aber noch mehr Katzen."), null)
			// (Brogo hat schon Katzen, egal von welchem Charakter und Charakter hat die Maximalanzahl seiner geschenkten Katzen erreicht)
			elseif (talk.cats() > 0 and talk.characterHasReachedMaximum(character, countedCats)) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, character, true, tr("Toll, noch eine Katze."), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, character, true, tr("Toll, noch mehr Katzen."), null)
				endif
				call speech(info, character, true, tr("Jetzt aber genug Katzen. Brogo gibt dir Belohnung und dankt dir für Katzen."), null)
				call speech(info, character, true, tr("Belohnung ist Waffe von Troll. Brogo hat getötet viele Trolle. Trolle böser als Katzen."), null)
				call QuestCatsForBrogo.characterQuest(character).questItem(0).complete()
			endif
			call talk.addCats(character.player())
		endmethod

		// (Auftrag „Katzen für Brogo“ ist aktiv und Charakter hat eine Katze)
		private static method infoConditionQuestCatsForBrogoIsActive takes AInfo info, ACharacter character returns boolean
			return QuestCatsForBrogo.characterQuest(character).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats(character.player()) == 1
		endmethod

		// Hier hast du eine Katze.
		private static method infoActionHereIsACat takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du eine Katze."), null)
			call thistype.giveCatsToBrogo(info, character)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Katzen für Brogo“ aktiv und Charakter hat mehrere Katzen)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return QuestCatsForBrogo.characterQuest(character).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats(character.player()) > 1
		endmethod

		// Hier hast du ein paar Katzen.
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du ein paar Katzen."), null)
			call thistype.giveCatsToBrogo(info, character)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Bist du irgendwie verblödet?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bist du irgendwie verblödet?"), null)
			call speech(info, character, true, tr("Nein! Brogo ist schlau. Tanka sagt immer zu Brogo: „Brogo ganz schlau, weil Brogo nicht dumm.“."), null)
			call speech(info, character, false, tr("Ach so."), null)
			call speech(info, character, true, tr("Brogo braucht jetzt seine Ruhe. Brogo muss Feuer beobachten. Feuer bewegt sich. Brogo passt auf, dass Feuer nicht abhaut. Brogo ist mutiger Wächter von Feuer."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.brogo(), thistype.startPageAction)
			local integer i = 0
			// members
			set this.m_cats = AUnitVector.create()
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_playerCatCount[i] = 0
				set this.m_playerHasTalkedTo[i] = false
				set i = i + 1
			endloop

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo.")) // 0
			set this.m_hereIsACat = this.addInfo(true, false, thistype.infoConditionQuestCatsForBrogoIsActive, thistype.infoActionHereIsACat, tr("Hier hast du eine Katze.")) // 1
			call this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tr("Hier hast du ein paar Katzen.")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Bist du irgendwie verblödet?")) // 3
			call this.addExitButton() // 4

			return this
		endmethod

		private method onDestroy takes nothing returns nothing
			call this.m_cats.destroy()
		endmethod
	endstruct

endlibrary
