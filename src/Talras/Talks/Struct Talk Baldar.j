library StructMapTalksTalkBaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToWhiteLegion

	struct TalkBaldar extends Talk
		private boolean array m_gotOffer[6] /// \todo \ref MapData#maxPlayers
		private integer array m_lastRewardScore[6] /// \todo \ref MapData#maxPlayers

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
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Wer bist du und was machst du in meinem Lager?"), null)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkHaldar.talk.evaluate().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tr("Dein Lager?"), null)
				call speech(info, character, true, tr("Ja, mein Lager!"), null)
				call speech(info, character, true, tr("Das ist das Lager der schwarzen Legion, meines Heers."), null)
			// (Charakter hat bereits Haldar getroffen)
			else
				call speech(info, character, false, tr("Bist du Haldars Bruder?"), null)
				call speech(info, character, true, tr("Woher weißt du das?"), null)
				call speech(info, character, false, tr("Hab mit ihm gesprochen."), null)
				call speech(info, character, true, tr("Du wagst es, mit diesem Feigling zu sprechen? Wie kannst du dir das nur antun?"), null)
				call speech(info, character, false, tr("Ganz ruhig, Flügelmann."), null)
				call speech(info, character, true, tr("Weißt du eigentlich wen du vor dir hast? Ich bin Baldar, der mächtige Erzdämon aus …"), null)
				call speech(info, character, false, tr("… einem Kartoffelsack."), null)
				call speech(info, character, true, tr("Schweig, du Hund!"), null)
				// (Auftrag „Tod der schwarzen Legion“ nicht aktiv)
				if (QuestDeathToBlackLegion.characterQuest(character).isNotUsed()) then
					call speech(info, character, true, tr("Wenn du schon so eine spitze Zunge hast, dann verwende sie wenigstens gegen meinen Bruder!"), null)
					call speech(info, character, true, tr("Tritt meinem Heer bei und bekämpfe ihn und seinesgleichen!"), null)
					call speech(info, character, false, tr("Ich überleg's mir."), null)
					call speech(info, character, true, tr("Gut, aber nicht zu lange will ich hoffen."), null)
					call speech(info, character, false, tr("Gut Ding will Weile haben."), null)
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
			call speech(info, character, false, tr("Ich möchte der schwarzen Legion beitreten."), null)
			call speech(info, character, true, tr("Du hast es dir also nochmal gründlich überlegt, was?"), null)
			call speech(info, character, true, tr("Gut, zunächst einmal bekommst du diese Standarte hier. Es ist mein schwarzes Wappen, nicht so hässlich wie das weiße meines Bruders. Und damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Schwefel."), null)
			call speech(info, character, true, tr("So, jetzt erkläre ich dir mal, wie das hier läuft, auf dem „Schlachtfeld“. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf jedem dieser Wege schicken mein Bruder und ich Truppen gegeneinander los. Du kannst dir aussuchen, auf welchem der Wege du kämpfen möchtest. Das ist mir ziemlich egal, Hauptsache du kämpfst."), null)
			call speech(info, character, true, tr("Da gibt's nur ein kleines Problem. Mein Bruder und ich haben damals, als wir mit dem Kampf begonnen haben, ausgemacht, dass keiner außer uns beiden sich in den Streit einmischen darf. Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als Einmischung."), null)
			call speech(info, character, true, tr("Du dagegen würdest gegen die Regeln verstoßen. Nicht, dass ich viel für Regeln übrig hätte, aber ich will nicht, dass mich mein verdammter Bruder einen Feigling nennt."), null)
			call speech(info, character, false, tr("Also, was soll ich tun?"), null)
			call speech(info, character, true, tr("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Dämons verwandelt."), null)
			call speech(info, character, false, tr("Aha."), null)
			call speech(info, character, true, tr("Keine Angst, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln."), null)
			call speech(info, character, true, tr("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!"), null)
			call speech(info, character, true, tr("Ach so und noch etwas: Hast du genügend Krieger getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst."), null)
			call Character(character).giveQuestItem('I01B') // Standarte
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
			call speech(info, character, false, tr("Gib mir meine Belohnung!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, character, true, tr("Gut, hier hast du sie. Mach nur weiter so und wir werden meinen Bruder bald besiegt haben!"), null)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(character).displayUpdateMessage(tr("Belohnung:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(character).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, character, true, tr("Pah, töte erst mal mehr von seinen Leuten dann sehen wir weiter."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Welches Heer?
		private static method infoActionWhichArmy takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Welches Heer?"), null)
			call speech(info, character, true, tr("Bist du etwa blind? Schau dich doch mal um! Siehst du nicht die vielen Krieger? Sie alle dienen mir, um diesen Bastard Haldar zu vernichten!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Schwarze Legion?
		private static method infoActionBlackLegion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Schwarze Legion?"), null)
			call speech(info, character, true, tr("Ja. So nennen wir uns, also mein Gefolge und ich. Wir kämpfen hier schon seit vielen Jahren gegen die weiße Legion. Sie wird von meinem widerlichen Bruder Haldar angeführt, einem Erzengel."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Schwarze Legion?“)
		private static method infoConditionAfterBlackLegion takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(4, character)
		endmethod

		// Wieso ist dein Bruder ein Erzengel?
		private static method infoActionWhyIsBrother takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso ist dein Bruder ein Erzengel?"), null)
			call speech(info, character, true, tr("Wieso sollte er es nicht sein, dieser Schweinehund?"), null)
			call speech(info, character, false, tr("Inzucht und so ..."), null)
			call speech(info, character, true, tr("Was sagst du? Sprich gefälligst lauter, wenn du mir was zu sagen hast."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoActionWhyDoYouFight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso kämpft ihr gegeneinander?"), null)
			call speech(info, character, true, tr("Spielt das eine Rolle für dich? Wieso fragst du überhaupt?"), null)
			call speech(info, character, false, tr("Reine Neugier."), null)
			call speech(info, character, true, tr("Hmm, na ja, also ehrlich gesagt, ich weiß es gar nicht mehr so genau. Aber das ändert nichts daran, dass mein Bruder ein mieser Lügner und Verräter ist und ich ihn vernichten werde!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoActionWhoIsStronger takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer ist denn der Stärkere von euch beiden?"), null)
			call speech(info, character, true, tr("Ich natürlich. Versteht sich doch von selbst, dass ein Erzdämon stärker als ein Erzengel ist!"), null)
			call speech(info, character, true, tr("Wobei ich noch etwas Unterstützung gebrauchen könnte. Immerhin kämpfen wir nun schon so lange gegeneinander und keiner von uns beiden kann gewinnen. Schätze mal, er hat einfach zu viele Truppen um sich geschart, dieser feige Hund!"), null)
			call speech(info, character, true, tr("Du hättest nicht zufällig Lust, in mein Heer einzutreten?"), null)
			call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
			call info.talk().showRange(9, 10, character)
		endmethod

		// Warum sollte ich?
		private static method infoActionWhyShouldI takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Warum sollte ich?"), null)
			call speech(info, character, true, tr("Weil du dann die Chance bekommst, einen Erzengel zu töten. Überleg's dir einfach mal."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Klar!
		private static method infoActionOfCourse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Klar!"), null)
			call speech(info, character, true, tr("So so, ein tapferer Mann. Ich gebe dir noch etwas Zeit und wenn du's dir überlegt hast, dann melde dich einfach nochmal bei mir. Ich kann jeden Krieger gerbauchen."), null)
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
			call this.addInfo(false, false, 0, thistype.infoActionGreeting, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoConditionGotOfferAndIsNotActive, thistype.infoActionIWantToJoin, tr("Ich möchte der schwarzen Legion beitreten.")) // 1
			call this.addInfo(true, false, thistype.infoConditionIsActive, thistype.infoActionReward, tr("Gib mir meine Belohnung!")) // 2
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhichArmy, tr("Welches Heer?")) // 3
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionBlackLegion, tr("Schwarze Legion?")) // 4
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyIsBrother, tr("Wieso ist dein Bruder ein Erzengel?")) // 5
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyDoYouFight, tr("Wieso kämpft ihr gegeneinander?")) // 6
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhoIsStronger, tr("Wer ist denn der Stärkere von euch beiden?")) // 7
			call this.addExitButton() // 8

			// sub info from infoActionWhoIsStronger
			call this.addInfo(false, false, 0, thistype.infoActionWhyShouldI, tr("Warum sollte ich?")) // 9
			call this.addInfo(false, false, 0, thistype.infoActionOfCourse, tr("Klar!")) // 10

			return this
		endmethod
	endstruct

endlibrary