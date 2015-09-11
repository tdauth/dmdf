library StructMapTalksTalkWigberht requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapTalksTalkRicman

	struct TalkWigberht extends Talk

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
		private AInfo m_victory
		private AInfo m_bringUsToHolzbruck
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
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo."), gg_snd_Wigberht1)
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
			call speech(info, character, true, tr("Nein."), gg_snd_Wigberht2)
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
			call speech(info, character, true, tr("Ich warte."), gg_snd_Wigberht3)
			// (Falls der Charakter Ricman das Gleiche gefragt hat)
			if (TalkRicman.talk().askedWhatAreYoDoing(character)) then
				call speech(info, character, false, tr("Warten alle Nordmänner auf irgendetwas?"), null)
				call speech(info, character, true, tr("Anscheinend."), gg_snd_Wigberht4)
			else
				call speech(info, character, false, tr("Und worauf?"), null)
				call speech(info, character, true, tr("Auf den Feind."), gg_snd_Wigberht5)
				call speech(info, character, false, tr("Du meinst die Orks?"), null)
				call speech(info, character, true, tr("Exakt."), gg_snd_Wigberht6)
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
			call speech(info, character, true, tr("Mein Name ist Wigberht."), gg_snd_Wigberht7)
			call speech(info, character, false, tr("Und was machst du hier?"), null)
			call speech(info, character, true, tr("Ich kam mit meinen Männern aus dem Norden."), gg_snd_Wigberht8)
			call speech(info, character, false, tr("Aus dem Norden?"), null)
			call speech(info, character, true, tr("Ja, vom nordwestlichen Gebirge."), gg_snd_Wigberht9)

			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung und wenn es gerade Nacht ist und Wigberht trainiert)
		private static method infoConditionTrainingAtNight takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character) and GetTimeOfDay() >= 22.00 or GetTimeOfDay() <= 5.00
		endmethod

		// Trainierst du nachts?
		private static method infoActionTrainingAtNight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Trainierst du nachts?"), null)
			call speech(info, character, true, tr("Wie du siehst."), gg_snd_Wigberht10)
			call speech(info, character, false, tr("Und wann schläfst du mal?"), null)
			call speech(info, character, true, tr("Nie."), gg_snd_Wigberht11)
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
			
			call speech(info, character, true, tr("Dafür habe ich keine Zeit. Ich muss trainieren."), gg_snd_Wigberht12)
			call speech(info, character, false, tr("Nun komm schon."), null)
			call speech(info, character, true, tr("Meine Heimat ist das Gebirge im Nordwesten. Dort wo noch Schnee liegt um diese Jahreszeit. Es ist eine raue Gegend mit wilden, blutrünstigen Kreaturen."), gg_snd_Wigberht13)
			call speech(info, character, true, tr("Ich werde sie bis zum Ende gegen die Orks und Dunkelelfen verteidigen."), gg_snd_Wigberht14)
			
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
			call speech(info, character, true, tr("Diese Rüstung gehört meinem Vater. Sie wird schon seit Jahrhunderten von Vater zu Sohn weitergegeben. Sie wurde vom Schmied Hrodo aus dem Erz meiner Heimat gefertigt. So eine Rüstung wirst du kein zweites Mal finden."), gg_snd_Wigberht15)
			call speech(info, character, true, tr("Sie wurde meinem Vater genommen als man ihn verschleppte. Die Dunkelelfen haben sie aus Spott über uns zurückgelassen. Nun trage ich sie bis ich meinen Vater befreit habe."), gg_snd_Wigberht16)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Erhalt des zweiten Ziels des Auftrags “Die Nordmänner”, falls dieses noch nicht abgeschlossen ist)
		private static method infoConditionLetUsAttack takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isNew()
		endmethod

		// Lass uns in den Kampf ziehen!
		private static method infoActionLetUsAttack takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Lass uns in den Kampf ziehen!"), null)
			call speech(info, character, true, tr("Gut, wenn ihr alle bereit seid ziehen wir los. Wir sammeln uns nahe des nordwestlichen Orklagers."), gg_snd_Wigberht17)
			call speech(info, character, true, tr("Und dann schlachten wir sie alle ab!"), gg_snd_Wigberht18)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach erfolgreichem Abschluss des zweiten Ziels des Auftrags “Die Nordmänner”)
		private static method infoConditionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isCompleted()
		endmethod

		// Wir haben die Orks und Dunkelelfen besiegt.
		private static method infoActionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wir haben die Orks und Dunkelelfen besiegt."), null)
			call speech(info, character, true, tr("Besiegt? Wir haben eine Schlacht gegen eine kleine Vorhut der Orks und Dunkelelfen gewonnen."), gg_snd_Wigberht19)
			call speech(info, character, true, tr("Wir können nicht ruhen, ehe wir nicht meinen Vater befreit haben und wenn wir dafür das gesamte Heer dieser widerlichen Kreaturen abschlachten müssen."), gg_snd_Wigberht20)
			call speech(info, character, true, tr("Ich möchte euch aber für eure Hilfe danken. Gehe zu Ricman, er hat eine Belohnung für dich."), gg_snd_Wigberht21)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach erfolgreichem Abschluss des Auftrags „Die Verteidigung von Talras“)
		private static method infoConditionVictory takes AInfo info, ACharacter character returns boolean
			return QuestTheDefenseOfTalras.quest().isCompleted()
		endmethod
		
		// Erneut war der Sieg unser.
		private static method infoActionVictory takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erneut war der Sieg unser."), null)
			call speech(info, character, true, tr("Das stimmt. Das bedeutet hoffentlich, dass wir nun endlich aufbrechen können."), gg_snd_Wigberht22)
			call speech(info, character, true, tr("Wer weiß ob mein Vater noch lebt. Aber ihr habt tapfer gekämpft. Zum Dank überreiche ich dir diese Waffe. Nutze sie mit Bedacht und Geschick wie ein wahrer Krieger des Nordens."), gg_snd_Wigberht23)
			// Charakter erhält eine besondere klassenabhängige Waffe.
			// TODO item!!!!
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag “Der Weg nach Holzbruck” ist aktiv)
		private static method infoConditionBringUsToHolzbruck takes AInfo info, ACharacter character returns boolean
			return QuestTheWayToHolzbruck.quest().isNew()
		endmethod

		// Bringt uns nach Holzbruck!
		private static method infoActionBringUsToHolzbruck takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bringt uns nach Holzbruck!"), null)
			call speech(info, character, true, tr("Was?"), gg_snd_Wigberht24)
			call speech(info, character, false, tr("Der Herzog benötigt Verstärkung aus Holzbruck, einer nördlichen, am Fluss liegenden Stadt. Du wolltest in den Norden, nimm uns bis nach Holzbruck mit!"), null)
			call speech(info, character, true, tr("Hm, dieser Herzog scheint ja wirklich sehr besorgt zu sein. Du hast Recht, wir wollten so bald wie möglich in den Norden aufbrechen und hatten eigentlich damit gerechnet, hier noch die versprochene Hilfe zu leisten."), gg_snd_Wigberht25)
			call speech(info, character, true, tr("Also gut. Wir nehmen euch in unserem Langboot mit, insofern ihr kräftig genug seid, es auch vorwärts zu bewegen, wenn wir keinen Fahrtwind haben."), gg_snd_Wigberht26)
			call speech(info, character, true, tr("Meldet euch bei mir, wenn ihr so weit seid."), gg_snd_Wigberht27)
			// do not complete twice if two characters are talking to Wigberht
			if (not  QuestTheWayToHolzbruck.quest().isCompleted()) then
				call QuestTheWayToHolzbruck.quest().complete()
			endif
			call info.talk().showStartPage(character)
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
			set this.m_victory = this.addInfo(false, false, thistype.infoConditionVictory, thistype.infoActionVictory, tr("Erneut war der Sieg unser."))
			set this.m_bringUsToHolzbruck = this.addInfo(false, false, thistype.infoConditionBringUsToHolzbruck, thistype.infoActionBringUsToHolzbruck, tr("Bringt uns nach Holzbruck."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary