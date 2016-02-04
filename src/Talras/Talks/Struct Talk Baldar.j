library StructMapTalksTalkBaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToWhiteLegion

	// TODO update dialog according to the latest file
	struct TalkBaldar extends Talk
		private boolean array m_gotOffer[12] /// \todo \ref MapData#maxPlayers
		private integer array m_lastRewardScore[12] /// \todo \ref MapData#maxPlayers

		implement Talk

		public method giveOffer takes player whichPlayer returns nothing
			set this.m_gotOffer[GetPlayerId(whichPlayer)] = true
		endmethod

		/// Parameter is required since it's used by \ref TalkHaldar.
		public method gotOffer takes player whichPlayer returns boolean
			return this.m_gotOffer[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoActionGreeting takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Wer bist du und was machst du in meinem Lager?", "Who are you and what are you doing in my camp?"), gg_snd_Baldar1)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkHaldar.talk.evaluate().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tre("Dein Lager?", "Your camp?"), null)
				call speech(info, character, true, tre("Ja, mein Lager!", "Yes, my camp!"), gg_snd_Baldar2)
				call speech(info, character, true, tre("Das ist das Lager der schwarzen Legion, meines Heers.", "This is the camp of the Black Legion, my army!"), gg_snd_Baldar3)
			// (Charakter hat bereits Haldar getroffen)
			else
				call speech(info, character, false, tre("Bist du Haldars Bruder?", "Are you Haldar's brother?"), null)
				call speech(info, character, true, tre("Woher weißt du das?", "Where do you know this from?"), gg_snd_Baldar4)
				call speech(info, character, false, tre("Hab mit ihm gesprochen.", "I talked to him."), null)
				call speech(info, character, true, tre("Du wagst es, mit diesem Feigling zu sprechen? Wie kannst du dir das nur antun?", "You dare to talk to this coward? How can you just do this to yourself?"), gg_snd_Baldar5)
				call speech(info, character, false, tre("Ganz ruhig, Flügelmann.", "Easy, wingman."), null)
				call speech(info, character, true, tre("Weißt du eigentlich wen du vor dir hast? Ich bin Baldar, der mächtige Erzdämon aus …", "Do you even know who is standing in front of you? I am Baldar, the powerful archdemon from ..."), gg_snd_Baldar6)
				call speech(info, character, false, tre("… einem Kartoffelsack.", "... a potato sack."), null)
				call speech(info, character, true, tre("Schweig, du Hund!", "Silence, you dog!"), gg_snd_Baldar7)
				// (Auftrag „Tod der schwarzen Legion“ nicht aktiv)
				if (QuestDeathToBlackLegion.characterQuest(character).isNotUsed()) then
					call speech(info, character, true, tre("Wenn du schon so eine spitze Zunge hast, dann verwende sie wenigstens gegen meinen Bruder!", "If you already have such a sharp tongue, then use it at least against my brother!"), gg_snd_Baldar8)
					call speech(info, character, true, tre("Tritt meinem Heer bei und bekämpfe ihn und seinesgleichen!", "Join my army and fight him and his ilk!"), gg_snd_Baldar9)
					call speech(info, character, false, tre("Ich überleg's mir.", "I'll think about it."), null)
					call speech(info, character, true, tre("Gut, aber nicht zu lange will ich hoffen.", "Good, but not too long I hope."), gg_snd_Baldar10)
					call speech(info, character, false, tre("Gut Ding will Weile haben.", "Good thinks take time."), null)
					call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der schwarzen Legion“ ist nicht aktiv)
		private static method infoConditionGotOfferAndIsNotActive takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).gotOffer(character.player()) and QuestDeathToBlackLegion.characterQuest(character).isNotUsed()
		endmethod

		// Ich möchte der schwarzen Legion beitreten.
		private static method infoActionIWantToJoin takes AInfo info, ACharacter character returns nothing
			local unit characterUnit = character.unit()
			local item whichItem
			call speech(info, character, false, tre("Ich möchte der schwarzen Legion beitreten.", "I wish to join the Black Legion."), null)
			call speech(info, character, true, tre("Das freut mich zu hören.", "That's nice to hear."), gg_snd_Baldar11)
			call speech(info, character, true, tre("Zunächst einmal bekommst du diese Standarte hier. Es ist mein schwarzes Wappen, nicht so hässlich wie das weiße meines Bruders. Und damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Schwefel.", "First of all you get this standard. It is my black coat of arms, not as ugly as the white of my brother. And so you do not have the feeling that you have to fight here for nothing, here you have a few gold coins and some sulfur."), gg_snd_Baldar12)
			call speech(info, character, true, tre("So, jetzt erkläre ich dir mal, wie das hier läuft, auf dem „Schlachtfeld“. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf jedem dieser Wege schicken mein Bruder und ich Truppen gegeneinander los. Du kannst dir aussuchen, auf welchem der Wege du kämpfen möchtest. Das ist mir ziemlich egal, Hauptsache du kämpfst.", "So now I tell you how this works on the \"battlefield\". There is two ways to connect the both camps. On each path my brother and I send troops against each other. You can choose on which of these paths you want to fight. That does not really matter, as long as you fight."), gg_snd_Baldar13)
			call speech(info, character, true, tre("Da gibt's nur ein kleines Problem. Mein Bruder und ich haben damals, als wir mit dem Kampf begonnen haben, ausgemacht, dass keiner außer uns beiden sich in den Streit einmischen darf. Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als Einmischung.", "There is only a small problem. My brother and I did agree that nobody except one of us two should interfere in the dispute when we began the battle. The warriors I send I have created all myself, so that does not count as interference."), gg_snd_Baldar14)
			call speech(info, character, true, tre("Du dagegen würdest gegen die Regeln verstoßen. Nicht, dass ich viel für Regeln übrig hätte, aber ich will nicht, dass mich mein verdammter Bruder einen Feigling nennt.", "You on the other hand would violate the rules. Not that I would have left much for rules but I do not want my damned brother to call my a coward."), gg_snd_Baldar15)
			call speech(info, character, false, tre("Also, was soll ich tun?", "So, what should I do?"), null)
			call speech(info, character, true, tre("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Dämons verwandelt.", "There would be a nice solution. Before you enter the battlefield, you use a magic ring of mine which transforms you into the form of a demon."), gg_snd_Baldar16)
			call speech(info, character, false, tre("Aha.", "Alright."), null)
			call speech(info, character, true, tre("Keine Angst, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln.", "Don't worry, once you use it again, you will be transformed back of course."), gg_snd_Baldar17)
			call speech(info, character, true, tre("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!", "However, the spell only works within this cave. Outside my auro is not strong enough!"), gg_snd_Baldar18)
			call speech(info, character, true, tre("Ach so und noch etwas: Hast du genügend Feinde getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst.", "Oh and one more thing: When you have killed enough enemies, of course, you also get corresponding rewards that you can pick up personally from me."), gg_snd_Baldar19)
			call Character(character).giveQuestItem('I01B') // Standarte
			// TODO Gold and sulfur
			// Ring
			if (character.class() == Classes.dragonSlayer()) then
				call Character(character).giveQuestItem('I02U')
			elseif (character.class() == Classes.druid()) then
				call Character(character).giveQuestItem('I02V')
			elseif (character.class() == Classes.elementalMage()) then
				call Character(character).giveQuestItem('I02W')
			elseif (character.class() == Classes.cleric()) then
				call Character(character).giveQuestItem('I02Y')
			elseif (character.class() == Classes.necromancer()) then
				call Character(character).giveQuestItem('I02Z')
			elseif (character.class() == Classes.ranger()) then
				call Character(character).giveQuestItem('I030')
			elseif (character.class() == Classes.knight()) then
				call Character(character).giveQuestItem('I031')
			elseif (character.class() == Classes.wizard()) then
				call Character(character).giveQuestItem('I032')
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call Character(character).giveQuestItem('I015')
			endif
			call QuestDeathToWhiteLegion.characterQuest(character).enable()
			call info.talk().showStartPage(character)
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der weißen Legion“ ist aktiv)
		private static method infoConditionIsActive takes AInfo info, ACharacter character returns boolean
			return QuestDeathToWhiteLegion.characterQuest(character).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoActionReward takes AInfo info, ACharacter character returns nothing
			local integer newScore = Aos.playerScore(character.player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())]
			local integer i
			call speech(info, character, false, tre("Gib mir meine Belohnung!", "Give me my reward!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, character, true, tre("Gut, hier hast du sie. Mach nur weiter so und wir werden meinen Bruder bald besiegt haben!", "Well, here you have it. Continue this way and we will defeat my brother soon!"), gg_snd_Baldar20)
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
				call speech(info, character, true, tre("Pah, töte erst mal mehr von seinen Kriegern und dann sehen wir weiter.", "Pooh, kill some of his warriors first and then we'll see."), gg_snd_Baldar21)
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
			call speech(info, character, true, tre("Bist du etwa blind? Schau dich doch mal um! Siehst du nicht die vielen Krieger? Sie alle dienen mir, um diesen Bastard Haldar zu vernichten!", "Are you blind? Look around! Don't you see the many warriors? They all serve me to destroy this bastard Haldar!"), gg_snd_Baldar22)
			call info.talk().showStartPage(character)
		endmethod

		// Schwarze Legion?
		private static method infoActionBlackLegion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Schwarze Legion?", "Black Legion?"), null)
			call speech(info, character, true, tre("Ja. So nennen wir uns, also mein Gefolge und ich. Wir kämpfen hier schon seit einiger Zeit gegen die weiße Legion. Sie wird von meinem widerlichen Bruder Haldar angeführt, einem Erzengel.", "Yes. That's what we call ourselves, my entourage and myself. We are fighting for some time against the White Legion. It is led by my loathsome brother Haldar, an archangel."), gg_snd_Baldar23)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Schwarze Legion?“)
		private static method infoConditionAfterBlackLegion takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(4, character)
		endmethod

		// Wieso ist dein Bruder ein Erzengel?
		private static method infoActionWhyIsBrother takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso ist dein Bruder ein Erzengel?", "Why is your brother an archangel?"), null)
			call speech(info, character, true, tre("Wieso sollte er es nicht sein, dieser Schweinehund?", "Why shouldn't he be one, this bastard?"), gg_snd_Baldar24)
			call speech(info, character, false, tre("Inzucht und so ...", "Inbreeding and so ..."), null)
			call speech(info, character, true, tre("Was sagst du? Sprich gefälligst lauter, wenn du mir was zu sagen hast.", "What are you saying. Speak kindly louder when you have to tell me something."), gg_snd_Baldar25)
			call info.talk().showStartPage(character)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoActionWhyDoYouFight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso kämpft ihr gegeneinander?", "Why are you fighting each other?"), null)
			call speech(info, character, true, tre("Spielt das eine Rolle für dich? Wieso fragst du überhaupt?", "Does it matter to you? Why are you even asking?"), gg_snd_Baldar26)
			call speech(info, character, false, tre("Reine Neugier.", "Pure curiosity."), null)
			call speech(info, character, true, tre("Hmm, na ja, also ehrlich gesagt, ich weiß es gar nicht mehr so genau. Aber das ändert nichts daran, dass mein Bruder ein mieser Lügner und Verräter ist und ich ihn vernichten werde!", "Hmm, well, so frankly, I cannot remember exactly. But the fact remains that my brother is a lousy liar and traitor and I will destroy him!"), gg_snd_Baldar27)
			call info.talk().showStartPage(character)
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoActionWhoIsStronger takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer ist denn der Stärkere von euch beiden?", "Who is the stronger of the two of you?"), null)
			call speech(info, character, true, tre("Ich natürlich. Versteht sich doch von selbst, dass ein Erzdämon stärker als ein Erzengel ist!", "I, of course. That goes without saying that an archdemon is stronger than an archangel!"), gg_snd_Baldar28)
			call speech(info, character, true, tre("Wobei ich noch etwas Unterstützung gebrauchen könnte. Immerhin kämpfen wir nun schon so lange gegeneinander und keiner von uns beiden kann gewinnen. Ich schätze mal, er hat einfach zu viele Truppen um sich geschart, dieser feige Hund!", "Although I still could use some support. After all, we are now fighting for so long against each other and neither of us can win. I guess he has gathered too many troops around, this cowardly dog!"), gg_snd_Baldar29)
			call speech(info, character, true, tre("Du hättest nicht zufällig Lust, in mein Heer einzutreten?", "You would not happen to like to join my army?"), gg_snd_Baldar30)
			call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
			call info.talk().showRange(9, 10, character)
		endmethod

		// Warum sollte ich?
		private static method infoActionWhyShouldI takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Warum sollte ich?", "Why should I?"), null)
			call speech(info, character, true, tre("Weil du dann die Chance bekommst, einen Erzengel zu töten. Überleg's dir einfach mal.", "Because you then get the chance to kill an archangel. Just think about it."), gg_snd_Baldar31)
			call info.talk().showStartPage(character)
		endmethod

		// Klar!
		private static method infoActionOfCourse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Klar!", "Of course!"), null)
			call speech(info, character, true, tre("So so, ein tapferer Mann. Ich gebe dir noch etwas Zeit und wenn du's dir überlegt hast, dann melde dich einfach nochmal bei mir. Ich kann jeden Krieger gerbauchen.", "Well, such a brave man. I'll give you some more time and if you have thought about it, then simply report to me again. I can use any warrior."), gg_snd_Baldar32)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.baldar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_gotOffer[i] = false
				set this.m_lastRewardScore[i] = 0
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoActionGreeting, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoConditionGotOfferAndIsNotActive, thistype.infoActionIWantToJoin, tre("Ich möchte der schwarzen Legion beitreten.", "I wish to join the Black Legion.")) // 1
			call this.addInfo(true, false, thistype.infoConditionIsActive, thistype.infoActionReward, tre("Gib mir meine Belohnung!", "Give me my reward!")) // 2
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhichArmy, tre("Welches Heer?", "Which army?")) // 3
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionBlackLegion, tre("Schwarze Legion?", "Black Legion?")) // 4
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyIsBrother, tre("Wieso ist dein Bruder ein Erzengel?", "Why is your brother an archangel?")) // 5
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyDoYouFight, tre("Wieso kämpft ihr gegeneinander?", "Why are you fighting each other?")) // 6
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhoIsStronger, tre("Wer ist denn der Stärkere von euch beiden?", "Who is the stronger of the two of you?")) // 7
			call this.addExitButton() // 8

			// sub info from infoActionWhoIsStronger
			call this.addInfo(false, false, 0, thistype.infoActionWhyShouldI, tre("Warum sollte ich?", "Why should I?")) // 9
			call this.addInfo(false, false, 0, thistype.infoActionOfCourse, tre("Klar!", "Of course!")) // 10

			return this
		endmethod
	endstruct

endlibrary