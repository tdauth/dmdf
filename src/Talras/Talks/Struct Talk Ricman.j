library StructMapTalksTalkRicman requires Asl, StructGameCharacter, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestTheWayToHolzbruck

	struct TalkRicman extends ATalk

		implement Talk
		
		private AInfo m_hi
		private AInfo m_whoAreYou
		private AInfo m_whatAreYouDoing
		private AInfo m_aboutYourWeapon
		private AInfo m_trade
		private AInfo m_whatAreWeGoingToDoNow
		private AInfo m_weWon
		private AInfo m_summonedDragon
		private AInfo m_rideDragon
		private AInfo m_dragonEggs
		private AInfo m_canYouTeachMe
		private AInfo m_teachMe
		private AInfo m_exit
		
		private AInfo m_teachMeFetteBeute
		private AInfo m_teachMeNordischeWucht
		private AInfo m_teachMeFirstMan
		private AInfo m_teachMeBack

		private method startPageAction takes ACharacter character returns nothing
			if (this.infoHasBeenShownToCharacter(this.m_hi.index(), character) or not this.showInfo(this.m_hi.index(), character)) then
				call this.showRange(this.m_whoAreYou.index(), this.m_exit.index(), character)
			endif
		endmethod

		// (Falls der Auftrag „Die Nordmänner“ noch nicht erhalten wurde)
		private static method infoConditionHi takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Automatisch
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("He, was machst du hier?"), gg_snd_Ricman1)
			call speech(info, character, false, tr("Ich sehe mich nur ein wenig um."), null)
			call speech(info, character, true, tr("Bring nichts durcheinander und komm erst gar nicht auf die unendlich dumme Idee, etwas zu stehlen!"), gg_snd_Ricman2)
			call speech(info, character, false, tr("Ich doch nicht."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Falls der Auftrag „Die Nordmänner“ noch nicht erhalten wurde)
		private static method infoConditionWhoAreYou takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Wer bist du?
		private static method infoActionWhoAreYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin Ricman."), gg_snd_Ricman3)
			call info.talk().showStartPage(character)
		endmethod
		
		public method askedWhatAreYoDoing takes ACharacter character returns boolean
			return this.infoHasBeenShownToCharacter(this.m_whatAreYouDoing.index(), character)
		endmethod
		
		// (Falls der Auftrag „Die Nordmänner“ noch nicht erhalten wurde)
		private static method infoConditionWhatAreDoingHere takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Was machst du hier?
		private static method infoActionWhatAreYouDoingHere takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du hier?"), null)
			call speech(info, character, true, tr("Ich warte."), gg_snd_Ricman4)
			// (Falls der Charakter Wigberht das Gleiche gefragt hat)
			if (TalkWigberht.talk.evaluate().askedWhatAreYoDoing.evaluate(character)) then
				call speech(info, character, false, tr("Warten alle Nordmänner auf irgendetwas?"), null)
				call speech(info, character, true, tr("Anscheinend."), gg_snd_Ricman5)
			// (Falls der Charakter Wigberht noch nicht das Gleiche gefragt hat)
			else
				call speech(info, character, false, tr("Und worauf?"), null)
				call speech(info, character, true, tr("Auf einen Dunkelelf, dem ich dann seine Eingeweide herausreiße."), gg_snd_Ricman6)
				call speech(info, character, false, tr("Interessant."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Was ist das für ein großer Hammer?
		private static method infoActionAboutYourWeapon takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was ist das für ein großer Hammer?"), null)
			call speech(info, character, true, tr("Ein Erbstück meiner Familie. Damit wurden schon viele Orks getötet, aber leider nur wenige Dunkelelfen."), gg_snd_Ricman7)
			call speech(info, character, false, tr("Du magst Dunkelelfen wohl nicht besonders?"), null)
			call speech(info, character, true, tr("Diese Orks sind hirnlose Bestien. Stark wie Bären, aber dumm. Dunkelefen dagegen sind gerissene, geschickte Krieger. Vor ihnen solltest du dich in Acht nehmen!"), gg_snd_Ricman8)
			call info.talk().showStartPage(character)
		endmethod

		// Handelst du auch mit irgendwas?
		private static method infoActionTrade takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Handelst du auch mit irgendwas?"), null)
			call speech(info, character, true, tr("Selbstverständlich. Wigberht hat mich dazu beauftragt, unsere Waren zu einem angemessenen Preis zu verkaufen oder gegen andere Gegenstände zu tauschen."), gg_snd_Ricman9)
			call speech(info, character, true, tr("Ich habe Felle, Fleisch, Waffen, Helme und Rüstungen."), gg_snd_Ricman10)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Nordmänner“ wurde erhalten)
		private static method infoConditionWhatAreYouGoingToDo takes AInfo info, ACharacter character returns boolean
			return not QuestTheNorsemen.quest().isNotUsed()
		endmethod

		// Was werdet ihr nun tun?
		private static method infoActionWhatAreYouGoingToDo takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was werdet ihr nun tun?"), null)
			// (Auftragsziel 2 des Auftrags „Die Nordmänner“ ist aktiv) 
			if (QuestTheNorsemen.quest().questItem(1).isNew()) then
				call speech(info, character, true, tr("Wir, du meinst wir. Wir ziehen gemeinsam in den Kampf, sobald ihr bereit seid. Ich kann es gar nicht erwarten, die Hundesöhne zu schlachten."), gg_snd_Ricman14)
				call speech(info, character, true, tr("Und falls ihr das Gemetzel überleben solltet, unterstützen wir den Herzog vermutlich noch eine Weile, damit er sich nicht in sein Seidengewand scheißt, der alte Hurenbock!"), gg_snd_Ricman15)
			// (Auftragsziel 2 des Auftrags „Die Nordmänner“ ist abgeschlossen) 
			elseif (QuestTheNorsemen.quest().questItem(1).isCompleted()) then
				call speech(info, character, true, tr("Wie versprochen werden wir den Herzog unterstützen. Das bedeutet, wir werden unsere Zeit vorerst damit verbringen uns im Kampf zu üben."), gg_snd_Ricman11)
			// (Auftrag „Der Weg nach Holzbruck“ ist abgeschlossen)
			else
				call speech(info, character, true, tr("Sieht so aus als würden wir gemeinsam den Fluss entlang fahren, in Richtung Norden. Der Gedanke daran gefällt mir immer besser."), gg_snd_Ricman12)
				call speech(info, character, true, tr("Wir kommen dem Feind endlich näher und somit auch Wigberths Vater, unseres Königs. Ihr solltet euch gut vorbereiten. Wer weiß, was uns in Holzbruck erwartet?"), null)
			endif
			// TODO
			// gg_snd_Ricman13
			call info.talk().showStartPage(character)
		endmethod

		//  (Auftragsziel 2 des Auftrags „Die Nordmänner“ ist abgeschlossen)
		private static method infoConditionWeWon takes AInfo info, ACharacter character returns boolean
			return QuestTheNorsemen.quest().questItem(1).isCompleted()
		endmethod

		// Wir haben gesiegt.
		private static method infoActionWeWon takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Wir haben gesiegt."), null)
			call speech(info, character, true, tr("Das haben wir und ihr habt euch tapfer geschlagen. Dennoch war es nur eine kleine Vorhut."), gg_snd_Ricman16)
			call speech(info, character, true, tr("Wir müssen uns gut vorbereiten wenn wir das Heer der Orks und Dunkelelfen schlagen wollen."), gg_snd_Ricman17)
			call speech(info, character, true, tr("Zum Dank für deine Dienste möchte ich dir diesen mächtigen Stab überreichen."), gg_snd_Ricman18)
			call speech(info, character, true, tr("Er stammt aus einer alten Festung weit oben im Norden. Man sagt ein Magier habe ihn geschaffen, der einst die Drachen beherrschte."), gg_snd_Ricman19)
			call speech(info, character, true, tr("Ich hoffe er wird dir von großem Nutzen sein. Der Legende nach kann man mit diesem Stab einen gezähmten Drachen beschwören, es handelt sich jedoch nur um ein Gerücht."), gg_snd_Ricman20)
			call speech(info, character, true, tr("Probiere ihn doch einmal aus und berichte mir dann, ob es funktioniert."), gg_snd_Ricman21)
			// Stab der Unsterblichkeit erhalten
			call character.giveQuestItem('I010')
			// Neuer Auftrag „Der gezähmte Drache“
			call QuestTheDragon.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Der gezähmte Drache“ ist abgeschlossen und Auftragsziel 2 ist aktiv)
		private static method infoConditionSummonedDragon takes AInfo info, ACharacter character returns boolean
			return QuestTheDragon.characterQuest(character).questItem(0).isCompleted() and QuestTheDragon.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe einen gezähmten Drachen beschworen.
		private static method infoActionSummonedDragon takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ich habe einen gezähmten Drachen beschworen."), null)
			call speech(info, character, true, tr("Tatsächlich? Unglaublich dass es funktioniert hat."), gg_snd_Ricman22)
			call speech(info, character, true, tr("Du musst wissen, in den alten Legenden heißt es weiter, dass der Magier sogar auf den Drachen geritten ist, um dort hin zu gelangen wo auch immer er hin wollte."), gg_snd_Ricman23)
			call speech(info, character, true, tr("Probiere das doch einmal aus."), gg_snd_Ricman24)
			// Auftragsziel 2 des Auftrags „Der gezähmte Drache“ abgeschlossen
			call QuestTheDragon.characterQuest(character).questItem(1).setState(AAbstractQuest.stateCompleted)
			// Auftragsziele 3 und 4 des Auftrags „Der gezähmte Drache“ aktiviert
			call QuestTheDragon.characterQuest(character).questItem(2).setState(AAbstractQuest.stateNew)
			call QuestTheDragon.characterQuest(character).questItem(3).setState(AAbstractQuest.stateNew)
			call QuestTheDragon.characterQuest(character).displayState()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 3 des Auftrags „Der gezähmte Drache“ ist abgeschlossen und Auftragsziel 4 ist aktiv)
		private static method infoConditionRideDragon takes AInfo info, ACharacter character returns boolean
			return QuestTheDragon.characterQuest(character).questItem(2).isCompleted() and QuestTheDragon.characterQuest(character).questItem(3).isNew()
		endmethod

		// Ich bin auf dem Drachen geritten.
		private static method infoActionRideDragon takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ich bin auf dem Drachen geritten."), null)
			call speech(info, character, true, tr("Das wird ja immer besser! Jetzt kommen wir aber zu meinem eigentlichen Anliegen."), gg_snd_Ricman25)
			call speech(info, character, true, tr("Ich muss zugeben dich ausgenutzt zu haben, ich selbst hätte es nicht gewagt einen Drachen herbeizurufen geschweigedenn auf seinen Rücken zu steigen."), gg_snd_Ricman26)
			call speech(info, character, true, tr("Bevor wir uns nach Talras aufmachten habe ich die Geschichte dieser Gegend in alten Schriften studiert."), gg_snd_Ricman27) // TODO Falsche aufnahme
			call speech(info, character, true, tr("Vor langer langer Zeit sollen auch hier noch Drachen gelebt haben. Vielleicht kannst du mit Hilfe des Drachens einen verlassenen Drachenhorst ausfindig machen."), gg_snd_Ricman28)
			call speech(info, character, true, tr("Vielleicht gibt es dort sogar noch Dracheneier. Wenn sie nicht ausgebrütet wurden, müssten sie noch gut erhalten sein. Ein Drachenei kann unbeschadet die Ewigkeit überdauern."), gg_snd_Ricman29)
			// Auftragsziel 4 des Auftrags „Der gezähmte Drache“ abgeschlossen
			call QuestTheDragon.characterQuest(character).questItem(3).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 5 des Auftrags „Der gezähmte Drache“ aktiviert
			call QuestTheDragon.characterQuest(character).questItem(4).setState(AAbstractQuest.stateNew)
			call QuestTheDragon.characterQuest(character).displayState()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 6 des Auftrags „Der gezähmte Drache“ ist aktiv, Charakter hat Dracheneier dabei)
		private static method infoConditionDragonEggs takes AInfo info, ACharacter character returns boolean
			return QuestTheDragon.characterQuest(character).questItem(5).isNew() and character.inventory().hasItemType('I03Z')
		endmethod

		// Hier sind einige Dracheneier.
		private static method infoActionDragonEggs takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Hier sind einige Dracheneier."), null)
			
			call speech(info, character, true, tr("Bei den Göttern, das gibt es doch nicht! Du hast tatsächlich Dracheneier dabei! Weißt du eigentlich wie viel die Wert sind?"), gg_snd_Ricman30)
			call speech(info, character, true, tr("Unbezahlbar sind die, das kann ich dir sagen. Pass auf, lass sie mich für dich verwahren. Ich gebe dir zum Dank auch eine wertvolle Belohnung."), gg_snd_Ricman31)
			call speech(info, character, false, tr("Na gut, hier hast du sie."), null)
			// Dracheneier übergeben
			call character.inventory().removeItemType('I03Z')
			call speech(info, character, true, tr("Vielen Dank, das werde ich dir nicht vergessen!"), gg_snd_Ricman32)
			// Auftrag „Der gezähmte Drache“ abgeschlossen
			call QuestTheDragon.characterQuest(character).complete()
			// Drachenfeuer erhalten
			call character.giveItem('I040')
			call info.talk().showStartPage(character)
		endmethod

		// Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?
		private static method infoActionCanYouTeachMe takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false ,tr("Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?"), null)
			// (Charakter ist Drachentöter)
			if (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, true, tr("Du bist ein Drachentöter, ein wahrer Krieger. Gib mir ein paar Goldmünzen und ich zeige dir ein paar nette Tricks!"), gg_snd_Ricman33)
			// (Charakter ist kein Drachentöter)
			else
				call speech(info, character, true, tr("Tut mir leid, aber ich lehre nur wahre Krieger."), gg_snd_Ricman34)
				// (Charakter ist Geistlicher)
				if (Classes.isChaplain(character.class())) then
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so etwas wie ein Gläubiger zu sein, der auf seine Gebete vertraut."), gg_snd_Ricman35)
				// (Charakter ist Ritter)
				elseif (character.class() == Classes.knight()) then
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so eine Art Idealist zu sein. Scher dich lieber weg! Ritter sind bei mir nicht gerade beliebt. Das gilt auch für ehemalige."), gg_snd_Ricman36)
				// (Charakter ist Waldläufer)
				elseif (character.class() == Classes.ranger()) then
					call speech(info, character, true, tr("Du aber scheinst mir zwar ein guter Jäger und Naturfreund zu sein, aber meine Kampfkunst ist mehr was für starke Kerle, die keine Angst vor dem Tod oder Schmerzen haben."), gg_snd_Ricman37) // TODO falscher sound
				// (Charakter ist Magier)
				else
					call speech(info, character, true, tr("Du aber scheinst mir wohl eher so etwas wie ein Zauberer zu sein, der auf seine Zauberkunst anstatt auf eine gute Klinge oder einen starken Speer vertraut."), gg_snd_Ricman38)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter ist Drachentöter und hat bereits danach gefragt)
		private static method infoConditionTeachMe takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return character.class() == Classes.dragonSlayer() and info.talk().infoHasBeenShownToCharacter(this.m_canYouTeachMe.index(), character)
		endmethod

		// Bring mir etwas bei!
		private static method infoActionTeachMe takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("Bring mir etwas bei!"), null)
			call speech(info, character, false, tr("Klar, wenn du genügend Goldmünzen dabei hast."), gg_snd_Ricman39)
			call info.talk().showRange(this.m_teachMeFetteBeute.index(), this.m_teachMeBack.index(), character)
		endmethod

		private static method teachAbility takes AInfo info, Character character, integer gold, integer skillPoints, integer abilityId returns boolean
			// (Charakter hat nicht genügend Goldmünzen)
			if (character.gold() < gold) then
				call speech(info, character, true, tr("Willst du mich verarschen? Besorge dir erst mal ein paar Goldmünzen!"), gg_snd_Ricman40)
				return false
			endif

			// (Charakter hat nicht genügend Zauberpunkte)
			if (character.grimoire().skillPoints() < skillPoints) then
				call speech(info, character, true, tr("Tut mir leid, aber dir fehlt es noch an Erfahrung."), gg_snd_Ricman41)
				debug call Print("Skill points " + I2S(skillPoints))
				debug call Print("Existing skill points " + I2S(character.grimoire().skillPoints()))
				return false
			endif

			call UnitAddAbility(character.unit(), abilityId)
			call character.removeGold(gold)
			call character.grimoire().removeSkillPoints(skillPoints)
			call speech(info, character, true, tr("Also ..."), gg_snd_Ricman42)

			return true
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoConditionTeachMeFetteBeute takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07K') == 0
		endmethod

		// Fette Beute (200 Goldmünzen, 1 Zauberpunkt)
		private static method infoActionTeachMeFetteBeute takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			if (thistype.teachAbility(info, character, 200, 1, 'A07K')) then
				call speech(info, character, true, tr("Besorg dir einfach mehr Goldmünzen! Ohne die kannst du dir keine anständige Ausrüstung kaufen und ohne anständige Ausrüstung geht überhaupt nichts."), gg_snd_Ricman43)
				call speech(info, character, true, tr("Stell dir mal vor, wir würden unseren Feinden ohne Waffen entgegentreten!"), gg_snd_Ricman44)
			endif
			call info.talk().showRange(this.m_teachMeFetteBeute.index(), this.m_teachMeBack.index(), character)
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoConditionTeachMeNordischeWucht takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07J') == 0
		endmethod

		// Nordische Wucht (500 Goldmünzen, 1 Zauberpunkt)
		private static method infoActionTeachMeNordischeWucht takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			if (thistype.teachAbility(info, character, 500, 1, 'A07J')) then
				call speech(info, character, true, tr("Versuche in Zukunft nicht nur einen Gegner mit deiner Waffe zu verwunden. Wenn du weit genug ausholst, erwischt du meistens auch noch ein paar andere mit, vorausgesetzt du bist stark genug."), gg_snd_Ricman46)
			endif
			call info.talk().showRange(this.m_teachMeFetteBeute.index(), this.m_teachMeBack.index(), character)
		endmethod

		// (Zauber wurde noch nicht erlernt)
		private static method infoConditionTeachMeFirstMan takes AInfo info, ACharacter character returns boolean
			return GetUnitAbilityLevel(character.unit(), 'A07I') == 0
		endmethod

		// Erster Mann (1000 Goldmünzen, 1 Zauberpunkt)
		private static method infoActionTeachMeFirstMan takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			if (thistype.teachAbility(info, character, 1000, 1, 'A07I')) then
				call speech(info, character, true, tr("Zeige mehr Mut, denn Mut ist der Schlüssel zum Sieg! Solange du Mut nicht mit blinder Wut oder völliger Furchtlosigkeit verwechselst, wirst du meist als Sieger aus Kämpfen hervorgehen."), gg_snd_Ricman48)
				call speech(info, character, true, tr("Mut bedeutet nicht, niemals Furcht zu haben, sondern die Furcht zu überwinden. Bist du mutig, sind es deine Gefährten auch und ihr werdet allesamt stärker und zur unüberwindbaren Streitmacht werden."), gg_snd_Ricman49)
			endif
			call info.talk().showRange(this.m_teachMeFetteBeute.index(), this.m_teachMeBack.index(), character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ricman(), thistype.startPageAction)
			call this.setName(tr("Ricman"))
			// start page
			set this.m_hi = this.addInfo(false, true, thistype.infoConditionHi, thistype.infoActionHi, null)
			set this.m_whoAreYou = this.addInfo(false, false, thistype.infoConditionWhoAreYou, thistype.infoActionWhoAreYou, tr("Wer bist du?"))
			set this.m_whatAreYouDoing = this.addInfo(false, false, thistype.infoConditionWhatAreDoingHere, thistype.infoActionWhatAreYouDoingHere, tr("Was machst du hier?"))
			set this.m_aboutYourWeapon = this.addInfo(false, false, 0, thistype.infoActionAboutYourWeapon, tr("Was ist das für ein großer Hammer?"))
			set this.m_trade = this.addInfo(false, false, 0, thistype.infoActionTrade, tr("Handelst du auch mit irgendwas?"))
			set this.m_whatAreWeGoingToDoNow = this.addInfo(true, false, thistype.infoConditionWhatAreYouGoingToDo, thistype.infoActionWhatAreYouGoingToDo, tr("Was werdet ihr nun tun?"))
			set this.m_weWon = this.addInfo(false, false, thistype.infoConditionWeWon, thistype.infoActionWeWon, tr("Wir haben gesiegt."))
			set this.m_summonedDragon = this.addInfo(false, false, thistype.infoConditionSummonedDragon, thistype.infoActionSummonedDragon, tr("Ich habe einen gezähmten Drachen beschworen."))
			set this.m_rideDragon = this.addInfo(false, false, thistype.infoConditionRideDragon, thistype.infoActionRideDragon, tr("Ich bin auf dem Drachen geritten."))
			set this.m_dragonEggs = this.addInfo(false, false, thistype.infoConditionDragonEggs, thistype.infoActionDragonEggs, tr("Hier sind einige Dracheneier."))
			set this.m_canYouTeachMe = this.addInfo(false, false, 0, thistype.infoActionCanYouTeachMe, tr("Kannst du mir vielleicht etwas von deiner Kampfkunst beibringen?"))
			set this.m_teachMe = this.addInfo(true, false, thistype.infoConditionTeachMe, thistype.infoActionTeachMe, tr("Bring mir etwas bei!"))
			set this.m_exit = this.addExitButton()

			// info teach me
			set this.m_teachMeFetteBeute = this.addInfo(true, false, thistype.infoConditionTeachMeFetteBeute, thistype.infoActionTeachMeFetteBeute, tr("Fette Beute (200 Goldmünzen, 1 Zauberpunkt)"))
			set this.m_teachMeNordischeWucht = this.addInfo(true, false, thistype.infoConditionTeachMeNordischeWucht, thistype.infoActionTeachMeNordischeWucht, tr("Nordische Wucht (500 Goldmünzen, 1 Zauberpunkt)"))
			set this.m_teachMeFirstMan = this.addInfo(true, false, thistype.infoConditionTeachMeFirstMan, thistype.infoActionTeachMeFirstMan, tr("Erster Mann (1000 Goldmünzen, 1 Zauberpunkt)"))
			set this.m_teachMeBack = this.addBackToStartPageButton()

			return this
		endmethod
	endstruct

endlibrary