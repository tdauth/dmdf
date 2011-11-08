library StructMapTalksTalkWieland requires Asl

	struct TalkWieland extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			if  (not this.showInfo(0)) then
				call this.showRange(1, 5)
			endif
		endmethod

		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, true, tr("He du! Bist du ein tapferer Krieger?"), null)
			call info.talk().showRange(6, 7)
		endmethod

		// Kannst du mir das Schmieden beibringen?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Kannst du mir das Schmieden beibringen?"), null)
			call speech(info, true, tr("Sonst noch was? Weißt du, wie lange es dauert, jemandem das beizubringen? Mein Sohn übernimmt das hier mal und da knn er keine Konkurrenz gebrauchen."), null)
			call info.talk().showStartPage()
		endmethod

		// Verkaufst du auch Waffen?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Verkaufst du auch Waffen?"), null)
			call speech(info, true, tr("Nein, ich stelle sie nur her. Einar verkauft welche am Tor zur Innenburg. Ich glaube, Agihard verkauft auch welche. Den findest du bei seiner Arena im Norden der Burg."), null)
			call speech(info, true, tr("Allerdings verkaufe ich wertvolle, selbst angefertigte Rüstungen und Helme."), null)
			if (Classes.isMage(info.talk().character()) or Classes.isChaplain(info.talk().character())) then // (Charakter ist Geistlicher oder Magier)
				call speech(info, true, tr("Vermutlich nichts für dich."), null)
			elseif (info.talk().character().class() == Classes.knight()) then // (Charakter ist Ritter)
				call speech(info, true, tr("Genau das Richtige für einen tapferen Rittersmann wie dich."), null)
			elseif (info.talk().character().class() == Classes.ranger()) then // (Charakter ist Waldläufer)
				call speech(info, true, tr("Vermutlich zu schwer für dich."), null)
			else // (Charakter ist Drachentöter)
				call speech(info, true, tr("Nichts für jeden dahergelaufenen Burschen."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// (Auftrag „Des Königs Krone“ ist aktiv und Auftragsziel 1 ist abgeschlossen)
		private static method infoCondition3 takes AInfo info returns boolean
			return QuestTheKingsCrown.characterQuest(info.talk().character()).isNew() and QuestTheKingsCrown.characterQuest(info.talk().character()).questItem(0).isCompleted()
		endmethod

		// Hier ist die Krone.
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Hier ist die Krone."), null)
			call speech(info, true, tr("Gib her!"), null)
			call info.talk().character().inventory().removeFromRucksackByTypeId(QuestTheKingsCrown.crownItemTypeId, false) // Krone geben
			call speech(info, true, tr("Tatsächlich! Das ist die Krone aus den Sagen. Sag, was ahst du mit dem König gemacht?"), null)
			call speech(info, false, tr("Rate mal."), null)
			call speech(info, true, tr("So so, dann ist er also tot? Na ja, vielleicht findet er so seinen Frieden, kann mir eigentlich egal sein. Ich danke dir, das ist mir wirklich einige Goldmünzen wert!"), null)
			call QuestTheKingsCrown.characterQuest(info.talk().character()).questItem(1).complete()
			call speech(info, true, tr("Sag, kannst du mir noch einen Gefallen tun?"), null)
			call info.talk().showRange(8, 9)
		endmethod

		// (Auftrag „Wielands Schwert“ ist aktiv und Auftragsziel 1 ist abgeschlossen)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestWielandsSword.characterQuest(info.talk().character()).isNew() and QuestTheKingsCrown.characterQuest(info.talk().character()).questItem(0).isCompleted()
		endmethod

		// Ich habe mit Einar gesprochen.
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Ich habe mit Einar gesprochen."), null)
			call speech(info, true, tr("Gut, wie viel verlangt er?"), null)
			call speech(info, false, tr("2000 Goldmünzen."), null)
			call speech(info, true, tr("Was? Verdammter Hundesohn! Bist du dir sicher?"), null)
			call speech(info, false, tr("Ja."), null)
			call speech(info, true, tr("Dieser Halsabschneider! Nächstes Mal kann er mir 2000 Goldmünzen bezahlen, damit ich ihn nicht umhaue! Danke, das war sehr wichtig für mich. Pass auf, ich gebe dir eine gute Waffe, weil du mir geholfen hast, schon zweimal."), null)
			call speech(info, true, tr("Achte gut darauf, es ist ein sehr gutes Schwert und pass auf dich auf, aber ich glaube, dass wohl eher deine Feinde auf sich aufpassen sollten."), null)
			// Schwert geben
			call QuestWielandsSword.characterQuest(info.talk().character()).questItem(1).complete()
			call info.talk().showStartPage()
		endmethod

		private static method info0_0Talk takes AInfo info returns nothing
			call speech(info, true, tr("Also erstmal hallo, ich bin Wieland, der Schmied von Talras. Wenn du irgendwas geschmiedet haben willst, bin ich dein Mann."), null)
			call speech(info, true, tr("Nun zu meinem Problem: Mein Sohn Wieland ist gerade irgendwo im Norden bei einem Ritter und dient diesem als Krieger. Wenn er zurückkommt, dann will ich, dass er für mich arbeitet."), null)
			call speech(info, true, tr("Leider hat's ihm die Schmiedekunst nicht so angetan, wie ich mir das erhofft hatte. Wir haben uns im Streit getrennt und er meinte noch zu mir \"Ich werde für dich arbeiten, wenn du mir die Krone eines Königs schenkst\"."), null)
			call speech(info, true, tr("Das war nur aus Zorn heraus als schlechter Scherz gemeint, aber ich will ihm zeigen, wie ernst es mir mit ihm ist."), null)
			call speech(info, true, tr("Die alten Sagen, die mir mein Vater erzählte, als ich noch selbst ein junger Bursche war, handelten oft von den Untoten. Wiederauferstandene Tote, die keinen Frieden finden konnten und nun alles töten wollen, was noch atmet."), null)
			call speech(info, true, tr("Diese Untoten haben auch einen König. Man sagt, er streife irgendwoe außerhalb von Talras umher und mache die Gegend mit seinen Kriegern unsicher."), null)
			call speech(info, true, tr("Ein König, der einst über dieses Land hier herrschte. Für dich hört sich das vielleicht nach Gespenstergeschichten an, aber ich glaube daran, denn mein Vater selbst hat ihn gesehen."), null)
			call speech(info, true, tr("Ich möchte, dass du mir seine Krone bringst, damit ich sie meinem Sohn überreichen kann, wenn er zurückkehrt."), null)
			call info.talk().showRange(10, 12)
		endmethod

		// Ja, natürlich.
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Ja, natürlich."), null)
			call speech(info, true, tr("Das trifft sich gut, ich brauche nämlich Hilfe."), null)
			call thistype.info0_0Talk.execute(info)
		endmethod

		// Wohl eher nicht.
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Wohl eher nicht."), null)
			call speech(info, true, tr("Schade, aber vielleicht kannst du mir trotzdem weiterhelfen."), null)
			call thistype.info0_0Talk.execute(info)
		endmethod

		// Wieso nicht?
		private static method infoAction3_0 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso nicht?"), null)
			call speech(info, true, tr("Du scheinst ja wirklich einer von der hilfsbereiten Sorte zu sein."), null)
			call speech(info, true, tr("Also es geht um Einar, den Waffenhändler vor dem Tor der Innenburg. Ich habe vor kurzem ein gutes Schwert für ihm geschmiedet."), null)
			call speech(info, true, tr("Er hat's mir für 800 Goldmünzen abgekauft. Ich möchte jetzt aber wissen, wie viel er dafür verlangt. Das würde mich brennend interessieren, denn nachher haut der Typ noch alle übers Ohr."), null)
			call speech(info, true, tr("Also frag ihn nach einem besonders guten Schwert, der Preis sei dir egal, dann wird er es dir schon anbieten. Danach kommst du zu mir und sagst mir den Preis."), null)
			call speech(info, false, tr("In Ordnung."), null)
			call QuestWielandsSword.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Nein.
		private static method infoAction3_1 takes AInfo info returns nothing
			call speech(info, false, tr("Nein."), null)
			call speech(info, true, tr("Na ja, macht nichts, trotzdem danke für deine Hilfe. Leute wie dich kann man hier brauchen. Hoffentlich bist du noch da, wenn der Feind hier einfällt."), null)
			call info.talk().showStartPage()
		endmethod

		// Wieso gehst du nicht selbst?
		private static method infoAction0_0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso gehst du nicht selbst?"), null)
			call speech(info, true, tr("Sieh dich doch mal hier um. Ich bin der einzige Schmied in Talras. Wenn ich nicht wäre, dann würde hier doch das reinste Chaos ausbrechen."), null)
			call speech(info, true, tr("Glaub mir, ich würde gehen, denn an Mut fehlt es mir wahrlich nicht, aber ich habe zu tun. Also was ist nun?"), null)
			call info.talk().showRange(11, 12)
		endmethod

		// Gut, ich werde sehen, was ich tun kann.
		private static method infoAction0_0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Gut, ich werde sehen, was ich tun kann."), null)
			call speech(info, true, tr("Ich danke dir und wenn er die Krone nicht freiwillig rausrückt, wovon ich mal ausgehe, dann spalte ihm halt den Schädel, diesem alten Knochengeist."), null)
			call QuestTheKingsCrown.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Willst du mich verarschen?
		private static method infoAction0_0_2 takes AInfo info returns nothing
			call speech(info, false, tr("Willst du mich verarschen?"), null)
			call speech(info, true, tr("Nein. Wenn du mir nicht glaubst, dann eben nicht. Aber wenn du ihn triffst, dann behaupte nicht, dass ich dich nicht gewarnt hätte."), null)
			call speech(info, true, tr("Er ist der Schrecken selbst."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01Y_0006, thistype.startPageAction)

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, 0, thistype.infoAction1, tr("Kannst du mir das Schmieden beibringen?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("Verkaufst du auch Waffen?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Hier ist die Krone.")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Ich habe mit Einar gesprochen.")) // 4
			call this.addExitButton() // 5

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Ja, natürlich.")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Wohl eher nicht.")) // 7

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tr("Wieso nicht?")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tr("Nein.")) // 9

			// info 0 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0_0, tr("Wieso gehst du nicht selbst?")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction0_0_1, tr("Gut, ich werde sehen, was ich tun kann.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction0_0_2, tr("Willst du mich verarschen?")) // 12

			return this
		endmethod
	endstruct

endlibrary