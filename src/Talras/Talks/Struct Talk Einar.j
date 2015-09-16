library StructMapTalksTalkEinar requires Asl, StructMapMapNpcs, StructMapQuestsQuestSuppliesForEinar, StructMapQuestsQuestWielandsSword

	struct TalkEinar extends Talk
		private AInfo m_hi
		private AInfo m_offer
		private AInfo m_whereFrom
		private AInfo m_specialWeapon
		private AInfo m_help
		private AInfo m_forge
		private AInfo m_weapons
		private AInfo m_exit
		private AInfo m_aboutWieland

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_aboutWieland.index(), character)) then
				call this.showUntil(this.m_exit.index(), character)
			endif
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Neu hier nehme ich an. Ja, war ich auch vor ein paar Wochen. Ich bin Einar und verkaufe Waffen in Talras."), null)
			call speech(info, character, true, tr("Du siehst wie einer aus, der Waffen gebrauchen kann, also wenn du bezahlen kannst, bekommst du auch was Anständiges von mir."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionOffer takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Was hast du denn so im Angebot?
		private static method infoActionOffer takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was hast du denn so im Angebot?"), null)
			call speech(info, character, true, tr("Alles was das Kriegerherz begehrt. Äxte, Schilde, Speere, Lanzen, Streitkolben, Morgensterne und natürlich Schwerter. Einige der Waffen habe ich mir nach Schlachten zusammengesammelt, manche stammen sogar von meinen Kameraden, die an meiner Seite fielen."), null)
			call speech(info, character, true, tr("Nachschub bekomme ich vom hiesigen Schmied Wieland, allerdings ist es eher Qualitätsware als Nachschub, denn die einfachen Waffen verkaufen sich nicht besonders gut. Die meisten Leute hier sind ganz gut ausgestattet und manche, wie zum Beispiel die Bauern, glauben doch tatsächlich, dass sie nicht kämpfen werden müssen."), null)
			call speech(info, character, true, tr("Aber was will man von einem Loch wie diesem auch erwarten. Ich bin nur froh, meine Ruhe zu haben und wenn hier die verdammten Dunkelelfen einfallen, bin ich schon weg."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionWhereFrom takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Woher kommst du?
		private static method infoActionWhereFrom takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Aus dem Nordwesten. Na ja eigentlich nicht direkt. Dort wurde ich geboren. Eigentlich komme ich aber aus unserer ach so schönen Hauptstadt (sarkastisch). Ich wurde aus dem Dienst des Königs entlassen, mit Belobigung (sarkastisch)! Dafür kann ich jetzt meinen rechten Arm nicht mehr richtig bewegen."), null)
			call speech(info, character, true, tr("Das tut höllisch weh, seitdem da ein freundlicher Dunkelelf mit seiner Keule drauf gehauen hat."), null)
			call speech(info, character, false, tr("Du warst also Krieger?"), null)
			call speech(info,  character, true, tr("Ja verdammt! Im Heer des Königs persönlich. Ich war bei den Feldzügen gegen den Karornwald dabei. Der König hat doch tatsächlich geglaubt, er könne sich beim Adel beliebt machen und Stärke zeigen, wenn er's diesen verdammten Dunkelelfen heimzahlt."), null)
			call speech(info, character, true, tr("Frag mich nicht, warum wir Menschen die Dunkelelfen so sehr hassen und umgekehrt. Das wissen wohl nicht mal die, die oben sitzen und etwas zu sagen haben."), null)
			call speech(info, character, true, tr("Jedenfalls war es das reinste Desaster. Wir sind in den dichten Wald hinein und kaum, waren wir eine Stunde unterwegs, fielen unsere Männer, einer nach dem anderen. Die Schweine hatten ihre Leute auf den riesigen Bäumen des Karornwaldes platziert und die haben uns wie Wild erlegt."), null)
			call speech(info, character, true, tr("Dann kamen plötzlich riesige Bären, keine normalen, bei denen brannten die Augen wie Feuer. Sie waren vollkommen wahnsinnig und gingen auf uns los."), null)
			call speech(info, character, true, tr("Und zu guter Letzt stürmten die Krieger der Dunkelelfen auf uns zu. Verdammt Mann, wir in unseren schweren Rüstungen standen da wie angewurzelt! Ich kann froh sein, mit dem Leben davon gekommen zu sein."), null)
			call speech(info, character, true, tr("Jetzt sitze ich in diesem elenden Loch und verkaufe meinen letzten Bezug zur Hölle. Wenigstens habe ich so meine Ruhe."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Wielands Schwert“ ist aktiv)
		private static method infoConditionSpecialWeapon takes AInfo info, ACharacter character returns boolean
			return QuestWielandsSword.characterQuest(character).questItem(0).isNew()
		endmethod
		
		// Verkaufst du auch eine ganz besondere Waffe?
		private static method infoActionSpecialWeapon takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Verkaufst du auch eine ganz besondere Waffe?"), null)
			call speech(info, character, true, tr("Solange du genügend Goldmünzen dabei hast, kann ich dir nur die beste Ware anbieten."), null)
			call speech(info, character, false, tr("Sicher, Gold spielt bei mir keine Rolle."), null)
			call speech(info, character, true, tr("(Gierig) Na wenn das so ist. Was hältst du denn von diesem Prachtstück hier? Es ist eines der besten Schwerter, die du im ganzen Königreich finden kannst."), null)
			call speech(info, character, true, tr("Wieland der Schmied von Talras hat es geschmiedet. Seine Kunst ist unerreicht! Mit diesem Schwert wirst du jede Schlacht gewinnen …"), null)
			call speech(info, character, false, tr("Wie viel?"), null)
			call speech(info, character, true, tr("Hm, weil ich dich als guten Menschen einschätze sagen wir … 2000 Goldmünzen."), null)
			call speech(info, character, false, tr("Lass mich noch mal darüber schlafen."), null)
			call speech(info, character, true, tr("Klar, lass dir nur Zeit. Das Schwert läuft dir nicht davon. Ich bewahre es für dich auf."), null)
			// Auftragsziel 1 des Auftrags „Wielands Schwert“ abgeschlossen
			call QuestWielandsSword.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Klar kannst du das, allerdings nur wenn du ein guter Schmied bist. Nichts gegen Wieland, er ist ein hervorragender Schmied, aber er hat eben auch viele andere Aufträge hier in der Burg."), null)
			call speech(info, character, true, tr("Ich brauche dringend mehr Schwerter. Die einfachen Schwerter verkaufen sich zwar nicht so gut, aber wenn ich gar keine mehr davon habe, hilft mir das auch nicht gerade."), null)
			call speech(info, character, true, tr("Schmiede mir fünf Kurzschwerter und ich gebe dir eine entsprechende Summe an Goldmünzen dafür. Vergiss aber nicht, dass sie neu geschmiedet werden müssen. Also drehe mir keine weiterverkaufte Ware an!"), null)
			// Neuer Auftrag „Nachschub für Einar“
			call QuestSuppliesForEinar.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Nachschub für Einar“ ist aktiv)
		private static method infoConditionForge takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestSuppliesForEinar.characterQuest(character).isNew()
		endmethod
		
		// Wo kann ich hier schmieden?
		private static method infoActionForge takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wo kann ich hier schmieden?"), null)
			call speech(info, character, true, tr("Vermutlich nur in Wielands Schmiede. Wenn du dich noch zu wenig mit dem Schmiedehandwerk auskennst, dann besorge dir doch ein gutes Buch mit Anleitungen von Wieland. Das wird dir sicher helfen."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Nachschub für Einar“ ist aktiv und Charakter hat fünf geschmiedete Kurzschwerter dabei)
		private static method infoConditionWeapons takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestSuppliesForEinar.characterQuest(character).isNew() and character.inventory().totalItemTypeCharges('I060') >= QuestSuppliesForEinar.maxSwords
		endmethod
		
		// Hier sind fünf Kurzschwerter.
		private static method infoActionWeapons takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier sind fünf Kurzschwerter."), null)
			call speech(info, character, true, tr("Sehr gut, mein Freund. Ich danke dir vielmals dafür. Hier hast du ein paar Goldmünzen."), null)
			// Auftrag „Nachschub für Einar“ abgeschlossen
			call QuestSuppliesForEinar.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Charakter hat den Auftrag „Wielands Schwert“ abgeschlossen)
		private static method infoConditionAboutWieland takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestWielandsSword.characterQuest(character).isCompleted()
		endmethod
		
		// Hey, hast du mich etwa bei Wieland angeschwärzt? Verdammt Mann, das war doch nicht so gemeint. Geschäft ist Geschäft, verstehst du das nicht?
		private static method infoActionAboutWieland takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Hey, hast du mich etwa bei Wieland angeschwärzt? Verdammt Mann, das war doch nicht so gemeint. Geschäft ist Geschäft, verstehst du das nicht?"), null)
			call info.talk().showStartPage(character)
		endmethod
		
		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.einar(), thistype.startPageAction)
			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo."))
			set this.m_offer = this.addInfo(false, false, thistype.infoConditionOffer, thistype.infoActionOffer, tr("Was hast du denn so im Angebot?"))
			set this.m_whereFrom = this.addInfo(false, false, thistype.infoConditionWhereFrom, thistype.infoActionWhereFrom, tr("Woher kommst du?"))
			set this.m_specialWeapon = this.addInfo(false, false, thistype.infoConditionSpecialWeapon, thistype.infoActionSpecialWeapon, tr("Verkaufst du auch eine ganz besondere Waffe?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Kann ich dir irgendwie helfen?"))
			set this.m_forge = this.addInfo(true, false, thistype.infoConditionForge, thistype.infoActionForge, tr("Wo kann ich hier schmieden?"))
			set this.m_weapons = this.addInfo(true, false, thistype.infoConditionWeapons, thistype.infoActionWeapons, tr("Hier sind fünf Kurzschwerter."))
			set this.m_exit = this.addExitButton()
			
			set this.m_aboutWieland = this.addInfo(false, true, thistype.infoConditionAboutWieland, thistype.infoActionAboutWieland, null)

			return this
		endmethod
	endstruct

endlibrary