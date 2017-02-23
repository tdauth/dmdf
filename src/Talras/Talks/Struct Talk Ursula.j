library StructMapTalksTalkUrsula requires Asl, StructMapQuestsQuestTheOaksPower, StructMapQuestsQuestSeedsForTheGarden

	struct TalkUrsula extends Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(10, character)
		endmethod

		// Was machst du hier?
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was machst du hier?", "What are you doing here?"), null)
			call speech(info, character, true, tre("Leben. Dies ist mein Heim, Fremder. Vielleicht etwas ungewohnt für einen aus unserem Königreich Stammenden, aber hier lässt es sich durchaus leben.", "I live here. This is my home, stranger. Perhaps something unfamiliar to one of our kingdom, but here it can be lived."), gg_snd_Ursula1)
			call speech(info, character, true, tre("Ich bin Ursula, Waldläuferin, Druidin und Heilerin. Das heißt, ich bin keine Jägerin, denn ich respektiere das Leben, sei es nun das eines Menschen, Hochelfen, Tieres oder eines anderen Lebewesens. Druidin bedeutet, dass ich an die Göttin Krepar, die Göttin der Natur, glaube.", "I am Ursula, ranger, druid and healer. That is, I am not a hunter, because I respect life, whether it is that of a human being, a High Elf, an animal or a different creature. Druid means I believe in the goddess Krepar, the goddess of nature."), gg_snd_Ursula2)
			call speech(info, character, true, tre("Ich weiß, viele Leute haben sich von den Göttern abgewandt, selbst im Adel ist es mehr zu einer Art Zeitvertreib und Symbolik für Wohlstand und Rechtschaffenheit geworden. Aber ich glaube aus meinem tiefsten Inneren heraus.", "I know many people have turned away from the gods, even in the nobility, it has become more a kind of pastime and symbolism for prosperity and righteousness. But I believe from my deepest interior."), gg_snd_Ursula3)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wie ist dein Leben hier draußen so?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wie ist dein Leben hier draußen so?", "How is your life out here?"), null)
			call speech(info, character, true, tre("Angenehm und auch nicht einsam, falls du das glaubst. Oft kommen die Bauern und auch manche Jäger zu mir und suchen Heilung oder meinen Rat.", "Pleasant and also not lonely, if you believe that. Often the farmers and some hunters come to me and seek healing or advice."), gg_snd_Ursula4)
			call speech(info, character, true, tre("Nur hier draußen fühle ich mich zu Natur verbunden genug, um Krepar eine würdige Dienerin oder besser gesagt Freundin zu sein.", "Just out here I feel natural enough to be a dignified servant, or rather a friend to Krepar."), gg_snd_Ursula5)
			call speech(info, character, true, tre("Manchmal mache ich auch lange Wanderungen durch die hiesigen Wälder, um die Schönheit zu betrachten, die Krepar uns schenkte.", "Sometimes I also make long walks through the local forests to look at the beauty that Krepar gave us."), gg_snd_Ursula6)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Womit verdienst du deinen Lebensunterhalt?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Womit verdienst du deinen Lebensunterhalt?", "What do you do for living?"), null)
			call speech(info, character, true, tre("Ich brauche nicht viel zum Leben. Das Meiste erhalte ich durch die Gnade Krepars von der Natur und den Rest verdiene ich mir sowohl durch meinen Rat und Beistand als auch durch meine Heilkünste und mein altes Wissen.", "I do not need much to live. Most of it I get by the grace of Krepar from the nature, and the rest I earn both by my advice and assistance as well as by my healing arts and my old knowledge."), gg_snd_Ursula7)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Erzähl mir mehr von Krepar.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Erzähl mir mehr von Krepar.", "Tell me about Krepar."), null)
			call speech(info, character, true, tre("Krepar ist eine der vier Götter. Einst war ich eine Dienerin der Kleriker, welche den Gott Urkarus verehren. Bei diesen lernte ich durch meine Stellung als Bibliothekarin der großen Bibliothek des Ordens in Klerfurt eine Menge über die alte Gesellschaft, die sich noch stärker zur Natur verbunden fühlte.", "Krepar is one of the four gods. Once I was a servant of the clerics who worship the gold Urkarus. With them I learned a lot about the old society, which felt even more strongly connected with nature, by my position as libarian of the great library of the order in Klerfurt."), gg_snd_Ursula8)
			call speech(info, character, true, tre("Damals lebten die Leute noch in einfachen Hütten in den Wäldern und waren eins mit der Natur.", "At that time, people lived in simple huts in the woods and were one with nature."), gg_snd_Ursula9)
			call speech(info, character, true, tre("Druiden, weise Persönlichkeiten, beteten Krepar, die Göttin der Natur und Symbiose an. Auf ihren Rat hörten die Bewohner der kleinen Siedlungen und suchten ihren Rat, wenn es etwas zu bewältigen gab.", "Druids, wise personailities, prayed to Krepar, the goddess of nature and symbiosis. On their advice, the inhabitants of the small settlements heard and sought their advice when there was something to be done."), gg_snd_Ursula10)
			call speech(info, character, true, tre("Anders als die heutigen Orden, gab es weniger durch die Herkunft bedingte Herrschaftshierarchien. Man respektierte die Alten und Weisen, denn ihr Rat war meist der beste.", "Unlike today's orders, there were fewer reigning hierarchies depending on the origins of people. They respected the old and wise, for their advice was usually the best."), gg_snd_Ursula11)
			call speech(info, character, true, tre("Krepar schuf die Natur um uns herum. Jeder Baum, jede Pflanze und jedes Tier ist ein Geschöpf ihrer. Daher sollte man sie ehren und dankbar sein.", "Krepare created the nature around us. Every tree, every plant and every animal is a creature of her. Therefore she should be honoured and you should be grateful."), gg_snd_Ursula12)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kannst du mich heilen?
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kannst du mich heilen?", "Can you heal me?"), null)
			call speech(info, character, true, tre("Krepar, leihe mir deine Kraft!", "Krepar, lend me your strength!"), gg_snd_Ursula13)
			call QueueUnitAnimation(gg_unit_n01U_0203, "Spell")
			call DestroyEffect(AddSpecialEffectTarget("Spells\\Models\\Effects\\Genesung.mdl", character.unit(), "chest"))
			call SetUnitLifePercentBJ(gg_unit_n01U_0203, 100.0)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich dir irgendwie helfen?", "Can I help you?"), null)
			call speech(info, character, true, tre("Sehe ich denn aus als bräuchte ich Hilfe?", "Do I look like I need help?"), gg_snd_Ursula14)
			call speech(info, character, false, tre("Na ja …", "Well ..."), null)
			call speech(info, character, true, tre("Schon gut, ich brauche tatsächlich Hilfe.", "Alright, I really need help."), gg_snd_Ursula15)
			call speech(info, character, true, tre("Ganz in der Nähe gibt es eine alte Eiche. Sie spendete mir stets Schatten während meiner langen Stunden des Philosophierens über dieses einfache Leben, das Krepar mir geschenkt hat. Doch nun haben starke, wilde Kreaturen die Eiche für sich in Anspruch genommen.", "There is an old oak tree nearby. It always gave me shadows during my long hours of philosophizing about this simple life that Krepar gave me. But now strong, wild creatures have claimed the oak for themselves."), gg_snd_Ursula16)
			call speech(info, character, true, tre("Da aber auch sie Geschöpfe Krepars sind, möchte ich, dass du sie nicht tötest, sondern ihre Geister einfängst.", "But since they too are Krepar's creatures, I want you not to kill them but to trap their spirits."), gg_snd_Ursula17)
			call speech(info, character, false, tre("Wie soll ich das anstellen?", "How shoul I do this?"), null)
			call speech(info, character, true, tre("Dazu gebe ich dir diesen Totem. Bringe mir den Geist von einer der Kreaturen, damit ich sie verstehen lerne und mich mit ihnen anfreunden kann und ich werde dir etwas schenken.", "I give you this totem. Bring me the spirit of one of the creatures, so I can understand them and make friends with them, and I will give you something."), gg_snd_Ursula18)
			call speech(info, character, false, tre("Und was?", "And what?"), null)
			call speech(info, character, true, tre("Das siehst du dann noch.", "You'll see."), gg_snd_Ursula19)
			call info.talk().showRange(11, 12, character)
		endmethod

		// (Nachdem der Charakter gefragt hat, ob er irgendwie helfen kann)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(5, character)
		endmethod

		// Du kannst die Geister wilder Kreaturen einfangen?
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Du kannst die Geister wilder Kreaturen einfangen?", "You can capture the spirits of wild creatures?"), null)
			call speech(info, character, true, tre("Ja, jeder kann das. Man braucht nur Geduld und muss von der Vorstellung der Vorherrschaft seiner eigenen Art wegkommen. Zeige dem Lebewesen deinen Respekt. Wenn du das beherrscht, wird es auch dich respektieren und das ermöglicht dir, zu seinem Geist durchzudringen.", "Yes, everyone can do that. One only needs patience and must get away from the notion of supremacy of its own kind. Show your respect to the creature. If you master that, it will also respect you and that will allow you to penetrate to his mind."), gg_snd_Ursula22)
			call speech(info, character, true, tre("Natürlich lernt man das nicht mal eben so, vielleicht ist „einfangen“ auch das falsche Wort. Man versucht vielmehr eins zu werden mit der Kreatur und wenn sie deine gute Absicht bemerkt, lässt sie dich an ihren Geist heran.", "Of course you do not learn it just like that, maybe \"catch\" is the wrong word. Rather, one tries to become one with the creature, and when it notices your good intention, it makes you approach your mind."), gg_snd_Ursula23)
			call speech(info, character, false, tre("Aber was ist daran eine gute Absicht?", "But what is a good intention?"), null)
			call speech(info, character, true, tre("Nun, ich lasse den Geist ja wieder frei, nachdem wir Informationen miteinander ausgetauscht haben.", "Well, I leave the spirit free after we exchanged information."), gg_snd_Ursula24)
			call speech(info, character, false, tre("Informationen?", "Information?"), null)
			call speech(info, character, true, tre("Du würdest dich sicher wundern, wenn du wüsstest, wie viel eine wilde Kreatur weiß. Sie vermag es vielleicht nicht, es aufzuschreiben oder anderen durch Sprache mitzuteilen, aber viele der wilden Kreaturen, auf die ich traf wussten mehr als so mancher sogenannter Zivilisierter.", "You would be wondering if you knew how much a wild creature knows. She may not be able to write it down or tell it to others by language, but many of the wild creatures I've met hit more than so many so-called civilized."), gg_snd_Ursula25)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Die Kraft der Eiche“ ist aktiv)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return QuestTheOaksPower.characterQuest(character).questItem(1).isNew()
		endmethod

		// Hier hast du deinen Totem wieder.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier hast du deinen Totem wieder.", "Here you have your totem again."), null)
			// Charakter gibt Ursula den Totem zurück.
			call character.inventory().removeItemType(QuestTheOaksPower.itemTypeId)
			call speech(info, character, true, tre("Du hast es also geschafft? Gut gemacht. Pass auf, ich gebe dir einen anderen Totem mit einem Teil der Kraft dieser Kreatur.", "So you did it? Well done. Look, I'll give you another totem with a part of the creature's power."), gg_snd_Ursula26)
			call speech(info, character, true, tre("Mit dem Toten wirst du in der Lage sein, die Kreatur herbeizurufen, zumindest mit einem Teil ihrer ursprünglichen Stärke. Allerdings wird sie nicht ihrem eigenen Instinkt folgen, sondern dir stattdessen stets treu ergeben sein.", "With the totem you will be able to summon the creature, at least part of its original strength. However, it won't follow its own instinct, but will always be faithful to you instead."), gg_snd_Ursula27)
			call speech(info, character, true, tre("Ziehe einen guten Nutzen daraus und behandle sie gut. Hier hast du noch ein paar Goldmünzen für deine Hilfe. Nun kann ich endlich eins werden mit diesen Wesen und mein Wissen mit ihnen teilen und auch von ihnen lernen.", "Take a good profit from it and treat it well. Here are some gold coins for your help. Now I can finally become one with these beings and share my knowledge with them and also learn from them."), gg_snd_Ursula28)
			// Auftrag „Die Kraft der Eiche“ abgeschlossen.
			call QuestTheOaksPower.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Verkaufst du auch was?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Verkaufst du auch was?", "Do you sell something?"), null)
			call speech(info, character, true, tre("Ja, ich möchte mein Wissen teilen. Einige meiner Bücher nützen mir nicht mehr viel, denn ich kenne sie bereits fast auswendig. Diese verkaufe ich, damit ich mir noch etwas Lebensunterhalt dazu verdienen kann.", "Yes, I want to share my knowledge. Some of my books do not help me much, because I know them almost by heart. I sell them, so I can earn a living."), gg_snd_Ursula29)
			call speech(info, character, true, tre("Ich werde nämlich langsam zu alt, um hinauszuziehen und Nahrung zu sammeln.", "I am getting too old to get out and get food."), gg_snd_Ursula30)
			call speech(info, character, true, tre("Auch wenn ich nicht viel von Besitz halte, so verkaufe ich die Bücher nicht gerade billig, da es wohl mein einziger, für gewöhnliche Leute ebenfalls wertvoller Besitz ist. Und glaube mir, es sind wahre Schätze darunter!", "Even though I do not think much of my possessions, I do not sell the books cheaply, since it is probably my only property, which is also valuable for ordinary people. And believe me, there are real treasures among them!"), gg_snd_Ursula31)
			call speech(info, character, true, tre("Noch viel wertvoller aber sind die Kreaturen, die mir von Zeit zu Zeit zulaufen. Sie sind zwar nicht mein Besitz, aber ich verlange auch für sie ein paar Goldmünzen, da sie mir auf Dauer sehr ans Herz wachsen.", "Still more valuable are the creatures that run into me from time to time. They are not my possessions, but I also demand for them a few gold coins, as they grow in my heart very much."), gg_snd_Ursula32)
			call speech(info, character, false, tre("Wovon sprichst du?", "What are you talking about?"), null)
			call speech(info, character, true, tre("Von den Katzen, die mir zulaufen. Hier in der Gegend scheint es von Katzen nur so zu wimmeln. Ich teile mein Essen mit ihnen und sie leben mit mir zusammen.", "Of the cats that run to me. Here in the area it seems to be teeming with cats. I share my food with them and they live with me."), gg_snd_Ursula33)
			call speech(info, character, true, tre("Da es wohl immer mehr werden, werde ich mich vermutlich von einigen von ihnen trennen  müssen, wenn ich nicht selbst verhungern will.", "Since it will probably become more and more, I will probably have to separate myself from some of them if I do not want to starve myself."), gg_snd_Ursula34)
			call speech(info, character, true, tre("Wenn du mir versprichst dich gut um sie zu kümmern, werde ich dir auch sie verkaufen.", "If you promise me to take care of them, I will sell them to you."), gg_snd_Ursula35)
			call speech(info, character, true, tre("Außerdem habe ich noch einige Gegenstände, um einen wahren Druiden auszurüsten. Vielleicht interessiert du dich ja dafür.", "In addition, I have some items to equip a true druid. Maybe you're interested in it."), gg_snd_Ursula36)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Samen für den Garten“ ist aktiv, permanent)
		private static method infoConditionSeedForTheGarden takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(0).isNew()
		endmethod

		// Trommon benötigt ein paar Samen für seinen Garten.
		private static method infoActionSeedForTheGarden takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Trommon benötigt ein paar Samen für seinen Garten.", "Trommon needs a few seeds for his garden."), null)
			call speech(info, character, true, tre("Trommon der Fährmann?", "Trommon the ferryman?"), gg_snd_Ursula37)
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Tatsächlich, er will sich also als Gärtner versuchen? Nun, wenn er so viel Vertrauen in mich setzt, muss ich ihn wohl dafür belohnen.", "In fact, he wants to try to be a gardener? Well, if he puts so much trust in me, I must probably reward him for it."), gg_snd_Ursula38)
			call speech(info, character, true, tre("Hat er dir denn etwas mitgegeben um mich zu bezahlen?", "Did he give you something to pay for?"), gg_snd_Ursula39)
			call info.talk().showRange(13, 14, character)
		endmethod

		// Gut.
		private static method infoAction5_0 takes AInfo info, ACharacter character returns nothing
			local item whichItem = null
			call speech(info, character, false, tre("Gut.", "Fine."), null)
			call speech(info, character, true, tre("Ich danke dir.", "I thank you."), gg_snd_Ursula20)
			// Neuer Auftrag „Die Kraft der Eiche“
			call QuestTheOaksPower.characterQuest(character).enable()
			set whichItem = CreateItem(QuestTheOaksPower.itemTypeId, GetUnitX(character.unit()), GetUnitY(character.unit()))
			call SetItemInvulnerable(whichItem, true)
			call SetItemPawnable(whichItem, false)
			call UnitAddItem(character.unit(), whichItem)
			call info.talk().showStartPage(character)
		endmethod

		// Kein Interesse.
		private static method infoAction5_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kein Interesse.", "No interest."), null)
			call speech(info, character, true, tre("Wie du meinst.", "As you mean."), gg_snd_Ursula21)
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat mindestens 50 Goldmünzen, permanent)
		private static method infoConditionEnoughGold takes AInfo info, ACharacter character returns boolean
			return character.gold() >= 50
		endmethod

		// Ja.
		private static method infoActionSeedForTheGarden_Yes takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Gut, gib mir die Goldmünzen und du erhältst einen sehr wertvollen, magischen Samen.", "Well, give me the gold coins and you get a very valuable, magical seed."), gg_snd_Ursula40)
			call speech(info, character, true, tre("Aber was daraus entstehen wird bleibt ein Geheimnis.", "But what will result from it remains a mystery."), gg_snd_Ursula41)
			// Goldmünzen entfernen
			call character.removeGold(50)
			// „Magischer Samen“ erhalten
			call character.giveQuestItem('I03N')
			// Auftragsziel 1 des Auftrags „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionSeedForTheGarden_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Tut mir Leid aber ganz umsonst werde ich das nicht entbehren.", "I'm sorry but I will not give it away for nothing."), gg_snd_Ursula42)
			call info.talk().showStartPage(character)
		endmethod

		// TODO
		// gg_snd_Ursula43

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01U_0203, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Was machst du hier?", "What are you doing here?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Wie ist dein Leben hier draußen so?", "How is your life out here?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tre("Womit verdienst du deinen Lebensunterhalt?", "What do you do for living?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Erzähl mir mehr von Krepar.", "Tell me about Krepar.")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Kannst du mich heilen?", "Can you heal me?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tre("Kann ich dir irgendwie helfen?", "Can I help you?")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tre("Du kannst die Geister wilder Kreaturen einfangen?", "You can capture the spirits of wild creatures?")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tre("Hier hast du deinen Totem wieder.", "Here you have your totem again.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tre("Verkaufst du auch was?", "Do you sell something?")) // 8
			call this.addInfo(true, false, thistype.infoConditionSeedForTheGarden, thistype.infoActionSeedForTheGarden, tre("Trommon benötigt ein paar Samen für seinen Garten.", "Trommon needs a few seeds for his garden.")) // 9
			call this.addExitButton() // 10

			// info 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tre("Gut.", "Fine.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tre("Kein Interesse.", "No interest.")) // 12

			// info 9
			call this.addInfo(true, false, thistype.infoConditionEnoughGold, thistype.infoActionSeedForTheGarden_Yes, tre("Ja.", "Yes.")) // 13
			call this.addInfo(true, false, 0, thistype.infoActionSeedForTheGarden_No, tre("Nein.", "No.")) // 14

			return this
		endmethod

		implement Talk
	endstruct

endlibrary