library StructMapTalksTalkTrommon requires Asl, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestWoodForTheHut, StructMapQuestsQuestSeedsForTheGarden

	struct TalkTrommon extends Talk
		private static constant integer goldCost = 10
		private boolean array m_hasPaid[12] /// @todo @member MapSettings.maxPlayers()
		private boolean array m_wasOffended[12] /// @todo @member MapSettings.maxPlayers()

		public method hasPaid takes player whichPlayer returns boolean
			return this.m_hasPaid[GetPlayerId(whichPlayer)]
		endmethod

		private method pay takes player whichPlayer returns nothing
			set this.m_hasPaid[GetPlayerId(whichPlayer)] = true
		endmethod

		private method offend takes player whichPlayer returns nothing
			set this.m_wasOffended[GetPlayerId(whichPlayer)] = true
		endmethod

		private method wasOffended takes player whichPlayer returns boolean
			return this.m_wasOffended[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(10, character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo! Wer bist du und was treibt dich in diese Gegend?", "Hello! Who are you and what brings you to this area?"), gg_snd_Trommon1)
			if (character.class() == Classes.cleric()) then
				call speech(info, character, false, tre("Der Glaube.", "The faith."), null)
				call speech(info, character, true, tre("Hmm, ein frommer Mann. Ich fühle mich geehrt auch wenn ich deinen Glauben wahrscheinlich nicht teile.", "Hmm, a pious man. I feel honored even though I probably do not share your faith."), gg_snd_Trommon2)
			elseif (character.class() == Classes.necromancer()) then
				call speech(info, character, false, tre("Der Tod.", "The death."), null)
				call speech(info, character, true, tre("Das sind aber finstere Worte mein Freund. Hier, nimm dir einen Apfel, dann geht’s dir schon viel besser.", "But these are dark words my friend. Here, take an apple, then you are much better."), gg_snd_Trommon3)
				// Charakter erhält einen Apfel
				call character.giveItem('I03O')
			elseif (character.class() == Classes.druid()) then
				call speech(info, character, false, tre("Die Natur.", "The nature."), null)
				call speech(info, character, true, tre("Das kann ich verstehen. Ein Grund weshalb ich hier draußen lebe.", "I can understand that. One reason I live out here."), gg_snd_Trommon4)
				call speech(info, character, true, tre("Hier hast du einen Apfel.", "Here you have an apple."), gg_snd_Trommon5)
				// Charakter erhält einen Apfel
				call character.giveItem('I03O')
			elseif (character.class() == Classes.knight()) then
				call speech(info, character, false, tre("Die Pflicht.", "The duty."), null)
				call speech(info, character, true, tre("So so, du bist also ein Pflichtbewusster. Na dazu sag' ich mal nichts.", "So, you are a duty-conscious. Well, I'll say nothing."), gg_snd_Trommon6)
			elseif (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, false, tre("Das Gold.", "The gold."), null)
				call speech(info, character, true, tre("Gib lieber Acht mein Freund. Viele derer, die ich kannte hat die Gier ins Verderben getrieben. Wäre schade um dich.", "Be carefuly, my dear friend. Many of those I knew the greed has driven to ruin. It would be a pity."), gg_snd_Trommon7)
			elseif (character.class() == Classes.ranger()) then
				call speech(info, character, false, tre("Die Wildnis.", "The wilderness."), null)
				call speech(info, character, true, tre("Ja, das kann ich verstehen. Ich liebe auch die Natur. Deshalb bin ich auch hierher gezogen. Da, nimm dir einen Apfel.", "Yes, I can understand that. That's why I moved here. There, take an apple."), gg_snd_Trommon8)
				// Charakter erhält einen Apfel
				call character.giveItem('I03O')
				call speech(info, character, true, tre("(Lachend) Ich fürchte, wir teilen das gleiche Schicksal.", "(Laughing) I'm afraid we share the same fate."), gg_snd_Trommon9)
			elseif (character.class() == Classes.elementalMage()) then
				call speech(info, character, false, tre("Der Wille.", "The will."), null)
				call speech(info, character, true, tre("Der Wille? Was gibt’s hier schon zu erreichen oder holen? Ich meine, mir gefällt’s hier, aber mit dieser Meinung gehöre ich zu einer kleinen Minderheit.", "The will? What can be done here or taken from here? I mean, I like it here, but with this opinion I belong to a small minority."), gg_snd_Trommon10)
			elseif (character.class() == Classes.wizard()) then
				call speech(info, character, false, tre("Die Neugier.", "The curiosity."), null)
				call speech(info, character, true, tre("Ich bin vermutlich zu alt, um neugierig zu sein. Aber vielleicht bringt sie dich ja eines Tages weiter als mich. Trotzdem, ich will mich nicht beklagen. Mir geht’s doch eigentlich recht gut.", "I am probably too old to be curious. But maybe it will take you further than me one day. Still, I will not complain. Actually I have everything I need."), gg_snd_Trommon11)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoConditionYourFerryBoat takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// ￼Ist das deine Fähre?
		private static method infoActionYourFerryBoat takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("￼Ist das deine Fähre?", "Is this your ferry?"), null)
			call speech(info, character, true, tre("￼Klar. Die hab ich selbst gebaut und der Holzfäller Kuno hat mir das Holz dafür beschafft. Na ja, er muss ja auch jeden Tag über den Fluss fahren.", "Sure. I built it myself and the woodcutter Kuno gave me the wood for it. Well, he has to cross the river every day."), gg_snd_Trommon12)
			call speech(info, character, true, tre("Natürlich fahre ich auch andere Leute über den Fluss.", "Of course, I also bring other people across the river."), gg_snd_Trommon13)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Ist das deine Fähre?“, Charakter hat noch nicht mit Kuno gesprochen)
		private static method infoConditionWhoIsKuno takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character) and true /// @todo Hat noch nicht mit Kuno gesprochen
		endmethod

		// Wer ist Kuno?
		private static method infoActionWhoIsKuno takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer ist Kuno?", "Who is Kuno?"), null)
			call speech(info, character, true, tre("Ach das ist ein Holzfäller und alter Freund von mir. Ich fahre ihn jeden Tag mit meiner Fähre zweimal über den Fluss. Hin und zurück.", "Oh, this is a woodcutter and old friend of mine. I bring him across the river with my ferry twice every day. There and back."), gg_snd_Trommon14)
			call speech(info, character, true, tre("Er hat seine Hütte am anderen Flussufer und transportiert sein Holz mit Hilfe meiner Fähre auf meine Seite, um es dann bei den Bauern zu verkaufen.", "He has his hut on the other side of the river and transports his wood to my side with the help of my ferry to sell it then to the farmers."), gg_snd_Trommon15)
			call speech(info, character, true, tre("Du kannst ja mal mit ihm sprechen, wenn ich dich hinüber gebracht habe.", "You can talk to him when I've brought you over."), gg_snd_Trommon16)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoConditionStableHut takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Deine Hütte sieht aber nicht grade stabil aus.
		private static method infoActionStableHut takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Deine Hütte sieht aber nicht grade stabil aus.", "Your hut does not exactly look stable."), null)
			call speech(info, character, true, tre("Ja, ich weiß. Sie ist wohl im Laufe der Zeit etwas kaputt gegangen. Na ja, ich hab mir auch nicht gerade viel Mühe bei ihrem Bau gegeben.", "Yes, I know. It has probably broken down in the course of time. Well, I have not given me much trouble with its construction."), gg_snd_Trommon17)
			call speech(info, character, true, tre("Da fällt mir ein, hättest du nicht vielleicht Lust meinen alten Freund Kuno um etwas Holz zu bitten, das er mir nächstes Mal, wenn er über den Fluss fährt, mitbringt?", "It reminds me, you might not want to ask my old friend Kuno for some wood, which he brings me next time he crosses river?"), gg_snd_Trommon18)
			call speech(info, character, false, tre("Wieso machst du das nicht selbst?", "Why don't you ddo it yourself?"), null)
			call speech(info, character, true, tre("Gut, er ist zwar ein alter Freund von mir, aber was seinen Beruf angeht, da hab ich mich wohl ab und zu etwas zu sehr drüber lustig gemacht. War ja nicht böse gemeint, aber er war natürlich wieder total verärgert und jetzt hab ich wirklich keine Lust ihn darum zu bitten.", "Well, he's an old friend of mine, but as far as his profession is concerned, I've probably made a little too much fun of it from time to time. It wasn't meant that way, but of course he was totatlly angry, and now I really do not want to ask him about it."), gg_snd_Trommon19)
			call speech(info, character, true, tre("Du würdest natürlich auch was dafür kriegen.", "You would also get something for it."), gg_snd_Trommon20)
			call info.talk().showRange(11, 13, character)
		endmethod

		// (Nach „Deine Hütte sieht aber nicht grade stabil aus.“, Auftrag „Holz für die Hütte“ wurde noch nicht erhalten)
		private static method infoConditionGetWood takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(3, character) and QuestWoodForTheHut.characterQuest(character).isNotUsed()
		endmethod

		// Ich hab's mir überlegt. Ich besorg dir dein Holz.
		private static method infoActionGetWood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich hab's mir überlegt. Ich besorg dir dein Holz.", "I thought about it. I'll get your wood."), null)
			if (thistype(info.talk()).wasOffended(character.player())) then
				call speech(info, character, true, tre("So so, ein wenig Gier steckt also doch in jedem von uns. Na ja, mir soll's recht sein.", "So, there is a bit greed in each of us. Well, I'll be okay with it."), gg_snd_Trommon25)
			else
				call speech(info, character, true, tre("Danke Mann. Du tust mir damit einen wirklich großen Gefallen.", "Thanks man. You're doing me a really big favor."), gg_snd_Trommon21)
			endif
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“, Trommon befindet sich in seinem Gemüsegarten)
		private static method infoConditionNiceGarden takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_trommons_vegetable_garden, gg_unit_n021_0004)
		endmethod

		// Einen hübschen Gemüsegarten hast du da.
		private static method infoActionNiceGarden takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Einen hübschen Gemüsegarten hast du da.", "You have a pretty vegetable garden."), null)
			call speech(info, character, true, tre("Findest du wirklich? Das freut mich aber. Vielleicht möchtest du ja etwas von meinem Gemüse kaufen. Zur Zeit kann ich wieder mehr ernten als ich für mich selbst brauche.", "Do you really think so? That makes me happy. Maybe you want to buy something from my vegetables. At the moment I can harvest again more than I need for myself."), gg_snd_Trommon26)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Holz für die Hütte“ ist abgeschlossen, Auftragsziel 2 des Auftrags „Holz für die Hütte“ ist aktiv, Charakter hat Bretter dabei)
		private static method infoConditionGetSomeWood takes AInfo info, ACharacter character returns boolean
			return QuestWoodForTheHut.characterQuest(character).questItem(0).isCompleted() and  QuestWoodForTheHut.characterQuest(character).questItem(1).isNew() and character.inventory().hasItemType('I03P')
		endmethod

		// Hier sind ein paar Bretter von Kuno.
		private static method infoActionGetSomeWood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier sind ein paar Bretter von Kuno.", "Here are a few boards from Kuno."), null)
			call speech(info, character, true, tre("Wirklich? Ich danke dir. Hier hast du ein paar Salatköpfe aus meinem Gemüsegarten und natürlich auch ein paar Goldmünzen.", "Really, I thank you, here you have some lettuces from my vegetable garden and, of course, a few gold coins."), gg_snd_Trommon27)
			// Bretter entfernt
			call character.inventory().removeItemType('I03P')
			// Auftrag „Holz für die Hütte“ abgeschlossen
			call QuestWoodForTheHut.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Holz für die Hütte“ ist abgeschlossen)
		private static method infoConditionMoreHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestWoodForTheHut.characterQuest(character).isCompleted()
		endmethod

		// Brauchst du sonst noch etwas?
		private static method infoActionMoreHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Brauchst du sonst noch etwas?", "Do you need something else?"), null)
			call speech(info, character, true, tre("Wenn du schon fragst, dann sage ich einfach mal „ja“. Wegen meiner Fähre kann ich hier schlecht weg. Die Arbeit auf der Fähre finde ich jedoch recht eintönig.", "If you already ask, then I simply say \"yes\". Because of my ferry I cannot leave. The work on the farry, however, is quite monotonus."), gg_snd_Trommon28)
			call speech(info, character, true, tre("Viel lieber würde ich mich jetzt weiter um meinen kleinen Garten kümmern. Leider kenne ich mich noch nicht so gut aus mit allem, was man so anpflanzen kann.", "I'd rather go to my little garden now. Unfortunately, I do not know yet that much about everything which one can plant."), gg_snd_Trommon29)
			call speech(info, character, true, tre("Südlich vom Bauernhof lebt eine alte Frau namens Ursula. Sie kennt sich mit solchen Dingen besser aus, denke ich.", "South of the farm lives an old woman named Ursula. She knows much more about such things, I think."), gg_snd_Trommon30)
			call speech(info, character, true, tre("Pass auf, ich gebe dir 50 Goldmünzen und du schaust, was du dafür von ihr bekommen kannst. Ich denke sie ist sehr ehrlich und hoffe du bist es auch.", "Look, I'll give you 50 gold coins and you'll see what yu can get for it. I think she is very honest hope you are, too."), gg_snd_Trommon31)
			// 50 Goldmünzen erhalten.
			call character.addGold(50)
			// Neuer Auftrag „Samen für den Garten“
			call QuestSeedsForTheGarden.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Samen für den Garten“ ist abgeschlossen, Auftragsziel 2 des Auftrags „Samen für den Garten“ ist aktiv, Charakter hat Samen dabei)
		private static method infoConditionSpecialSeed takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(0).isCompleted() and QuestSeedsForTheGarden.characterQuest(character).questItem(1).isNew() and  character.inventory().hasItemType('I03N')
		endmethod

		// Hier hast du einen ganz besonderen Samen.
		private static method infoActionSpecialSeed takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier hast du einen ganz besonderen Samen.", "Here you have a very special seed."), null)
			call speech(info, character, true, tre("Zeig her! Was ist daran so besonders?", "Show me! What is so special about it?"), gg_snd_Trommon32)
			call speech(info, character, false, tre("Das siehst du wenn es soweit ist.", "You see that when it's time."), null)
			call speech(info, character, true, tre("Hm, ich vertraue dir mal. Hab vielen Dank und nimm das hier als Belohnung.", "Hm, I trust you. Thanks a lot and take this as a reward."), gg_snd_Trommon33)
			call speech(info, character, true, tre("Wenn du willst kannst du ihn selbst einpflanzen.", "If you want to you can plant it yourself."), gg_snd_Trommon34)
			// Auftragsziel 2 des Auftrags „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).questItem(1).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 3 des Auftrags „Samen für den Garten“ aktiviert
			call QuestSeedsForTheGarden.characterQuest(character).questItem(2).setState(AAbstractQuest.stateNew)
			// Auftragsziel 4 des Auftrags „Samen für den Garten“ aktiviert
			call QuestSeedsForTheGarden.characterQuest(character).questItem(3).setState(AAbstractQuest.stateNew)
			call QuestSeedsForTheGarden.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 3 des Auftrags „Samen für den Garten“ abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionWhatDoYouThink takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(2).isCompleted() and QuestSeedsForTheGarden.characterQuest(character).questItem(3).isNew()
		endmethod

		// Und was hältst du von dem Baum?
		private static method infoActionWhatDoYouThink takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Und was hältst du von dem Baum?", "So, what do you think of the tree?"), null)
			call speech(info, character, true, tre("Unglaublich und er scheint eine magische Wirkung auf seine Umgebung zu haben.", "Unbelievable and it seems to have a magical effect on his environment."), gg_snd_Trommon35)
			call speech(info, character, true, tre("Damit hätte ich nicht gerechnet. Hier nimm das, ich hoffe das reicht dir als Entschädigung für deine Mühen.", "I would not have expected that. Here, take it, I hope this is enough for you as compensation for your troubles."), gg_snd_Trommon36)
			// Auftrag „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Kein Problem, mache ich.
		private static method infoActionStableHut_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kein Problem, mache ich.", "No problem, I'll do it."), null)
			call speech(info, character, true, tre("Danke Mann. Du tust mir damit einen wirklich großen Gefallen.", "Thank you man. You're doing me a really big favor."), gg_snd_Trommon24)
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.
		private static method infoActionStableHut_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.", "Bite me! My father's father, my grandfather, and his father, my great-grandfather, were all woodcutters, and you just made fun of it."), null)
			call speech(info, character, true, tre("Verdammt Mann, krieg dich wieder ein! War ja nicht böse gemeint, dann halt nicht.", "Damn it, just relax! It was not meant nasty, so you won't do it."), gg_snd_Trommon22)
			call info.talk().showStartPage(character)
		endmethod

		// Ich überleg's mir mal.
		private static method infoActionStableHut_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich überleg's mir mal.", "I'll think about it."), null)
			call speech(info, character, true, tre("In Ordnnug.", "All right."), gg_snd_Trommon23)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.trommon(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_hasPaid[i] = false
				set this.m_wasOffended[i] = false
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoConditionYourFerryBoat, thistype.infoActionYourFerryBoat, tre("￼Ist das deine Fähre?", "Is this your ferry?")) // 1
			call this.addInfo(false, false, thistype.infoConditionWhoIsKuno, thistype.infoActionWhoIsKuno, tre("Wer ist Kuno?", "Who is Kuno?")) // 2
			call this.addInfo(false, false, thistype.infoConditionStableHut, thistype.infoActionStableHut, tre("Deine Hütte sieht aber nicht grade stabil aus.", "Your hut does not exactly look stable.")) // 3
			call this.addInfo(false, false, thistype.infoConditionGetWood, thistype.infoActionGetWood, tre("Ich hab's mir überlegt. Ich besorg dir dein Holz.", "I thought about it. I'll get your wood.")) // 4
			call this.addInfo(false, false, thistype.infoConditionNiceGarden, thistype.infoActionNiceGarden, tre("Einen hübschen Gemüsegarten hast du da.", "You have a pretty vegetable garden.")) // 5
			call this.addInfo(false, false, thistype.infoConditionGetSomeWood, thistype.infoActionGetSomeWood, tre("Hier sind ein paar Bretter von Kuno.", "Here are a few boards from Kuno.")) // 6
			call this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tre("Brauchst du sonst noch etwas?", "Do you need something else?")) // 7
			call this.addInfo(false, false, thistype.infoConditionSpecialSeed, thistype.infoActionSpecialSeed, tre("Hier hast du einen ganz besonderen Samen.", "Here you have a very special seed.")) // 8
			call this.addInfo(false, false, thistype.infoConditionWhatDoYouThink, thistype.infoActionWhatDoYouThink, tre("Und was hältst du von dem Baum?", "So, what do you think of the tree?")) // 9
			call this.addExitButton() // 10

			// page 5
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_0, tre("Kein Problem, mache ich.", "No problem, I'll do it.")) // 11
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_1, tre("Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.", "Bite me! My father's father, my grandfather, and his father, my great-grandfather, were all woodcutters, and you just made fun of it.")) // 12
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_2, tre("Ich überleg's mir mal.", "I'll think about it.")) // 13

			return this
		endmethod

		implement Talk
	endstruct

endlibrary