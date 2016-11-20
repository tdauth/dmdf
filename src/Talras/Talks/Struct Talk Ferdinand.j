library StructMapTalksTalkFerdinand requires Asl, StructMapQuestsQuestAmongTheWeaponsPeasants

	struct TalkFerdinand extends Talk
		private boolean array m_knowsCost[12] /// @todo @member MapSettings.maxPlayers()

		implement Talk

		public method knowsCost takes ACharacter character returns boolean
			return this.m_knowsCost[GetPlayerId(character.player())]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(6, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("￼Ich grüße dich. Tut mir leid, ich habe momentan viel zu tun, also sprich schnell, wenn du etwas zu sagen hast.", "I greet you. I'm sorry, I currently have a lot to do, so talk fast when you have something to say."), gg_snd_Ferdinand1)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition0 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Was hast du denn zu tun?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was hast du denn zu tun?", "What do you have to do?"), null)
			call speech(info, character, true, tre("￼Nun, ich muss meines Lehnsherrn Gut verwalten und mich um dieses Lumpenpack von Bauern kümmern. Die wollen doch tatsächlich den Schwanz einziehen und sich aus dem Staub machen oder in der Burg verstecken, sobald unsere Feinde hier eintreffen.", "Well, I have to manage the good of my feudal lord and take care of this rabble of farmers. They actually want to move the tail and make off or hide in the castle as soon as our enemies arrive here."), gg_snd_Ferdinand2)
			call speech(info, character, true, tre("Zum Kriegsdienst haben sie sich allesamt verpflichtet. Mindestens ein Jahr lang. Diese feigen Hunde. Und zu allem Überfluss beschweren sie sich auch noch über die angeblich zu hohen Abgaben.", "They have all committed themselves for the military service. At least for one year. These cowardly dogs. And to make it worse, they complain even about the allegedly excessive charges."), gg_snd_Ferdinand3)
			call speech(info, character, true, tre("Schlechte Ernte erzählen sie mir dauernd. Der Weizen blüht und die wollen mir was von einer Hungersnot verkaufen. Dabei müssen wir unsere Vorräte aufstocken und uns auf eine mögliche Belagerung vorbereiten.", "Poor harvest they tell me all the time. Wheat flowers and they want to tell me something about a famine. We need to increase our supplies and prepare for a possible siege."), gg_snd_Ferdinand4)
			call speech(info, character, true, tre("Früher hätte man ein solches Verhalten nicht geduldet und sie einfach allesamt verprügeln lassen, aber wir leben ja seit Neustem in einer Zeit der Verhandlungen. Als Nächstes wollen sie vermutlich noch mitbestimmen, wer in der Burg leben darf und wer nicht, dieses Hundepack!", "In the past one would not have tolerated such behaviour and just let have them all beaten up, but we live most recently even in a time of negotiations. Next they probably want to say who is allowed to live in the castle and who isn't, this dog pack!"), gg_snd_Ferdinand5)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung, es wurde weder über die Handelsgenehmigung, noch über den Bauern Manfred gesprochen)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and not info.talk().infoHasBeenShownToCharacter(3, character) and not info.talk().infoHasBeenShownToCharacter(4, character)
		endmethod

		// Wer bist du?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			if (info.talk().infoHasBeenShownToCharacter(1, character)) then
				call speech(info, character, true, tre("Na hör mal! Willst du mich jetzt auch für dumm verkaufen? Du kannst dir doch wohl denken, dass ich der Vogt des Herzogs bin.", "Listen! Do you want to sell me for stupid? You can surely get that I am the reeve of the duke."), gg_snd_Ferdinand6)
			else
				call speech(info, character, true, tre("Ich bin der Vogt des Herzogs Heimrich, meines und vermutlich auch deines Herrn, und somit der Verwalter seines Besitzes.", "I am the reeve of the duke Heimrich, the lord of me and probably yours too, and therefore the steward of his estate."), gg_snd_Ferdinand7)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Gold für die Handelsgenehmigung“ aktiv)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestGoldForTheTradingPermission.characterQuest(character).isNew()
		endmethod

		// Warum bekommt der Händler Haid keine Handelsgenehmigung für Talras?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Warum bekommt der Händler Haid keine Handelsgenehmigung für Talras?", "Why doesn't the merchant Haid get a trading permission for Talras?"), null)
			call speech(info, character, true, tre("Nun, wenn er die lumpigen 10 Goldmünzen bezahlt, die das Ganze kostet, dann darf er auch hier seine Waren verkaufen, solange er keinen Ärger macht und mir einen gerechten Anteil seines Gewinns gibt.", "Well, if he pays the dent 10 gold coins which the whole costs, then he may sell his goods here as long as he does not cause trouble and gives me a fair share of his winnings."), gg_snd_Ferdinand8)
			call speech(info, character, false, tre("10 Goldmünzen?", "10 gold coins?"), null)
			call speech(info, character, true, tre("Ja, 10 Goldmünzen. Das können selbst diese armen Bauern bezahlen.", "Yes, 10 gold coins. That even the poor peasants themselves can afford."), gg_snd_Ferdinand9)
			set thistype(info.talk()).m_knowsCost[GetPlayerId(character.player())] = true
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Schutz dem Volke“ aktiv)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestProtectThePeople.characterQuest(character).isNew()
		endmethod

		// Der Bauer Manfred fordert mehr Schutz für seinen Hof.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Der Bauer Manfred fordert mehr Schutz für seinen Hof.", "The farmer Manfred calls for more protection for his farm."), null)
			call speech(info, character, true, tre("Was? Was erlaubt sich dieser Hund? Erst kommt er mir mit seiner Kriegsdienstverweigerung und jetzt auch noch so was?", "What? What is this dog thinking? First he comes to me with his military service objection and now even such a thing?"), gg_snd_Ferdinand10)
			call speech(info, character, true, tre("Die Bauern leben doch wie die Made im Speck. Die müssen sich ja auch keine Gedanken um die Verteidigung dieser Burg machen. Wenn der Feind kommt, rennen sie vermutlich wie die Hasen davon.", "But the farmers live live how in clover. They do not have to worry about the defense of the castle. If the enemy comes, they probably run away like rabbits."), gg_snd_Ferdinand11)
			call speech(info, character, true, tre("Pass auf! Sag deinem Bauernfreund, dass er selbst zu kämpfen hat, für seinen Herrn, den Herzog von Talras und wenn er das nicht tut, dann kommt er an den Pranger.", "Watch out! Tell your farmer friend that he has to fight himself for his master, the duke of Talras and if he does not, then he comes to the pillory."), gg_snd_Ferdinand12)
			call QuestAmongTheWeaponsPeasants.characterQuest(character).enable()
			call info.talk().showRange(7, 8, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Zu den Waffen, Bauern!“ abgeschlossen)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return QuestAmongTheWeaponsPeasants.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Manfred macht dir keinen Ärger mehr.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Manfred macht dir keinen Ärger mehr.", "Manfred won't make you any more trouble."), null)
			call speech(info, character, true, tre("Tatsächlich? Das freut mich zu hören. Dann lässt mich dieses elende Bauernpack hoffentlich endlich in Ruhe.", "Really? That's good to hear. Then this miserable peasant pack will hopefully leave me alone."), gg_snd_Ferdinand17)
			call speech(info, character, true, tre("Hier hast du deinen Lohn. Du taugst wirklich etwas.", "Here you have your reward. You're really good at something."), gg_snd_Ferdinand18)
			call QuestAmongTheWeaponsPeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Pass mal auf du Lustigbär …
		private static method infoAction4_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Pass mal auf du Lustigbär …", "Watch out you funny bear ..."), null)
			call speech(info, character, false, tre("Du wirst den Bauern ein paar Leute schicken, die ihren Hof bewachen oder du hast das letzte Mal ruhig geschlafen.", "You'll end a couple of people to the farmers who guard their farm or it will be the last time you have slept quietly."), null)
			call speech(info, character, false, tre("Ich kenne genug Leute, die dir für ein paar Goldmünzen im Schlaf die Kehle durchschneiden würden. Manche machen das sogar umsonst!", "I know plenty of people who would cut your throat for a few gold coins in your sleep. Some do it even for free!"), null)
			call speech(info, character, false, tre("Schick ihm Wachen und über den Kriegsdienst reden wir nochmal.", "Send him guards and about the military service we talk again."), null)
			call speech(info, character, true, tre("Was? Was erlaubst du dir? Du, du … das meinst du doch nicht ernst oder?", "What? How dare you? You, you ... you can not be serious right?"), gg_snd_Ferdinand13)
			call speech(info, character, false, tre("Hmm, lass mich überlegen. Ja verdammt, ich meine es ernst! Also tu was ich sage und ich vergesse meine netten Pläne ganz schnell wieder.", "Hmm, let me think. Yes damn, I'm serious! So do as I say and I forget my nice plans very quickly."), null)
			call speech(info, character, true, tre("Na gut, ich werde ein paar Leute hinschicken. Kann ja nicht schaden, mal ein Auge auf die Sicherheit der Nahrungsbestände zu werfen. Nun komm aber wieder runter.", "Well, I'll send in a few people. It cannot hurt, to keep an eye on the safety of the food stucks sometime. Now calm down again."), gg_snd_Ferdinand14)
			call QuestAmongTheWeaponsPeasants.characterQuest(character).fail()
			call QuestProtectThePeople.characterQuest(character).questItem(0).setState(AAbstractQuest.stateCompleted)
			call QuestProtectThePeople.characterQuest(character).questItem(1).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Gut, ich werd's ihm weismachen.
		private static method infoAction4_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gut, ich werd's ihm weismachen.", "Well, I will make him believe it."), null)
			call speech(info, character, true, tre("Na das hört man doch gerne. Ein treuer Diener des Herzogs! Falls du ihn tatsächlich überzeugen kannst, kann ich mir die Mühe sparen, ein paar Wachen zu ihm zu schicken.", "Well, that one hears with pleasure. A faithful servant of the duke! If you can actually convince him, I can save myself the trouble to send a few guards to him."), gg_snd_Ferdinand15)
			call speech(info, character, true, tre("Damit wäre mir wirklich geholfen. Dafür würdest du natürlich auch bezahlt werden.", "This would be really helpful. But of course you would also be paid."), gg_snd_Ferdinand16)
			call QuestProtectThePeople.characterQuest(character).fail()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01J_0154, thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_knowsCost[i] = false
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoCondition0, thistype.infoAction1, tre("Was hast du denn zu tun?", "What do you have to do?")) // 1
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction2, tre("Wer bist du?", "Who are you?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Warum bekommt der Händler Haid keine Handelsgenehmigung für Talras?", "Why doesn't the merchant Haid get a trading permission for Talras?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Der Bauer Manfred fordert mehr Schutz für seinen Hof.", "The farmer Manfred calls for more protection for his farm.")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tre("Manfred macht dir keinen Ärger mehr.", "Manfred won't make you any more trouble.")) // 5
			call this.addExitButton() // 6

			// info 4
			call this.addInfo(false, false, 0, thistype.infoAction4_0, tre("Pass mal auf du Lustigbär …", "Watch out you funny bear ...")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction4_1, tre("Gut, ich werd's ihm weismachen.", "Well, I will make him believe it.")) // 8

			return this
		endmethod
	endstruct

endlibrary