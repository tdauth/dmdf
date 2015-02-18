library StructMapTalksTalkSisgard requires Asl, StructGameCharacter, StructGameClasses, StructMapMapNpcs, StructMapMapFellows, StructMapQuestsQuestTheMagic, StructMapQuestsQuestTheMagicalShield, StructMapQuestsQuestTheGhostOfTheMaster

	struct TalkSisgard extends ATalk
		private static AInfo m_hi
		private static AInfo m_hi_whyNot
		private static AInfo m_hi_no
		private static AInfo m_yourHouse
		private static AInfo m_whatDoYouSell
		private static AInfo m_aboutYourMaster
		private static AInfo m_youAreAWizard
		private static AInfo m_comeWithMe
		private static AInfo m_beenAtTheRunes
		private static AInfo m_beenAtTheRunes_magic
		private static AInfo m_beenAtTheRunes_nothing
		private static AInfo m_makeGood
		private static AInfo m_triedTheShield
		private static AInfo m_moreHelp
		private static AInfo m_metYourMaster
		private static AInfo m_letsGo
		private static AInfo m_onMyOwn
		private static AInfo m_busy
		private static AInfo m_exit

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call thistype.m_hi.show(character)
			call thistype.m_yourHouse.show(character)
			call thistype.m_whatDoYouSell.show(character)
			call thistype.m_aboutYourMaster.show(character)
			call thistype.m_youAreAWizard.show(character)
			call thistype.m_comeWithMe.show(character)
			call thistype.m_beenAtTheRunes.show(character)
			call thistype.m_makeGood.show(character)
			call thistype.m_triedTheShield.show(character)
			call thistype.m_moreHelp.show(character)
			call thistype.m_metYourMaster.show(character)
			call thistype.m_letsGo.show(character)
			call thistype.m_onMyOwn.show(character)
			call thistype.m_busy.show(character)
			call thistype.m_exit.show(character)
			call this.show(character.player())
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Bist du vielleicht an einigen Zaubern oder Tränken interessiert?"), null)
			call info.talk().showRange(thistype.m_hi_whyNot.index(), thistype.m_hi_no.index(), character)
		endmethod
		
		// Wieso nicht?
		private static method infoActionHi_WhyNot takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso nicht?"), null)
			call speech(info, character, true, tr("Oh, das freut mich aber. In diesen schweren Zeiten trifft man nur noch selten Kauffreudige."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Schade, na ja, vielleicht überlegst du es dir ja noch."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method infoConditionGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_hi.index(), character)
		endmethod

		// Ist das dein Haus?
		private static method infoActionYourHouse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ist das dein Haus?"), null)
			call speech(info, character, true, tr("Ja, ich habe es für einen guten Preis erworben. Ich lies mich hier nieder nachdem mein Meister vor einigen Jahren mit mir nach Talras ging und bald darauf starb."), null)
			call speech(info, character, true, tr("Er war schon sehr alt und diese Gegend hier war seine Heimat. Er erinnerte sich sogar an die Zeit als hier noch keine Burg stand."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// Was genau verkaufst du?
		private static method infoActionWhatDoYouSell takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was genau verkaufst du?"), null)
			call speech(info, character, true, tr("Tränke und magische Gegenstände aller Art. Falls du ein Zauberer oder Magier bist wirst du bei mir genau das Richtige finden."), null)
			call speech(info, character, true, tr("Ich biete nur das Beste an, was ich auch selbst verwenden würde."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach „Ist das dein Haus“, dauerhaft)
		private static method infoConditionAboutYourMaster takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_yourHouse.index(), character)
		endmethod
		
		// Erzähl mir mehr von deinem Meister. 
		private static method infoActionAboutYourMaster takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir mehr von deinem Meister."), null)
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

		// Du bist wohl eine Zauberin?
		private static method infoActionYouAreAWizard takes AInfo info, ACharacter character returns nothing
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
		private static method infoConditionComeWithMe takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_aboutYourMaster.index(), character)
		endmethod

		// Zieh mit mir in den Kampf!
		private static method infoActionComeWithMe takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Zieh mit mir in den Kampf!"), null)
			call speech(info, character, true, tr("Ich soll mit dir in den Kampf ziehen? Hmm, so wie damals mit meinem Meister. Das waren noch Zeiten ..."), null)
			call speech(info, character, true, tr("Beherrscht du denn auch die Zauberkunst?"), null)
			call speech(info, character, false, tr("Sicher."), null)
			call speech(info, character, true, tr("Beweise es mir! In der Nähe gibt es einen Wald, wir nennen ihn den Dunkelwald. In diesem Wald stehen einige Runensteine, die dort vor einer Ewigkeit errichtet wurden. Mein Meister sprach von einer außergewöhnlichen Aura, welche diese Steine umgibt."), null)
			call speech(info, character, true, tr("Er gab mir vor seinem Tod einige Zauberspruchrollen, mit welchen es mir möglich sein sollte, jene Aura zu nutzen. Nimm eine dieser Zauberspruchrollen, geh zu den Runensteinen und probier aus, was passiert, dann komm wieder und berichte mir davon."), null)
			call QuestTheMagic.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat die Zauberspruchrolle bei den Runensteinen benutzt)
		private static method infoConditionBeenAtTheRunes takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Ich war bei den Runensteinen.
		private static method infoActionBeenAtTheRunes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich war bei den Runensteinen."), null)
			call speech(info, character, true, tr("Und, was ist passiert?"), null)
			call info.talk().showRange(thistype.m_beenAtTheRunes_magic.index(), thistype.m_beenAtTheRunes_nothing.index(), character)
		endmethod
		
		// Ich spürte, wie die magischen Kräfte mich durchflossen.
		private static method infoActionBeenAtTheRunes_Magic takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich spürte, wie die magischen Kräfte mich durchflossen."), null)
			call speech(info, character, true, tr("Hmm, dann solltest du mal einen Heiler aufsuchen."), null)
			call speech(info, character, true, tr("Tut mir leid, aber ich habe dich belogen, um zu sehen, ob du eine ehrliche Haut bist. Mit unehrlichen Leuten werde ich sicherlich nicht gemeinsam umher ziehen."), null)
			call QuestTheMagic.characterQuest(character).fail()
			call info.talk().showStartPage(character)
		endmethod

		// Gar nichts.
		private static method infoActionBeenAtTheRunes_Nothing takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Gar nichts."), null)
			call speech(info, character, true, tr("Ich hatte nichts anderes erwartet. Das war nur ein Test, um zu sehen, ob du eine ehrliche Haut bist."), null)
			call speech(info, character, true, tr("Von mir aus können wir jederzeit gemeinsam losziehen."), null)
			call QuestTheMagic.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Die Zauberkunst“ ist fehlgeschlagen)
		private static method infoConditionMakeGood takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).isFailed()
		endmethod

		// Kann ich es wieder gut machen?
		private static method infoActionMakeGood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich es wieder gut machen?"), null)
			call speech(info, character, true, tr("Vielleicht, immerhin will ich nicht nachtragend da stehen auch wenn du mich schwer enttäuscht hast."), null)
			call speech(info, character, true, tr("Ist es dir dies mal wenigstens ernst?"), null)
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Gut, ich gebe dir eine zweite und aller letzte Chance mein Vertrauen zu gewinnen. Es gibt da eine wichtige Sache, die ich noch erledigen müsste."), null)
			call speech(info, character, true, tr("Wie du sicherlich weißt, steht uns ein Krieg gegen die Orks und Dunkelelfen unmittelbar bevor. Ganz Talras spricht von nichts anderem mehr und ich als „angesehene“ Bürgerin möchte natürlich meinen Beitrag zur Verteidigung leisten."), null)
			call speech(info, character, true, tr("Ich habe einen neuen Zauber kreiert, der einen mächtigen magischen Schild erschaffen soll, welcher uns vor Pfeilangriffen schützt. Um ihn auszuprobieren, müsstest du dich allerdings von echten Pfeilen beschießen lassen."), null)
			call speech(info, character, false, tr("Ist das dein Ernst?"), null)
			call speech(info, character, true, tr("Tja, vielleicht hättest du mich nicht belügen sollen …"), null)
			call speech(info, character, false, tr("Schon gut, also was genau muss ich tun?"), null)
			call speech(info, character, true, tr("Du wirkst zunächst den Zauber, der den magischen Schild erzeugt und dann einen weiteren Zauber, der Pfeile auf dich los lässt und dann wartest du einfach ab was passiert."), null)
			call speech(info, character, false, tr("Das hört sich gefährlich an."), null)
			call speech(info, character, true, tr("Das ist es auch, deshalb habe ich den Zauber noch nicht ausprobiert. Sei aber nicht so dumm und wirke die Zauber in falscher Reihenfolge. Hier hast du die beiden Zauberspruchrollen."), null)
			call speech(info, character, true, tr("Wenn du diesen Auftrag erfüllst, hast du mein Vertrauen wieder erlangt, aber belüge mich dies mal nicht!"), null)
			call speech(info, character, false, tr("Wenn er nicht funktioniert dann sehen wir uns wohl kaum wieder."), null)
			call speech(info, character, true, tr("Habe etwas mehr Vertrauen in meine Zauberkünste!"), null)
			// Neuer Auftrag „Der magische Schild“
			call QuestTheMagicalShield.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Der magische Schild“ ist abgeschlossen und Auftragsziel 2 ist noch aktiv)
		private static method infoConditionTriedTheShield takes AInfo info, ACharacter character returns boolean
			return QuestTheMagicalShield.characterQuest(character).questItem(0).isCompleted() and QuestTheMagicalShield.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe den magischen Schild ausprobiert.
		private static method infoActionTriedTheShield takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe den magischen Schild ausprobiert."), null)
			call speech(info, character, true, tr("Und du lebst noch, also muss es funktioniert haben!"), null)
			call speech(info, character, false, tr("Ja, das hat es. Ein Glück für mich!"), null)
			call speech(info, character, true, tr("Mein Meister wäre sicher stolz auf mich, verdanke ich es doch seiner Weisheit diesen Zauber erschaffen zu haben. Wir werden es diesen Orks und Dunkelelfen zeigen, das sage ich dir!"), null)
			call speech(info, character, false, tr("Und ziehst du jetzt mit mir in den Kampf?"), null)
			call speech(info, character, true, tr("Selbstverständlich, du hast mein Vertrauen wieder erlangt. Aber glaube ja nicht, dass du mich hättest belügen können!"), null)
			call speech(info, character, true, tr("Ich habe die Zauberspruchrollen natürlich präpariert, um zu erfahren, ob du sie richtig gewirkt hast und wie ich sehe hast du mich nicht belogen. Von mir aus können wir jederzeit gemeinsam losziehen."), null)
			// Auftrag „Der magische Schild“ abgeschlossen
			call QuestTheMagicalShield.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Die Zauberkunst“ abgeschlossen oder Auftrag „Der magische Schild“ ist abgeschlossen)
		private static method infoConditionMoreHelp takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).isCompleted() or QuestTheMagicalShield.characterQuest(character).isCompleted()
		endmethod

		// Kann ich dir sonst noch irgendwie helfen?
		private static method infoActionMoreHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir sonst noch irgendwie helfen?"), null)
			call speech(info, character, true, tr("Hm, ich weiß nicht ob ich dich damit belasten oder dir das überhaupt anvertrauen kann aber …"), null)
			call speech(info, character, false, tr("Nun komm schon."), null)
			call speech(info, character, true, tr("Also … ich weiß nicht so recht."), null)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Ich habe dir doch von meinem Meister erzählt und davon wie viel er mir bedeutet hat und ja eigentlich immer noch bedeutet."), null)
			call speech(info, character, false, tr("Ja?"), null)
			call speech(info, character, true, tr("Du musst wissen auf unseren Reisen begegneten wir vielen eigenartigen Gestalten. Darunter war auch ein Nekromant, ein Diener Deranors des Schrecklichen. Wir begegneten dem Nekromanten auf unserer Reise vorbei an den Todessümpfen, dort wo Deranors Reich beginnt."), null)
			call speech(info, character, true, tr("Es war ein mächtiger Nekromant, der auch unter Deranor gedient und von ihm gelernt hatte. Da wir ihn vor einer üblen Kreatur beschützten, schenkte er uns aus Dankbarkeit einige wertvolle Artefakte und …"), null)
			call speech(info, character, false, tr("Und was?"), null)
			call speech(info, character, true, tr("Er brachte uns eine Zauberformel bei, die Geister herbeirufen konnte. Ich weiß nicht, ob er damals in die Zukunft sehen konnte, denn kurze Zeit später kamen wir nach Talras und mein Meister starb schließlich."), null)
			call speech(info, character, false, tr("Du willst also den Geist deines Meisters herbeirufen? Wieso hast du es noch nicht getan?"), null)
			call speech(info, character, true, tr("Ich weiß es nicht. Ehrlich gesagt fürchte ich mich davor. Es ist inzwischen so viel Zeit vergangen und ich fürchte es würde meine guten Erinnerungen an ihn zerstören."), null)
			call speech(info, character, true, tr("Stell dir nur mal vor was passieren würde, wenn der Zauber nicht funktioniert oder dem Geist meines Meisters Schaden zufügt? Das könnte ich mir nie verzeihen!"), null)
			call speech(info, character, false, tr("Aber so wirst du ihn nie wieder sehen."), null)
			call speech(info, character, true, tr("Ich weiß, ach du hast die Erinnerungen in mir wach gerufen jetzt kann ich an nichts anderes mehr denken!"), null)
			call speech(info, character, false, tr("Dann probieren wir es doch aus!"), null)
			call speech(info, character, true, tr("Vielleicht hast du Recht. Du hattest auch damit Recht, dass ich wieder los ziehen sollte Abenteuer zu erleben."), null)
			call speech(info, character, true, tr("Also gut wir probieren es aus, wenn du willst. Mein Meister liegt begraben auf dem kleinen Friedhof unten beim Bauernhof, dort wo alle Leute aus Talras begraben werden, bis auf die Familie des Herzogs."), null)
			call speech(info, character, true, tr("Geh mit mir zum Friedhof und ich werde die Zauberformel ausprobieren."), null)
			call speech(info, character, false, tr("Einverstanden."), null)
			// Neuer Auftrag „Der Geist des Meisters“
			call QuestTheGhostOfTheMaster.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Der Geist des Meisters“ ist abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionMetYourMaster takes AInfo info, ACharacter character returns boolean
			return QuestTheGhostOfTheMaster.characterQuest(character).questItem(0).isCompleted() and QuestTheGhostOfTheMaster.characterQuest(character).questItem(1).isNew()
		endmethod

		// Du hast deinen Meister wieder getroffen!
		private static method infoActionMetYourMaster takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du hast deinen Meister wieder getroffen!"), null)
			call speech(info, character, true, tr("Ja, das habe ich! Ich kann dir gar nicht sagen wie sehr ich nun in deiner Schuld stehe Fremder."), null)
			call speech(info, character, true, tr("Ich schenke dir zum Dank dieses mächtige Artefakt, das uns der Nekromant damals überreichte. Es soll von nun an dir gehören."), null)
			call speech(info, character, true, tr("Du hast mir Erlösung gebracht und dafür danke ich dir auf ewig!"), null)
			// Auftrag „Der Geist des Meisters“ abgeschlossen
			call QuestTheGhostOfTheMaster.characterQuest(character).complete()
			// TODO Artefakt übergeben
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Zauberkunst“ abgeschlossen oder Auftrag „Der magische Schild“ ist abgeschlossen)
		private static method infoConditionLetsGo takes AInfo info, ACharacter character returns boolean
			debug if (Fellows.sisgard().isShared()) then
				debug call Print("Is shared.")
			debug endif
			return (QuestTheMagic.characterQuest(character).isCompleted() or QuestTheMagicalShield.characterQuest(character).isCompleted()) and not Fellows.sisgard().isShared()
		endmethod

		// Gehen wir.
		private static method infoActionLetsGo takes AInfo info, Character character returns nothing
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
		private static method infoConditionOnMyOwn takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() == character
		endmethod

		// Ich komm alleine klar.
		private static method infoActionOnMyOwn takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich komm alleine klar."), null)
			call speech(info, character, true, tr("Gut, du weißt ja, wo du mich findest."), null)
			call info.talk().close(character)
			call Fellows.sisgard().reset()
		endmethod

		// (Folgt einem Charakter und wird von einem anderen angesprochen)
		private static method infoConditionBusy takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() != character
		endmethod

		// Ich hab zu tun.
		private static method infoActionBusy takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Ich hab zu tun."), null)
			call info.talk().close(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.sisgard(), thistype.startPageAction)
			
			set thistype.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo."))
			set thistype.m_hi_whyNot = this.addInfo(false, false, 0, thistype.infoActionHi_WhyNot, tr("Wieso nicht?"))
			set thistype.m_hi_no = this.addInfo(false, false, 0, thistype.infoActionHi_No, tr("Nein."))
			set thistype.m_yourHouse = this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoActionYourHouse, tr("Ist das dein Haus?"))
			set thistype.m_whatDoYouSell = this.addInfo(true, false, thistype.infoConditionGreeting, thistype.infoActionWhatDoYouSell, tr("Was genau verkaufst du?"))
			set thistype.m_aboutYourMaster = this.addInfo(true, false, thistype.infoConditionAboutYourMaster, thistype.infoActionAboutYourMaster, tr("Erzähl mir mehr von deinem Meister."))
			set thistype.m_youAreAWizard = this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoActionYouAreAWizard, tr("Du bist wohl eine Zauberin?"))
			set thistype.m_comeWithMe = this.addInfo(false, false, thistype.infoConditionComeWithMe, thistype.infoActionComeWithMe, tr("Zieh mit mir in den Kampf!"))
			set thistype.m_beenAtTheRunes = this.addInfo(false, false, thistype.infoConditionBeenAtTheRunes, thistype.infoActionBeenAtTheRunes, tr("Ich war bei den Runensteinen."))
			set thistype.m_beenAtTheRunes_magic = this.addInfo(false, false, 0, thistype.infoActionBeenAtTheRunes_Magic, tr("Ich spürte, wie die magischen Kräfte mich durchflossen."))
			set thistype.m_beenAtTheRunes_nothing = this.addInfo(false, false, 0, thistype.infoActionBeenAtTheRunes_Nothing, tr("Gar nichts."))
			set thistype.m_makeGood = this.addInfo(false, false, thistype.infoConditionMakeGood, thistype.infoActionMakeGood, tr("Kann ich es wieder gut machen?"))
			set thistype.m_triedTheShield = this.addInfo(false, false, thistype.infoConditionTriedTheShield, thistype.infoActionTriedTheShield, tr("Ich habe den magischen Schild ausprobiert."))
			set thistype.m_moreHelp = this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tr("Kann ich dir sonst noch irgendwie helfen?"))
			set thistype.m_metYourMaster = this.addInfo(false, false, thistype.infoConditionMetYourMaster, thistype.infoActionMetYourMaster, tr("Du hast deinen Meister wieder getroffen!"))
			set thistype.m_letsGo = this.addInfo(true, false, thistype.infoConditionLetsGo, thistype.infoActionLetsGo, tr("Gehen wir."))
			set thistype.m_onMyOwn = this.addInfo(true, false, thistype.infoConditionOnMyOwn, thistype.infoActionOnMyOwn, tr("Ich komm alleine klar."))
			set thistype.m_busy = this.addInfo(true, true, thistype.infoConditionBusy, thistype.infoActionBusy, null)
			set thistype.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary