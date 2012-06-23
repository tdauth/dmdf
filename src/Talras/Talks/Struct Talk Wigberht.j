library StructMapTalksTalkWigberht requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapTalksTalkRicman

	struct TalkWigberht extends ATalk
		private static sound m_soundCHello
		private static sound m_soundNHello
		private static AVote m_vote0
		private static AVote m_vote1

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(7)
		endmethod

		// (Falls der Auftrag “Die Nordmänner” noch nicht erhalten wurde)
		private static method infoCondition0 takes AInfo info returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), thistype.m_soundCHello)
			call speech(info, true, tr("Hallo."), thistype.m_soundNHello)
			call info.talk().showRange(8, 9)
		endmethod

		// (Wenn es gerade Nacht ist und Wigberht trainiert)
		private static method infoCondition1 takes AInfo info returns boolean
			return GetTimeOfDay() >= 18.00 or GetTimeOfDay() <= 5.00
		endmethod

		// Trainierst du nachts?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Trainierst du nachts?"), null)
			call speech(info, true, tr("Wie du siehst."), null)
			call speech(info, false, tr("Und wann schläfst du mal?"), null)
			call speech(info, true, tr("Nie."), null)
			call speech(info, false, tr("Nie?"), null)
			call speech(info, true, tr("(Belehrend) Der wahre Krieger ist immer bereit."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach erfolgreichem Abschluss des zweiten Ziels des Auftrags “Die Nordmänner”)
		private static method infoCondition2And3 takes AInfo info returns boolean
			return QuestTheNorsemen.quest().questItem(1).isCompleted()
		endmethod

		// Wo hast du so zu kämpfen gelernt?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Wo hast du so zu kämpfen gelernt?"), null)
			call speech(info, true, tr("Erfahrung. Wenn du erst einmal so viele Gegner wie ich getötet hast, kommt das von ganz alleine. Wieso fragst du überhaupt. Hab ich dich etwa so beeindruckt (Lacht)?"), null)
			call info.talk().showRange(10, 11)
		endmethod

		// Was trägst du da für eine Rüstung?
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Was trägst du da für eine Rüstung?"), null)
			call speech(info, true, tr("Diese Rüstung gehörte einst meinem Vater. Sie wird schon seit Jahrhunderten von Vater zu Sohn weitergegeben. Sie wurde vom Schmied Hrodo aus dem Erz meiner Heimat gefertigt. So eine Rüstung wirst du kein zweites Mal finden."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Erhalt des zweiten Ziels des Auftrags “Die Nordmänner”, falls dieses noch nicht abgeschlossen ist)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestTheNorsemen.quest().questItem(1).isNew()
		endmethod

		private static method resultAction0 takes AVote vote returns nothing
			call VideoTheFirstCombat.video().play()
			call thistype.m_vote0.destroy()
		endmethod

		// Lass uns in den Kampf ziehen!
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Lass uns in den Kampf ziehen!"), null)
			call speech(info, true, tr("Gut. Wenn ihr alle bereit seid, kann's losgehen."), null)
			call info.talk().close()
			// start vote
			if (thistype.m_vote0 == 0) then
				set thistype.m_vote0 = AVote.create(tr("Wann wollen Sie den Kampf gegen die Orks beginnen?"))
				call thistype.m_vote0.setResultAction(thistype.resultAction0)
				call thistype.m_vote0.setRecognizePlayerLeavings(true)
				call thistype.m_vote0.addChoice(tr("Sofort"))
				call thistype.m_vote0.addChoice(tr("Später"))
				call thistype.m_vote0.addForce(GetPlayingUsers())
			endif
			call thistype.m_vote0.start()
		endmethod

		// (Auftrag “Der Weg nach Holzbruck” ist aktiv)
		private static method infoCondition5 takes AInfo info returns boolean
			return QuestTheWayToHolzbruck.quest().isNew()
		endmethod

		// Fahrt uns nach Holzbruck!
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, false, tr("Fahrt uns nach Holzbruck!"), null)
			call speech(info, true, tr("Was?"), null)
			call speech(info, false, tr("Der Herzog benötigt Verstärkung aus Holzbruck, einer nördlichen, am Fluss liegenden Stadt. Du wolltest in den Norden, nimm uns bis nach Holzbruck mit!"), null)
			call speech(info, true, tr("Hm, dieser Herzog scheint ja wirklich sehr besorgt zu sein. Du hast Recht, wir wollten so bald wie möglich in den Norden aufbrechen und hatten eigentlich damit gerechnet, hier noch die versprochene Hilfe zu leisten."), null)
			call speech(info, true, tr("Also gut. Wir nehmen euch in unserem Langboot mit, insofern ihr kräftig genug seid, es auch vorwärts zu bewegen, wenn wir keinen Fahrtwind haben."), null)
			call speech(info, true, tr("Meldet euch bei mir, wenn ihr so weit seid."), null)
			call QuestTheWayToHolzbruck.quest().complete()
			call info.talk().showStartPage()
		endmethod

		// (Auftrag “Der Weg nach Holzbruck” ist abgeschlossen)
		private static method infoCondition6 takes AInfo info returns boolean
			return QuestTheWayToHolzbruck.quest().isCompleted()
		endmethod

		private static method resultAction1 takes AVote vote returns nothing
			call VideoUpstream.video().play()
			call thistype.m_vote1.destroy()
		endmethod

		// Wir sind so weit.
		private static method infoAction6 takes AInfo info returns nothing
			call speech(info, false, tr("Wir sind so weit."), null)
			call speech(info, true, tr("Seid ihr auch sicher? Die Fahrt wird vermutlich sehr lange dauern."), null)
			call info.talk().close()
			// start vote
			if (thistype.m_vote1 == 0) then
				set thistype.m_vote1 = AVote.create(tr("Wann wollen Sie nach Holzbruck fahren (und das Spiel somit beenden)?"))
				call thistype.m_vote0.setResultAction(thistype.resultAction1)
				call thistype.m_vote0.setRecognizePlayerLeavings(true)
				call thistype.m_vote1.addChoice(tr("Sofort"))
				call thistype.m_vote1.addChoice(tr("Später"))
				call thistype.m_vote1.addForce(GetPlayingUsers())
			endif
			call thistype.m_vote1.start()
		endmethod

		// Bist wohl nicht so gesprächig?
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Bist wohl nicht so gesprächig?"), null)
			call speech(info, true, tr("Nein."), null)
			call info.talk().showRange(12, 14)
		endmethod

		// Klar.
		private static method infoAction2_0 takes AInfo info returns nothing
			call speech(info, false, tr("Klar."), null)
			call info.talk().showStartPage()
		endmethod

		// Unsinn! Ich wollte nur mal wissen, wieso du kämpfst wie ein Schweinehirte aus der Gosse.
		private static method infoAction2_1 takes AInfo info returns nothing
			call speech(info, false, tr("Unsinn! Ich wollte nur mal wissen, wieso du kämpfst wie ein Schweinehirte aus der Gosse."), null)
			call speech(info, true, tr("Na ja, ich musste ja lange genug auf euch aufpassen ..."), null)
			call info.talk().showStartPage()
		endmethod

		// Was machst du hier?
		private static method infoAction0_0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Was machst du hier?"), null)
			call speech(info, true, tr("Ich warte."), null)
			// (Falls der Charakter Ricman das Gleiche gefragt hat)
			if (TalkRicman.talk().infoHasBeenShownToCharacter(9, info.talk().character())) then
				call speech(info, false, tr("Warten alle Nordmänner auf irgendetwas?"), null)
				call speech(info, true, tr("Anscheinend."), null)
			else
				call speech(info, false, tr("Und worauf?"), null)
				call speech(info, true, tr("Auf den Feind."), null)
				call speech(info, false, tr("Du meinst die Orks?"), null)
				call speech(info, true, tr("Exakt."), null)
			endif

			call info.talk().showRange(12, 14)
		endmethod

		// Wer bist du?
		private static method infoAction0_0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Wer bist du?"), null)
			call speech(info, true, tr("Mein Name ist Wigberht."), null)
			call speech(info, false, tr("Und was machst du hier?"), null)
			call speech(info, true, tr("Ich kam mit meinen Männern aus dem Norden."), null)
			call speech(info, false, tr("Aus dem Norden?"), null)
			call speech(info, true, tr("Ja, vom nordwestlichen Gebirge."), null)

			call info.talk().showRange(12, 14)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.wigberht(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, thistype.infoCondition0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(true, false, thistype.infoCondition1, thistype.infoAction1, tr("Trainierst du nachts?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction2, tr("Wo hast du so zu kämpfen gelernt?")) // 2
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction3, tr("Was trägst du da für eine Rüstung?")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tr("Lass uns in den Kampf ziehen!")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Fahrt uns nach Holzbruck.")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Wir sind so weit.")) // 6
			call this.addExitButton() // 7

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Bist wohl nicht so gesprächig?")) // 8
			call this.addBackToStartPageButton() // 9

			// info 2
			call this.addInfo(true, false, 0, thistype.infoAction2_0, tr("Klar.")) // 10
			call this.addInfo(true, false, 0, thistype.infoAction2_1, tr("Unsinn! Ich wollte nur mal wissen, wieso du kämpfst wie ein Schweinehirte aus der Gosse.")) // 11

			// info 0 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0_0, tr("Was machst du hier?")) // 12
			call this.addInfo(false, false, 0, thistype.infoAction0_0_1, tr("Wer bist du?")) // 13
			call this.addBackToStartPageButton() // 14

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			// 2 Sekunden = 2000 ms
			set thistype.m_soundCHello = CreateSound("Sound\\Talks\\Wigberht\\CHallo.wav", false, false, false, 10, 10, "")
			call SetSoundDuration(thistype.m_soundCHello, 1000)
			call SetSoundChannel(thistype.m_soundCHello, 0)
			call SetSoundVolume(thistype.m_soundCHello, 127)
			call SetSoundPitch(thistype.m_soundCHello, 1.0)

			set thistype.m_soundNHello = CreateSound("Sound\\Talks\\Wigberht\\NHallo.wav", false, false, false, 10, 10, "")
			call SetSoundDuration(thistype.m_soundNHello, 1000)
			call SetSoundChannel(thistype.m_soundNHello, 0)
			call SetSoundVolume(thistype.m_soundNHello, 127)
			call SetSoundPitch(thistype.m_soundNHello, 1.0)
			set thistype.m_vote0 = 0
			set thistype.m_vote1 = 0
		endmethod
	endstruct

endlibrary