library StructMapTalksTalkSisgard requires Asl, StructGameCharacter, StructGameClasses, StructMapMapFellows, StructMapQuestsQuestTheMagic

	struct TalkSisgard extends ATalk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Bist du vielleicht an einigen Zaubern oder Tränken interessiert?"), null)
			call info.talk().showRange(9, 10, character)
		endmethod

		private static method infoConditionGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Ist das dein Haus?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ist das dein Haus?"), null)
			call speech(info, character, true, tr("Ja, ich habe es für einen guten Preis erworben. Ich lies mich hier nieder nachdem mein Meister vor einigen Jahren mit mir nach Talras ging und bald darauf starb."), null)
			call speech(info, character, true, tr("Er war schon sehr alt und diese Gegend hier war seine Heimat. Er erinnerte sich sogar an die Zeit als hier noch keine Burg stand."), null)
			call info.talk().showRange(11, 12, character)
		endmethod

		// Du bist wohl eine Zauberin?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du bist wohl eine Zauberin?"), null)
			if (character.class() == Classes.wizard()) then
				call speech(info, character, true, tr("Und du bist wohl ein Zauberer. Freut mich dich kennenzulernen. Hier trifft man nicht oft andere Zauberer."), null)
				call speech(info, character, true, tr("Pass auf, ich schenke dir einige Zauberspruchrollen."), null)
				/// @todo Charakter erhält Zauberspruchrollen
			elseif (character.class() == Classes.illusionist() or character.class() == Classes.elementalMage()) then
				call speech(info, character, true, tr("Na ja, die Kunst der Magie dürfte wohl auch dir vertraut sein."), null)
				call speech(info, character, true, tr("Aber ja, ich bin eine Zauberin. Ich vermag es meine Zauberkraft und die der anderen zu beherrschen."), null)
			else
				call speech(info, character, true, tr("Ja, ich bin eine Zauberin. Deshalb verkaufe ich ja auch Zauber und Tränke. Alles was das Magier- oder Zaubererherz begehrt."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat sich das Gelaber über ihren Meister angehört)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(11, character)
		endmethod

		// Zieh mit mir in den Kampf!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Zieh mit mir in den Kampf!"), null)
			call speech(info, character, true, tr("Ich soll mit dir in den Kampf ziehen? Hmm, so wie damals mit meinem Meister. Das waren noch Zeiten ..."), null)
			call speech(info, character, true, tr("Beherrscht du denn auch die Zauberkunst?"), null)
			call speech(info, character, false, tr("Sicher."), null)
			call speech(info, character, true, tr("Beweise es mir! In der Nähe gibt es einen Wald, wir nennen ihn den Dunkelwald. In diesem Wald stehen einige Runensteine, die dort vor einer Ewigkeit errichtet wurden. Mein Meister sprach von einer außergewöhnlichen Aura, welche diese Steine umgibt."), null)
			call speech(info, character, true, tr("Er gab mir vor seinem Tod einige Zauberspruchrollen, mit welchen es mir möglich sein sollte, jene Aura zu nutzen. Nimm eine dieser Zauberspruchrollen, geh zu den Runensteinen und probier aus, was passiert, dann komm wieder und berichte mir davon."), null)
			call info.talk().showRange(13, 14, character)
		endmethod

		// (Charakter hat die Zauberspruchrolle bei den Runensteinen benutzt)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Ich war bei den Runensteinen.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich war bei den Runensteinen."), null)
			call speech(info, character, true, tr("Und, was ist passiert?"), null)
			call info.talk().showRange(15, 16, character)
		endmethod

		// (Auftrag „Die Zauberkunst“ abgeschlossen)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			debug if (Fellows.sisgard().isShared()) then
				debug call Print("Is shared.")
			debug endif
			return QuestTheMagic.characterQuest(character).isCompleted() and not Fellows.sisgard().isShared()
		endmethod

		/*
		private method resetHer takes nothing returns nothing
			local player oldOwner
			call SetUnitInvulnerable(this.unit(), true)
			call PauseUnit(this.unit(), true)
			call SetUnitLifePercentBJ(this.unit(), 100.0)
			call TriggerSleepAction(1.0)
			call SetUnitAnimation(this.unit(), "Spell")
			call TriggerSleepAction(1.0)
			call SetUnitX(this.unit(), GetRectCenterX(gg_rct_waypoint_sisgard_0))
			call SetUnitY(this.unit(), GetRectCenterY(gg_rct_waypoint_sisgard_0))
			call SetUnitFacing(this.unit(), 211.35)
			call ResetUnitAnimation(this.unit())
			set oldOwner = Player(PLAYER_NEUTRAL_PASSIVE)
			call SetUnitOwner(this.unit(), oldOwner, true)
			set oldOwner = null
			call PauseUnit(this.unit(), false)
			call ARoutine.enableForUnitInAll(this.unit())
			call TalkSisgard.talk().setFollowsCharacter(0)
		endmethod
		*/

		// Gehen wir.
		private static method infoAction5 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Gehen wir."), null)
			// (Unterhält sich noch mit anderen Charakteren)
			if (info.talk().characters().size() > 1) then
				call speech(info, character, true, tr("Ich unterhalte mich gerade noch. Danach kann ich dir folgen."), null)
				call info.talk().showStartPage(character)
			// (Unterhält sich nur mit dem aktuellen Charakter)
			else
				call speech(info, character, true, tr("Na wenn du mich so nett bittest. Kann's gar nicht erwarten. Geh voraus, ich folge dir."), null)
				call info.talk().close(character)
				call Fellows.sisgard().shareWith(character)
				call IssueTargetOrder(info.talk().unit(), "move", character.unit())
			endif
		endmethod

		// (Folgt dem Charakter)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() == character
		endmethod

		// Ich komm alleine klar.
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich komm alleine klar."), null)
			call speech(info, character, true, tr("Gut, du weißt ja, wo du mich findest."), null)
			call info.talk().close(character)
			call Fellows.sisgard().reset()
		endmethod

		// (Folgt einem Charakter und wird von einem anderen angesprochen)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() != character
		endmethod

		// Ich hab zu tun.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Ich hab zu tun."), null)
			call info.talk().close(character)
		endmethod

		// Wieso nicht?
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso nicht?"), null)
			call speech(info, character, true, tr("Oh, das freut mich aber. In diesen schweren Zeiten trifft man nur noch selten Kauffreudige."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Schade, na ja, vielleicht überlegst du dir's ja noch."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Erzähl mir mehr.
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir mehr."), null)
			call speech(info, character, true, tr("So, dich interessiert das also? Hmm, die meisten Leute würgen mich irgendwann ab, wenn ich mal wieder das Schwärmen von alten Zeiten anfange."), null)
			call speech(info, character, true, tr("Mein Meister war ein großer Zauberer und sein Wissen war so umfassend, dass er selbst bei den Magiern der Hochelfen, welche sich eher mit den Elementen als mit der magischen Kraft und deren Beherrschung beschäftigen, ein hohes Ansehen genoss."), null)
			call speech(info, character, true, tr("Das erste Mal traf ich ihn im Kloster eines Klerikerordens, in welches mich meine Eltern geschickt hatten. Leider ist das oft die einzige Möglichkeit an Bildung ranzukommen und auch wenn sie es gut meinten, dieses ganze Beten und Huldigen war todlangweilig."), null)
			call speech(info, character, true, tr("Mein Meister war also auf der Durchreise und suchte einen Ort zum Übernachten. Ich war neugierig und fragte ihn über alles aus und da er schon lange keinen Schüler mehr gehabt hatte, bot ich  mich ihm als solchen an."), null)
			call speech(info, character, true, tr("Schließlich willigte er gegen meine Erwartungen ein und von diesem Zeitpunkt an war ich eine Schülerin der Zauberkunst."), null)
			call speech(info, character, true, tr("Er hat mich vieles gelehrt und ihm verdanke ich so ziemlich alles, was ich heute bin. Er nahm mich mit ins Königreich der Hochelfen und Zwerge und selbst durch die Gebirge der Orks zogen wir. Wir trotzten allen Gefahren ..."), null)
			call speech(info, character, true, tr("Doch was rede ich da. Das ist längst Vergangenheit und nun bin ich nicht mehr als eine einfache Händlerin, die ihre verbliebene Zeit weiterhin für die Studien der Zauberkünste nutzt."), null)
			call speech(info, character, true, tr("Ich wünschte, ich könnte erneut losziehen, wie damals und gemeinsam mit Gleichgesinnten Abenteuer erleben und allen Feinden trotzen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Ja ja, schon gut. Er war bestimmt großartig.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ja ja, schon gut. Er war bestimmt großartig."), null)
			call speech(info, character, true, tr("Langweile ich dich etwa schon? Schade, ich dachte, ich hätte endlich mal jemanden getroffen, der sich für meine Geschichten interessiert."), null)
			call info.talk().showStartPage(character)
		endmethod

		// In Ordnung.
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			local item questItem
			call speech(info, character, false, tr("In Ordnung."), null)
			call speech(info, character, true, tr("Gut, hier hast du die Zauberspruchrolle."), null)
			call QuestTheMagic.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Geh doch selbst!
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Geh doch selbst!"), null)
			call speech(info, character, true, tr("Wie du willst. Dann eben nicht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Ich spürte, wie die magischen Kräfte mich durchflossen.
		private static method infoAction4_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich spürte, wie die magischen Kräfte mich durchflossen."), null)
			call speech(info, character, true, tr("Hmm, dann solltest du mal einen Heiler aufsuchen."), null)
			call speech(info, character, true, tr("Tut mir leid, aber ich habe dich belogen, um zu sehen, ob du eine ehrliche Haut bist. Mit unehrlichen Leuten werde ich sicherlich nicht gemeinsam umher ziehen."), null)
			call QuestTheMagic.characterQuest(character).fail()
			call info.talk().showStartPage(character)
		endmethod

		// Gar nichts.
		private static method infoAction4_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Gar nichts."), null)
			call speech(info, character, true, tr("Ich hatte nichts anderes erwartet. Das war nur ein Test, um zu sehen, ob du eine ehrliche Haut bist."), null)
			call speech(info, character, true, tr("Von mir aus können wir jederzeit gemeinsam losziehen."), null)
			call QuestTheMagic.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01B_0144, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoAction1, tr("Ist das dein Haus?")) // 1
			call this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoAction2, tr("Du bist wohl eine Zauberin?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Zieh mit mir in den Kampf!")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Ich war bei den Runensteinen.")) // 4
			call this.addInfo(true, false, thistype.infoCondition5, thistype.infoAction5, tr("Gehen wir.")) // 5
			call this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tr("Ich komm alleine klar.")) // 6
			call this.addInfo(true, true, thistype.infoCondition7, thistype.infoAction7, null) // 7
			call this.addExitButton() // 8

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Wieso nicht?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein")) // 10

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Erzähl mir mehr.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Ja ja, schon gut. Er war bestimmt großartig.")) // 12

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tr("In Ordnung.")) // 13
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tr("Geh doch selbst!")) // 14

			// info 4
			call this.addInfo(false, false, 0, thistype.infoAction4_0, tr("Ich spürte, wie die magischen Kräfte mich durchflossen.")) // 15
			call this.addInfo(false, false, 0, thistype.infoAction4_1, tr("Gar nichts.")) // 16

			return this
		endmethod
	endstruct

endlibrary