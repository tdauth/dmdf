library StructMapTalksTalkOsman requires Asl, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestWitchingHour

	struct TalkOsman extends ATalk
		private static constant integer brotherGoldReward = 20
		private boolean array m_wasOffended[6] /// \todo \ref Game.maxPlayers, vJass bug.
		private boolean array m_gaveHealPotion[6] /// \todo \refGame.maxPlayers, vJass bug.

		implement Talk

		private method offend takes nothing returns nothing
			local player user = this.character().player()
			set this.m_wasOffended[GetPlayerId(user)] = true
			set user = null
		endmethod

		private method wasOffended takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_wasOffended[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method giveHealPotion takes nothing returns nothing
			local player user = this.character().player()
			local unit characterUnit = this.character().unit()
			local item healPotion = CreateItem('I00A', GetUnitX(characterUnit), GetUnitY(characterUnit))
			call UnitAddItem(characterUnit, healPotion)
			set this.m_gaveHealPotion[GetPlayerId(user)] = true
			set user = null
			set characterUnit = null
			set healPotion = null
		endmethod

		private method gaveHealPotion takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_gaveHealPotion[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			call this.showUntil(4)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			if (info.talk().character().class() == Classes.cleric()) then
				call speech(info, true, tr("Sei gegrüßt werter Bruder. Es ist selten geworden, dass ich einen Glaubensgenossen treffe"), null)
				call info.talk().showRange(5, 6)
			else
				call speech(info, true, tr("Ich grüße dich."), null)
				call info.talk().showStartPage()
			endif
		endmethod

		// (Nach der Begrüßung, Osman steht vor den Gräbern und betet)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0) and RectContainsUnit(gg_rct_waypoint_osman_0, gg_unit_n00R_0101)
		endmethod

		// Was machst du hier?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Was machst du hier?"), null)
			if (not TalkOsman(info.talk()).wasOffended()) then
				call speech(info, true, tr("Nun, ich bin Osman, der Kleriker des Herzogs und wie du vielleicht gesehen hast, habe ich hier gebetet, um in meinem Glauben Kraft zu finden und unseren geliebten Herzog zu stärken."), null)
				call speech(info, true, tr("Dies hier sind die Gräber der Ahnen unseres Herzogs. Mögen Sie in Frieden ruhen."), null)
				call info.talk().showStartPage()
			else
				call speech(info, true, tr("Was maßt du dir an, mich weiterhin zu belästigen? Soll ich dich etwa der Ketzerei beschuldigen?"), null)
				call info.talk().showRange(7, 8)
			endif
		endmethod

		// (Charakter hat den Heiltrank erhalten)
		private static method infoCondition2 takes AInfo info returns boolean
			return TalkOsman(info.talk()).gaveHealPotion()
		endmethod

		// Hast du noch mehr Heilmittel?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Hast du noch mehr Heilmittel?"), null)
			// (Wird zum ersten Mal aufgerufen)
			if (not info.talk().infoHasBeenShown(2)) then
				call speech(info, true, tr("So, der Trank ist dir also gut bekommen? Das freut mich zu hören. Selbstverständlich habe ich noch mehr Heilmittel, allerdings wird dich das auch eine Kleinigkeit kosten."), null)
			// (Wird nicht zum ersten Mal aufgerufen)
			else
				call speech(info, true, tr("Noch mehr? Mann, wo treibst du dich denn rum? Wie auch immer, selbstverständlich habe ich noch ein paar."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// (Nach der Begrüßung, Auftragsziel 1 des Auftrags „Geisterstunde“ ist aktiv)
		private static method infoCondition3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0) and QuestWitchingHour.characterQuest(info.talk().character()).questItem(0).isNew()
		endmethod

		// Guntrich braucht deine Hilfe.
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, true, tr("Guntrich braucht deine Hilfe. Er sagt, auf dem Berg, auf dem seine Mühle steht, würde es spuken und …"), null)
			call speech(info, false, tr("Verdammt! Ich hab schon genug zu tun, hier in der Burg. Soll er sich doch selbst drum kümmern. Solange er das nicht bezahlen kann, werde ich keinen Finger krumm machen!"), null)
			// Auftragsziel 1 des Auftrags „Geisterstunde“ ist abgeschlossen
			call QuestWitchingHour.characterQuest(info.talk().character()).questItem(0).setState(AAbstractQuest.stateCompleted)
			call QuestWitchingHour.characterQuest(info.talk().character()).questItem(1).enable()
			call info.talk().showStartPage()
		endmethod

		// Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben."), null)
			call speech(info, true, tr("Hüte deine Zunge elender Wurm!"), null)
			call TalkOsman(info.talk()).offend()
			call info.talk().showStartPage()
		endmethod

		// Die Freude ist ganz meinerseits.
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Die Freude ist ganz meinerseits."), null)
			call speech(info, true, tr("Na das ist mir doch glatt ein paar Goldmünzen wert. Hier, nimm Bruder!"), null)
			call info.talk().character().addGold(thistype.brotherGoldReward)
			call speech(info, false, tr("Danke."), null)
			call info.talk().showStartPage()
		endmethod

		// So so, du stehst wohl auf junge Knaben.
		private static method infoAction1_0 takes AInfo info returns nothing
			call speech(info, false, tr("So so, du stehst wohl auf junge Knaben."), null)
			call speech(info, true, tr("Jetzt reicht's mir! Ich werde mich beim Herzog persönlich über dich beschweren!"), null)
			call QuestThePaedophilliacCleric.characterQuest(info.talk().character()).enable()
			call speech(info, false, tr("Es war mir ein Vergnügen."), null)
			call speech(info, true, tr("Du wirst schon noch dein blaues Wunder erleben!"), null)
			call info.talk().showStartPage()
		endmethod

		// Das vorhin tut mir leid. Ich hab das nicht so gemeint.
		private static method infoAction1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Das vorhin tut mir leid. Ich hab das nicht so gemeint."), null)
			call speech(info, true, tr("Schon gut. Ich weiß ja wie angespannt die Lage ist, da kann einem so etwas schon mal raus rutschen."), null)
			call speech(info, true, tr("Verdammter Krieg eben."), null)
			call info.talk().showRange(9, 10)
		endmethod

		// Halt den Mund du Tölpel!
		private static method infoAction1_0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Halt den Mund du Tölpel!"), null)
			call speech(info, true, tr("Du scheinst wohl unter Stimmungsschwankungen zu leiden. Ich glaube, ich hab da was für dich. Wäre doch gelacht, wenn dir ein alter Kleriker wie ich nicht helfen könnte. Hier, nimm das!"), null)
			call TalkOsman(info.talk()).giveHealPotion()
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.osman(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_wasOffended[i] = false
				set this.m_gaveHealPotion[i] = false
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(true, false, thistype.infoCondition1, thistype.infoAction1, tr("Was machst du hier?")) // 1
			call this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tr("Hast du noch mehr Heilmittel?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Guntrich braucht deine Hilfe.")) // 3
			call this.addExitButton() // 4

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.")) // 5
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Die Freude ist ganz meinerseits.")) // 6

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("So so, du stehst wohl auf junge Knaben.")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Das vorhin tut mir leid. Ich hab das nicht so gemeint.")) // 8

			// info 1 0
			call this.addInfo(false, false, 0, thistype.infoAction1_0_0, tr("Halt den Mund du Tölpel!")) // 9
			call this.addBackToStartPageButton() // 10

			return this
		endmethod
	endstruct

endlibrary