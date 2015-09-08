library StructMapTalksTalkManfred requires Asl, StructMapMapNpcs, StructMapTalksTalkMathilda, StructMapQuestsQuestSupplyForTalras, StructMapQuestsQuestReinforcementForTalras

	struct TalkManfred extends Talk
	
		implement Talk
		
		private AInfo m_hi
		private AInfo m_aboutTheDuke
		private AInfo m_mathilda
		private AInfo m_talkedToFerdinand
		private AInfo m_markwardNeedsSupply
		private AInfo m_supply
		private AInfo m_lumber
		private AInfo m_exit
		
		private AInfo m_hi_Yes
		private AInfo m_hi_No
		
		private AInfo m_aboutTheDuke_Yes
		private AInfo m_aboutTheDuke_No

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Suchst du zufällig Arbeit?"), null)
			call this.showRange(this.m_hi_Yes.index(), this.m_hi_No.index(), character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAboutTheDuke takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi_Yes.index(), character)
		endmethod

		// Was hältst du vom Herzog?
		private static method infoActionAboutTheDuke takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Was hältst du vom Herzog?"), null)
			call speech(info, character, true, tr("Er hat dich doch nicht etwa geschickt oder? Sonst würde ich wohl meine Zunge hüten."), null)
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Na ja, eigentlich kann's mir auch egal sein. Ohne mich und meine Leute hat er kaum etwas zu essen und falls es zur Belagerung käme, würde er schon nach ein paar Tagen verhungern."), null)
			call speech(info, character, true, tr("Vor einer Weile waren seine Leute hier und haben sich nach der Ernte erkundigt. Ich wette, die nehmen sich einfach alles, wenn es hart auf hart kommt, aber mir bleibt keine Wahl."), null)
			call speech(info, character, true, tr("Ich hab mir das hier nach und nach aufgebaut. Meine Eltern waren hart arbeitende Leute und hatten kaum genug zum Leben. Eigentlich müsste ich mit dem zufrieden sein, was ich habe."), null)
			call speech(info, character, true, tr("Aber dieser verdammte Adel macht es einem ja nicht gerade leicht. Also, ich halte vom Herzog nicht allzu viel. Er sollte mir lieber mal ein paar Leute schicken, die auf meine Felder und Leute aufpassen, wenn es wirklich stimmt, dass der Feind schon recht nah ist."), null)
			call speech(info, character, true, tr("Am Ende lassen die uns wahrscheinlich nicht mal in die Burg. Der Herzog hat jetzt auch noch unseren Kriegsdienst auf ein Jahr eingefordert, falls der Feind hier aufkreuzt. Als ob ich nicht genug zu tun hätte."), null)
			call this.showRange(this.m_aboutTheDuke_Yes.index(), this.m_aboutTheDuke_No.index(), character)
		endmethod

		// (Nach Begrüßung und nachdem der Charakter mit Mathilda darüber gesprochen hat)
		private static method infoConditionMathilda takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character) and TalkMathilda.talk().toldThatSleepingInBarn(character)
		endmethod

		// Du lässt Mathilda in deiner Scheune pennen?
		private static method infoActionMathilda takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du lässt Mathilda in deiner Scheune pennen?"), null)
			call speech(info, character, true, tr("Klar, wieso nicht? Sie hat mir dafür auch schon ein paar wirklich gute Geschichten erzählt. Sonst gibt's hier ja keine Unterhaltung und für's Herumreisen fehlen mir die nötigen Goldmünzen und die Zeit."), null)
			call speech(info, character, true, tr("Außerdem ist sie doch wirklich nett. Dass musst du doch zugeben."), null)
			call speech(info, character, false, tr("Na ja ..."), null)
			call speech(info, character, true, tr("Komm schon. Meine Frau ist vor drei Jahren an irgend so einer Krankheit gestorben. Was weiß ich? Ist schon lange her, dass ich was mit einer hatte. Die Mathilda wär genau die Richtige."), null)
			call speech(info, character, true, tr("Zusammen könnten wir hier den Hof führen. Das wär doch was! (Lacht) Ich hab wohl zu viel gearbeitet. Na ja, nimm's nicht so ernst."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Schutz dem Volke“ abgeschlossen oder Auftrag „Zu den Waffen, Bauern!“ aktiv)
		private static method infoConditionTalkedToFerdinand takes AInfo info, ACharacter character returns boolean
			return QuestProtectThePeople.characterQuest(character).questItem(0).isCompleted() or QuestAmongTheWeaponsPeasants.characterQuest(character).isNew()
		endmethod

		// Ich habe mit dem Vogt gesprochen.
		private static method infoActionTalkedToFerdinand takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe mit dem Vogt gesprochen."), null)
			call speech(info, character, true, tr("Und?"), null)
			if (QuestProtectThePeople.characterQuest(character).questItem(0).isCompleted()) then
				call speech(info, character, false, tr("Er überlegt sich das mit dem Kriegsdienst nochmal und er wird ein paar Leute herschicken."), null)
				call speech(info, character, true, tr("Donnerwetter! Wie hast du das angestellt? Obwohl, ich frag besser nicht. Das sind gute Neuigkeiten, mein Freund!"), null)
				call speech(info, character, true, tr("Dafür werde ich dich auch gut entlohnen."), null)
				// Auftrag „Schutz dem Volke“ abgeschlossen.
				call QuestProtectThePeople.characterQuest(character).complete()
			// (Auftrag „Zu den Waffen, Bauern!“ aktiv)
			else
				call speech(info, character, false, tr("Sieht schlecht aus, Freundchen. Du wirst gefälligst deinen Kriegsdienst leisten und deine Leute ebenso oder ich reiß dir deine Eingeweide heraus und verfüttere deine Leute an den Feind."), null)
				call speech(info, character, false, tr("Und wegen den Leuten, die dein Hab und Gut bewachen sollen, wirst du dich auch nicht mehr beschweren, klar?"), null)
				call speech(info, character, true, tr("Oh Mann, komm mal wieder runter. Schon gut, ich ... ich denke, das geht schon in Ordnung."), null)
				call speech(info, character, false, tr("Das will ich auch hoffen."), null)
				// Auftragsziel 1 des Auftrags „Zu den Waffen, Bauern!“ abgeschlossen
				call QuestAmongTheWeaponsPeasants.characterQuest(character).questItem(0).complete()
			endif
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Die Versorgung von Talras“ ist aktiv und sonst keines)
		private static method infoConditionMarkwardNeedsSupply takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestSupplyForTalras.characterQuest(character).questItem(0).isNew()
		endmethod

		// Markward benötigt Vorräte in der Burg.
		private static method infoActionMarkwardNeedsSupply takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Markward benötigt Vorräte in der Burg."), null)
			call speech(info, character, true, tr("Ich habe es geahnt. Wie ich es vorausgesagt habe, wir werden nun unserer hart erbrachten Ernte beraubt."), null)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Gut ich sage lieber nichts mehr, am Ende werde ich noch eingesperrt. Wenn du schon Vorräte haben willst, dann sammle sie selbst ein und bringe sie zu mir. Ich schicke sie dann zur Burg."), null)
			call speech(info, character, false, tr("Und wo sind die Vorräte?"), null)
			call speech(info, character, true, tr("Du kannst einen entsprechenden Teil von Guntrichs Mühle und in der Scheune mitnehmen, aber lass uns doch noch etwas übrig."), null)
			call speech(info, character, true, tr("Wer weiß ob wir hier am Ende auf uns allein gestellt sind."), null)
			// Auftragsziele 2, 3 und 4 des Auftrags „Die Versorgung von Talras“ aktiviert
			call QuestSupplyForTalras.characterQuest(character).questItem(1).setState(AAbstractQuest.stateNew)
			call QuestSupplyForTalras.characterQuest(character).questItem(2).setState(AAbstractQuest.stateNew)
			call QuestSupplyForTalras.characterQuest(character).questItem(3).setState(AAbstractQuest.stateNew)
			call QuestSupplyForTalras.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod
		
		
		// (Charakter hat alle Vorräte im Inventar)
		private static method infoConditionSupply takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return character.inventory().hasItemType('I03S') and character.inventory().hasItemType('I03T')
		endmethod

		// Hier sind die Vorräte.
		private static method infoActionSupply takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier sind die Vorräte."), null)
			call speech(info, character, true, tr("Da hast du aber auch nicht gerade gespart. Na wie du meinst … ich schicke sie nun zur Burg. Du kannst Markward berichten, dass sie unterwegs sind."), null)
			// Gegenstände entfernen
			call character.inventory().removeItemType('I03S')
			call character.inventory().removeItemType('I03T')
			// Auftragsziele 1 und 4 des Auftrags „Die Versorgung von Talras“ abgeschlossen
			call QuestSupplyForTalras.characterQuest(character).questItem(0).setState(AAbstractQuest.stateCompleted)
			call QuestSupplyForTalras.characterQuest(character).questItem(3).setState(AAbstractQuest.stateCompleted)
			call QuestSupplyForTalras.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 2 des Auftrags „Die Befestigung von Talras“ ist aktiv und Charakter hat das Holz dabei)
		private static method infoConditionLumber takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestReinforcementForTalras.characterQuest(character).questItem(1).isNew() and character.inventory().hasItemType('I051')
		endmethod

		// Bring dieses Holz zur Burg.
		private static method infoActionLumber takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bring dieses Holz zur Burg."), null)
			call speech(info, character, true, tr("Was?! Was erlaubst du dir?"), null)
			call speech(info, character, false, tr("Markward benötigt das Holz für die Burg. Es stammt von Kuno und der hat mir gesagt du würdest es zur Burg schaffen."), null)
			call speech(info, character, true, tr("Kuno? Verdammt, na gut. Kuno ist ein netter Kerl und verkauft uns immer gute Waren. Aber dieser Markward meint wohl wir machen die ganze Drecksarbeit für ihn."), null)
			call speech(info, character, true, tr("Wenn die Orks und Dunkelelfen hier einfallen, gehen wir doch als erste drauf, das kann ich dir versichern …"), null)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Schon gut ich schicke das Holz zur Burg, gib schon her!"), null)
			// Charakter verliert Kunos Holz
			call character.inventory().removeItemType('I051')
			// Auftragsziel 1 des Auftrags „Die Befestigung von Talras“ abgeschlossen
			call QuestReinforcementForTalras.characterQuest(character).questItem(0).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 2 des Auftrags „Die Befestigung von Talras“ abgeschlossen
			call QuestReinforcementForTalras.characterQuest(character).questItem(1).setState(AAbstractQuest.stateCompleted)
			call QuestReinforcementForTalras.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod

		// Ja.
		private static method infoActionHi_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Gut, ich kann jeden Helfer gebrauchen. Falls du also Lust hast, dir ein paar Goldmünzen dazuzuverdienen, dann melde dich einfach bei mir."), null)
			call speech(info, character, true, tr("Gerade ist Erntezeit und da kann man nicht genug Leute haben. Ich will ja schließlich noch ernten, bevor unser Feind hier auftaucht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Schade. In diesen harten Zeiten findet man nur noch selten Leute, die Arbeit suchen."), null)
			call speech(info, character, true, tr("Die Meisten wollen doch sowieso nur weg von der Grenze. Krieg, Krieg, das ist das Einzige, was sie noch interessiert. Aber ich muss meinen Hof führen. Die Leute in der Burg brauchen ja auch was zu beißen."), null)
			call speech(info, character, true, tr("Aber auf uns Bauern wird sowieso nur rumgehackt, dabei lastet auf uns der ganze Rest."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Ich kümmere mich drum.
		private static method infoActionAboutTheDuke_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich kümmere mich drum."), null)
			call speech(info, character, true, tr("Wirklich? Das würdest du tun? Du musst mit dem Vogt in der Burg sprechen. Ferdinand ist sein Name. Ich war schon mal bei ihm, aber hat mich abgewiesen."), null)
			call speech(info, character, true, tr("Verdammter Arschkriecher des Herzogs. Der Sack sitzt in der Burg mit ihren dicken Mauern und bekommt ne Menge Goldmünzen für's Faulenzen."), null)
			call speech(info, character, true, tr("Lass dich nicht von ihm unterkriegen!"), null)
			call QuestProtectThePeople.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Wirst schon nicht draufgehen.
		private static method infoActionAboutTheDuke_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wirst schon nicht draufgehen."), null)
			call speech(info, character, true, tr("Hmm, wenn nicht ich, dann ein anderer. Das ist auch nicht viel besser. Ich wünschte, der Krieg wäre schon vorbei und wir würden gemeinsam etwas Neues aufbauen. Eine Welt ohne Adel, in der jeder nach seiner wirklichen Leistung beurteilt werden würde."), null)
			call speech(info, character, true, tr("Ich wette, in einer solchen Welt wäre das Ansehen des Herzogs ganz unten."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.manfred(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo.")) // 0
			set this.m_aboutTheDuke = this.addInfo(false, false, thistype.infoConditionAboutTheDuke, thistype.infoActionAboutTheDuke, tr("Was hältst du vom Herzog?"))
			set this.m_mathilda = this.addInfo(false, false, thistype.infoConditionMathilda, thistype.infoActionMathilda, tr("Du lässt Mathilda in deiner Scheune pennen?"))
			set this.m_talkedToFerdinand = this.addInfo(false, false, thistype.infoConditionTalkedToFerdinand, thistype.infoActionTalkedToFerdinand, tr("Ich habe mit dem Vogt gesprochen."))
			set this.m_markwardNeedsSupply = this.addInfo(false, false, thistype.infoConditionMarkwardNeedsSupply, thistype.infoActionMarkwardNeedsSupply, tr("Markward benötigt Vorräte in der Burg."))
			set this.m_supply = this.addInfo(false, false, thistype.infoConditionSupply, thistype.infoActionSupply, tr("Hier sind die Vorräte."))
			set this.m_lumber = this.addInfo(false, false, thistype.infoConditionLumber, thistype.infoActionLumber, tr("Bring dieses Holz zur Burg."))
			set this.m_exit = this.addExitButton()

			// info 0
			set this.m_hi_Yes = this.addInfo(false, false, 0, thistype.infoActionHi_Yes, tr("Ja."))
			set this.m_hi_No = this.addInfo(false, false, 0, thistype.infoActionHi_No, tr("Nein."))

			// info 1
			set this.m_aboutTheDuke_Yes = this.addInfo(false, false, 0, thistype.infoActionAboutTheDuke_Yes, tr("Ich kümmere mich drum."))
			set this.m_aboutTheDuke_No = this.addInfo(false, false, 0, thistype.infoActionAboutTheDuke_No, tr("Wirst schon nicht draufgehen."))

			return this
		endmethod
	endstruct

endlibrary