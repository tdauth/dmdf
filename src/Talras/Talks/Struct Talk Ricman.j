library StructMapTalksTalkRicman requires Asl, StructGameCharacter, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestTheWayToHolzbruck

	struct TalkRicman extends ATalk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (this.infoHasBeenShownToCharacter(0, character) or not this.showInfo(0, character)) then
				call this.showRange(1, 8, character)
			endif
		endmethod

		// (Falls der Auftrag „Die Nordmänner“ noch nicht erhalten wurde)
		private static method infoCondition0And1 takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Automatisch
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("He, was machst du hier?"), null)
			call speech(info, character, false, tr("Ich sehe mich nur ein wenig um."), null)
			call speech(info, character, true, tr("Bring nichts durcheinander und komm erst gar nicht auf die unendlich dumme Idee, etwas zu stehlen!"), null)
			call speech(info, character, false, tr("Ich doch nicht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin Ricman."), null)
			call info.talk().showInfo(9, character)
			call info.talk().show(character.player())
		endmethod

		// Was ist das für ein großer Speer?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was ist das für ein großer Speer?"), null)
			call speech(info, character, true, tr("Ein Erbstück meiner Familie. Damit wurden schon viele Orks getötet aber leider nur wenige Dunkelelfen."), null)
			call speech(info, character, false, tr("Du magst Dunkelelfen wohl nicht besonders?"), null)
			call speech(info, character, true, tr("Diese Orks sind hirnlose Bestien. Stark wie Bären, aber dumm. Dunkelefen sind gerissene, geschickte Krieger. Vor ihnen solltest du dich in Acht nehmen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Handelst du auch mit irgendwas?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Handelst du auch mit irgendwas?"), null)
			call speech(info, character, true, tr("Selbstverständlich. Wigberht hat mich dazu beauftragt, unsere Waren zu einem angemessenen Preis zu verkaufen oder gegen andere Gegenstände zu tauschen."), null)
			call speech(info, character, true, tr("Ich habe Felle, Fleisch, Waffen, Helme und Rüstungen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Nordmänner“ wurde erhalten)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return not QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Was werdet ihr nun tun?
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was werdet ihr nun tun?"), null)
			// (Auftragsziel 2 des Auftrags „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().questItem(1).isNew()) then
				call speech(info, character, true, tr("Wir, du meinst wir. Wir ziehen gemeinsam in den Kampf, sobald ihr bereit seid. Ich kann es gar nicht erwarten, die Hundesöhne zu schlachten."), null)
				call speech(info, character, true, tr("Und falls ihr das Gemetzel überleben solltet, unterstützen wir den Herzog vermutlich noch eine Weile, damit er sich nicht in sein Seidengewand scheißt, der alte Hurenbock!"), null)
			// (Auftrag „Die Nordmänner“ ist abgeschlossen)
			elseif (not QuestTheWayToHolzbruck.quest().isCompleted()) then
				call speech(info, character, true, tr("Wie versprochen werden wir den Herzog unterstützen. Das bedeutet, wir werden unsere Zeit vorerst damit verbringen uns im Kampf zu üben."), null)
				call speech(info, character, false, tr("Klingt ja spannend."), null)
				call speech(info, character, true, tr("Hältst es wohl für besser, wenn uns eine von diesen Bestien abschlachtet, was? Schon gut. Ihr habt ja euren Beitrag geleistet. Ich muss zugeben, euch unterschätzt zu haben."), null)
				call speech(info, character, true, tr("Aber ich wette, der alte Sack in der Burg besteigt gerade eine seiner Mägde anstatt sein Schwert zu suchen."), null)
			// (Auftrag „Der Weg nach Holzbruck“ ist abgeschlossen)
			else
				call speech(info, character, true, tr("Sieht so aus als würden wir gemeinsam den Fluss entlang fahren, in Richtung Norden. Der Gedanke daran gefällt mir immer besser."), null)
				call speech(info, character, true, tr("Wir kommen dem Feind endlich näher und somit auch meines Herrn Vaters, unseres Königs. Ihr solltet euch gut vorbereiten. Wer weiß, was uns in Holzbruck erwartet."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Nordmänner“ ist abgeschlossen)
		private static method infoCondition5And6 takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isCompleted()
		endmethod

		// Du hast tapfer gekämpft!
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du hast tapfer gekämpft!"), null)
			call speech(info, character, true, tr("Nun übertreib mal nicht, sonst steigt mir das noch zu Kopf!"), null)
			call speech(info, character, true, tr("Mein Herr, Wigberht, der hat wahrlich tapfer gekämpft. An ihm solltet ihr euch ein Beispiel nehmen, wenn ihr den nächsten Winter in diesem Reich von Feiglingen überleben wollt!"), null)
			call info.talk().showStartPage(character)
		endmethod


		// Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false ,tr("Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?"), null)
			// (Charakter ist Drachentöter)
			if (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, true, tr("Natürlich. Gib mir ein paar Goldmünzen und ich zeige dir ein paar nette Tricks!"), null)
			// (Charakter ist kein Drachentöter)
			else
				call speech(info, character, true, tr("Tut mir leid, aber ich lehre nur wahre Krieger."), null)
				// (Charakter ist Geistlicher)
				if (Classes.isChaplain(character.class())) then
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so etwas wie ein Gläubiger zu sein, der auf seine Gebete vertraut."), null)
				// (Charakter ist Ritter)
				elseif (character.class() == Classes.knight()) then
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so eine Art Idealist zu sein. Scher dich lieber weg! Ritter sind bei mir nicht gerade beliebt. Das gilt auch für ehemalige."), null)
				// (Charakter ist Waldläufer)
				elseif (character.class() == Classes.ranger()) then
					call speech(info, character, true, tr("Du aber scheinst mir zwar ein guter Jäger und Naturfreund zu sein, aber meine Kampfkunst ist mehr was für starke Kerle, die keine Angst vor dem Tod oder Schmerzen haben."), null)
				// (Charakter ist Magier)
				else
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so etwas wie ein Zauberer zu sein, der auf seine Zauberkunst anstatt auf eine gute Klinge oder einen starken Speer vertraut."), null)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter ist Drachentöter und hat bereits danach gefragt)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return character.class() == Classes.dragonSlayer() and info.talk().infoHasBeenShownToCharacter(6, character)
		endmethod

		// Bring mir etwas bei!
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Bring mir etwas bei!"), null)
			call speech(info, character, false, tr("Klar, wenn du genügend Goldmünzen dabei hast."), null)
			call info.talk().showRange(10, 13, character)
		endmethod

		// Und was machst du hier?
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Und was machst du hier?"), null)
			call speech(info, character, true, tr("Ich warte."), null)
			// (Falls der Charakter Wigberht das Gleiche gefragt hat)
			if (TalkWigberht.talk.evaluate().infoHasBeenShownToCharacter(12, character)) then
				call speech(info, character, false, tr("Warten alle Nordmänner auf irgendetwas?"), null)
				call speech(info, character, true, tr("Anscheinend."), null)
			// (Falls der Charakter Wigberht noch nicht das Gleiche gefragt hat)
			else
				call speech(info, character, false, tr("Und worauf?"), null)
				call speech(info, character, true, tr("Auf einen netten Dunkelelf, dem ich dann seine Eingeweide herausreiße."), null)
				call speech(info, character, false, tr("Klingt spannend."), null)
				call speech(info, character, true, tr("Ist es auch."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		private static method teachAbility takes AInfo info, ACharacter character, integer gold, integer skillPoints, integer abilityId returns boolean
			// (Charakter hat nicht genügend Goldmünzen)
			if (character.gold() < gold) then
				call speech(info, character, true, tr("Willst du mich verarschen? Besorg dir erstmal ein paar Goldmünzen!"), null)
				return false
			endif

			// (Charakter hat nicht genügend Zauberpunkte)
			if (character.skillPoints() < skillPoints) then
				call speech(info, character, true, tr("Tut mir leid, aber dir fehlt es noch an Erfahrung."), null)
				return false
			endif

			call UnitAddAbility(character.unit(), abilityId)
			call character.removeGold(gold)
			call character.removeSkillPoints(skillPoints)
			call speech(info, character, true, tr("Also ..."), null)

			return true
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoCondition7_0 takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07K') == 0
		endmethod

		// Fette Beute (200 Goldmünzen, 1 Zauberpunkt)
		private static method infoAction7_0 takes AInfo info, ACharacter character returns nothing
			if (thistype.teachAbility(info, character, 200, 1, 'A07K')) then
				call speech(info, character, true, tr("Besorg dir einfach mehr Goldmünzen! Ohne die kannst du dir keine anständige Ausrüstung kaufen und ohne anständige Ausrüstung geht überhaupt nichts."), null)
				call speech(info, character, true, tr("Stell dir mal vor, wir würden unseren Feinden ohne Waffen entgegentreten!"), null)
			endif
			call info.talk().showRange(10, 13, character)
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoCondition7_1 takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07J') == 0
		endmethod

		// Nordische Wucht (500 Goldmünzen, 1 Zauberpunkt)
		private static method infoAction7_1 takes AInfo info, ACharacter character returns nothing
			if (thistype.teachAbility(info, character, 500, 1, 'A07J')) then
				call speech(info, character, true, tr("Versuche in Zukunft nicht nur einen Gegner mit deiner Waffe zu verwunden. Wenn du weit genug ausholst, erwischt du meistens auch noch ein paar andere mit, vorausgesetzt du bist stark genug."), null)
			endif
			call info.talk().showRange(10, 13, character)
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoCondition7_2 takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07I') == 0
		endmethod

		// Erster Mann (1000 Goldmünzen, 1 Zauberpunkt)
		private static method infoAction7_2 takes AInfo info, ACharacter character returns nothing
			if (thistype.teachAbility(info, character, 1000, 1, 'A07I')) then
				call speech(info, character, true, tr("Zeige mehr Mut, denn Mut ist der Schlüssel zum Sieg! Solange du Mut nicht mit blinder Wut oder völliger Furchtlosigkeit verwechselst, wirst du meist als Sieger aus Kämpfen hervorgehen."), null)
				call speech(info, character, true, tr("Mut bedeutet nicht, niemals Furcht zu haben, sondern die Furcht zu überwinden. Bist du mutig, sind es deine Gefährten auch und ihr werdet allesamt stärker und zur unüberwindbaren Streitmacht werden."), null)
			endif
			call info.talk().showRange(10, 13, character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ricman(), thistype.startPageAction)

			// start page
			call this.addInfo(false, true, thistype.infoCondition0And1, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, thistype.infoCondition0And1, thistype.infoAction1, tr("Wer bist du?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("Was ist das für ein großer Speer?")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Handelst du auch mit irgendwas?")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tr("Was werdet ihr nun tun?")) // 4

			call this.addInfo(false, false, thistype.infoCondition5And6, thistype.infoAction5, tr("Du hast tapfer gekämpft! ")) // 5
			call this.addInfo(false, false, thistype.infoCondition5And6, thistype.infoAction6, tr("Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?")) // 6
			call this.addInfo(true, false, thistype.infoCondition7, thistype.infoAction7, tr("Bring mir etwas bei!")) // 7
			call this.addExitButton() // 8

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Und was machst du hier?")) // 9

			// info 7
			call this.addInfo(true, false, thistype.infoCondition7_0, thistype.infoAction7_0, tr("Fette Beute (200 Goldmünzen, 1 Zauberpunkt)")) // 10
			call this.addInfo(true, false, 0, thistype.infoAction7_1, tr("Nordische Wucht (500 Goldmünzen, 1 Zauberpunkt)")) // 11
			call this.addInfo(true, false, 0, thistype.infoAction7_2, tr("Erster Mann (1000 Goldmünzen, 1 Zauberpunkt)")) // 12
			call this.addBackToStartPageButton()  // 13

			return this
		endmethod
	endstruct

endlibrary