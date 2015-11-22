library StructMapTalksTalkDago requires Asl, StructMapQuestsQuestBurnTheBearsDown, StructMapQuestsQuestReinforcementForTalras

	struct TalkDago extends Talk

		implement Talk
		
		private AInfo m_hi
		private AInfo m_castle
		private AInfo m_tastyMushrooms
		private AInfo m_orcs
		private AInfo m_area
		private AInfo m_iHaveMushrooms
		private AInfo m_spell
		private AInfo m_wood
		private AInfo m_apprentice
		private AInfo m_arrows
		private AInfo m_exit
		
		private AInfo m_whatKindOfMushrooms
		private AInfo m_goodLuck
		
		private AInfo m_ofCourse
		private AInfo m_no

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_hi.index(), character)) then
				call this.showRange(this.m_castle.index(), this.m_exit.index(), character)
			endif
		endmethod

		// He du! Danke, dass ihr mich vor den Bären gerettet habt!
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("He du! Danke, dass ihr mich vor den Bären gerettet habt!", "Hey you there! Thank you for rescuing me from the bears!"), gg_snd_Dago1)
			call speech(info, character, true, tre("Ich wette, dass sich da noch ein paar von diesen Bestien in der Höhle verkrochen haben.", "I'll bet that there are still some beasts hiding in the cave."), gg_snd_Dago2)
			call speech(info, character, true, tre("Aber keine Sorge. Um die werde ich mich selbst kümmern.", "But don't worry. I will take care of them by myself."), gg_snd_Dago3)
			call speech(info, character, true, tre("Ich hab auch schon einen Plan. Ich stecke einfach die ganze verdammte Höhle in Brand und lasse diese Scheißviecher elendiglich verrecken!", "I do already have a plan. I just set the whole damned cave ablaze and let these damned animals come to a miserable end wretchedly!"), gg_snd_Dago4)
			call speech(info, character, true, tre("Allerdings bräuchte ich dazu entweder ne verdammte Menge Holz oder einen guten Zauberspruch.", "But I need a huge amount of wood or a good spell for that."), gg_snd_Dago5)
			call speech(info, character, true, tre("Also wenn du mal einen für mich hast … ich würde dich selbstverständlich dafür entlohnen. Und noch mal danke für die Hilfe vorhin!", "So if you have just one for me … naturally I would reward you for it. And again thank you for the help a moment ago."), gg_snd_Dago6)

			call QuestBurnTheBearsDown.characterQuest(character).enable()

			call info.talk().showStartPage(character)
		endmethod

		// Willst du nicht mal langsam in die Burg?
		private static method infoActionCastle takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Willst du nicht mal langsam in die Burg?", "Don't you want to go to the castle gradually?"), null)
			call speech(info, character, true, tre("Nein, ich muss erst mehr Pilze finden.", "No, first I must find more mushrooms."), gg_snd_Dago7)
			call info.talk().showRange(this.m_whatKindOfMushrooms.index(), this.m_goodLuck.index(), character)
		endmethod

		// (Nach „Willst du nicht mal langsam in die Burg?“)
		private static method infoConditionTastyMushrooms takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Gibt’s hier leckere Pilze?
		private static method infoActionTastyMushrooms takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gibt’s hier leckere Pilze?", "Are there delecious mushrooms in this area?"), null)
			call speech(info, character, true, tr("Ja, aber leider finde ich davon kaum welche."), gg_snd_Dago13)
			call speech(info, character, true, tr("Vielleicht hätten mich die Bären lieber fressen sollen. Am Ende stehe ich noch mit leeren Händen vor dem Herzog (Lacht)."), gg_snd_Dago14)
			call info.talk().showStartPage(character)
		endmethod

		// Schon was von den Orks gehört?
		private static method infoActionOrcs takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Schon was von den Orks gehört?", "Have you already heard something about the Orcs?"), null)
			call speech(info, character, true, tr("Hör mir bloß auf mit diesen verdammten Orks! Jeder hier spricht von nichts anderem mehr und unser Herzog ist sowieso unfähig. Aber was red' ich da?"), gg_snd_Dago15)
			call speech(info, character, true, tr("Sollen die Orks endlich kommen und uns alle töten. Das Warten ist das, was einen fertigmacht."), gg_snd_Dago16)
			call speech(info, character, true, tr("Ihr habt mir heute das Leben gerettet und dafür bin ich euch sehr dankbar, aber die Orks sind mit zwei Bären nicht zu vergleichen. Die werden euch in Stücke reißen."), gg_snd_Dago17)
			call info.talk().showStartPage(character)
		endmethod

		// Was weißt du über die Gegend hier?
		private static method infoActionArea takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was weißt du über die Gegend hier?"), null)
			call speech(info, character, true, tr("Einiges. Ich wurde immerhin hier geboren. Mann, wie die Zeit vergeht! Aber ich werde sowieso nicht mehr lange leben. Heute habt ihr mich zwar gerettet, aber morgen schon werden mich die Orks töten."), gg_snd_Dago18)
			call speech(info, character, true, tr("Manchmal frage ich mich wirklich, welchen Sinn es macht, sich noch weiter abzumühen und auf seinen sicheren Tod zu warten."), gg_snd_Dago19)
			call speech(info, character, false, tr("Die Gegend hier …"), null)
			call speech(info, character, true, tr("Ja, tut mir leid. Ich bin vom Thema abgewichen. Also, es gibt hier natürlich einmal die Burg Talras, welche dem Herzog oder besser gesagt dessen Familie gehört. Dann sind da noch die Bauern auf dem Hof im Westen. Die haben das Land vom Herzog gepachtet und sind nicht besonders gut auf ihn zu sprechen."), gg_snd_Dago20)
			call speech(info, character, true, tr("Noch weiter westlich vom Bauernhof befindet sich der Mühlberg, auf welchem Guntrichs Mühle steht und manchmal die Kühe oder Schafe der Bauern grasen."), gg_snd_Dago21)
			call speech(info, character, true, tr("Wir Jagdleute leben in der Burg. Wahrscheinlich wirst du auch noch einige Aussiedler wie den Fährmann Trommon treffen, die lieber für sich leben. Ach so und vor einer Weile sind einige Krieger aus dem Norden hier angekommen. Sie haben ihr Lager etwas weiter nördlich am Fluss aufgeschlagen."), gg_snd_Dago22)
			call speech(info, character, true, tr("Weiß der Teufel, was die hier wollen!"), gg_snd_Dago23)
			call speech(info, character, true, tr("Und pass auf, wenn du durch die Wälder hier ziehst. Hier gibt’s außer den wilden Tieren auch noch Wegelagerer, die dir für ein paar Goldmünzen die Haut bei lebendigem Leibe abziehen würden. Ganz zu schweigen von den Kreaturen, die sich nördlich des Hofes und am Ostufer des Flusses rumtreiben."), gg_snd_Dago24)
			call info.talk().showStartPage(character)
		endmethod
		
		private static method hasMushrooms takes ACharacter character returns boolean
			return (character.inventory().hasItemType('I01L') or character.inventory().hasItemType('I01K') or character.inventory().hasItemType('I03Y')) // NOTE alle Pilze hinzufügen
		endmethod
		
		private static method mushroomsAreTasty takes ACharacter character returns boolean
			return (character.inventory().hasItemType('I01L') or character.inventory().hasItemType('I01K')) // NOTE alle Pilze hinzufügen
		endmethod

		// (Auftrag „Pilzsuche ist aktiv und Charakter hat Pilz dabei)
		private static method infoConditionIHaveMushrooms takes AInfo info, ACharacter character returns boolean
			return QuestMushroomSearch.characterQuest(character).isNew() and thistype.hasMushrooms(character)
		endmethod

		// Ich habe hier einen Pilz.
		private static method infoActionIHaveMushrooms takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Ich habe hier einen Pilz.", "I have one mushroom."), null)
			if (thistype.mushroomsAreTasty(character)) then
				// Steinpilz ist essbar
				if (character.inventory().hasItemType('I01L')) then
					// Pilz entfernen
					call character.inventory().removeItemType('I01L')
				// Pfifferling ist essbar
				elseif (character.inventory().hasItemType('I01K')) then
					// Pilz entfernen
					call character.inventory().removeItemType('I01K')
				endif
				// (Pilze sind essbar, aber noch nicht genug)
				if (not QuestMushroomSearch.characterQuest(character).addMushroom()) then
					call speech(info, character, true, tr("Sehr gut, danke. Ich brauche aber noch mehr essbare Pilze."), gg_snd_Dago25)
				// (Pilze sind essbar und genug)
				else
					call speech(info, character, true, tr("Danke, das reicht, sogar dem Herzog (Lacht). Hier hast du ein paar Goldmünzen, danke für deine Mühen. Man trifft selten Leute, die noch was Anderes als sich selbst im Kopf haben."), gg_snd_Dago26)
					// Auftrag „Pilzsuche“ abgeschlossen
					call QuestMushroomSearch.characterQuest(character).complete()
				endif
			// (Pilze sind nicht essbar)
			else
				call speech(info, character, true, tr("Tut mir leid, aber der sieht nicht gerade essbar aus. Nicht, dass mich das sonderlich stören würde, aber den Herzog wahrscheinlich schon."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		private static method completeBoth takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Gleich beides also? Du bist mir wirklich eine große Hilfe, da werden die Bären nichts zu Lachen haben!"), gg_snd_Dago28)
			// Auftrag „Brennt die Bären nieder!“ mit Bonus abgeschlossen
			call QuestBurnTheBearsDown.characterQuest(character).complete()
			call Character(character).xpBonus(QuestBurnTheBearsDown.xpBonus, QuestBurnTheBearsDown.characterQuest(character).title())
		endmethod

		private static method complete takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Vielen Dank! Ich werde die Höhle mit den Drecksbären in Flammen aufgehen lassen!"), gg_snd_Dago29)
			// Auftrag „Brennt die Bären nieder!“ abgeschlossen
			call QuestBurnTheBearsDown.characterQuest(character).complete()
		endmethod

		private static method conclusion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Hier hast du deine versprochene Belohnung."), gg_snd_Dago30)
			call Character(character).giveItem(QuestBurnTheBearsDown.itemTypeIdDagger)
			call Character.displayItemAcquiredToAll(tr("STRING 4869"), tr("STRING 4880"))
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Brennt die Bären nieder!“ ist aktiv und Charakter besitzt Zauberspruch)
		private static method infoConditionSpell takes AInfo info, ACharacter character returns boolean
			return QuestBurnTheBearsDown.characterQuest(character).isNew() and Character(character).inventory().hasItemType(QuestBurnTheBearsDown.itemTypeIdScroll)
		endmethod

		// Hier ist dein Zauberspruch.
		private static method infoActionSpell takes AInfo info, ACharacter character returns nothing
			if (Character(character).inventory().totalItemTypeCharges(QuestBurnTheBearsDown.itemTypeIdWood) == QuestBurnTheBearsDown.maxWood) then // (Charakter besitzt zudem das Holz)
				call speech(info, character, false, tr("Außerdem habe ich noch Holz für dich."), null)
				call thistype.completeBoth(info, character)

			else // (Charakter besitzt nur den Zauberspruch)
				call thistype.complete(info, character)
			endif
			call thistype.conclusion(info, character)
		endmethod

		// (Auftrag „Brennt die Bären nieder!“ ist aktiv und Charakter besitzt Holz)
		private static method infoConditionWood takes AInfo info, ACharacter character returns boolean
			return QuestBurnTheBearsDown.characterQuest(character).isNew() and Character(character).inventory().totalItemTypeCharges(QuestBurnTheBearsDown.itemTypeIdWood) == QuestBurnTheBearsDown.maxWood
		endmethod

		// Hier ist dein Holz.
		private static method infoActionWood takes AInfo info, ACharacter character returns nothing
			// (Charakter besitzt zudem den Zauberspruch)
			if (Character(character).inventory().hasItemType(QuestBurnTheBearsDown.itemTypeIdScroll)) then
				call speech(info, character, false, tr("Außerdem habe ich noch einen Zauberspruch für dich."), null)
				call thistype.completeBoth(info, character)
			else // (Charakter besitzt nur das Holz)
				call thistype.complete(info, character)
			endif
			call thistype.conclusion(info, character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ aktiv und nicht abgeschlossen)
		private static method infoConditionApprentice takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isNew()
		endmethod

		// Suchst du einen Schüler?
		private static method infoActionApprentice takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Suchst du einen Schüler?"), null)
			call speech(info, character, true, tr("Einen Schüler? Nein, für so etwas habe ich keine Zeit!"), gg_snd_Dago31)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 3 des Auftrags „Die Befestigung von Talras“ ist aktiv)
		private static method infoConditionArrows takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(2).isNew()
		endmethod

		// Kannst du Pfeile herstellen?
		private static method infoActionArrows takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kannst du Pfeile herstellen?"), null)
			call speech(info, character, true, tr("Natürlich kann ich das. Ich bin ja schließlich Jäger. Wieso fragst du denn?"), gg_snd_Dago32)
			call speech(info, character, false, tr("Markward benötigt Pfeile zur Verteidigung der Burg."), null)
			call speech(info, character, true, tr("So, braucht er die? Ich brauche aber selbst welche und außerdem habe ich gerade sowieso keine Zeit. Sprich mal mit Björn, der lässt sich gerne ausnutzen (grinst)."), gg_snd_Dago33)
			call info.talk().showStartPage(character)
		endmethod

		// Was denn für Pilze?
		private static method infoActionCastle_WhatKindOfMushrooms takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Was denn für Pilze?", "What kind of mushrooms?"), null)
			call speech(info, character, true, tr("Ach alle Möglichen, Hauptsache essbar."), gg_snd_Dago8)
			call speech(info, character, true, tr("Wieso fragst du überhaupt? Willst du mir etwa dabei helfen?"), gg_snd_Dago9)
			call info.talk().showRange(this.m_ofCourse.index(), this.m_no.index(), character)
		endmethod

		// Na dann mal viel Spaß!
		private static method infoActionCastle_GoodLuck takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Na dann mal viel Spaß!"), null)
			call speech(info, character, true, tr("Danke."), gg_snd_Dago12)
			call info.talk().showStartPage(character)
		endmethod

		// Klar.
		private static method infoActionCastle_WhatKindOfMushrooms_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Klar."), null)
			call speech(info, character, true, tr("Das finde ich aber nett. Ist selten geworden, dass jemand einem seine Hilfe anbietet."), gg_snd_Dago10)
			// Neuer Auftrag „Pilzsuche“
			call QuestMushroomSearch.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionCastle_WhatKindOfMushrooms_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Schade.", "Too bad."), gg_snd_Dago11)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.dago(), thistype.startPageAction)
			call this.setName(tr("Dago"))

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null)
			set this.m_castle = this.addInfo(false, false, 0, thistype.infoActionCastle, tre("Willst du nicht mal langsam in die Burg?", "Don't you want to go to the castle gradually?"))
			set this.m_tastyMushrooms = this.addInfo(false, false, thistype.infoConditionTastyMushrooms, thistype.infoActionTastyMushrooms, tre("Gibt’s hier leckere Pilze?", "Are there delecious mushrooms in this area?"))
			set this.m_orcs = this.addInfo(false, false, 0, thistype.infoActionOrcs, tre("Schon was von den Orks gehört?", "Have you already heard something about the Orcs?"))
			set this.m_area = this.addInfo(true, false, 0, thistype.infoActionArea, tr("Was weißt du über die Gegend hier?"))
			set this.m_iHaveMushrooms = this.addInfo(true, false, thistype.infoConditionIHaveMushrooms, thistype.infoActionIHaveMushrooms, tre("Ich habe hier einen Pilz.", "I have one mushroom."))
			set this.m_spell = this.addInfo(false, false, thistype.infoConditionSpell, thistype.infoActionSpell, tre("Hier ist dein Zauberspruch.", "Here is your spell."))
			set this.m_wood = this.addInfo(false, false, thistype.infoConditionWood, thistype.infoActionWood, tre("Hier ist dein Holz.", "Here is your wood."))
			set this.m_apprentice = this.addInfo(false, false, thistype.infoConditionApprentice, thistype.infoActionApprentice, tr("Suchst du einen Schüler?"))
			set this.m_arrows = this.addInfo(false, false, thistype.infoConditionArrows, thistype.infoActionArrows, tr("Kannst du Pfeile herstellen?"))
			set this.m_exit = this.addExitButton()

			// info 1
			set this.m_whatKindOfMushrooms = this.addInfo(false, false, 0, thistype.infoActionCastle_WhatKindOfMushrooms, tr("Was denn für Pilze?"))
			set this.m_goodLuck = this.addInfo(false, false, 0, thistype.infoActionCastle_GoodLuck, tr("Na dann mal viel Spaß!"))

			// info 1_0
			set this.m_ofCourse = this.addInfo(false, false, 0, thistype.infoActionCastle_WhatKindOfMushrooms_Yes, tr("Klar."))
			set this.m_no = this.addInfo(false, false, 0, thistype.infoActionCastle_WhatKindOfMushrooms_No, tr("Nein."))

			return this
		endmethod
	endstruct

endlibrary