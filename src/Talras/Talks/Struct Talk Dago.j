library StructMapTalksTalkDago requires Asl, StructMapQuestsQuestBurnTheBearsDown

	struct TalkDago extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			if (not this.showInfo(0)) then
				call this.showRange(1, 8)
			endif
		endmethod

		// He du! Danke, dass ihr mich vor den Bären gerettet habt!
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, true, tr("He du! Danke, dass ihr mich vor den Bären gerettet habt!"), null)
			call speech(info, true, tr("Ich wette, dass sich da noch ein paar von diesen Bestien in der Höhle verkrochen haben."), null)
			call speech(info, true, tr("Aber keine Sorge. Um die werde ich mich selbst kümmern."), null)
			call speech(info, true, tr("Ich hab auch schon einen Plan. Ich stecke einfach die ganze verdammte Höhle in Brand und lasse diese Scheißviecher elendlich verrecken!"), null)
			call speech(info, true, tr("Allerdings bräuchte ich dazu entweder ne verdammte Menge Holz oder einen guten Zauberspruch."), null)
			call speech(info, true, tr("Also wenn du mal einen für mich hast ... ich würde dich selbstverständlich dafür entlohnen. Also nochmal danke für die Hilfe vorhin!"), null)
			debug call Print("Before quest creation.")
			call QuestBurnTheBearsDown.characterQuest(info.talk().character()).enable()
			debug call Print("After quest creation.")
			call info.talk().showStartPage()
		endmethod

		// Willst du nicht mal langsam in die Burg?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Willst du nicht mal langsam in die Burg?"), null)
			call speech(info, true, tr("Nein, ich muss erst mehr Pilze finden."), null)
			call info.talk().showRange(9, 10)
		endmethod

		// (Nach „Willst du nicht mal langsam in die Burg?“)
		private static method infoCondition2 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(1)
		endmethod

		// Gibt’s hier leckere Pilze?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Gibt’s hier leckere Pilze?"), null)
			call speech(info, true, tr("Ja, aber leider finde ich davon kaum welche."), null)
			call speech(info, true, tr("Vielleicht hätten mich die Bären lieber fressen sollen. Am Ende stehe ich noch mit leeren Händen vor dem Herzog (Lacht)."), null)
			call info.talk().showStartPage()
		endmethod

		// Schon was von den Orks gehört?
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Schon was von den Orks gehört?"), null)
			call speech(info, true, tr("Hör mir bloß auf mit diesen verdammten Orks! Jeder hier spricht von nichts anderem mehr und unser Herzog ist sowieso unfähig. Aber was red' ich da?"), null)
			call speech(info, true, tr("Sollen die Orks endlich kommen und uns alle töten. Das Warten ist das, was einen fertigmacht."), null)
			call speech(info, true, tr("Ihr habt mir heute das Leben gerettet und dafür bin ich euch sehr dankbar, aber die Orks sind mit zwei Bären nicht zu vergleichen. Die werden euch in Stücke reißen."), null)
			call info.talk().showStartPage()
		endmethod

		// Was weißt du über die Gegend hier?
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Was weißt du über die Gegend hier?"), null)
			call speech(info, true, tr("Einiges. Ich wurde immerhin hier geboren. Mann, wie die Zeit vergeht! Aber ich werde sowieso nicht mehr lange leben. Heute habt ihr mich zwar gerettet, aber morgen schon werden mich die Orks töten."), null)
			call speech(info, true, tr("Manchmal frage ich mich wirklich, welchen Sinn es macht, sich noch weiter abzumühen und auf seinen sicheren Tod zu warten."), null)
			call speech(info, false, tr("Die Gegend hier …"), null)
			call speech(info, true, tr("Ja, tut mir leid. Ich bin vom Thema abgewichen. Also, es gibt hier natürlich einmal die Burg Talras, welche dem Herzog oder besser gesagt dessen Familie gehört. Dann sind da noch die Bauern auf dem Hof im Westen. Die haben das Land vom Herzog gepachtet und sind nicht besonders gut auf ihn zu sprechen."), null)
			call speech(info, true, tr("Noch weiter westlich vom Bauernhof befindet sich der Mühlberg, auf welchem Guntrichs Mühle steht und manchmal die Kühe oder Schafe der Bauern grasen."), null)
			call speech(info, true, tr("Wir Jagdleute leben in der Burg. Wahrscheinlich wirst du auch noch einige Aussiedler wie den Fährmann Trommon finden, die lieber für sich leben. Ach so und seit einer Weile sind einige Krieger aus dem Norden hier angekommen. Sie haben ihr Lager etwas weiter nördlich am Fluss aufgeschlagen."), null)
			call speech(info, true, tr("Weiß der Teufel, was die hier wollen!"), null)
			call speech(info, true, tr("Und pass auf, wenn du durch die Wälder hier ziehst. Hier gibt’s außer den wilden Tieren auch noch Wegelagerer, die dir für ein paar Goldmünzen die Haut bei lebendigem Leibe abziehen würden. Ganz zu schweigen von den Kreaturen, die sich nördlich des Hofes und am Ostufer des Flusses rumtreiben."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftrag „Pilzsuche ist aktiv und Charakter hat Pilze dabei)
		private static method infoCondition5 takes AInfo info returns boolean
			return QuestMushroomSearch.characterQuest(info.talk().character()).isNew() and true /// @todo FIXME
		endmethod

		// Ich habe hier ein paar Pilze.
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, false, tr("Ich habe hier ein paar Pilze."), null)
			if (false) then /// @todo FIXME
				// (Pilze sind essbar, aber noch nicht genug)
				if (not QuestMushroomSearch.characterQuest(info.talk().character()).addMushroom()) then
					call speech(info, true, tr("Sehr gut, danke. Ich brauche aber noch mehr essbare Pilze."), null)
				// (Pilze sind essbar und genug)
				else
					call speech(info, true, tr("Danke, das reicht, sogar dem Herzog (Lacht). Hier hast du ein paar Goldmünzen, danke für deine Mühen. Man trifft selten Leute, die noch was Anderes als sich selbst im Kopf haben."), null)
					// Auftrag „Pilzsuche“ abgeschlossen
					call QuestMushroomSearch.characterQuest(info.talk().character()).complete()
				endif
			// (Pilze sind nicht essbar)
			else
				call speech(info, true, tr("Tut mir leid, aber die sehen nicht gerade essbar aus. Nicht, dass mich das sonderlich stören würde, aber den Herzog wahrscheinlich schon."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		private static method completeBoth takes AInfo info returns nothing
			call speech(info, true, tr("Gleich beides also? Du bist mir wirklich eine große Hilfe, da werden die Bären nichts zu Lachen haben!"), null)
			// Auftrag „Brennt die Bären nieder!“ mit Bonus abgeschlossen
			call QuestBurnTheBearsDown.characterQuest(info.talk().character()).complete()
			call Character(info.talk().character()).xpBonus(QuestBurnTheBearsDown.xpBonus, QuestBurnTheBearsDown.characterQuest(info.talk().character()).title())
		endmethod

		private static method complete takes AInfo info returns nothing
			call speech(info, true, tr("Vielen Dank! Ich werde die Höhle mit den Drecksbären in Flammen aufgehen lassen!"), null)
			// Auftrag „Brennt die Bären nieder!“ abgeschlossen
			call QuestBurnTheBearsDown.characterQuest(info.talk().character()).complete()
		endmethod

		private static method conclusion takes AInfo info returns nothing
			call speech(info, true, tr("Hier hast du deine versprochene Belohnung."), null)
			call Character(info.talk().character()).giveItem(QuestBurnTheBearsDown.itemTypeIdDagger)
			call Character.displayItemAcquiredToAll(tr("STRING 4869"), tr("STRING 4880"))
			call info.talk().showStartPage()
		endmethod

		// (Auftrag „Brennt die Bären nieder!“ ist aktiv und Charakter besitzt Zauberspruch)
		private static method infoCondition6 takes AInfo info returns boolean
			return QuestBurnTheBearsDown.characterQuest(info.talk().character()).isNew() and Character(info.talk().character()).inventory().hasItemType(QuestBurnTheBearsDown.itemTypeIdScroll)
		endmethod

		// Hier ist dein Zauberspruch.
		private static method infoAction6 takes AInfo info returns nothing
			if (Character(info.talk().character()).inventory().totalItemTypeCharges(QuestBurnTheBearsDown.itemTypeIdWood) == QuestBurnTheBearsDown.maxWood) then // (Charakter besitzt zudem das Holz)
				call speech(info, false, tr("Außerdem habe ich noch Holz für dich."), null)
				call thistype.completeBoth(info)

			else // (Charakter besitzt nur den Zauberspruch)
				call thistype.complete(info)
			endif
			call thistype.conclusion(info)
		endmethod

		// (Auftrag „Brennt die Bären nieder!“ ist aktiv und Charakter besitzt Holz)
		private static method infoCondition7 takes AInfo info returns boolean
			return QuestBurnTheBearsDown.characterQuest(info.talk().character()).isNew() and Character(info.talk().character()).inventory().totalItemTypeCharges(QuestBurnTheBearsDown.itemTypeIdWood) == QuestBurnTheBearsDown.maxWood
		endmethod

		// Hier ist dein Holz.
		private static method infoAction7 takes AInfo info returns nothing
			// (Charakter besitzt zudem den Zauberspruch)
			if (Character(info.talk().character()).inventory().hasItemType(QuestBurnTheBearsDown.itemTypeIdScroll)) then
				call speech(info, false, tr("Außerdem habe ich noch einen Zauberspruch für dich."), null)
				call thistype.completeBoth(info)
			else // (Charakter besitzt nur das Holz)
				call thistype.complete(info)
			endif
			call thistype.conclusion(info)
		endmethod

		// Was denn für Pilze?
		private static method infoAction1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Was denn für Pilze?"), null)
			call speech(info, true, tr("Ach alle Möglichen, Hauptsache essbar."), null)
			call speech(info, true, tr("Wieso fragst du überhaupt? Willst du mir etwa dabei helfen?"), null)
			call info.talk().showRange(11, 12)
		endmethod

		// Na dann mal viel Spaß!
		private static method infoAction1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Na dann mal viel Spaß!"), null)
			call speech(info, true, tr("Danke."), null)
			call info.talk().showStartPage()
		endmethod

		// Klar.
		private static method infoAction1_0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Klar."), null)
			call speech(info, true, tr("Das find ich aber nett. Selten geworden, dass jemand einem seine Hilfe anbietet."), null)
			// Neuer Auftrag „Pilzsuche“
			call QuestMushroomSearch.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Nein.
		private static method infoAction1_0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Nein."), null)
			call speech(info, true, tr("Schade."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n00Q_0028, thistype.startPageAction)

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, 0, thistype.infoAction1, tr("Willst du nicht mal langsam in die Burg?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Gibt’s hier leckere Pilze?")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Schon was von den Orks gehört?")) // 3
			call this.addInfo(false, false, 0, thistype.infoAction4, tr("Was weißt du über die Gegend hier?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Ich habe hier ein paar Pilze.")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Hier ist dein Zauberspruch.")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Hier ist dein Holz.")) // 7
			call this.addExitButton() // 8

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Was denn für Pilze?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Na dann mal viel Spaß!")) // 10

			// info 1_0
			call this.addInfo(false, false, 0, thistype.infoAction1_0_0, tr("Klar.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction1_0_1, tr("Nein.")) // 12

			return this
		endmethod
	endstruct

endlibrary