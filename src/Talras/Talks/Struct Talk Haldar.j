library StructMapTalksTalkHaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToBlackLegion

	struct TalkHaldar extends ATalk
		private boolean array m_gotOffer[6] /// \todo \ref MapData.maxPlayers
		private integer array m_lastRewardScore[6] /// \todo \ref MapData#maxPlayers

		implement Talk

		public method giveOffer takes nothing returns nothing
			local player user = this.character().player()
			set this.m_gotOffer[GetPlayerId(user)] = true
			set user = null
		endmethod

		/// Parameter is required since it's used by \ref TalkBaldar.
		public method gotOffer takes Character character returns boolean
			local player user = character.player()
			local boolean result = this.m_gotOffer[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			call this.showUntil(3)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Wer bist du und was machst du in meinem Lager?"), null)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkBaldar.talk.evaluate().infoHasBeenShownToCharacter(0, info.talk().character())) then
				call speech(info, false, tr("Dein Lager?"), null)
				call speech(info, true, tr("Ja, mein Lager!"), null)
				call speech(info, true, tr("Dies ist das Lager der weißen Legion, meines Heers."), null)
				call info.talk().showRange(4, 5)
			// (Charakter hat bereits Baldar getroffen)
			else
				call speech(info, false, tr("Bist du Baldars Bruder?"), null)
				call speech(info, true, tr("Woher weißt du das?"), null)
				call speech(info, false, tr("Hab mit ihm gesprochen."), null)
				call speech(info, true, tr("Ich hoffe nur, er hat dir keinen Wurm ins Ohr gesetzt. Seine Wut und Dummheit kennen keine Grenzen!"), null)
				call speech(info, false, tr("Ganz ruhig, Flügelmann."), null)
				call speech(info, true, tr("Weißt du eigentlich wen du vor dir hast? Ich bin Haldar, der mächtige Erzengel aus …"), null)
				call speech(info, false, tr("… einem Kartoffelsack."), null)
				call speech(info, true, tr("Schweig, du Hund!"), null)
				// (Auftrag „Tod der weißen Legion“ nicht aktiv)
				if (QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNotUsed()) then
					call speech(info, true, tr("Bevor mein dummer Bruder noch auf die Idee kommen sollte, dich anzuwerben, tue ich das lieber."), null)
					call speech(info, true, tr("Also hast du nicht zufällig Lust, meinem Heer beizutreten, damit ich diesem Kampf hier ein schnelleres Ende bereiten kann?"), null)
					call speech(info, false, tr("Ich überleg's mir."), null)
					call speech(info, true, tr("Gut, lass dir ruhig Zeit. Er wird mich sowieso nicht besiegen können."), null)
					call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
				endif
				call info.talk().showStartPage()
			endif
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
		private static method infoCondition1 takes AInfo info returns boolean
			return thistype(info.talk()).gotOffer(info.talk().character()) and QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNotUsed()
		endmethod

		// Ich möchte der weißen Legion beitreten.
		private static method infoAction1 takes AInfo info returns nothing
			local unit characterUnit = info.talk().character().unit()
			local item whichItem
			call speech(info, false, tr("Ich möchte der weißen Legion beitreten."), null)
			call speech(info, true, tr("Du hast es dir also nochmal gründlich überlegt."), null)
			call speech(info, true, tr("Gut, zunächst einmal bekommst du diese Standarte hier. Es ist mein weißes Wappen. Und damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Weihwasser, auch wenn ich Leute eher ungern für Bezahlung kämpfen lasse. Aber was tut man nicht alles im Krieg."), null)
			call speech(info, true, tr("Gut, ich erkläre dir mal, wie das hier läuft, auf dem „Schlachtfeld“. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf jedem dieser Wege schicken mein Bruder und ich Truppen gegeneinander los. Du kannst dir aussuchen, auf welchem der Wege du kämpfen möchtest. Das ist mir eigentlich egal, solange du kämpfst."), null)
			call speech(info, true, tr("Da gibt’s nur ein kleines Problem. Mein Bruder und ich haben damals, als wir mit dem Kampf begonnen haben, ausgemacht, dass keiner außer uns beiden sich in den Streit einmischen darf. Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als Einmischung."), null)
			call speech(info, true, tr("Du dagegen würdest gegen die Regeln verstoßen. Ich halte zwar viel von Regeln, aber hier mache selbst ich mal eine Ausnahme, um den Streit zu beenden."), null)
			call speech(info, false, tr("Also, was soll ich tun?"), null)
			call speech(info, true, tr("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Engels verwandelt."), null)
			call speech(info, false, tr("Aha."), null)
			call speech(info, true, tr("Keine Angst, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln."), null)
			call speech(info, true, tr("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!"), null)
			call speech(info, true, tr("Ach so und noch etwas: Hast du genügend Feinde getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst."), null)
			/// TODO andere Standarte!
			call Character(info.talk().character()).giveQuestItem('I01B') // Standarte
			// Ring
			if (info.talk().character().class() == Classes.astralModifier()) then
				call Character(info.talk().character()).giveQuestItem('I015')
			/// TODO Add item types
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call Character(info.talk().character()).giveQuestItem('I015')
			endif
			call QuestDeathToBlackLegion.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der schwarzen Legion“ ist aktiv)
		private static method infoCondition2 takes AInfo info returns boolean
			return QuestDeathToBlackLegion.characterQuest(info.talk().character()).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoAction2 takes AInfo info returns nothing
			local integer newScore = Aos.playerScore(info.talk().character().player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())]
			local integer i
			call speech(info, false, tr("Gib mir meine Belohnung!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, true, tr("Gut, hier hast du sie. Mach nur weiter so und wir werden diesen Streit bald beendet haben!"), null)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).displayUpdateMessage(tr("Belohnung:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, true, tr("Ein paar mehr solltest du aber schon getötet haben. Es heißt ja nicht umsonst Belohnung."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// Welches Heer?
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Welches Heer?"), null)
			call speech(info, true, tr("Sieh dich um! Dies ist mein Heer. Ich habe diese Krieger geschaffen, um meinen Bruder Baldar zur Vernunft zu bringen."), null)
			if (info.talk().showInfo(5)) then
				call info.talk().show()
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Weiße Legion?
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Weiße Legion?"), null)
			call speech(info, true, tr("Ja. So nennen wir uns, also mein Gefolge und ich. Wir kämpfen hier schon seit vielen Jahren gegen die schwarze Legion. Sie wird von meinem etwas dümmlichen und aggressiven Bruder Baldar angeführt, einem Erzdämon."), null)
			call info.talk().showRange(6, 8)
		endmethod

		// (Zurück)
		private static method infoAction0_2 takes AInfo info returns nothing
			call info.talk().showStartPage()
		endmethod

		// Wieso ist dein Bruder ein Erzdämon?
		private static method infoAction0_1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso ist dein Bruder ein Erzdämon?"), null)
			call speech(info, true, tr("Wieso sollte er es nicht sein, dieser Idiot?"), null)
			call speech(info, false, tr("Geburtsfehler und so ..."), null)
			call speech(info, true, tr("Sehr lustig. Unsere Familiengeschichte geht dich nichts an, Sterblicher!"), null)
			call info.talk().showRange(7, 8)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoAction0_1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso kämpft ihr gegeneinander?"), null)
			call speech(info, true, tr("Was weiß ich? Frag doch meinen Bruder, der fängt immer mit den Streitereien an."), null)
			call info.talk().showInfo(6)
			call info.talk().showInfo(8)
			call info.talk().show()
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoAction0_1_2 takes AInfo info returns nothing
			call speech(info, false, tr("Wer ist denn der Stärkere von euch beiden?"), null)
			call speech(info, true, tr("(Lacht) Mein Bruder würde dir jetzt vermutlich antworten, dass er der Stärkere ist und das doch selbstverständlich wäre."), null)
			call speech(info, true, tr("Er war schon immer schwächer, aber das Ganze zieht sich jetzt schon recht lange hin und ich möchte dem ein Ende bereiten. Also hättest du vielleicht Lust mir zu helfen?"), null)
			call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
			call info.talk().showRange(9, 10)
		endmethod

		// (Zurück)
		private static method infoAction0_1_3 takes AInfo info returns nothing
			if (info.talk().showInfo(4)) then
				call info.talk().show()
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Warum sollte ich?
		private static method infoAction0_1_2_0 takes AInfo info returns nothing
			call speech(info, false, tr("Warum sollte ich?"), null)
			call speech(info, true, tr("Weil du dann die Chance bekommst, die böse Brut, die er geschaffen hat ins Jenseits zu befördern. Überleg's dir einfach mal."), null)
			call info.talk().showRange(6, 7)
		endmethod

		// Klar!
		private static method infoAction0_1_2_1 takes AInfo info returns nothing
			call speech(info, false, tr("Klar!"), null)
			call speech(info, true, tr("Ein kriegswilliger Mann also. Ich hoffe, dahinter steckt eine gute Absicht und gebe dir noch etwas Zeit. Wenn du's dir überlegt hast, dann melde dich einfach nochmal bei mir."), null)
			call info.talk().showRange(6, 7)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.haldar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_gotOffer[i] = false
				set this.m_lastRewardScore[i] = 0
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) //0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Ich möchte der weißen Legion beitreten.")) //1
			call this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tr("Gib mir meine Belohnung!")) //2
			call this.addExitButton() //3

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Welches Heer?")) //4
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Weiße Legion?")) //5
			// no back button since you have to talk about this!

			// info 0_1
			call this.addInfo(false, false, 0, thistype.infoAction0_1_0, tr("Wieso ist dein Bruder ein Erzdämon?")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1_1, tr("Wieso kämpft ihr gegeneinander?")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2, tr("Wer ist denn der Stärkere von euch beiden?")) // 8
			// no back button since you have to talk about this!

			// info 0_1_1
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2_0, tr("Warum sollte ich?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2_1, tr("Klar!")) // 10

			return this
		endmethod
	endstruct

endlibrary