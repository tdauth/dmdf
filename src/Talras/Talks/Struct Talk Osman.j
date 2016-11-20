library StructMapTalksTalkOsman requires Asl, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestWitchingHour, StructMapQuestsQuestTheDarkCult

	struct TalkOsman extends Talk
		private static constant integer brotherGoldReward = 20
		private boolean array m_wasOffended[12] /// \todo \ref Game.maxPlayers, vJass bug.
		private boolean array m_gaveHealPotion[12] /// \todo \refGame.maxPlayers, vJass bug.

		private AInfo m_hi
		private AInfo m_whatAreYouDoingHere
		private AInfo m_doYouHaveMoreHealing
		private AInfo m_guntrichNeedsHelp
		private AInfo m_aboutTheGods
		private AInfo m_area
		private AInfo m_help
		private AInfo m_moreAboutTheCult
		private AInfo m_searchForTheCult
		private AInfo m_foundTheCult
		private AInfo m_cultIsHistory
		private AInfo m_exit
		private AInfo m_youAreKnowBeliever
		private AInfo m_itsMyPleasure
		private AInfo m_youLikeYoungBoys
		private AInfo m_iAmSorry
		private AInfo m_shutUp
		private AInfo m_back

		private method offend takes player whichPlayer returns nothing
			set this.m_wasOffended[GetPlayerId(whichPlayer)] = true
		endmethod

		private method wasOffended takes player whichPlayer returns boolean
			return this.m_wasOffended[GetPlayerId(whichPlayer)]
		endmethod

		private method giveHealPotion takes ACharacter character returns nothing
			local player user = character.player()
			local unit characterUnit = character.unit()
			local item healPotion = CreateItem('I00A', GetUnitX(characterUnit), GetUnitY(characterUnit))
			call UnitAddItem(characterUnit, healPotion)
			set this.m_gaveHealPotion[GetPlayerId(user)] = true
			set user = null
			set characterUnit = null
			set healPotion = null
		endmethod

		private method gaveHealPotion takes ACharacter character returns boolean
			local player user = character.player()
			local boolean result = this.m_gaveHealPotion[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			if (character.class() == Classes.cleric()) then
				call speech(info, character, true, tre("Sei gegrüßt werter Bruder. Es ist selten geworden, dass ich einen Glaubensgenossen treffe.", "Best greetings, brother. It happened to become a rareness to meet a coreligionist."), gg_snd_Osman1)
				call this.showRange(this.m_youAreKnowBeliever.index(), this.m_itsMyPleasure.index(), character)
			else
				call speech(info, character, true, tre("Ich grüße dich.", "Be welcome."), gg_snd_Osman4)
				call this.showStartPage(character)
			endif
		endmethod

		// (Nach der Begrüßung, Osman steht vor den Gräbern und betet)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_waypoint_osman_0, gg_unit_n00R_0101)
		endmethod

		// Was machst du hier?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Was machst du hier?", "What are you doing here?"), null)
			if (not this.wasOffended(character.player())) then
				call speech(info, character, true, tre("Nun, ich bin Osman, der Kleriker des Herzogs und wie du vielleicht gesehen hast, habe ich hier gebetet, um in meinem Glauben Kraft zu finden und unseren geliebten Herzog zu stärken.", "Well, I am Osman, the duke's cleric. And as you could eventually see I was praying, to become stronger due to my faith and to strengthen our beloved duke."), gg_snd_Osman5)
				call speech(info, character, true, tre("Dies hier sind die Gräber der Ahnen unseres Herzogs. Mögen sie in Frieden ruhen.", "These here are the graves of the ancestors. Do they rest in peace."), gg_snd_Osman6)
				call this.showStartPage(character)
			else
				call speech(info, character, true, tre("Was maßt du dir an, mich weiterhin zu belästigen? Soll ich dich etwa der Ketzerei beschuldigen?", "How you arrogate to keep bothering me? Do you want to get blamed for heresy?"), gg_snd_Osman7)
				if (not this.infoHasBeenShownToCharacter(this.m_youLikeYoungBoys.index(), character) or not this.infoHasBeenShownToCharacter(this.m_iAmSorry.index(), character)) then
					call this.showRange(this.m_youLikeYoungBoys.index(), this.m_iAmSorry.index(), character)
				else
					call this.showStartPage(character)
				endif
			endif
		endmethod

		// (Charakter hat den Heiltrank erhalten)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.gaveHealPotion(character)
		endmethod

		// Hast du noch mehr Heilmittel?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hast du noch mehr Heilmittel?", "Do you have any more healings?"), null)
			// (Wird zum ersten Mal aufgerufen)
			if (not this.infoHasBeenShownToCharacter(2, character)) then
				call speech(info, character, true, tre("So, der Trank ist dir also gut bekommen? Das freut mich zu hören. Selbstverständlich habe ich noch mehr Heilmittel, allerdings wird dich das auch eine Kleinigkeit kosten.", "I see, the healing potion did well? I'm glad to hear that. Of course I have more healings, though it will cost you a trifle."), gg_snd_Osman13)
			// (Wird nicht zum ersten Mal aufgerufen)
			else
				call speech(info, character, true, tre("Noch mehr? Mann, wo treibst du dich denn rum? Wie auch immer, selbstverständlich habe ich noch ein paar.", "Even more? Man, where are you around all the time? Anyways, of course I have to offer some more."), gg_snd_Osman14)
			endif
			call this.showStartPage(character)
		endmethod

		// (Nach der Begrüßung, Auftragsziel 1 des Auftrags „Geisterstunde“ ist aktiv)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(0, character) and QuestWitchingHour.characterQuest(character).questItem(0).isNew()
		endmethod

		// Guntrich braucht deine Hilfe.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Guntrich braucht deine Hilfe. Er sagt, auf dem Berg, auf dem seine Mühle steht, würde es spuken und …", "Guntrich does need your help. He says it hounts, on the hill, right where his mill is placed  …"), null)
			call speech(info, character, true, tre("Verdammt! Ich hab schon genug zu tun, hier in der Burg. Soll er sich doch selbst drum kümmern. Solange er das nicht bezahlen kann, werde ich keinen Finger krumm machen!", "Damn it! I'm busy enough here inside the castle. Shall he deal with it on his own. I won't lift a finger aslong as he can't pay!"), gg_snd_Osman15)
			// Auftragsziel 1 des Auftrags „Geisterstunde“ ist abgeschlossen
			call QuestWitchingHour.characterQuest(character).questItem(0).setState(AAbstractQuest.stateCompleted)
			call QuestWitchingHour.characterQuest(character).questItem(1).enable()
			call this.showStartPage(character)
		endmethod

		// (Nach Begrüßung, permanent)
		private static method infoConditionAboutTheGods takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Erzähl mir etwas über die Götter.
		private static method infoActionAboutTheGods takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Erzähl mir etwas über die Götter.", "Tell me about the gods."), null)
			call speech(info, character, true, tre("Die Götter wachen über uns. Sie blicken herab auf uns Diener, uns winzige Kreaturen. Sie beobachten jeden unserer Schritte und bewerten uns aufgrund unseres Willens, unserer Taten und unseres Glaubens.", "The gods are watching on us. They look down to us servants, us tiny creaturs. They observe all our decissions and judge us on the basis of our will, our deeds, and our faith."), gg_snd_Osman16)
			call speech(info, character, true, tre("Wendest du dich von ihnen ab, wird es dein Untergang sein! Sie vergeben nicht, sie vergessen nicht, und sie werden letztendlich immer ihre Rache vollziehen!", "Once you turn away from them, it will be your doom! They don't forgive, they don't forget, and in the end they will always enforce revenge."), gg_snd_Osman17)
			call speech(info, character, true, tre("Nimm dich in Acht vor dir selbst und wache über deine Taten auf dass du nicht ihren Zorn auf dich lenkst.", "Take care of yourself, and pay attention on your own deeds, so you will never direct theit wrath on you."), gg_snd_Osman18)
			call speech(info, character, false, tre("Interessant.", "Interesting."), null)

			call this.showStartPage(character)
		endmethod

		// (Nach Begrüßung, permanent)
		private static method infoConditionArea takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Was weißt du über diese Gegend?
		private static method infoActionArea takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Was weißt du über diese Gegend?", "What do you know about this area?"), null)
			call speech(info, character, true, tre("Eine ganze Menge. Vor vielen Jahren ging ich von meinem Kloster auf Pilgerfahrt und zog durch das Königreich, um Antworten zu finden. Antworten auf alle Fragen, die ich mir in der langen Zeit im Kloster gestellt hatte.", "Whole a lot. Many years ago I went from my monastery on a pilgrimage and travelled though the kingdom to find answers. Answers to all my questions I had asked myself during the long stay in the monastery."), gg_snd_Osman19)
			call speech(info, character, true, tre("Als ich schließlich Talras erreichte, traf ich auf den damaligen Herzog, Heimrichs Vater, der mich als persönlichen Burgkleriker anstellte.", "When I finaly reached Talas, I met the then Duke, Heimrich's father, who hired me as his personal castle cleric."), gg_snd_Osman20)
			call speech(info, character, true, tre("Seitdem lebe ich hier in der Burg und studiere die Götter und ihre Geschichte.", "Since then I live here in the castle, studying the gods and their past."), gg_snd_Osman21)
			call speech(info, character, true, tre("Die Leute in dieser Gegend sind dem Glauben sehr verbunden, besonders die Familie des Herzogs. Aber auch auf dem Bauernhof sind die Menschen äußerst fromm.", "The folks in this strongly appreciate their faith, exepcially the Duke's familty. But also the people on the farm here are utterly devout."), gg_snd_Osman22)
			call speech(info, character, true, tre("Im Norden und Nordosten jedoch befinden sich finstere Wälder, geplagt von Unheil und Abtrünnigen des Glaubens.", "Though, in the north and northeast are dark forests marked by mischief and renegarded of faith."), gg_snd_Osman23)
			call speech(info, character, true, tre("An deiner Stelle würde ich diese Gegenden meiden.", "If I was you I would avoid those places."), gg_snd_Osman24)
			call speech(info, character, true, tre("Aber da die Orks und Dunkelelfen bereits in das Königreich eingefallen sind, werden wird uns vermutlich bald mit übleren Kreaturen auseinandersetzen müssen.", "But since the orcs and dark evles have already invaded the kingdom, we probably will have to face even more evil creaturs very soon."), gg_snd_Osman25)
			call speech(info, character, true, tre("Mögen uns die Götter dabei beistehen!", "Shall the gods stay with us."), gg_snd_Osman26)

			call this.showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Kann ich dir irgendwie helfen?", "Is there something I can help with?"), null)
			call speech(info, character, true, tre("Helfen? Sicherlich, Hilfe kann ich immer gebrauchen. Ein alter Mann wie ich spürt, dass es mit ihm zu Ende geht.", "Help? Of course, I can always need help. An old man like me feels when one's end comes closer."), gg_snd_Osman27)
			call speech(info, character, true, tre("Wenn mein Ende gekommen ist, wird die Frage im Raume stehen, ob ich meinem Glauben so gewissenhaft gedient habe, wie es die Götter von mir verlangt haben.", "When my time has come the question will arise if I served my faith as relegious, as the gods called for."), gg_snd_Osman28)
			call speech(info, character, false, tre("Schon gut.", "Okay, I got it."), null)
			call speech(info, character, true, tre("Hm, es gibt da etwas, was mir auf dem Herzen liegt seit ich nach Talras gekommen bin, vor so vielen Jahren.", "Hm, there's something on my mind since I came to Talras, so many years ago."), gg_snd_Osman29)
			call speech(info, character, false, tre("Und das wäre?", "What is it?"), null)
			call speech(info, character, true, tre("Du musst wissen, die Bewohner von Talras sind womöglich nicht die einzigen Menschen, die sich hier herumtreiben. Damals als ich in Talras ankam gab es eine Auseinandersetzung unter den Bewohnern.", "You have to know that the residents of Talras are probably not the only people in this area. At the time I arrived in Talras there was a dispute among the living residents there."), gg_snd_Osman30)
			call speech(info, character, true, tre("Ein Teil der Bewohner spaltete sich vom damaligen Herzog, dem Vater Heimrichs, ab und verließ die Burg und den Bauernhof.", "A part of the people splitted from the Duke back then, Heimrich's father, and left the castle and the farm beyond."), gg_snd_Osman31)
			call speech(info, character, true, tre("Sie schworen den Göttern ab und zogen in den Wald, um etwas ... anderem zu dienen.", "They forswear the gods und settled down in the forest to serve... something else."), gg_snd_Osman32)
			call speech(info, character, true, tre("Der dunkle Kult belästigte daraufhin die Bewohner der Burg und des Dorfes. Sie stahlen, verschleppten und mordeten sogar bis schließlich der Herzog selbst ausritt und dem Ganzen ein Ende bereitete.", "Their new dark cult was disturbing the peace of of the castle's inhabitants and the ones in the whole village. They stole, kidnapped, and murdered until the Duke himself  finaly dealt with the issue to end all the drama."), gg_snd_Osman33)
			call speech(info, character, true, tre("Wie du dir denken kannst, wurden nicht alle Anhänger des Kultes gefasst und erschlagen. Ich frage mich seitdem, ob der Kult danach seine Existenz aufgegeben hat, haben wir doch so lange nichts mehr von ihm gehört.", "But as you probably can imagine not everyone of the new cult was caught and slayed. Since then I ask myself if the cult resigned it's existence, since we haven't heard of them for a long time already."), gg_snd_Osman34)
			call speech(info, character, true, tre("Diese ungeklärte Frage muss ich wohl mit ins Grab nehmen.", "Seems like I will take this unexplained question right with me into the grave."), gg_snd_Osman35)

			call QuestTheDarkCult.characterQuest(character).enable()

			call this.showStartPage(character)
		endmethod

		// (Nach „Kann ich dir irgendwie helfen?“ und Auftrag „Der dunkle Kult“ ist noch aktiv, permanent)
		private static method infoConditionMoreAboutTheCult takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_help.index(), character) and QuestTheDarkCult.characterQuest(character).isNew()
		endmethod

		// Erzähl mir mehr über den dunklen Kult.
		private static method infoActionMoreAboutTheCult takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Erzähl mir mehr über den dunklen Kult.", "Tell me some more about this dark cult."), null)
			call speech(info, character, true, tre("Dieser Kult hatte einen Anführer, einen dunklen Diakon. Er versprach seinen Gefolgsleuten das ewige Leben und so schlossen sich ihm einige Bewohner an.", "The cult had a leader, a dark deacon. He promised his followers an eternal life and could convice some of the residents this way."), gg_snd_Osman36)
			call speech(info, character, true, tre("Ich weiß nicht, woher er die Gewissheit nahm, das Leben kontrollieren zu können, aber anscheinend war er sehr überzeugend. Seine Leute taten alles für ihn und gehorchten ihm aufs Wort.", "I don't know where he got this confidence about being able to control the life, but apparently he was very convincingly. His followers were about to do everything for him and obeyed every single order."), gg_snd_Osman37)
			call speech(info, character, true, tre("Sie vergingen sich an Dorfbewohnern in einer Art und Weise, die selbst erfahrene Kriegsleute abschrecken würde.", "They dealt with other vilagers in such a mannar that it even experienced soldiers would be scared off."), gg_snd_Osman38)
			call speech(info, character, true, tre("Die Leichen schleppten sie danach mit in ihr Versteck. Die Götter allein wissen, was sie damit vor hatten.", "The dead bodies were braught into their hide. The gods alone know what they were about to do with them."), gg_snd_Osman39)
			call speech(info, character, false, tre("Wo befand sich ihr Versteck?", "Where was their hide?"), null)
			call speech(info, character, true, tre("Hm, wenn ich das noch wüsste. Ich glaube, sie hielten sich irgendwo im nördlichen Wald versteckt.", "Hm, if I could just remember that. I believe they were hiding somewhere in the northern forest."), gg_snd_Osman40)

			call this.showStartPage(character)
		endmethod

		// (Nach „Kann ich dir irgendwie helfen?“ und Auftrag „Der dunkle Kult“ ist noch aktiv)
		private static method infoConditionSearchForTheCult takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_help.index(), character) and QuestTheDarkCult.characterQuest(character).isNew()
		endmethod

		// Warum sucht keiner nach den verbliebenen Kultanhängern?
		private static method infoActionSearchForTheCult takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Warum sucht keiner nach den verbliebenen Kultanhängern?", "Why noone is searching for the rest of culr followers?"), null)
			call speech(info, character, true, tre("Ach … das ist eine lange Geschichte. Heimrich wuchs mit diesem dunklen Kapitel in der Geschichte seiner Heimat auf. Später wollte er nichts mehr davon wissen.", "Oh, this a quite long story. Heimrich grep up together with his homeland's dark chapter. But later on, he didn't want to deal with it anymore."), gg_snd_Osman41)
			call speech(info, character, true, tre("Auch die anderen Bewohner schweigen lieber darüber. Es scheint, den Leuten wird bei dem Gedanken an diese Geschichte sehr unbehaglich.", "Other residents also prefer to remain silent about it. It seems the people start to get very uncomfortable when thinking abour the past."), gg_snd_Osman42)

			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Der dunkle Kult“ ist abgeschlossen und Auftragsziel 2 des Auftrags ist noch aktiv)
		private static method infoConditionFoundTheCult takes AInfo info, ACharacter character returns boolean
			return QuestTheDarkCult.characterQuest(character).questItem(0).isCompleted() and QuestTheDarkCult.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe den dunklen Kult ausfindig gemacht.
		private static method infoActionFoundTheCult takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Ich habe den dunklen Kult ausfindig gemacht.", "I was able to locate the darc cult."), null)
			call speech(info, character, true, tre("Was sagst du da? Der Kult existiert noch? Sprich rasch!", "You say what? The cult does still exist?"), gg_snd_Osman43)
			call speech(info, character, false, tre("Sie haben eine Halle in einem Berg im Norden. Dort halten sie irgendwelche Predigten ab.", "They settled down in a hall inside a mountain in the north. They hold certain sermons there."), null)
			call speech(info, character, true, tre("Wie bitte?! Bei den Göttern, dagegen müssen wir sofort vorgehen!", "How is this possible!? By all gods, we immediatly have to act against this!"), gg_snd_Osman44)
			call speech(info, character, false, tre("Es sieht so aus, als hätte ihr Anführer etwas mit seinen Gefolgsleuten herumexperimentiert.", "It seems like the leader made some experiments with his followers."), null)
			call speech(info, character, true, tre("Wie meinst du das?", "What do you mean?"), gg_snd_Osman45)
			call speech(info, character, false, tre("Ihre Körper sehen nicht sehr natürlich aus. Einige von ihnen haben drei Beine, andere die Füße von Vögeln und wieder andere Flügel aus Knochen.", "Their bodies don't look very naturally. Some of them have three legs, others legs by birds, and some also wings made out of bones."), null)
			call speech(info, character, false, tre("Bist du sicher, dass alle Menschen waren?", "Are you sure, that these were all human beings?"), null)
			call speech(info, character, true, tre("Götter steht uns bei! Dunkle Magie, anders lässt sich das nicht erklären! Geh da hin und vernichte diese Ketzer, diese Frevler, diese ungläubigen Sünder! Du hast meinen Segen!", "Gods help us! Dark magic.. else it's just unexplainable. Go there and kill all of them, these heretics, these infidels, these sinners! You have my blessing!"), gg_snd_Osman46)
			call speech(info, character, true, tre("Nimm diese Gegenstände. Sie werden dir bei deiner Reinigung von Nutzen sein. Mögen die Götter über dich wachen.", "Take these items. They will serve you in helping staying pure. Shall the gods be with you."), gg_snd_Osman47)

			call QuestTheDarkCult.characterQuest(character).questItem(1).complete()
			call QuestTheDarkCult.characterQuest(character).questItem(2).enable()
			call QuestTheDarkCult.characterQuest(character).questItem(3).enable()
			// TODO give items
			//call character.giveItem()
			call character.giveItem('I06N')
			call character.giveItem('I06N')
			call character.giveItem('I06N')

			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 3 des Auftrags „Der dunkle Kult“ ist abgeschlossen und Auftragsziel 4 ist aktiv)
		private static method infoConditionCultIsHistory takes AInfo info, ACharacter character returns boolean
			return QuestTheDarkCult.characterQuest(character).questItem(2).isCompleted() and QuestTheDarkCult.characterQuest(character).questItem(3).isNew()
		endmethod

		// Der Kult ist Geschichte.
		private static method infoActionCultIsHistory takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Der Kult ist Geschichte.", "The cult became history."), null)
			call speech(info, character, true, tre("Gepriesen seist du, Gottgesandter! Das Übel hat nun endlich ein Ende und ich muss nicht unwissend sterben. Nimm dies als Belohnung. Du hast es dir verdient.", "You shall be blessed, gods' ambassador. The evil is finaly defeated and I won't die unsespecting. Take this as reward, you really deserved it."), gg_snd_Osman48)

			call QuestTheDarkCult.characterQuest(character).complete()
			// TODO give items
			//call character.giveItem()

			call this.showStartPage(character)
		endmethod

		// Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.", "You are no fellow believer. You're just a coward who fears the Duke. A true cleric travels around and fights for his faith."), null)
			call speech(info, character, true, tre("Hüte deine Zunge elender Wurm!", "Watch your mouth, you miserable worm!"), gg_snd_Osman2)
			call this.offend(character.player())
			call this.showStartPage(character)
		endmethod

		// Die Freude ist ganz meinerseits.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Die Freude ist ganz meinerseits.", "The pleasure is mine."), null)
			call speech(info, character, true, tre("Na das ist mir doch glatt ein paar Goldmünzen wert. Hier, nimm Bruder!", "Well, this is worth some of my gold coins! Here you are, brother."), gg_snd_Osman3)
			call character.addGold(thistype.brotherGoldReward)
			call speech(info, character, false, tre("Danke.", "Thanks."), null)
			call this.showStartPage(character)
		endmethod

		// So so, du stehst wohl auf junge Knaben.
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("So so, du stehst wohl auf junge Knaben.", "Ahem, so you have a favel for young boys."), null)
			call speech(info, character, true, tre("Jetzt reicht's mir! Ich werde mich beim Herzog persönlich über dich beschweren!","You went too far now! I persoanly will complain to the Duke about you."), gg_snd_Osman8)
			call QuestThePaedophilliacCleric.characterQuest(character).enable()
			call speech(info, character, false, tre("Es war mir ein Vergnügen.", "It was a pleasure."), null)
			call speech(info, character, true, tre("Du wirst schon noch dein blaues Wunder erleben!", "You will experience a nasty surprise soon!"), gg_snd_Osman9)
			call this.showStartPage(character)
		endmethod

		// Das vorhin tut mir leid. Ich hab das nicht so gemeint.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Das von vorhin tut mir leid. Ich hab das nicht so gemeint.", "I'm sorry about the situation before. It wasn't meant like that."), null)
			call speech(info, character, true, tre("Schon gut. Ich weiß ja wie angespannt die Lage ist, da kann einem so etwas schon mal raus rutschen.", "Alright. Yet, I know how keen the current situation is, and something like this might easily happen then."), gg_snd_Osman10)
			call speech(info, character, true, tre("Verdammter Krieg eben.", "Just this goddamn war."), gg_snd_Osman11)
			call this.showRange(this.m_shutUp.index(), this.m_back.index(), character)
		endmethod

		// Halt den Mund du Tölpel!
		private static method infoAction1_0_0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Halt den Mund du Tölpel!", "Shut your mouth, you fool!"), null)
			call speech(info, character, true, tre("Du scheinst wohl unter Stimmungsschwankungen zu leiden. Ich glaube, ich hab da was für dich. Wäre doch gelacht, wenn dir ein alter Kleriker wie ich nicht helfen könnte. Hier, nimm das!", "You seem to suffer from mood swings. I've got something for you. It was laughable if a old cleric like me was unable to help. Here you are!"), gg_snd_Osman12)
			call this.giveHealPotion(character)
			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.osman(), thistype.startPageAction)
			local integer i = 0
			loop
			exitwhen (i == MapSettings.maxPlayers())
				set this.m_wasOffended[i] = false
				set this.m_gaveHealPotion[i] = false
				set i = i + 1
			endloop

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello."))
			set this.m_whatAreYouDoingHere = this.addInfo(true, false, thistype.infoCondition1, thistype.infoAction1, tre("Was machst du hier?", "What are you doing here?"))
			set this.m_doYouHaveMoreHealing = this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tre("Hast du noch mehr Heilmittel?", "Do you have any more healings?"))
			set this.m_guntrichNeedsHelp = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Guntrich braucht deine Hilfe.", "Guntrich does need your help."))
			set this.m_aboutTheGods = this.addInfo(true, false, thistype.infoConditionAboutTheGods, thistype.infoActionAboutTheGods, tre("Erzähl mir etwas über die Götter.", "Tell me about the gods."))
			set this.m_area = this.addInfo(true, false, thistype.infoConditionArea, thistype.infoActionArea, tre("Was weißt du über diese Gegend?", "What do you know about this area?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tre("Kann ich dir irgendwie helfen?", "Is there something I can help with?"))
			set this.m_moreAboutTheCult = this.addInfo(true, false, thistype.infoConditionMoreAboutTheCult, thistype.infoActionMoreAboutTheCult, tre("Erzähl mir mehr über den dunklen Kult.", "Tell me some more about this dark cult."))
			set this.m_searchForTheCult = this.addInfo(false, false, thistype.infoConditionSearchForTheCult, thistype.infoActionSearchForTheCult, tre("Warum sucht keiner nach den verbliebenen Kultanhängern?", "Why noone is searching for the rest of culr followers?"))
			set this.m_foundTheCult = this.addInfo(false, false, thistype.infoConditionFoundTheCult, thistype.infoActionFoundTheCult, tre("Ich habe den dunklen Kult ausfindig gemacht.", "I was able to locate the darc cult."))
			set this.m_cultIsHistory = this.addInfo(false, false, thistype.infoConditionCultIsHistory, thistype.infoActionCultIsHistory, tre("Der Kult ist Geschichte.", "The cult became history."))
			set this.m_exit = this.addExitButton()

			// m_hi
			set this.m_youAreKnowBeliever = this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.", "You are no fellow believer. You're just a coward who fears the Duke. A true cleric travels around and fights for his faith."))
			set this.m_itsMyPleasure = this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Die Freude ist ganz meinerseits.", "The pleasure is mine."))

			// m_whatAreYouDoingHere
			set this.m_youLikeYoungBoys = this.addInfo(false, false, 0, thistype.infoAction1_0, tre("So so, du stehst wohl auf junge Knaben.", "Ahem, so you have a favel for young boys."))
			set this.m_iAmSorry = this.addInfo(false, false, 0, thistype.infoAction1_1, tre("Das vorhin tut mir leid. Ich hab das nicht so gemeint.", "I'm sorry about the situation before. It wasn't meant like that."))

			// m_youLikeYoungBoys
			set this.m_shutUp = this.addInfo(false, false, 0, thistype.infoAction1_0_0, tre("Halt den Mund du Tölpel!", "Shut your mouth, you fool!"))
			set this.m_back = this.addBackToStartPageButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary