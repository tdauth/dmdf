library StructMapTalksTalkEinar requires Asl, StructMapMapNpcs

	struct TalkEinar extends ATalk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(3, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Neu hier nehme ich an. Ja, war ich auch vor ein paar Wochen. Ich bin Einar und verkaufe Waffen in Talras."), null)
			call speech(info, character, true, tr("Du siehst wie einer aus, der Waffen gebrauchen kann, also wenn du bezahlen kannst, bekommst du auch was Anständiges von mir."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Was hast du denn so im Angebot?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was hast du denn so im Angebot?"), null)
			call speech(info, character, true, tr("Alles was das Kriegerherz begehrt. Äxte, Schilde, Speere, Lanzen, Streitkolben, Morgensterne und natürlich Schwerter. Einige der Waffen habe ich mir nach Schlachten zusammengesammelt, manche stammen sogar von meinen Kameraden, die an meiner Seite fielen."), null)
			call speech(info, character, true, tr("Nachschub bekomme ich vom hiesigen Schmied Wieland, allerdings ist es eher Qualitätsware als Nachschub, denn die einfachen Waffen verkaufen sich nicht besonders gut. Die meisten Leute hier sind ganz gut ausgestattet und manche, wie zum Beispiel die Bauern, glauben doch tatsächlich, dass sie nicht kämpfen werden müssen."), null)
			call speech(info, character, true, tr("Aber was will man von einem Kaff wie diesem auch erwarten. Ich bin nur froh, meine Ruhe zu haben und wenn hier die verdammten Dunkelelfen einfallen, bin ich schon weg."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Woher kommst du?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Aus dem Nordwesten. Na ja eigentlich nicht direkt. Da wurde ich halt geboren. Eigentlich komme ich aus unserer tollen Hauptstadt. Wurde aus dem Dienst des Königs entlassen, mit Belobigung. Dafür kann ich jetzt meinen rechten Arm nicht mehr richtig bewegen."), null)
			call speech(info, character, true, tr("Das tut höllisch weh, seitdem da ein lustiger Dunkelelf mit seiner Keule drauf gehauen hat."), null)
			call speech(info, character, false, tr("Du warst also Krieger?"), null)
			call speech(info,  character, true, tr("Ja verdammt! Im Heer des Königs persönlich. Ich war bei den Feldzügen gegen den Karornwald dabei. Der König hat doch tatsächlich geglaubt, er könne sich beim Adel beliebt machen und Stärke zeigen, wenn er's diesen verdammten Dunkelelfen heimzahlt."), null)
			call speech(info, character, true, tr("Frag mich nicht, warum wir Menschen die Dunkelelfen so hassen und umgekehrt. Das wissen wohl nicht mal die, die oben sitzen."), null)
			call speech(info, character, true, tr("Jedenfalls war das das reinste Desaster. Wir sind in den dichten Wald hinein und kaum, waren wir eine Stunde unterwegs, sind uns die Männer umgefallen. Die Schweine hatten ihre Leute auf den riesigen Bäumen des Karornwalds platziert und die haben uns wie Wild erlegt."), null)
			call speech(info, character, true, tr("Dann kamen plötzlich so große Bären, keine normalen, bei denen brannten die Augen wie Feuer und die tickten völlig aus und gingen auf uns los."), null)
			call speech(info, character, true, tr("Und zu guter Letzt stürmten dann deren Krieger auf uns zu. Verdammt Mann, wir in unseren schweren Rüstungen waren wie gelähmt. Ich kann froh sein, mit dem Leben davon gekommen zu sein."), null)
			call speech(info, character, true, tr("Jetzt sitze ich in diesem Kaff und verkaufe meinen letzten Bezug zur Hölle. Wenigstens habe ich so meine Ruhe."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.einar(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) //0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Was hast du denn so im Angebot?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Woher kommst du?")) // 2
			call this.addExitButton() // 3

			return this
		endmethod
	endstruct

endlibrary