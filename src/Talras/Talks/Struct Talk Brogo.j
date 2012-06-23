library StructMapTalksTalkBrogo requires Asl, StructMapMapNpcs

	struct TalkBrogo extends ATalk
		private static constant integer experienceBonus = 50
		private static constant integer catUnitTypeId = 'n00B'
		private static constant integer maxCats = 5
		// members
		private AUnitVector m_cats
		private integer array m_playerCatCount[6] /// @todo @member MapData.maxPlayers, vJass bug
		private boolean array m_playerHasTalkedTo[6] /// @todo @member MapData.maxPlayers, vJass bug

		implement Talk

		public method playerHasTalkedTo takes player whichPlayer returns boolean
			return this.m_playerHasTalkedTo[GetPlayerId(whichPlayer)]
		endmethod

		public method characterHasTalkedTo takes ACharacter character returns boolean
			return this.playerHasTalkedTo(character.player())
		endmethod

		private method countCats takes nothing returns integer
			local player owner = this.character().player()
			local group units = GetUnitsOfPlayerAndTypeId(owner, thistype.catUnitTypeId)
			local integer result = CountUnitsInGroup(units)
			set owner = null
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

		private method addCats takes nothing returns nothing
			local player owner = this.character().player()
			local group units = GetUnitsOfPlayerAndTypeId(owner, thistype.catUnitTypeId)
			local AGroup unitGroup = AGroup.create()
			call unitGroup.addGroup(units, true, false)
			loop
				exitwhen (unitGroup.units().empty() or this.m_playerCatCount[GetPlayerId(owner)] == thistype.maxCats)
				call this.addCat(unitGroup.units().back())
				call unitGroup.units().popBack()
			endloop
			set owner = null
			set units = null
			call unitGroup.destroy()
		endmethod

		private method cats takes nothing returns integer
			return this.m_cats.size()
		endmethod

		private method characterHasAlmostReachedCatMaximum takes ACharacter character, integer newCats returns boolean
			local player owner = character.player()
			local boolean result = this.m_playerCatCount[GetPlayerId(owner)] + newCats == thistype.maxCats - 1
			set owner = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			call this.showUntil(4)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			set thistype(info.talk()).m_playerHasTalkedTo[GetPlayerId(info.talk().character().player())] = true
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Katze?"), null)
			call speech(info, false, tr("Äh, was ist los?"), null)
			call speech(info, true, tr("Katze?"), null)
			call speech(info, false, tr("Was ist mit der?"), null)
			call speech(info, true, tr("Du hast Katze?"), null)
			call speech(info, false, tr("Hm?"), null)
			call speech(info, true, tr("Brogo mag Katzen. Katzen zum Streicheln da. Brogo mag streicheln. Du bringst Katzen zu Brogo, dann Brogo glücklich."), null)
			call QuestCatsForBrogo.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		/// @todo Katzen sind normale kaufbare Einheiten, welche vom Käuferspieler gesteuert werden können. Sie werden an Brogo übergeben und stehen am besten um ihn herum (Katzenflut und so).
		private static method giveCatsToBrogo takes AInfo info returns nothing
			local thistype talk = info.talk()
			local integer countedCats = talk.countCats()
			// (Ist Brogos erste Katze)
			if (talk.cats() == 0) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, true, tr("Toll, Katze, her damit. Brogo will streicheln!"), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, true, tr("Toll, Katzen, her damit. Brogo will streicheln!"), null)
				endif
				call talk.character().addExperience(thistype.experienceBonus, true)
				call talk.character().displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Erfahrungsbonus +%i"), thistype.experienceBonus))
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(tr("%s hat den Katzenbonus erhalten"), talk.character().name()))
			// (Brogo hat schon Katzen, egal von welchem Charakter und Charakter hat noch nicht die Maximalanzahl seiner geschenkten Katzen erreicht)
			elseif (not talk.characterHasAlmostReachedCatMaximum(talk.character(), countedCats)) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, true, tr("Toll, noch eine Katze."), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, true, tr("Toll, noch mehr Katzen."), null)
				endif
				call speech(info, true, tr("Streicheln macht Brogo Spaß. Brogo will aber noch mehr Katzen."), null)
			// (Brogo hat schon Katzen, egal von welchem Charakter und Charakter hat die Maximalanzahl seiner geschenkten Katzen erreicht)
			elseif (talk.cats() > 0 and talk.characterHasAlmostReachedCatMaximum(talk.character(), countedCats)) then
				// (Charakter hat eine Katze)
				if (countedCats == 1) then
					call speech(info, true, tr("Toll, noch eine Katze."), null)
				// (Charakter hat mehrere Katzen)
				else
					call speech(info, true, tr("Toll, noch mehr Katzen."), null)
				endif
				call speech(info, true, tr("Jetzt aber genug Katzen. Brogo gibt dir Belohnung und dankt dir für Katzen."), null)
				call speech(info, true, tr("Belohnung ist Waffe von Troll. Brogo hat getötet viele Trolle. Trolle böser als Katzen."), null)
				call QuestCatsForBrogo.characterQuest(talk.character()).questItem(0).complete()
			endif
			call talk.addCats()
		endmethod

		// (Auftrag „Katzen für Brogo“ ist aktiv und Charakter hat eine Katze)
		private static method infoCondition1 takes AInfo info returns boolean
			return QuestCatsForBrogo.characterQuest(info.talk().character()).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats() == 1
		endmethod

		// Hier hast du eine Katze.
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du eine Katze."), null)
			call thistype.giveCatsToBrogo(info)
			call info.talk().showStartPage()
		endmethod

		// (Auftrag „Katzen für Brogo“ aktiv und Charakter hat mehrere Katzen)
		private static method infoCondition2 takes AInfo info returns boolean
			return QuestCatsForBrogo.characterQuest(info.talk().character()).state() == AAbstractQuest.stateNew and thistype(info.talk()).countCats() > 1
		endmethod

		// Hier hast du ein paar Katzen.
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du ein paar Katzen."), null)
			call thistype.giveCatsToBrogo(info)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Bist du irgendwie verblödet?
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Bist du irgendwie verblödet?"), null)
			call speech(info, true, tr("Nein! Brogo ist schlau. Tanka sagt immer zu Brogo: „Brogo ganz schlau, weil Brogo nicht dumm.“."), null)
			call speech(info, false, tr("Ach so."), null)
			call speech(info, true, tr("Brogo braucht jetzt seine Ruhe. Brogo muss Feuer beobachten. Feuer bewegt sich. Brogo passt auf, dass Feuer nicht abhaut. Brogo ist mutiger Wächter von Feuer."), null)
			call info.talk().showStartPage()
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
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(true, false, thistype.infoCondition1, thistype.infoAction1, tr("Hier hast du eine Katze.")) // 1
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
