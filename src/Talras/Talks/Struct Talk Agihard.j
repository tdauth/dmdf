library StructMapTalksTalkAgihard requires Asl, StructGameClasses

	struct TalkAgihard extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(6)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Ich grüße dich. Du bist nicht zufällig im Umgang mit Waffen geübt?"), null)
			call speech(info, false, tr("Warum?"), null)
			call speech(info, true, tr("Ich suche noch Leute, für meine Arena."), null)
			call info.talk().showRange(7, 9)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Dienst du dem Herzog?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Dienst du dem Herzog?"), null)
			call speech(info, true, tr("Wegen meiner Rüstung oder was? Ja, ich bin der Waffenmeister der Burg. Schon mein Vater diente ihm und ich bin stolz sein Erbe weiterzutragen."), null)
			call speech(info, false, tr("Dein Vater?"), null)
			call speech(info, true, tr("Ja, er war ein großer Mann. Er war der beste Waffenmeister weit und breit und trainierte viele große Krieger."), null)
			call info.talk().showRange(10, 11)
		endmethod

		// (Nachdem der Charakter erfahren hat, dass Agihard dem Herzog dient)
		private static method infoCondition2 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(1)
		endmethod

		// Was weißt du über die Situation?
		private static method infoAction2 takes AInfo info returns nothing
			local boolean sayIt = false
			call speech(info, false, tr("Was weißt du über die Situation?"), null)
			call speech(info, true, tr("Über welche Situation? Meinst du die bevorstehenden Kämpfe?"), null)
			call speech(info, false, tr("Ja."), null)
			call speech(info, true, tr("Tut mir leid. Darüber darf ich nicht sprechen. Uns wurde das Sprechen über solche Angelegenheiten strengstens untersagt. Dadurch bekommen die Leute nur noch mehr Angst."), null)
			if (info.talk().character().class() == Classes.cleric()) then
				call speech(info, false, tr("Ich bin ein Geistlicher. Nicht einmal mir willst du etwas erzählen?!"), null)
				call speech(info, true, tr("Na ja ..."), null)
				call speech(info, false, tr("Natürlich achte ich auch das Schweigegelübde."), null)
				set sayIt = true
			elseif (info.talk().character().class() == Classes.knight()) then
				call speech(info, false, tr("Ich bin ein Ritter, ein treuer Diener des Königs, genau wie du. Mir kannst du es ruhig erzählen."), null)
				set sayIt = true
			elseif (info.talk().character().class() == Classes.dragonSlayer()) then
				call speech(info, false, tr("Kannst du nicht mal eine Ausnahme machen?"), null)
				call speech(info, true, tr("Nein, ich würde damit gegen meinen Eid verstoßen!"), null)
				call speech(info, false, tr("Ach was ist schon so ein Eid, ich erzähls auch bestimmt keinem."), null)
				call speech(info, true, tr("Schluss jetzt! Entweder du bist hier, um zu kämpfen oder du verschwindest!"), null)
			endif
			if (sayIt) then
				call speech(info, true, tr("Also gut ... aber du darfst es niemandem erzählen! Ich glaube die Ritter planen einen Ausfall und wollen dem Feind entgegen ziehen. Doch der Herzog ist anderer Meinung. Er wartet auf irgendetwas. Das ist allerdings nur ein Gerücht und erzähl niemandem, dass du das von mir hast!"), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// (Weiß von der Arena)
		private static method infoCondition3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Lass mich in die Arena!
		private static method infoAction3 takes AInfo info returns nothing
			local unit arenaEnemy
			local ACharacter character
			call speech(info, false, tr("Lass mich in die Arena!"), null)
			if (not Arena.isFree()) then
				call speech(info, true, tr("Tut mir leid, aber die Arena ist gerade belegt."), null)
				call info.talk().showStartPage()
			else
				call speech(info, true, tr("Gut, und halte dich an die Regeln!"), null)
				set character = info.talk().character()
				call info.talk().close()
				set arenaEnemy = Arena.getRandomEnemy(info.talk().character().level())
				call Arena.addUnit(arenaEnemy)
				set arenaEnemy = null
				call Arena.addCharacter(character)
			endif
		endmethod

		// (Falls das erste Auftragsziel des Auftrags "Arenameister" abgeschlossen und das zweite noch aktiv ist)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestArenaChampion.characterQuest(info.talk().character()).questItem(0).isCompleted() and QuestArenaChampion.characterQuest(info.talk().character()).questItem(1).isNew()
		endmethod

		// Ich habe fünf Gegner besiegt!
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Ich habe fünf Gegner besiegt!"), null)
			call speech(info, true, tr("Tatsächlich? Du scheinst mir ein sehr starker Kämpfer zu sein. Nun gut, du hast dir deine Belohnung ehrenhaft verdient. Hier hast du sie."), null)
			call QuestArenaChampion.characterQuest(info.talk().character()).questItem(1).complete()
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung, Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ ist aktiv)
		private static method infoCondition5 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0) and QuestTheBraveArmourerOfTalras.characterQuest(info.talk().character()).questItem(0).isNew()
		endmethod

		// Irmina mag dich.
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, false, tr("Irmina mag dich."), null)
			call speech(info, true, tr("Was?"), null)
			call speech(info, false, tr("…"), null)
			call speech(info, true, tr("Irmina, die Händlerin? Wieso das denn?"), null)
			call speech(info, false, tr("Ich wette, du wusstest es."), null)
			call speech(info, true, tr("Na ja, ich dachte … vielleicht, aber ich war mir nicht sicher. Vielleicht sollte ich mal bei ihr vorbeischauen."), null)
			call speech(info, true, tr("Mal unter uns, ich mag sie auch sehr. Erzähl das aber keinem, sonst schlage ich dir den Kopf ab!"), null)
			// Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ abgeschlossen
			call QuestTheBraveArmourerOfTalras.characterQuest(info.talk().character()).questItem(0).complete()
			call info.talk().showStartPage()
		endmethod

		// Welche Arena?
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Welche Arena?"), null)
			call speech(info, true, tr("Eben eine ganz normale Arena. Man kämpft und wer gewinnt, bekommt Goldmünzen."), null)
			call speech(info, true, tr("Die Kämpfe finden immer zwischen genau zwei Leuten statt."), null)
			if (not info.talk().infoHasBeenShown(8) or not info.talk().infoHasBeenShown(9)) then
				call info.talk().showRange(8, 9)
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Gibt es bestimmte Regeln in der Arena?
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Gibt es bestimmte Regeln in der Arena?"), null)
			call speech(info, true, tr("Ja, allerdings. Ich will nicht, dass das am Ende in einem Massaker endet. Wir wollen ja fair bleiben. Also ..."), null)
			call speech(info, true, tr("1. Es ist nur ein Wettkampf, daher werden keine Gegner getötet oder sonst aufs Brutalste verstümmelt. Liegt ein Gegner am Boden, so ist der Kampf zu Ende."), null)
			call speech(info, true, tr("2. Es kämpfen immer genau zwei Leute gegeneinander. Niemand hat sich da einzumischen!"), null)
			call speech(info, true, tr("3. Wer die Arena verlässt, hat verloren."), null)
			call speech(info, false, tr("Was passiert wenn ich gegen eine dieser Regeln verstoße?"), null)
			call speech(info, true, tr("Probier es erst gar nicht! Wenn du gegen die zweite Regel verstößt, wird wohl kaum noch jemand in die Arena kommen, verstößt du gegen die erste, hast du ein ernsthaftes Problem!"), null)
			if (not info.talk().infoHasBeenShown(7) or not info.talk().infoHasBeenShown(9)) then
				call info.talk().showInfo(7)
				call info.talk().showInfo(9)
				call info.talk().show()
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Was gibt es zu gewinnen?
		private static method infoAction0_2 takes AInfo info returns nothing
			call speech(info, false, tr("Was gibt es zu gewinnen?"), null)
			call speech(info, true, tr("War ja wieder klar, dass du das wissen willst. Ein wahrer Krieger kämpft ohne Aussicht auf Belohnung!"), null)
			call speech(info, false, tr("Interessant."), null)
			call speech(info, true, tr("Ja, ja, schon gut. Also, du kriegst deine Belohnung sobald der Kampf vorbei ist und du deinen Gegner besiegt hast. Pro Sieg erhältst du zehn Goldmünzen. Wenn du öfter als fünfmal gewinnst, erhältst du einen besonderen Preis. Allerdings will ich noch nicht verraten, um was genau es sich dabei handelt. Mitmachen lohnt sich aber auf jeden Fall!"), null)
			call speech(info, true, tr("Ach ja, den Preis gibt es natürlich nur einmal für jeden, der das schafft. Sonst werde ich ja noch arm (Lacht)."), null)
			call QuestArenaChampion.characterQuest(info.talk().character()).enable()
			if (not info.talk().infoHasBeenShown(7) or not not info.talk().infoHasBeenShown(8)) then
				call info.talk().showRange(7, 8)
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Kennst du dich mit Waffen aus?
		private static method infoAction1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Kennst du dich mit Waffen aus?"), null)
			call speech(info, true, tr("Natürlich, worum geht's denn?"), null)
			call speech(info, false, tr("Wo finde ich gute Waffen?"), null)
			call speech(info, true, tr("(Lachend) Bei mir natürlich. Nein, im Ernst. Du könntest zum Beispiel zum Burgschmied gehen oder einige andere Händler fragen, aber meine Waffen sind auch nicht die schlechtesten."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n00S_0135, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Dienst du dem Herzog?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Was weißt du über die Situation?")) // 2
			call this.addInfo(true, false, thistype.infoCondition3, thistype.infoAction3, tr("Lass mich in die Arena!")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tr("Ich habe fünf Gegner besiegt!")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Irmina mag dich.")) // 5
			call this.addExitButton() // 6

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Welche Arena?")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Gibt es bestimmte Regeln in der Arena?")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction0_2, tr("Was gibt es zu gewinnen?")) // 9

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Kennst du dich mit Waffen aus?")) // 10
			call this.addBackToStartPageButton() // 11

			return this
		endmethod
	endstruct

endlibrary
