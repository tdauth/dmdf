library StructMapTalksTalkTrommon requires Asl, StructGameClasses, StructMapQuestsQuestWoodForTheHut

	struct TalkTrommon extends ATalk
		private static constant integer goldCost = 10
		private boolean array m_hasPaid[6] /// @todo @member MapData.maxPlayers
		private boolean array m_wasOffended[6] /// @todo @member MapData.maxPlayers

		implement Talk

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
			call this.showUntil(9, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo! Wer bist du und was treibt dich in diese Gegend?"), null)
			if (character.class() == Classes.cleric()) then
				call speech(info, character, false, tr("Der Glaube."), null)
				call speech(info, character, true, tr("Hmm, ein frommer Mann. Ich fühle mich geehrt auch wenn ich deinen Glauben wahrscheinlich nicht teile."), null)
			elseif (character.class() == Classes.necromancer()) then
				call speech(info, character, false, tr("Der Tod."), null)
				call speech(info, character, true, tr("Das sind aber finstere Worte mein Freund. Hier, nimm dir einen Apfel, dann geht’s dir schon viel besser."), null)
				/// @todo Charakter erhält einen Apfel
			elseif (character.class() == Classes.astralModifier()) then
				call speech(info, character, false, tr("Die Geister."), null)
				call speech(info, character, true, tr("Klingt beängstigend. Na ja, wer weiß schon, was sich hier in dieser Gegend so rumtreibt."), null)
			elseif (character.class() == Classes.knight()) then
				call speech(info, character, false, tr("Die Pflicht."), null)
				call speech(info, character, true, tr("So so, du bist also ein Pflichtbewusster. Na dazu sag' ich mal nichts."), null)
			elseif (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, false, tr("Das Gold."), null)
				call speech(info, character, true, tr("Gib lieber Acht mein Freund. Viele derer, die ich kannte hat die Gier ins Verderben getrieben. Wäre schade um dich."), null)
			elseif (character.class() == Classes.ranger()) then
				call speech(info, character, false, tr("Die Wildnis."), null)
				call speech(info, character, true, tr("Ja, das kann ich verstehen. Ich liebe auch die Natur. Deshalb bin ich auch hierher gezogen. Da, nimm dir einen Apfel."), null)
				/// @todo Charakter erhält einen Apfel
				call speech(info, character, true, tr("(Lachend) Ich fürchte, wir teilen das gleiche Schicksal."), null)
			elseif (character.class() == Classes.elementalMage()) then
				call speech(info, character, false, tr("Der Wille."), null)
				call speech(info, character, true, tr("Der Wille? Was gibt’s hier schon zu erreichen oder holen? Ich meine, mir gefällt’s hier, aber mit dieser Meinung gehöre ich zu einer kleinen Minderheit."), null)
			elseif (character.class() == Classes.illusionist()) then
				call speech(info, character, false, tr("Die Freiheit."), null)
				call speech(info, character, true, tr("Freiheit! Na ja, ich möchte deine Träume nicht zerstören, aber wirklich frei ist in dieser Zeit keiner. Selbst ich muss meinem Herzog dienen und ihm regelmäßig etwas von meinem Hab und Gut abgeben. (Lachend) Ist natürlich freiwillig."), null)
			elseif (character.class() == Classes.wizard()) then
				call speech(info, character, false, tr("Die Neugier."), null)
				call speech(info, character, true, tr("Ich bin vermutlich zu alt, um neugierig zu sein. Aber vielleicht bringt sie dich ja eines Tages weiter als mich. Trotzdem, ich will mich nicht beklagen. Mir geht’s doch eigentlich recht gut."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// ￼Ist das deine Fähre?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("￼Ist das deine Fähre?"), null)
			call speech(info, character, true, tr("￼Klar. Die hab ich selbst gebaut und der Holzfäller Kuno hat mir das Holz dafür beschafft. Na ja, er muss ja auch jeden Tag über den Fluss fahren."), null)
			call speech(info, character, true, tr("Natürlich fahre ich auch andere Leute gegen eine geringe Gebühr über den Fluss."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Ist das deine Fähre?“, Charakter hat noch nicht mit Kuno gesprochen)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character) and true /// @todo Hat noch nicht mit Kuno gesprochen
		endmethod

		// Wer ist Kuno?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer ist Kuno?"), null)
			call speech(info, character, true, tr("Ach, das ist ein Holzfäller und alter Freund von mir. Ich fahr ihn jeden Tag mit meiner Fähre zweimal über den Fluss. Hin und zurück. Er hat seine Hütte am anderen Flussufer und transportiert sein Holz mit Hilfe meiner Fähre auf meine Seite, um es dann bei den Bauern zu verkaufen."), null)
			call speech(info, character, true, tr("Du kannst ja mal mit ihm sprechen. Eine Überfahrt kostet nicht die Welt."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Ist das deine Fähre?“)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Was kostet eine Überfahrt?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was kostet eine Überfahrt?"), null)
			call speech(info, character, true, tr("Pro Person 20 Goldmünzen. Ich fahre täglich um 12:00 und um 19:00 Uhr über den Fluss. Das sind praktisch Kunos Standardzeiten."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Was kostet eine Überfahrt?“, Charakter hat keine Überfahrt bezahlt)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(3, character) and not thistype(info.talk()).hasPaid(character.player())
		endmethod

		// Fahr mich ans andere Flussufer. (Kostet 20 Goldmünzen)
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Fahr mich ans andere Flussufer."), null)
			if (character.gold() < thistype.goldCost) then
				call speech(info, character, true, tr("Willst du mich verarschen? Besorg dir erstmal ein paar Goldmünzen, dann sehen wir weiter."), null)
				call info.talk().showStartPage(character)
				return
			elseif (GetTimeOfDay() > 19.00) then // (Nach 19:00 Uhr, aber noch nicht der nächste Tag)
				call speech(info, character, true, tr("Mach ich gerne, aber erst morgen."), null)
			elseif (GetTimeOfDay() < 12.00) then // (Vor 12:00 Uhr)
				call speech(info, character, true, tr("Mach ich. Geht um 12:00 Uhr los."), null)
			elseif (GetTimeOfDay() > 12.00 and GetTimeOfDay() < 19.00) then // (Nach 12:00 und vor 19:00 Uhr)
				call speech(info, character, true, tr("Mach ich. Geht um 19:00 Uhr los."), null)
			endif
			// gold
			call character.removeGold(thistype.goldCost)
			call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("%i Goldmünzen bezahlt."), thistype.goldCost))
			call thistype(info.talk()).pay(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Deine Hütte sieht aber nicht grade stabil aus.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine Hütte sieht aber nicht grade stabil aus."), null)
			call speech(info, character, true, tr("Ja, ich weiß. Sie ist wohl im Laufe der Zeit etwas kaputt gegangen. Na ja, ich hab mir auch nicht gerade viel Mühe bei ihrem Bau gegeben."), null)
			call speech(info, character, true, tr("Da fällt mir ein, hättest du nicht vielleicht Lust meinen alten Freund Kuno um etwas Holz zu bitten, das er mir nächstes Mal, wenn er über den Fluss fährt, mitbringt."), null)
			call speech(info, character, false, tr("Wieso machst du das nicht selbst?"), null)
			call speech(info, character, true, tr("Gut, er ist zwar ein alter Freund von mir, aber was seinen Beruf angeht, da hab ich mich wohl ab und zu etwas zu sehr drüber lustig gemacht. War ja nicht böse gemeint, aber er war natürlich wieder total verärgert und jetzt hab ich wirklich keine Lust ihn darum zu bitten."), null)
			call speech(info, character, true, tr("Du würdest natürlich auch was dafür kriegen."), null)
			call info.talk().showRange(10, 12, character)
		endmethod

		// (Nach „Deine Hütte sieht aber nicht grade stabil aus.“, Auftrag „Holz für die Hütte“ wurde noch nicht erhalten)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(5, character) and QuestWoodForTheHut.characterQuest(character).isNotUsed()
		endmethod

		// Ich hab's mir überlegt. Ich besorg dir dein Holz.
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich hab's mir überlegt. Ich besorg dir dein Holz. "), null)
			if (thistype(info.talk()).wasOffended(character.player())) then
				call speech(info, character, true, tr("So so, ein wenig Gier steckt also doch in jedem von uns. Na ja, mir soll's recht sein."), null)
			else
				call speech(info, character, true, tr("Danke Mann. Du tust mir damit einen wirklich großen Gefallen."), null)
			endif
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“, Trommon befindet sich in seinem Gemüsegarten)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_trommons_vegetable_garden, gg_unit_n021_0004)
		endmethod

		// Einen hübschen Gemüsegarten hast du da.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Einen hübschen Gemüsegarten hast du da."), null)
			call speech(info, character, true, tr("Findest du wirklich? Das freut mich aber. Vielleicht möchtest du ja etwas von meinem Gemüse kaufen. Zur Zeit kann ich wieder mehr ernten als ich für mich selbst brauche."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Holz für die Hütte“ ist aktiv, Charakter hat mit Kuno gesprochen)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			return QuestWoodForTheHut.characterQuest(character).isNew() and  QuestWoodForTheHut.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Kuno besorgt dir ein paar Bretter.
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kuno besorgt dir ein paar Bretter."), null)
			call speech(info, character, true, tr("Wirklich? Ich danke dir. Hier hast du ein paar Salatköpfe aus meinem Gemüsegarten und natürlich auch ein paar Goldmünzen."), null)
			call QuestWoodForTheHut.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Kein Problem, mach ich.
		private static method infoAction5_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kein Problem, mach ich."), null)
			call speech(info, character, true, tr("Danke Mann. Du tust mir damit einen wirklich großen Gefallen."), null)
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Du kannst mich mal! Mein Vater, dessen Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.
		private static method infoAction5_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du kannst mich mal! Mein Vater, dessen Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig."), null)
			call speech(info, character, true, tr("Verdammt Mann, krieg dich wieder ein! War ja nicht böse gemeint, dann halt nicht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Ich überleg's mir mal.
		private static method infoAction5_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich überleg's mir mal."), null)
			call speech(info, character, true, tr("In Ordnnug."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n021_0004, thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_hasPaid[i] = false
				set this.m_wasOffended[i] = false
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("￼Ist das deine Fähre?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Wer ist Kuno?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Was kostet eine Überfahrt?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Fahr mich ans andere Flussufer (Kostet 20 Goldmünzen).")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Deine Hütte sieht aber nicht grade stabil aus.")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Ich hab's mir überlegt. Ich besorg dir dein Holz.")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Einen hübschen Gemüsegarten hast du da.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Kuno besorgt dir ein paar Bretter. ")) // 8
			call this.addExitButton() // 9

			// page 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tr("Kein Problem, mach ich.")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tr("Du kannst mich mal! Mein Vater, dessen Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction5_2, tr("Ich überleg's mir mal.")) // 12

			return this
		endmethod
	endstruct

endlibrary