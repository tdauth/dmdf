library StructMapTalksTalkHaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToBlackLegion

	struct TalkHaldar extends Talk
		private boolean array m_gotOffer[12] /// \todo \ref MapSettings.maxPlayers()
		private integer array m_lastRewardScore[12] /// \todo \ref MapData#maxPlayers

		public method giveOffer takes player whichPlayer returns nothing
			set this.m_gotOffer[GetPlayerId(whichPlayer)] = true
		endmethod

		/// Parameter is required since it's used by \ref TalkBaldar.
		public method gotOffer takes player whichPlayer returns boolean
			return this.m_gotOffer[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoActionGreeting takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Wer bist du und was machst du in meinem Lager?", "Who are you and what are you doing in my camp?"), gg_snd_Haldar1)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkBaldar.talk.evaluate().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tre("Dein Lager?", "Your camp?"), null)
				call speech(info, character, true, tre("Ja, mein Lager!", "Yes, my camp!"), gg_snd_Haldar2)
				call speech(info, character, true, tre("Dies ist das Lager der weißen Legion, meines Heers.", "This is the camp of the White Legion, my army."), gg_snd_Haldar3)
			// (Charakter hat bereits Baldar getroffen)
			else
				call speech(info, character, true, tre("Dies ist das Lager der weißen Legion, meines Heers.", "This is the camp of the White Legion, my army."), gg_snd_Haldar3) // add these information here as well, otherwise the later options make no sense
				call speech(info, character, false, tre("Bist du Baldars Bruder?", "Are you Baldar's brother?"), null)
				call speech(info, character, true, tre("Woher weißt du das?", "Where do you know this from?"), gg_snd_Haldar4)
				call speech(info, character, false, tre("Ich habe mit ihm gesprochen.", "I've talked to him."), null)
				call speech(info, character, true, tre("Ist das so? Ich hoffe nur, er hat dir keinen Wurm ins Ohr gesetzt. Seine Wut und Dummheit kennen keine Grenzen!", "Is that so? I just hope he has not put a worm in your ear. His anger and stupidity know no boundaries!"), gg_snd_Haldar5)

				// (Auftrag „Tod der weißen Legion“ nicht aktiv)
				if (QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()) then
					call speech(info, character, true, tre("Aber bevor mein dummer Bruder noch auf die Idee kommen sollte, dich anzuwerben, tue ich das lieber.", "But before my stupid brother should get the idea even to recruit you, I prefer to do that myself."), gg_snd_Haldar6)
					call speech(info, character, true, tre("Möchtest du nicht meinem glorreichen Heer beitreten, damit ich diesem Kampf hier ein schnelleres Ende bereiten kann?", "Don't you want to join my glorious army, so I can make end this fight here more rapidly?"), gg_snd_Haldar7)
					call speech(info, character, false, tre("Mal sehen.", "We'll see."), null)
					call speech(info, character, true, tre("Gut, lasse dir ruhig Zeit. Er wird mich sowieso nicht besiegen können.", "Well, just take your time. He won't be able to defeat my anyway."), gg_snd_Haldar8)
					call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
		private static method infoConditionGotOfferAndIsNotActive takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).gotOffer(character.player()) and QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()
		endmethod

		// Ich möchte der weißen Legion beitreten.
		private static method infoActionIWantToJoin takes AInfo info, Character character returns nothing
			local unit characterUnit = character.unit()
			local item whichItem
			call speech(info, character, false, tre("Ich möchte der weißen Legion beitreten.", "I wish to join the White Legion."), null)
			call speech(info, character, true, tre("Das freut mich zu hören! Auf jeden Fall war es eine weise Entscheidung.", "That's nice to hear! Anyway it was a wise decision."), gg_snd_Haldar9)
			call speech(info, character, true, tre("Doch nun zu deiner neuen Aufgabe: zunächst einmal bekommst du diese Standarte hier. Es ist mein ruhmreiches weißes Wappen.", "But now to your new job: First of all you get this banner here. It is my glorious white crest."), gg_snd_Haldar10)
			call speech(info, character, true, tre("Damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Weihwasser, auch wenn ich eigentlich Leute nur sehr ungern gegen einen Sold für mich kämpfen lasse. Aber was tut man nicht alles im Krieg?.", "So you do not have the feeling that you have to fight here for nothing, here you have a few gold coins and some holy water, even if I usually don't like to let people fight for me for a payment. But what does one not do in the war?"), gg_snd_Haldar11)
			call speech(info, character, true, tre("Gut, nun lasse mich dir erklären, was du auf dem „Schlachtfeld“ zu tun hast. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf beiden Wegen schicken mein Bruder und ich Truppen gegeneinander los. Es steht dir also frei, auf welchem der Wege du für mich kämpfen möchtest.", "Good, now let me tell you what you have to do on the \"battlefield\". There are two ways to connect the two camps together. On both ways my brother and I send troops against each other. You are free on which of the paths you want to fight for me."), gg_snd_Haldar12)
			call speech(info, character, true, tre("Es gibt nur ein kleines Problem dabei. Mein Bruder und ich haben damals, als wir mit dem Kampf gegeneinander begannen, vereinbart, dass keiner außer uns beiden, das Recht besitzt, sich in den Streit einzumischen.", "There is only one small problem with this. My brother and I agreed that no one besides us both has the right to interfere in the dispute when we started to fight against each other."), gg_snd_Haldar13)
			call speech(info, character, true, tre("Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als fremde Einmischung.", "The warriors I send I have created all myself, so that does not count as foreign interference."), gg_snd_Haldar14)
			call speech(info, character, true, tre("Du dagegen würdest gegen die Regeln verstoßen. Für gewöhnlich achte ich Regeln zwar ganz besonders, hierbei aber mache selbst ich einmal eine Ausnahme, um den Streit endlich siegreich zu beenden.", "You on the other hand would violate the rules. Usually I respect rules all the more but in this case I do an exception myself once to finally end the dispute victorious."), gg_snd_Haldar15)
			call speech(info, character, false, tre("Also, was soll ich tun?", "So, what should I do?"), null)
			call speech(info, character, true, tre("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Engels verwandelt.", "There would be a nice solution. Before you enter the battlefield, you use a magic ring of mine which turns you in the form of an angel."), gg_snd_Haldar16)
			call speech(info, character, false, tre("Was?", "What?"), null)
			call speech(info, character, true, tre("Keine Sorge, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln.", "Do not worry, once you use it again, you'll transform back to yourself of course."), gg_snd_Haldar18)
			call speech(info, character, true, tre("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!", "However, the spell affects only within this cave. Outside my aura is not strong enough!"), gg_snd_Haldar17)
			call speech(info, character, true, tre("Ach so und noch etwas: Hast du genügend Feinde getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst.", "Oh and one more thing: Did you kill enough enemies, of course you also get corresponding rewards that you can pick up personally from me."), gg_snd_Haldar19)
			call character.giveQuestItem('I01C') // Standarte
			call character.giveItem('I06N') // holy water
			call character.giveItem('I00T') // gold
			// Ring
			if (character.class() == Classes.dragonSlayer()) then
				call character.giveQuestItem('I034')
			elseif (character.class() == Classes.druid()) then
				call character.giveQuestItem('I035')
			elseif (character.class() == Classes.elementalMage()) then
				call character.giveQuestItem('I036')
			elseif (character.class() == Classes.cleric()) then
				call character.giveQuestItem('I038')
			elseif (character.class() == Classes.necromancer()) then
				call character.giveQuestItem('I039')
			elseif (character.class() == Classes.ranger()) then
				call character.giveQuestItem('I03B')
			elseif (character.class() == Classes.knight()) then
				call character.giveQuestItem('I03A')
			elseif (character.class() == Classes.wizard()) then
				call character.giveQuestItem('I03C')
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call character.giveQuestItem('I033')
			endif
			call QuestDeathToBlackLegion.characterQuest(character).enable()
			call info.talk().showStartPage(character)
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der schwarzen Legion“ ist aktiv)
		private static method infoConditionIsActive takes AInfo info, ACharacter character returns boolean
			return QuestDeathToBlackLegion.characterQuest(character).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoActionReward takes AInfo info, ACharacter character returns nothing
			local integer newScore = Aos.playerScore(character.player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())]
			local integer i
			call speech(info, character, false, tre("Gib mir meine Belohnung!", "Give me my reward!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, character, true, tre("Gut, hier hast du sie. Mach nur weiter so und wir werden diesen Streit bald beendet haben!", "Well, here you have it. Just continue with this and we will have ended this dispute soon!"), gg_snd_Haldar20)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(character).displayUpdateMessage(tre("Belohnung:", "Reward:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(character).questItem(1).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, character, true, tre("Ein paar mehr solltest du aber schon getötet haben. Es heißt ja nicht umsonst Belohnung.", "You should kill a few more. It's not called reward for nothing."), gg_snd_Haldar21)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Welches Heer?
		private static method infoActionWhichArmy takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Welches Heer?", "Which army?"), null)
			call speech(info, character, true, tre("Sieh dich um! Dies ist mein Heer. Ich habe diese Krieger geschaffen, um meinen Bruder Baldar zur Vernunft zu bringen.", "Look around! This is my army. I have created these warriors to bring my brother Baldar to reason."), gg_snd_Haldar22)
			call info.talk().showStartPage(character)
		endmethod

		// Weiße Legion?
		private static method infoActionWhiteLegion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Weiße Legion?", "White Legion?"), null)
			call speech(info, character, true, tre("Ganz genau, so nennen wir uns, mein Gefolge und ich. Wir kämpfen hier schon seit einiger Zeit gegen die schwarze Legion. Sie wird von meinem etwas dümmlichen und aggressiven Bruder Baldar angeführt, einem Erzdämon.", "Exactly, that is how we call ourselves, my entourage and myself. We are fighting for some time against the Black Legion. It is led by my little stupid and aggressive brother Baldar, an archdemon."), gg_snd_Haldar23)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Weiße Legion?“)
		private static method infoConditionAfterBlackLegion takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(4, character)
		endmethod

		// Wieso ist dein Bruder ein Erzdämon?
		private static method infoActionWhyIsBrother takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso ist dein Bruder ein Erzdämon?", "Why is your brother an archdemon?"), null)
			call speech(info, character, true, tre("Wieso sollte er es nicht sein, dieser Narr?", "Why should he not be one, this fool?"), gg_snd_Haldar24)
			call info.talk().showStartPage(character)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoActionWhyDoYouFight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso kämpft ihr gegeneinander?", "Why are you fighting each other?"), null)
			call speech(info, character, true, tre("Was weiß ich? Frage doch meinen Bruder, warum er immer Streit anfängt.", "What do I know? Ask my brother why he always starts dispute."), gg_snd_Haldar25)
			call info.talk().showStartPage(character)
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoActionWhoIsStronger takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer ist denn der Stärkere von euch beiden?", "Who is the stronger of the two of you?"), null)
			call speech(info, character, true, tre("(Lacht) Mein Bruder würde dir jetzt vermutlich antworten, dass er der Stärkere ist und das doch selbstverständlich wäre.", "My brother would answer you now probably that he is the stronger one and that it would be obvious."), gg_snd_Haldar26)
			call speech(info, character, true, tre("Er war schon immer schwächer, aber das Ganze zieht sich jetzt schon recht lange hin und ich möchte dem ein Ende bereiten.", "He has always been weaker, but the whole thing takes palce now quite a while and I want to put an end to it."), gg_snd_Haldar27)
			if (not thistype(info.talk()).gotOffer(character.player()) and QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()) then // (Charakter hat kein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
				call speech(info, character, true, tre("Möchtest du mir dabei helfen?", "Do you want to help me with this?"), gg_snd_Haldar28)
				call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
			endif
			call info.talk().showRange(9, 10, character)
		endmethod

		// Warum sollte ich?
		private static method infoActionWhyShouldI takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Warum sollte ich?", "Why should I?"), null)
			call speech(info, character, true, tre("Ganz einfach, weil du damit einem ruhmreichen, gerechten Weg folgen würdest. Vielleicht aber auch nur für einen verächtlichen Sold.", "Simply because you would thus follow a glorious, righeous way. But maybe only for a contemptuous payment."), gg_snd_Haldar30) // TODO gg_snd_Haldar29 is the same
			call info.talk().showStartPage(character)
		endmethod

		// Klar!
		private static method infoActionOfCourse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Klar!", "Sure!"), null)
			call speech(info, character, true, tre("Du scheinst mir sehr mutig zu sein. Ich hoffe, dahinter steckt eine ehrenvolle Absicht. Das Beste ist vermutlich, wenn ich dir noch etwas Zeit zum Überlegen gebe.", "You seem to be very brave. I hope behind it an honorable intention. The best is probably, if I give you some time to think."), gg_snd_Haldar31)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.haldar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_gotOffer[i] = false
				set this.m_lastRewardScore[i] = 0
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoActionGreeting, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoConditionGotOfferAndIsNotActive, thistype.infoActionIWantToJoin,  tre("Ich möchte der weißen Legion beitreten.", "I wish to join the White Legion.")) // 1
			call this.addInfo(true, false, thistype.infoConditionIsActive, thistype.infoActionReward, tre("Gib mir meine Belohnung!", "Give me my reward!")) // 2
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhichArmy, tre("Welches Heer?", "Which army?")) // 3
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhiteLegion, tre("Weiße Legion?", "White Legion?")) // 4
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyIsBrother, tre("Wieso ist dein Bruder ein Erzdämon?", "Why is your brother an archdemon?")) // 5
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyDoYouFight, tre("Wieso kämpft ihr gegeneinander?", "Why are you fighting each other?")) // 6
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhoIsStronger, tre("Wer ist denn der Stärkere von euch beiden?", "Who is the stronger of the two of you?")) // 7
			call this.addExitButton() // 8

			// sub info from infoActionWhoIsStronger
			call this.addInfo(false, false, 0, thistype.infoActionWhyShouldI, tre("Warum sollte ich?", "Why should I?")) // 9
			call this.addInfo(false, false, 0, thistype.infoActionOfCourse, tre("Klar!", "Sure!")) // 10

			return this
		endmethod

		implement Talk
	endstruct

endlibrary