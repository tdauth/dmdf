library StructMapTalksTalkManfred requires Asl, StructMapMapNpcs, StructMapTalksTalkMathilda, StructMapQuestsQuestSupplyForTalras, StructMapQuestsQuestReinforcementForTalras

	struct TalkManfred extends Talk
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
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo. Suchst du zufällig Arbeit?", "Hello. Are you looking for work coincidentally?"), gg_snd_Manfred1)
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
			call speech(info, character, false, tre("Was hältst du vom Herzog?", "What do you think of the duke?"), null)
			call speech(info, character, true, tre("Er hat dich doch nicht etwa geschickt oder? Sonst würde ich wohl meine Zunge hüten.", "He did not send you did he? Otherwise I would probably guard my tongue."), gg_snd_Manfred7)
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Na ja, eigentlich kann's mir auch egal sein. Ohne mich und meine Leute hat er kaum etwas zu essen und falls es zur Belagerung käme, würde er schon nach ein paar Tagen verhungern.", "Well, actually I don't have to care. Without me and my people he has little to eat and if it came to the siege, he would starve after a few days."), gg_snd_Manfred8)
			call speech(info, character, true, tre("Vor einer Weile waren seine Leute hier und haben sich nach der Ernte erkundigt. Ich wette, die nehmen sich einfach alles, wenn es hart auf hart kommt, aber mir bleibt keine Wahl.", "A while ago his people were here and asked to have the harvest. I bet that they just take everything when it comes to the crunch, but I have no choice."), gg_snd_Manfred9)
			call speech(info, character, true, tre("Ich hab mir das hier nach und nach aufgebaut. Meine Eltern waren hart arbeitende Leute und hatten kaum genug zum Leben. Eigentlich müsste ich mit dem zufrieden sein, was ich habe.", "I have built this up gradually. My parents were hardworking people and had barely enough to live on. Actually, I would be satisfied with what I have."), gg_snd_Manfred10)
			call speech(info, character, true, tre("Aber dieser verdammte Adel macht es einem ja nicht gerade leicht. Also, ich halte vom Herzog nicht allzu viel. Er sollte mir lieber mal ein paar Leute schicken, die auf meine Felder und Leute aufpassen, wenn es wirklich stimmt, dass der Feind schon recht nah ist.", "But these damn aristocrats don't make it easy for one. So, I think not too much of the duke. He should rather send a few people to me who take care of my fields and people if it is really true that the enemy is already quite close to me."), gg_snd_Manfred11)
			call speech(info, character, true, tre("Am Ende lassen die uns wahrscheinlich nicht mal in die Burg. Der Herzog hat jetzt auch noch unseren Kriegsdienst auf ein Jahr eingefordert, falls der Feind hier aufkreuzt. Als ob ich nicht genug zu tun hätte.", "At the end they probably do not let us even in the castle. The duke has now also demanded our conscientious to one year, if the enemy shows up here. As if I did not do enough."), gg_snd_Manfred12)
			call this.showRange(this.m_aboutTheDuke_Yes.index(), this.m_aboutTheDuke_No.index(), character)
		endmethod

		// (Nach Begrüßung und nachdem der Charakter mit Mathilda darüber gesprochen hat)
		private static method infoConditionMathilda takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character) and TalkMathilda.talk().toldThatSleepingInBarn(character)
		endmethod

		// Du lässt Mathilda in deiner Scheune pennen?
		private static method infoActionMathilda takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Du lässt Mathilda in deiner Scheune pennen?", "You let Mathilda sleep in your barn?"), null)
			call speech(info, character, true, tre("Klar, wieso nicht? Sie hat mir dafür auch schon ein paar wirklich gute Geschichten erzählt. Sonst gibt's hier ja keine Unterhaltung und für's Herumreisen fehlen mir die nötigen Goldmünzen und die Zeit.", "Sure, why not? She has already told me a few really good stories. Other than that here's no entertainment and for traveling around I am lacking the necessary gold coins and time."), gg_snd_Manfred18)
			call speech(info, character, true, tre("Außerdem ist sie doch wirklich nett. Dass musst du doch zugeben.", "Besides she is really nice. You have to admit that."), gg_snd_Manfred19)
			call speech(info, character, false, tre("Na ja ...", "Well ..."), null)
			call speech(info, character, true, tre("Komm schon. Meine Frau ist vor drei Jahren an irgend so einer Krankheit gestorben. Was weiß ich? Ist schon lange her, dass ich was mit einer hatte. Die Mathilda wär genau die Richtige.", "Come on. My wife died three years ago to something like a disease. What do I know? It's a long time since I had something with a woman. Mathilda would be just right."), gg_snd_Manfred20)
			call speech(info, character, true, tre("Zusammen könnten wir hier den Hof führen. Das wär doch was! (Lacht) Ich hab wohl zu viel gearbeitet. Na ja, nimm's nicht so ernst.", "Together we could lead this farm here. That would be something! (Laughs) I'm probably working too hard. Well, do not take it so seriously."), gg_snd_Manfred21)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Schutz dem Volke“ abgeschlossen oder Auftrag „Zu den Waffen, Bauern!“ aktiv)
		private static method infoConditionTalkedToFerdinand takes AInfo info, ACharacter character returns boolean
			return QuestProtectThePeople.characterQuest(character).questItem(0).isCompleted() or QuestAmongTheWeaponsPeasants.characterQuest(character).isNew()
		endmethod

		// Ich habe mit dem Vogt gesprochen.
		private static method infoActionTalkedToFerdinand takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe mit dem Vogt gesprochen.", "I have spoken with the steward."), null)
			call speech(info, character, true, tre("Und?", "And?"), gg_snd_Manfred22)
			if (QuestProtectThePeople.characterQuest(character).questItem(0).isCompleted()) then
				call speech(info, character, false, tre("Er überlegt sich das mit dem Kriegsdienst nochmal und er wird ein paar Leute herschicken.", "He considers the military service again and he will send along a few people."), null)
				call speech(info, character, true, tre("Donnerwetter! Wie hast du das angestellt? Obwohl, ich frag besser nicht. Das sind gute Neuigkeiten, mein Freund!", "Bloody hell! How did you do that? Though, I better don't ask. This is good news, my friend!"), gg_snd_Manfred23)
				call speech(info, character, true, tre("Dafür werde ich dich auch gut entlohnen.", "For that I will reward you well."), gg_snd_Manfred24)
				// Auftrag „Schutz dem Volke“ abgeschlossen.
				call QuestProtectThePeople.characterQuest(character).complete()
			// (Auftrag „Zu den Waffen, Bauern!“ aktiv)
			else
				call speech(info, character, false, tre("Sieht schlecht aus, Freundchen. Du wirst gefälligst deinen Kriegsdienst leisten und deine Leute ebenso oder ich reiß dir deine Eingeweide heraus und verfüttere deine Leute an den Feind.", "Looks bad, friend. You will kindly do your military service and your people as well or I will tear your entrails and feed your people to the enemy."), null)
				call speech(info, character, false, tre("Und wegen den Leuten, die dein Hab und Gut bewachen sollen, wirst du dich auch nicht mehr beschweren, klar?", "And about the people who are supposed to guard your belongings, you will not complain anymore, will you?"), null)
				call speech(info, character, true, tre("Oh Mann, komm mal wieder runter. Schon gut, ich ... ich denke, das geht schon in Ordnung.", "Oh man, come down again. Alright, I ... I think that's all right."), gg_snd_Manfred25)
				call speech(info, character, false, tre("Das will ich auch hoffen.", "I hope so."), null)
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
			call speech(info, character, true, tr("Ich habe es geahnt. Wie ich es vorausgesagt habe, wir werden nun unserer hart erbrachten Ernte beraubt."), gg_snd_Manfred26)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Gut ich sage lieber nichts mehr, am Ende werde ich noch eingesperrt. Wenn du schon Vorräte haben willst, dann sammle sie selbst ein und bringe sie zu mir. Ich schicke sie dann zur Burg."), gg_snd_Manfred27)
			call speech(info, character, false, tr("Und wo sind die Vorräte?"), null)
			call speech(info, character, true, tr("Du kannst einen entsprechenden Teil von Guntrichs Mühle und in der Scheune mitnehmen, aber lass uns doch noch etwas übrig."), gg_snd_Manfred28)
			call speech(info, character, true, tr("Wer weiß ob wir hier am Ende auf uns allein gestellt sind."), gg_snd_Manfred29)
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
			call speech(info, character, true, tr("Da hast du aber auch nicht gerade gespart. Na wie du meinst … ich schicke sie nun zur Burg. Du kannst Markward berichten, dass sie unterwegs sind."), gg_snd_Manfred30)
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
			call speech(info, character, true, tr("Was?! Was erlaubst du dir?"), gg_snd_Manfred31)
			call speech(info, character, false, tr("Markward benötigt das Holz für die Burg. Es stammt von Kuno und der hat mir gesagt du würdest es zur Burg schaffen."), null)
			call speech(info, character, true, tr("Kuno? Verdammt, na gut. Kuno ist ein netter Kerl und verkauft uns immer gute Waren. Aber dieser Markward meint wohl wir machen die ganze Drecksarbeit für ihn."), gg_snd_Manfred32)
			call speech(info, character, true, tr("Wenn die Orks und Dunkelelfen hier einfallen, gehen wir doch als erste drauf, das kann ich dir versichern …"), gg_snd_Manfred33)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Schon gut ich schicke das Holz zur Burg, gib schon her!"), gg_snd_Manfred34)
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
			call speech(info, character, true, tr("Gut, ich kann jeden Helfer gebrauchen. Falls du also Lust hast, dir ein paar Goldmünzen dazuzuverdienen, dann melde dich einfach bei mir."), gg_snd_Manfred2)
			call speech(info, character, true, tr("Gerade ist Erntezeit und da kann man nicht genug Leute haben. Ich will ja schließlich noch ernten, bevor unser Feind hier auftaucht."), gg_snd_Manfred3)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Schade. In diesen harten Zeiten findet man nur noch selten Leute, die Arbeit suchen."), gg_snd_Manfred4)
			call speech(info, character, true, tr("Die Meisten wollen doch sowieso nur weg von der Grenze. Krieg, Krieg, das ist das Einzige, was sie noch interessiert. Aber ich muss meinen Hof führen. Die Leute in der Burg brauchen ja auch was zu beißen."), gg_snd_Manfred5)
			call speech(info, character, true, tr("Aber auf uns Bauern wird sowieso nur rumgehackt, dabei lastet auf uns der ganze Rest."), gg_snd_Manfred6)
			call info.talk().showStartPage(character)
		endmethod

		// Ich kümmere mich drum.
		private static method infoActionAboutTheDuke_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich kümmere mich drum."), null)
			call speech(info, character, true, tr("Wirklich? Das würdest du tun? Du musst mit dem Vogt in der Burg sprechen. Ferdinand ist sein Name. Ich war schon mal bei ihm, aber er hat mich abgewiesen."), gg_snd_Manfred13)
			call speech(info, character, true, tr("Verdammter Arschkriecher des Herzogs. Der Sack sitzt in der Burg mit ihren dicken Mauern und bekommt ne Menge Goldmünzen für's Faulenzen."), gg_snd_Manfred14)
			call speech(info, character, true, tr("Lass dich nicht von ihm unterkriegen!"), gg_snd_Manfred15)
			call QuestProtectThePeople.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Wirst schon nicht draufgehen.
		private static method infoActionAboutTheDuke_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wirst schon nicht draufgehen."), null)
			call speech(info, character, true, tr("Hmm, wenn nicht ich, dann ein anderer. Das ist auch nicht viel besser. Ich wünschte, der Krieg wäre schon vorbei und wir würden gemeinsam etwas Neues aufbauen. Eine Welt ohne Adel, in der jeder nach seiner wirklichen Leistung beurteilt werden würde."), gg_snd_Manfred16)
			call speech(info, character, true, tr("Ich wette, in einer solchen Welt wäre das Ansehen des Herzogs ganz unten."), gg_snd_Manfred17)
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

		implement Talk
	endstruct

endlibrary
