library StructMapTalksTalkWigberht requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapTalksTalkRicman

	struct TalkWigberht extends Talk
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
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo.", "Hello."), gg_snd_Wigberht1)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionTalkingTooMuch takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Du bist wohl nicht so gesprächig?
		private static method infoActionTalkingTooMuch takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Bist wohl nicht so gesprächig?", "You are probably not so talkative?"), null)
			call speech(info, character, true, tre("Nein.", "No."), gg_snd_Wigberht2)
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
			call speech(info, character, false, tre("Was machst du hier?", "What are you doing here?"), null)
			call speech(info, character, true, tre("Ich warte.", "I am waiting."), gg_snd_Wigberht3)
			// (Falls der Charakter Ricman das Gleiche gefragt hat)
			if (TalkRicman.talk().askedWhatAreYoDoing(character)) then
				call speech(info, character, false, tre("Warten alle Nordmänner auf irgendetwas?", "Are all norsemen wait for something?"), null)
				call speech(info, character, true, tre("Anscheinend.", "Apparently."), gg_snd_Wigberht4)
			else
				call speech(info, character, false, tre("Und worauf?", "And for what?"), null)
				call speech(info, character, true, tre("Auf den Feind.", "For the enemy."), gg_snd_Wigberht5)
				call speech(info, character, false, tre("Du meinst die Orks?", "You are talking about the Orcs?"), null)
				call speech(info, character, true, tre("Exakt.", "Exactly."), gg_snd_Wigberht6)
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
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Mein Name ist Wigberht.", "My name is Wigberht."), gg_snd_Wigberht7)
			call speech(info, character, false, tre("Und was machst du hier?", "And what are you doing here?"), null)
			call speech(info, character, true, tre("Ich kam mit meinen Männern aus dem Norden.", "I came with my men from the north."), gg_snd_Wigberht8)
			call speech(info, character, false, tre("Aus dem Norden?", "From the north?"), null)
			call speech(info, character, true, tre("Ja, vom nordwestlichen Gebirge.", "Yes, from the mountains in the north west."), gg_snd_Wigberht9)

			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung und wenn es gerade Nacht ist und Wigberht trainiert)
		private static method infoConditionTrainingAtNight takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character) and GetTimeOfDay() >= 22.00 or GetTimeOfDay() <= 5.00
		endmethod

		// Trainierst du nachts?
		private static method infoActionTrainingAtNight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Trainierst du nachts?", "Are you training at night?"), null)
			call speech(info, character, true, tre("Wie du siehst.", "As you can see."), gg_snd_Wigberht10)
			call speech(info, character, false, tre("Und wann schläfst du mal?", "And when are you sleeping?"), null)
			call speech(info, character, true, tre("Nie.", "Never."), gg_snd_Wigberht11)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoConditionTellMeAboutYourHome takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_whoAreYou.index(), character) or not QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Erzähl mir etwas über deine Heimat.
		private static method infoActionTellMeAboutYourHome takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Erzähl mir etwas über deine Heimat.", "Tell me about your home."), null)

			call speech(info, character, true, tre("Dafür habe ich keine Zeit. Ich muss trainieren.", "I have no time for this. I have to train."), gg_snd_Wigberht12)
			call speech(info, character, false, tre("Nun komm schon.", "Come on."), null)
			call speech(info, character, true, tre("Meine Heimat ist das Gebirge im Nordwesten. Dort wo noch Schnee liegt um diese Jahreszeit. Es ist eine raue Gegend mit wilden, blutrünstigen Kreaturen.", "My home is the mountains in the northwest. Where there is still snow at this time of the year. It is a rough area with wild, bloodthirsty creatures."), gg_snd_Wigberht13)
			call speech(info, character, true, tre("Ich werde sie bis zum Ende gegen die Orks und Dunkelelfen verteidigen.", "I will defend it to the end against the Orcs and Dark Elves."), gg_snd_Wigberht14)

			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionYourArmour takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character) or not QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Was trägst du da für eine Rüstung?
		private static method infoActionYourArmour takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was trägst du da für eine Rüstung?", "What kind of armour a are you wearing?"), null)
			call speech(info, character, true, tre("Diese Rüstung gehört meinem Vater. Sie wird schon seit Jahrhunderten von Vater zu Sohn weitergegeben. Sie wurde vom Schmied Hrodo aus dem Erz meiner Heimat gefertigt. So eine Rüstung wirst du kein zweites Mal finden.", "This armour is my father's. It is passed on from father to son for centuries. It was crafted by the blacksmith Hrodo from the ore of my home. This kind of armour you won't find a second time."), gg_snd_Wigberht15)
			call speech(info, character, true, tre("Sie wurde meinem Vater genommen als man ihn verschleppte. Die Dunkelelfen haben sie aus Spott über uns zurückgelassen. Nun trage ich sie bis ich meinen Vater befreit habe.", "It was taken from my father when they abducted him. The Dark Elves have left it for mockery of us. Now I wear it until I've freed my father."), gg_snd_Wigberht16)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Erhalt des zweiten Ziels des Auftrags “Die Nordmänner”, falls dieses noch nicht abgeschlossen ist)
		private static method infoConditionLetUsAttack takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isNew()
		endmethod

		// Lass uns in den Kampf ziehen!
		private static method infoActionLetUsAttack takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Lass uns in den Kampf ziehen!", "Let us go into battle!"), null)
			call speech(info, character, true, tre("Gut, wenn ihr alle bereit seid ziehen wir los. Wir sammeln uns nahe des nordwestlichen Orklagers.", "Well, if you're all ready, we head out. We gather near the northwestern Orc camp."), gg_snd_Wigberht17)
			call speech(info, character, true, tre("Und dann schlachten wir sie alle ab!", "And then we kill them all off!"), gg_snd_Wigberht18)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach erfolgreichem Abschluss des zweiten Ziels des Auftrags “Die Nordmänner”)
		private static method infoConditionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isCompleted()
		endmethod

		// Wir haben die Orks und Dunkelelfen besiegt.
		private static method infoActionOrcsAndDarkElvesAreDone takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wir haben die Orks und Dunkelelfen besiegt.", "We have defeated the Orcs and Dark Elves."), null)
			call speech(info, character, true, tre("Besiegt? Wir haben eine Schlacht gegen eine kleine Vorhut der Orks und Dunkelelfen gewonnen.", "Defeated? We have won a battle against a small vanguard of Orcs and Dark Elves."), gg_snd_Wigberht19)
			call speech(info, character, true, tre("Wir können nicht ruhen, ehe wir nicht meinen Vater befreit haben und wenn wir dafür das gesamte Heer dieser widerlichen Kreaturen abschlachten müssen.", "We can not rest until we have liberated my father even if we have to slaughter the entire army of these foul creatures."), gg_snd_Wigberht20)
			call speech(info, character, true, tre("Ich möchte euch aber für eure Hilfe danken. Gehe zu Ricman, er hat eine Belohnung für dich.", "But I want to thank you for your help. Go to Ricman, he has a reward for you."), gg_snd_Wigberht21)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach erfolgreichem Abschluss des Auftrags „Die Verteidigung von Talras“)
		private static method infoConditionVictory takes AInfo info, ACharacter character returns boolean
			return QuestTheDefenseOfTalras.quest().isCompleted()
		endmethod

		// Erneut war der Sieg unser.
		private static method infoActionVictory takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Erneut war der Sieg unser.", "Again, the victory was ours."), null)
			call speech(info, character, true, tre("Das stimmt. Das bedeutet hoffentlich, dass wir nun endlich aufbrechen können.", "That's true. This means hopefully, that we can finally move on."), gg_snd_Wigberht22)
			call speech(info, character, true, tre("Wer weiß ob mein Vater noch lebt. Aber ihr habt tapfer gekämpft. Zum Dank überreiche ich dir diese Waffe. Nutze sie mit Bedacht und Geschick wie ein wahrer Krieger des Nordens.", "Who knows if my father is still alive. But you have fought bravely. As a reward I Present you this weapon. Use it wisely and with skill like a true warrior of the north."), gg_snd_Wigberht23)
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
			call speech(info, character, false, tre("Bringt uns nach Holzbruck!", "Bring us to Holzbruck!"), null)
			call speech(info, character, true, tre("Was?", "What?"), gg_snd_Wigberht24)
			call speech(info, character, false, tre("Der Herzog benötigt Verstärkung aus Holzbruck, einer nördlichen, am Fluss liegenden Stadt. Du wolltest in den Norden, nimm uns bis nach Holzbruck mit!", "The duke needs reinforcement from Holzbruck, a northern city, lying on the river. You wanted to the north, take use with you until Holzbruck!"), null)
			call speech(info, character, true, tre("Hm, dieser Herzog scheint ja wirklich sehr besorgt zu sein. Du hast Recht, wir wollten so bald wie möglich in den Norden aufbrechen und hatten eigentlich damit gerechnet, hier noch die versprochene Hilfe zu leisten.", "Hm, this duke really seems to be very worried. You're right, we wanted to leave as soon as possible to the north and had actually expected to give the promised help here."), gg_snd_Wigberht25)
			call speech(info, character, true, tre("Also gut. Wir nehmen euch in unserem Langboot mit, insofern ihr kräftig genug seid, es auch vorwärts zu bewegen, wenn wir keinen Fahrtwind haben.", "All right then. We take you with our longboat, as long as you are strong enough to move it forward as well if we have no wind."), gg_snd_Wigberht26)
			call speech(info, character, true, tre("Meldet euch bei mir, wenn ihr so weit seid.", "Report to me when you are ready."), gg_snd_Wigberht27)
			// do not complete twice if two characters are talking to Wigberht
			if (not  QuestTheWayToHolzbruck.quest().isCompleted()) then
				call QuestTheWayToHolzbruck.quest().complete()
			endif
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.wigberht(), thistype.startPageAction)
			call this.setName(tre("Wigberht", "Wigberht"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo.", "Hello."))
			set this.m_talkingTooMuch = this.addInfo(false, false, thistype.infoConditionTalkingTooMuch, thistype.infoActionTalkingTooMuch, tre("Du bist wohl nicht so gesprächig?", "You are probably not so talkative?"))
			set this.m_whatAreYouDoing = this.addInfo(false, false, thistype.infoConditionWhatAreYouDoing, thistype.infoActionWhatAreYouDoing, tre("Was machst du hier?", "What are you doing here?"))
			set this.m_whoAreYou = this.addInfo(false, false, thistype.infoConditionWhoAreYou, thistype.infoActionWhoAreYou, tre("Wer bist du?", "Who are you?"))
			set this.m_trainingAtNight = this.addInfo(true, false, thistype.infoConditionTrainingAtNight, thistype.infoActionTrainingAtNight, tre("Trainierst du nachts?", "Are you training at night?"))
			set this.m_tellMeAboutYourHome =  this.addInfo(true, false, thistype.infoConditionTellMeAboutYourHome, thistype.infoActionTellMeAboutYourHome, tre("Erzähl mir etwas über deine Heimat.", "Tell me something about your home."))
			set this.m_yourArmour = this.addInfo(false, false, thistype.infoConditionYourArmour, thistype.infoActionYourArmour, tre("Was trägst du da für eine Rüstung?", "What kind of armour a are you wearing?"))
			set this.m_letUsAttack = this.addInfo(true, false, thistype.infoConditionLetUsAttack, thistype.infoActionLetUsAttack, tre("Lass uns in den Kampf ziehen!", "Let us go into battle!"))
			set this.m_orcsAndDarkElvesAreDone = this.addInfo(false, false, thistype.infoConditionOrcsAndDarkElvesAreDone, thistype.infoActionOrcsAndDarkElvesAreDone, tre("Wir haben die Orks und Dunkelelfen besiegt.", "We have defeated the Orcs and Dark Elves."))
			set this.m_victory = this.addInfo(false, false, thistype.infoConditionVictory, thistype.infoActionVictory, tre("Erneut war der Sieg unser.", "Again, the victory was ours."))
			set this.m_bringUsToHolzbruck = this.addInfo(false, false, thistype.infoConditionBringUsToHolzbruck, thistype.infoActionBringUsToHolzbruck, tre("Bringt uns nach Holzbruck.", "Bring us to Holzbruck!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary