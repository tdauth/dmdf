library StructMapTalksTalkWigberht requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapTalksTalkRicman

	struct TalkWigberht extends ATalk
		private static sound m_soundCHello
		private static sound m_soundNHello
		private static AVote m_vote1

		implement Talk
		
		private AInfo m_hi
		private AInfo m_talkingTooMuch
		private AInfo m_whatAreYouDoing
		private AInfo m_whoAreYou
		private AInfo m_trainingAtNight
		private AInfo m_tellMeAboutYourHome
		private AInfo m_yourArmour
		private AInfo m_letUsAttack
		private AInfo m_orcsAndDarkElvesAreDone
		private AInfo m_bringUsToHolzbruck
		private AInfo m_weAreReady
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// (Falls der Auftrag “Die Nordmänner” noch nicht erhalten wurde)
		private static method infoConditionHi takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), thistype.m_soundCHello)
			call speech(info, character, true, tr("Hallo."), thistype.m_soundNHello)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionTalkingTooMuch takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Du bist wohl nicht so gesprächig?
		private static method infoActionTalkingTooMuch takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bist wohl nicht so gesprächig?"), null)
			call speech(info, character, true, tr("Nein."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		public method askedWhatAreYoDoing takes ACharacter character returns boolean
			return this.infoHasBeenShownToCharacter(this.m_whatAreYouDoing.index(), character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionWhatAreYouDoing takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Was machst du hier?
		private static method infoActionWhatAreYouDoing takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du hier?"), null)
			call speech(info, character, true, tr("Ich warte."), null)
			// (Falls der Charakter Ricman das Gleiche gefragt hat)
			if (TalkRicman.talk().askedWhatAreYoDoing(character)) then
				call speech(info, character, false, tr("Warten alle Nordmänner auf irgendetwas?"), null)
				call speech(info, character, true, tr("Anscheinend."), null)
			else
				call speech(info, character, false, tr("Und worauf?"), null)
				call speech(info, character, true, tr("Auf den Feind."), null)
				call speech(info, character, false, tr("Du meinst die Orks?"), null)
				call speech(info, character, true, tr("Exakt."), null)
			endif

			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionWhoAreYou takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Wer bist du?
		private static method infoActionWhoAreYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Mein Name ist Wigberht."), null)
			call speech(info, character, false, tr("Und was machst du hier?"), null)
			call speech(info, character, true, tr("Ich kam mit meinen Männern aus dem Norden."), null)
			call speech(info, character, false, tr("Aus dem Norden?"), null)
			call speech(info, character, true, tr("Ja, vom nordwestlichen Gebirge."), null)

			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung und wenn es gerade Nacht ist und Wigberht trainiert)
		private static method infoConditionTrainingAtNight takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character) and GetTimeOfDay() >= 18.00 or GetTimeOfDay() <= 5.00
		endmethod

		// Trainierst du nachts?
		private static method infoActionTrainingAtNight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Trainierst du nachts?"), null)
			call speech(info, character, true, tr("Wie du siehst."), null)
			call speech(info, character, false, tr("Und wann schläfst du mal?"), null)
			call speech(info, character, true, tr("Nie."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach „Wer bist du?“)
		private static method infoConditionTellMeAboutYourHome takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_whoAreYou.index(), character) or not QuestTheNorsemen.quest().isNotUsed()
		endmethod
		
		// Erzähl mir etwas über deine Heimat.
		private static method infoActionTellMeAboutYourHome takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir etwas über deine Heimat."), null)
			
			call speech(info, character, true, tr("Dafür habe ich keine Zeit. Ich muss trainieren."), null)
			call speech(info, character, false, tr("Nun komm schon."), null)
			call speech(info, character, true, tr("Meine Heimat ist das Gebirge im Nordwesten. Dort wo noch Schnee liegt um diese Jahreszeit. Es ist eine raue Gegend mit wilden, blutrünstigen Kreaturen."), null)
			call speech(info, character, true, tr("Ich werde sie bis zum Ende gegen die Orks und Dunkelelfen verteidigen."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionYourArmour takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character) or not QuestTheNorsemen.quest().isNotUsed()
		endmethod
		
		// Was trägst du da für eine Rüstung?
		private static method infoActionYourArmour takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was trägst du da für eine Rüstung?"), null)
			call speech(info, character, true, tr("Diese Rüstung gehörte einst meinem Vater. Sie wird schon seit Jahrhunderten von Vater zu Sohn weitergegeben. Sie wurde vom Schmied Hrodo aus dem Erz meiner Heimat gefertigt. So eine Rüstung wirst du kein zweites Mal finden."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Erhalt des zweiten Ziels des Auftrags “Die Nordmänner”, falls dieses noch nicht abgeschlossen ist)
		private static method infoConditionLetUsAttack takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isNew()
		endmethod

		// Lass uns in den Kampf ziehen!
		private static method infoActionLetUsAttack takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Lass uns in den Kampf ziehen!"), null)
			call speech(info, character, true, tr("Gut, wenn ihr alle bereit seid ziehen wir los. Wir sammeln uns nahe des nordwestlichen Orklagers."), null)
			call speech(info, character, true, tr("Und dann schlachten wir sie alle ab!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach erfolgreichem Abschluss des zweiten Ziels des Auftrags “Die Nordmänner”)
		private static method infoConditionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isCompleted()
		endmethod

		// Wir haben die Orks und Dunkelelfen besiegt.
		private static method infoActionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wir haben die Orks und Dunkelelfen besiegt."), null)
			call speech(info, character, true, tr("Besiegt? Wir haben eine Schlacht gegen eine kleine Vorhut der Orks und Dunkelelfen gewonnen."), null)
			call speech(info, character, true, tr("Wir können nicht ruhen, ehe wir nicht meinen Vater befreit haben und wenn wir dafür das gesamte Heer dieser widerlichen Kreaturen abschlachten müssen."), null)
			call speech(info, character, true, tr("Ich möchte euch aber für eure Hilfe danken. Gehe zu Ricman, er hat eine Belohnung für dich."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag “Der Weg nach Holzbruck” ist aktiv)
		private static method infoConditionBringUsToHolzbruck takes AInfo info, ACharacter character returns boolean
			return QuestTheWayToHolzbruck.quest().isNew()
		endmethod

		// Bringt uns nach Holzbruck!
		private static method infoActionBringUsToHolzbruck takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bringt uns nach Holzbruck!"), null)
			call speech(info, character, true, tr("Was?"), null)
			call speech(info, character, false, tr("Der Herzog benötigt Verstärkung aus Holzbruck, einer nördlichen, am Fluss liegenden Stadt. Du wolltest in den Norden, nimm uns bis nach Holzbruck mit!"), null)
			call speech(info, character, true, tr("Hm, dieser Herzog scheint ja wirklich sehr besorgt zu sein. Du hast Recht, wir wollten so bald wie möglich in den Norden aufbrechen und hatten eigentlich damit gerechnet, hier noch die versprochene Hilfe zu leisten."), null)
			call speech(info, character, true, tr("Also gut. Wir nehmen euch in unserem Langboot mit, insofern ihr kräftig genug seid, es auch vorwärts zu bewegen, wenn wir keinen Fahrtwind haben."), null)
			call speech(info, character, true, tr("Meldet euch bei mir, wenn ihr so weit seid."), null)
			call QuestTheWayToHolzbruck.quest().complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag “Der Weg nach Holzbruck” ist abgeschlossen)
		private static method infoConditionWeAreReady takes AInfo info, ACharacter character returns boolean
			return QuestTheWayToHolzbruck.quest().isCompleted()
		endmethod

		private static method resultAction1 takes AVote vote returns nothing
			if (vote.result() == 0) then
				call VideoUpstream.video().play()
				call thistype.m_vote1.destroy()
			endif
		endmethod

		// Wir sind so weit.
		private static method infoActionWeAreReady takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wir sind so weit."), null)
			call speech(info, character, true, tr("Seid ihr auch sicher? Die Fahrt wird vermutlich sehr lange dauern."), null)
			call info.talk().close(character)
			// start vote
			if (thistype.m_vote1 == 0) then
				set thistype.m_vote1 = AVote.create(tr("Wann wollen Sie nach Holzbruck fahren (und das Spiel somit beenden)?"))
				call thistype.m_vote1.setResultAction(thistype.resultAction1)
				call thistype.m_vote1.setRecognizePlayerLeavings(true)
				call thistype.m_vote1.addChoice(tr("Sofort"))
				call thistype.m_vote1.addChoice(tr("Später"))
				call thistype.m_vote1.addForce(GetPlayingUsers())
			endif
			call thistype.m_vote1.start()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.wigberht(), thistype.startPageAction)
			call this.setName(tr("Wigberht"))
			
			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tr("Hallo."))
			set this.m_talkingTooMuch = this.addInfo(false, false, thistype.infoConditionTalkingTooMuch, thistype.infoActionTalkingTooMuch, tr("Du bist wohl nicht so gesprächig?"))
			set this.m_whatAreYouDoing = this.addInfo(false, false, thistype.infoConditionWhatAreYouDoing, thistype.infoActionWhatAreYouDoing, tr("Was machst du hier?"))
			set this.m_whoAreYou = this.addInfo(false, false, thistype.infoConditionWhoAreYou, thistype.infoActionWhoAreYou, tr("Wer bist du?"))
			set this.m_trainingAtNight = this.addInfo(true, false, thistype.infoConditionTrainingAtNight, thistype.infoActionTrainingAtNight, tr("Trainierst du nachts?"))
			set this.m_tellMeAboutYourHome =  this.addInfo(true, false, thistype.infoConditionTellMeAboutYourHome, thistype.infoActionTellMeAboutYourHome, tr("Erzähl mir etwas über deine Heimat."))
			set this.m_yourArmour = this.addInfo(false, false, thistype.infoConditionYourArmour, thistype.infoActionYourArmour, tr("Was trägst du da für eine Rüstung?"))
			set this.m_letUsAttack = this.addInfo(true, false, thistype.infoConditionLetUsAttack, thistype.infoActionLetUsAttack, tr("Lass uns in den Kampf ziehen!"))
			set this.m_orcsAndDarkElvesAreDone = this.addInfo(false, false, thistype.infoConditionOrcsAndDarkElvesAreDone, thistype.infoActionOrcsAndDarkElvesAreDone, tr("Wir haben die Orks und Dunkelelfen besiegt."))
			set this.m_bringUsToHolzbruck = this.addInfo(false, false, thistype.infoConditionBringUsToHolzbruck, thistype.infoActionBringUsToHolzbruck, tr("Bringt uns nach Holzbruck."))
			set this.m_weAreReady = this.addInfo(true, false, thistype.infoConditionWeAreReady, thistype.infoActionWeAreReady, tr("Wir sind so weit."))
			set this.m_exit = this.addExitButton()

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
			set thistype.m_vote1 = 0
		endmethod
	endstruct

endlibrary