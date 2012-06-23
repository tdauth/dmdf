library StructMapTalksTalkUrsula requires Asl, StructMapQuestsQuestTheOaksPower

	struct TalkUrsula extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(9)
		endmethod

		// Was machst du hier?
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Was machst du hier?"), null)
			call speech(info, true, tr("Leben. Dies ist mein Heim, Fremder. Vielleicht etwas ungewohnt für einen aus unserem Königreich Stammenden, aber hier lässt es sich durchaus leben."), null)
			call speech(info, true, tr("Ich bin Ursula, Waldläuferin, Druidin und Heilerin. Das heißt, ich bin keine Jägerin, denn ich respektiere das Leben, sei es nun das eines Menschen, Hochelfen, Tieres oder sonst irgendeines. Druidin bedeutet, dass ich an die Göttin Krepar, die Göttin der Natur, glaube."), null)
			call speech(info, true, tr("Ich weiß, viele Leute haben sich den Göttern abgewandt, selbst im Adel ist es mehr eine Art Zeitvertreib und Symbolik für Wohlstand und Rechtschaffenheit geworden. Aber ich glaube aus dem tiefsten Herzen heraus."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Wie ist dein Leben hier draußen so?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Wie ist dein Leben hier draußen so?"), null)
			call speech(info, true, tr("Angenehm und auch nicht einsam, falls du das glaubst. Oft kommen die Bauern und auch manche Jäger zu mir und suchen Heilung oder meinen Rat."), null)
			call speech(info, true, tr("Nur hier draußen fühle ich mich zu Natur verbunden genug, um Krepar eine würdige Dienerin oder besser gesagt Freundin zu sein."), null)
			call speech(info, true, tr("Manchmal mache ich auch lange Wanderungen durch die hiesigen Wälder, um die Schönheit zu betrachten, die Krepar uns schenkte."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition2 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Womit verdienst du deinen Lebensunterhalt?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Womit verdienst du deinen Lebensunterhalt?"), null)
			call speech(info, true, tr("Ich brauche nicht viel zum Leben. Das Meiste erhalte ich durch Gnade Krepars von der Natur und den Rest verdiene ich mir sowohl durch meinen Rat und Beistand als auch durch meine Heilkünste und mein altes Wissen."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Erzähl mir mehr von Krepar.
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Erzähl mir mehr von Krepar."), null)
			call speech(info, true, tr("Krepar ist eine der der vier Götter. Einst war ich eine Dienerin der Kleriker, welche den Gott Urang verehren. Bei diesen lernte ich durch meine Stellung als Bibliothekarin der großen Bibliothek des Ordens in Klerfurt  eine Menge über die alte Gesellschaft, die sich noch mehr zur Natur verbunden fühlte."), null)
			call speech(info, true, tr("Damals lebten die Leute noch in einfachen Hütten in den Wäldern und waren eins mit der Natur."), null)
			call speech(info, true, tr("Druiden, weise Persönlichkeiten, beteten Krepar, die Göttin der Natur und Symbiose an. Auf ihren Rat hörten die Bewohner der kleinen Siedlungen und suchten ihren Rat, wenn es etwas zu bewältigen gab."), null)
			call speech(info, true, tr("Anders als die heutigen Orden, gab es weniger durch die Herkunft bedingte Herrschaftshierarchien. Man respektierte die Alten und Weisen, denn ihr Rat war meist der beste."), null)
			call speech(info, true, tr("Krepar schuf die Natur um uns herum. Jeder Baum, jede Pflanze und jedes Tier ist ein Geschöpf ihrer. Daher sollte man sie ehren und dankbar sein."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition4 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Kannst du mich heilen?
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Kannst du mich heilen?"), null)
			call speech(info, true, tr("Krepar, leihe mir deine Kraft!"), null)
			call QueueUnitAnimation(gg_unit_n01U_0203, "Spell")
			call DestroyEffect(AddSpecialEffectTarget("Spells\\Models\\Effects\\Genesung.mdl", info.talk().character().unit(), "chest"))
			call SetUnitLifePercentBJ(gg_unit_n01U_0203, 100.0)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition5 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, true, tr("Sehe ich denn aus als bräuchte ich Hilfe?"), null)
			call speech(info, false, tr("Na ja …"), null)
			call speech(info, true, tr("Schon gut, ich brauche tatsächlich Hilfe."), null)
			call speech(info, true, tr("Ganz in der Nähe gibt es eine alte Eiche. Sie spendete mir stets Schatten während meiner langen Stunden des Nachdenkens. Doch nun haben starke, wilde Kreaturen die Eiche für sich in Anspruch genommen."), null)
			call speech(info, true, tr("Da aber auch sie Geschöpfe Krepars sind, möchte ich, dass du sie nicht tötest, sondern ihre Geister einfängst."), null)
			call speech(info, false, tr("Wie soll ich das anstellen?"), null)
			call speech(info, true, tr("Dazu gebe ich dir diesen Totem. Bring mir den Geist von einer der Kreaturen, damit ich sie verstehen lerne und mich mit ihnen anfreunden kann und ich werde dir etwas schenken."), null)
			call speech(info, false, tr("Und was?"), null)
			call speech(info, true, tr("Das siehst du dann noch."), null)
			call info.talk().showRange(10, 11)
		endmethod

		// (Nachdem der Charakter gefragt hat, ob er irgendwie helfen kann)
		private static method infoCondition6 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(5)
		endmethod

		// Du kannst die Geister wilder Kreaturen einfangen?
		private static method infoAction6 takes AInfo info returns nothing
			call speech(info, false, tr("Du kannst die Geister wilder Kreaturen einfangen?"), null)
			call speech(info, true, tr("Ja, jeder kann das. Man braucht nur Geduld und muss von der Vorstellung der Vorherrschaft seiner eigenen Rasse wegkommen. Zeige dem Lebewesen deinen Respekt. Wenn du das beherrscht, wird es auch dich respektieren und das ermöglicht dir, zu seinem Geist durchzudringen."), null)
			call speech(info, true, tr("Natürlich lernt man das nicht mal eben so, vielleicht ist „einfangen“ auch das falsche Wort. Man versucht vielmehr eins zu werden mit der Kreatur und wenn sie deine gute Absicht bemerkt, lässt sie dich an ihren Geist."), null)
			call speech(info, false, tr("Aber was ist daran eine gute Absicht?"), null)
			call speech(info, true, tr("Nun, ich lasse den Geist ja wieder frei, nachdem wir Informationen miteinander ausgetauscht haben."), null)
			call speech(info, false, tr("Informationen?"), null)
			call speech(info, true, tr("Du würdest dich sicher wundern, wenn du wüsstest, wie viel eine wilde Kreatur weiß. Sie vermag es vielleicht nicht, es aufzuschreiben oder anderen durch Sprache mitzuteilen, aber viele der wilden Kreaturen, auf die ich traf wussten mehr als so mancher sogenannter Zivilisierter."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 2 des Auftrags „Die Kraft der Eiche“ ist aktiv)
		private static method infoCondition7 takes AInfo info returns boolean
			return QuestTheOaksPower.characterQuest(info.talk().character()).questItem(1).isNew()
		endmethod

		// Hier hast du deinen Totem wieder.
		private static method infoAction7 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du deinen Totem wieder."), null)
			// Charakter gibt Ursula den Totem zurück.
			call info.talk().character().inventory().removeFromRucksackByTypeId(QuestTheOaksPower.itemTypeId, false)
			call speech(info, true, tr("Du hast es also geschafft? Gut gemacht. Pass auf, ich gebe dir einen anderen Totem mit einem Teil der Seele dieser Kreatur."), null)
			call speech(info, true, tr("Mit dem Toten wirst du in der Lage sein, die Kreatur herbeizurufen, zumindest mit einem Teil ihrer ursprünglichen Stärke. Allerdings wird sie keinen eigenen Instinkt haben und dir stets treu ergeben sein."), null)
			call speech(info, true, tr("Ziehe einen guten Nutzen daraus und behandle sie gut. Hier hast du noch ein paar Goldmünzen für deine Hilfe. Nun kann ich endlich eins werden mit diesen Wesen und mein Wissen mit ihm teilen."), null)
			// Auftrag „Die Kraft der Eiche“ abgeschlossen.
			call QuestTheOaksPower.characterQuest(info.talk().character()).complete()
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition8 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Verkaufst du auch was?
		private static method infoAction8 takes AInfo info returns nothing
			call speech(info, false, tr("Verkaufst du auch was?"), null)
			call speech(info, true, tr("Ja, ich möchte mein Wissen teilen. Einige meiner Bücher nützen mir nicht mehr viel, denn ich kenne sie bereits fast auswendig. Diese verkaufe ich, damit ich mir noch etwas Lebensunterhalt dazu verdienen kann."), null)
			call speech(info, true, tr("Ich werde nämlich langsam zu alt, um hinauszuziehen und Nahrung zu sammeln."), null)
			call speech(info, true, tr("Auch wenn ich nicht viel von Besitz halte, so verkaufe ich die Bücher nicht gerade billig, da es wohl mein einziger, für gewöhnliche Leute ebenfalls wertvoller Besitz ist. Und glaube mir, es sind wahre Schätze darunter!"), null)
			call speech(info, true, tr("Noch viel wertvoller aber sind die Kreaturen, die mir von Zeit zu Zeit zulaufen. Sie sind zwar nicht mein Besitz, aber ich verlange auch für sie ein paar Goldmünzen, da sie mir auf Dauer sehr ans Herz wachsen."), null)
			call speech(info, false, tr("Wovon sprichst du?"), null)
			call speech(info, true, tr("Von den Katzen, die mir zulaufen. Hier in der Gegend scheint es von Katzen nur so zu wimmeln. Ich teile mein Essen mit ihnen und sie leben mit mir zusammen."), null)
			call speech(info, true, tr("Da es wohl immer mehr werden, werde ich mich vermutlich von einigen von ihnen trennen  müssen, wenn ich nicht selbst verhungern will."), null)
			call speech(info, true, tr("Wenn du mir versprichst dich gut um sie zu kümmern, werde ich dir auch sie verkaufen."), null)
			call info.talk().showStartPage()
		endmethod

		// Gut.
		private static method infoAction5_0 takes AInfo info returns nothing
			local item whichItem
			call speech(info, false, tr("Gut."), null)
			call speech(info, true, tr("Ich danke dir."), null)
			// Neuer Auftrag „Die Kraft der Eiche“
			call QuestTheOaksPower.characterQuest(info.talk().character()).enable()
			set whichItem = CreateItem(QuestTheOaksPower.itemTypeId, GetUnitX(info.talk().character().unit()), GetUnitY(info.talk().character().unit()))
			call SetItemInvulnerable(whichItem, true)
			call SetItemPawnable(whichItem, false)
			call UnitAddItem(info.talk().character().unit(), whichItem)
			call info.talk().showStartPage()
		endmethod

		// Kein Interesse.
		private static method infoAction5_1 takes AInfo info returns nothing
			call speech(info, false, tr("Kein Interesse."), null)
			call speech(info, true, tr("Wie du meinst."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01U_0203, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Was machst du hier?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Wie ist dein Leben hier draußen so?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Womit verdienst du deinen Lebensunterhalt?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Erzähl mir mehr von Krepar.")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Kannst du mich heilen?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Kann ich dir irgendwie helfen?")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Du kannst die Geister wilder Kreaturen einfangen?")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Hier hast du deinen Totem wieder.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Verkaufst du auch was?")) // 8
			call this.addExitButton() // 9

			// info 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tr("Gut.")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tr("Kein Interesse.")) // 11

			return this
		endmethod
	endstruct

endlibrary