library StructMapTalksTalkBjoern requires Asl, StructMapQuestsQuestBurnTheBearsDown, StructMapQuestsQuestCoatsForThePeasants, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestPerdixHunt, StructMapQuestsQuestReinforcementForTalras

	struct TalkBjoern extends Talk
		private static constant integer smallGoldReward = 20
		private static constant integer bigGoldReward = 100
		// Riesen-Felle
		private static constant integer goldReward1 = 600
		private static constant integer goldReward2 = 450
		private AInfo m_hi
		private AInfo m_aboutDago
		private AInfo m_whatAreYouDoingHere
		private AInfo m_skins
		private AInfo m_apprentice
		private AInfo m_arrows
		private AInfo m_arrowsDone
		private AInfo m_whatDoYouSell
		private AInfo m_yourDogs
		private AInfo m_yourFalcons
		private AInfo m_hunt
		private AInfo m_whereAnimals
		private AInfo m_explainHunt
		private AInfo m_animals
		private AInfo m_exit
		private AInfo m_fromFarAway
		private AInfo m_noneOfYourBusiness
		private AInfo m_coins
		private AInfo m_halfOfYourReward
		private boolean m_toldDeath
		private integer m_toldBearFight
		private boolean m_bonus

		private method startPageAction takes ACharacter character returns nothing
			if (not this.infoHasBeenShownToCharacter(this.m_hi.index(), character)) then
				call this.showInfo(this.m_hi.index(), character)
			else
				call this.showUntil(this.m_exit.index(), character)
			endif
		endmethod

		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("He Fremder! Woher kommst du?", "Hey stranger! Where are you from?"), gg_snd_Bjoern1)
			call info.talk().showRange(this.m_fromFarAway.index(), this.m_noneOfYourBusiness.index(), character)
		endmethod

		// Woher kennst du Dago?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Woher kennst du Dago?", "Where do you know Dago from?"), null)
			call speech(info, character, true, tre("Er wohnt in der unteren Hütte und ist mit mir der einzige Jäger in Talras.", "He lives in the lower hut and is with me the only hunter in Talras."), gg_snd_Bjoern17)
			call speech(info, character, true, tre("Ich bin übrigens Björn.", "Anyway, I'm Björn."), gg_snd_Bjoern18)
			// (Björns Frau ist in der Nähe)
			if (IsUnitInRange(gg_unit_n02U_0142, gg_unit_n02V_0146, 600.0)) then
				call speech(info, character, false, tre("Ist das deine Frau?", "Is that your wife?"), null)
				call speech(info, character, true, tre("Ja und lass dir bloß nichts Dummes einfallen. Wenn du sie blöd anmachst oder anquatscht, prügel ich dir deine Dreck￼sfresse zu Brei, verstanden?", "Yes, and don't think about anything stupid. If you pick her up stupidly or talk to her I beat your dirt face to mush, understood?"), gg_snd_Bjoern19)
				// (Auftrag ￼„Felle für die Bauern￼“ nicht abgeschlossen)
				if (not QuestCoatsForThePeasants.characterQuest(character).isCompleted()) then
					call speech(info, character, false, tre("Komm mal wieder runter! Ich hab doch nur gefragt.", "Calm down! I just asked."), null)
					call speech(info, character, true, tre("Schon gut, aber bei sowas verstehe ich keinen Spaß und habe schon schlechte Erfahrung mit Landstreichern gemacht.", "All right, but with this don't understand any fun and have already had bad experience with vagrants."), gg_snd_Bjoern20)
				// (Auftrag ￼„Felle für die Bauern￼“ abgeschlossen)
				else
					call speech(info, character, false, tre("So so, du ￼Riese.", "Is that so you giant?"), null)
					call speech(info, character, true, tre("Ich ... äh ... ich, ich meine ... ich wollte nicht ... ich wollte nur ...", "I ... uh ... I, I mean ... I did not ... I just wanted ..."), null)
					call speech(info, character, false, tre("Höflich sagen, dass ich deine Frau gut behandeln soll?", "Politely say that I should treat your wife well?"), null)
					call speech(info, character, true, tre("Ja, ich meine ... ja, genau das!", "Yes, I mean ... yes, exactly!"), null)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (￼Björn befindet sich auf dem Bauernhof und nach ￼„Woher kennst du Dago?￼“)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return not RectContainsUnit(gg_rct_music_talras, Npcs.bjoern()) and info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Was machst du hier?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was machst du hier?", "What are you doing here?"), null)
			call speech(info, character, true, tre("Ich verkaufe dem Bauern Manfred Felle. Allerdings fehlen mir noch ￼Riesen-Felle. Die Viecher sind einfach zu stark für mich und ich bleibe lieber am Leben als dass ich ein besseres Geschäft mache.", "I sell furs to the farmer Manfred. However, I still need some giant furs. These critters are just too strong for me and I prefer to stay alive than doing a better business."), gg_snd_Bjoern23)
			call speech(info, character, false, tre("￼Riesen-Felle?", "Giant furs?"), null)
			call speech(info, character, true, tre("Ja, östlich vom Fluss leben einige ￼Riesen. Die sind groß und haben folglich große Felle, die man sehr teuer verkaufen kann. Du müsstest mit Trommons Fähre rüberfahren.", "Yes, east of the river live some giants. They are large and therefore have large furs which you can sell very expensive. You'd have to cross the river with Trommon's ferryboat."), gg_snd_Bjoern24)
			call speech(info, character, true, tre("Allerdings würde ich dir das nicht empfehlen, da die Viecher einfach verdammt aggressiv und stark sind. Mit drei dieser verdammten Felle hätte ich bestimmt den Gewinn eines ganzen Jahres drinnen.", "However, I would not recommend you this because the critters are just damn aggressive and strong. WIth three of those damned furs I certainly would have the profit of a whole year."), gg_snd_Bjoern25)
			// Neuer Auftrag ￼„Felle für die Bauern￼“
			call QuestCoatsForThePeasants.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags ￼„Felle für die Bauern￼“ abgeschlossen und Charakter hat tatsächlich drei Riesen-Felle)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestCoatsForThePeasants.characterQuest(character).questItem(0).isCompleted() and character.inventory().totalItemTypeCharges('I01Z') >= 3
		endmethod

		// Ich habe hier drei Riesen-Felle.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Ich habe hier drei Riesen-Felle.", "I have three giant furs here."), null)
			call character.inventory().removeItemType('I01Z')
			call character.inventory().removeItemType('I01Z')
			call character.inventory().removeItemType('I01Z')
			call speech(info, character, true, tre("Willst du mich verarschen oder was? ... Tatsächlich! Verdammt, wie hast du das angestellt?", "Are you kidding me or what? ... Indeed! Damn, how did you do that?"), gg_snd_Bjoern26)
			call speech(info, character, false, tre("Mit Gewalt.", "With violence."), null)
			call speech(info, character, true, tre("Mann, vor dir sollte man sich besser in Acht nehmen. Scheinst ja ein harter Brocken zu sein. Wie viel willst du für die Felle?", "Man, in front of you one should better be careful. You seem to be a tough one indeed. How much do you want for the furs?"), gg_snd_Bjoern27)
			call info.talk().showRange(this.m_coins.index(), this.m_halfOfYourReward.index(), character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ aktiv und nicht abgeschlossen)
		private static method infoConditionApprentice takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isNew()
		endmethod

		// Suchst du einen Schüler?
		private static method infoActionApprentice takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Suchst du einen Schüler?", "Are you looking for a student?"), null)
			call speech(info, character, true, tre("Einen Schüler? Du meinst ich soll jemandem das Jagen beibringen?", "A student? You mean I should teach someone to hunt?"), gg_snd_Bjoern30)
			call speech(info, character, false, tre("Ganz genau.", "Exactly."), null)
			call speech(info, character, true, tre("Möglich, ich würde es jedoch nicht umsonst tun! Um wen geht es denn?", "Possible, I would however not do it for free! Who is this about, anwyway?"), gg_snd_Bjoern31)
			call speech(info, character, false, tre("Um Kunos Tochter.", "It's about Kuno's daughter."), null)
			call speech(info, character, true, tre("Kunos Tochter?! Na sowas, damit hätte ich jetzt nicht gerechnet. Also wenn das so ist …", "Kuno's daughter?! Well, that's something I would not have expected. So if it is like that ..."), gg_snd_Bjoern32)
			call speech(info, character, true, tre("Kuno liefert Holz an den Bauernhof auf dem ich selbst Felle verkaufe. Er ist ein anständiger Kerl.", "Kuno delivers wood to the farm on which I myself sell furs. He's a decent guy."), gg_snd_Bjoern33)
			call speech(info, character, true, tre("Er lebt da draußen ganz alleine mit seiner Tochter im Wald. Es könnte nicht schaden, wenn sie sich in der Wildnis besser zurechtfände. Immerhin ist das ein verdammt gefährlicher Wald.", "He lives far outside alone with his daughter in the woods. It would not hurt if she gets used to the wild better. After all, this is a damn dangerous forest."), gg_snd_Bjoern34)
			call speech(info, character, true, tre("Sag ihm, ich werde seine Tochter ausbilden, wenn er sie vorbeischickt. Es kostet ihn natürlich nichts.", "Tell him I'm going to train his daughter when he sends her over. Of course, it will cost him nothing."), gg_snd_Bjoern35)
			call speech(info, character, false, tre("Mache ich.", "I do."), null)
			call QuestKunosDaughter.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 3 des Auftrags „Die Befestigung von Talras“ ist aktiv)
		private static method infoConditionArrows takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(2).isNew()
		endmethod

		// Kannst du Pfeile herstellen?
		private static method infoActionArrows takes AInfo info, ACharacter character returns nothing
			local AQuest whichQuest = QuestReinforcementForTalras.characterQuest(character)
			call speech(info, character, false, tre("Kannst du Pfeile herstellen?", "Can you produce arrows?"), null)
			call speech(info, character, true, tre("Klar, wieso fragst du?", "Sure, why do you ask?"), gg_snd_Bjoern36)
			call speech(info, character, false, tre("Markward benötigt Pfeile zur Verteidigung der Burg.", "Markward needs arrows to defend the castle."), null)
			call speech(info, character, true, tre("Ich sehe schon es handelt sich um eine wichtige Angelegenheit. Pass auf ich fertige neue Pfeile an und gebe ihm noch ein paar von mir.", "I can see it is an important matter. Look, I make new arrows and still give him a couple of mine."), gg_snd_Bjoern37)
			call speech(info, character, true, tre("Das dauert allerdings eine Weile. Komm später noch einmal vorbei.", "However, this takes a while. Come back later."), gg_snd_Bjoern37_1)
			// Auftragsziel 3 des Auftrags „Die Befestigung von Talras“ abgeschlossen
			call whichQuest.questItem(2).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ aktiviert
			call whichQuest.questItem(3).setState(AAbstractQuest.stateNew)
			call whichQuest.displayUpdate()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ ist aktiv)
		private static method infoConditionArrowsDone takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(3).isNew()
		endmethod

		// Sind die Pfeile fertig?
		private static method infoActionArrowsDone takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			local QuestReinforcementForTalras whichQuest = QuestReinforcementForTalras(QuestReinforcementForTalras.characterQuest(character))
			call speech(info, character, false, tre("Sind die Pfeile fertig?", "Are the arrows ready?"), null)
			// (Genügend Zeit ist vergangen)
			if (whichQuest.oneMinutePassed()) then
				call speech(info, character, true, tre("Ja, hier hast du sie. Am besten du platzierst sie an strategisch wichtigen Orten in der Burg.", "Yes, here you have it. It's best to place them at strategic important places in the castle."), null)
				call speech(info, character, true, tre("Markward wird dich sowieso früher oder später mit den Pfeilen losschicken.", "Markward will send you out with the arrows sooner or later anyway."), gg_snd_Bjoern39)
				// Charakter erhält Pfeilbündel
				call character.giveQuestItem('I03U')
				// Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ abgeschlossen
				call QuestReinforcementForTalras.characterQuest(character).questItem(3).setState(AAbstractQuest.stateCompleted)
				// Auftragsziel 5 des Auftrags „Die Befestigung von Talras“ aktiviert
				call QuestReinforcementForTalras.characterQuest(character).questItem(4).setState(AAbstractQuest.stateNew)
				call QuestReinforcementForTalras.characterQuest(character).displayUpdate()
			// (Weniger als fünf Sekunden sind vergangen)
			elseif (whichQuest.lessThanFiveSecondsPassed() and not this.m_bonus) then
				call speech(info, character, true, tre("Du bist ja lustig. Es sind noch nicht einmal fünf Sekunden vergangen!", "You're funny. It has not even lasted five seconds!"), gg_snd_Bjoern40)
				// Erfahrungsbonus „Ungeduld“
				call character.xpBonus(50, tre("Ungeduld", "Impatience"))
				set this.m_bonus = true
			// (Noch keine zwei Tage vergangen)
			else
				call speech(info, character, false, tre("Nein, du musst dich noch etwas gedulden.", "No, you have to wait a bit longer."), gg_snd_Bjoern41)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Was verkaufst du?
		private static method infoActionWhatDoYouSell takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Was verkaufst du?", "What do you sell?"), null)
			call speech(info, character, true, tre("Alles was ein Jäger so gebrauchen kann. Einen guten Bogen, warme Bekleidung, Pfeile, Fallen und Messer. Sieh es dir einfach an.", "Everything a hunter can use. A good bow, warm clothing, arrows, traps and knives. Just look at it."), gg_snd_Bjoern42)

			call info.talk().showStartPage(character)
		endmethod

		// (Björn befindet sich in der Burg)
		private static method infoConditionBjoernIsInCastle takes AInfo info, ACharacter character returns boolean
			return RectContainsUnit(gg_rct_area_bjoern, Npcs.bjoern())
		endmethod

		// Ist das dein Hundezwinger?
		private static method infoActionYourDogs takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ist das dein Hundezwinger?", "Ist that your dog kennel?"), null)
			call speech(info, character, true, tre("In der Tat, aber eigentlich gehört er dem Herzog. Dago und ich kümmern uns jedoch um die Hunde.", "Indeed, but actually it belongs to the duke. However Dago and I take care of the dogs."), gg_snd_Bjoern43)

			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tre("Nun muss ich mich wohl alleine um sie kümmern.", "Now I have to take care of them alone."), gg_snd_Bjoern44)
			endif

			call speech(info, character, true, tre("Die Hunde wurden von uns zu den besten Jagdhunden weit und breit ausgebildet. Sie spüren jeden Fuchs und jeden Hasen auf. Ich bin ganz besonders stolz auf sie.", "The dogs were trained by us to the best hunting dogs far and wide. They track down every fox and rabbit. I am particularly proud of them."), gg_snd_Bjoern45)
			call speech(info, character, true, tre("Der Herzog veranstaltet nur selten eine Treibjagd, zu besonderen Anlässen. Wenn es soweit ist, dann müssen sie gut vorbereitet sein.", "The duke hosts rarely a battue, on sepcial occasions. When the time comes, then they must be well prepared."), gg_snd_Bjoern46)
			call speech(info, character, false, tre("Verkaufst du auch Hunde?", "Do you sell dogs?"), null)
			call speech(info, character, true, tre("Was?! Was erlaubst du dir? Diese Hunde sind mir ans Herz gewachsen. Nie würde ich sie hergeben.", "What?! How dare you? These dogs are very close to my heart. I would never give them away."), gg_snd_Bjoern47)
			call speech(info, character, false, tre("Ich dachte sie gehören dem Herzog.", "I thought they belong to the duke."), null)
			call speech(info, character, true, tre("Ja, sicher … also gut. Der Herzog hat tatsächlich zu viele Hunde. Die vermehren sich auch wie die Karnickel. Wenn du einen angemessenen Preis bezahlst, dann kannst du einen Hund haben.", "Yeah, sure ... okay. The duke actually has too many dogs. They multiply even like rabbits. If you pay a reasonable price, then you can have a dog."), gg_snd_Bjoern48)
			call speech(info, character, true, tre("Aber bitte behandele sie gut. Du weißt nicht wie lange ich mit einigen schon zusammenlebe. Da baut man eine Bindung auf die stärker ist als zu manchem Menschen.", "But please treat them well. You do not know how long I've lived with some of them. You build a bond that is stronger than the bond to many people."), gg_snd_Bjoern49)

			call info.talk().showStartPage(character)
		endmethod

		// Ist das dein Falkenkäfig?
		private static method infoActionYourFalcons takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ist das dein Falkenkäfig?", "Is that your falcon cage?"), null)
			call speech(info, character, true, tre("Ja das ist er. Die Falken darin gehören allerdings dem Herzog. Dago und ich haben diese Falken für ihn ausgebildet.", "Yes it is. The falcons however belong to the duke. Dago and I have trained these falcons for him."), gg_snd_Bjoern50)

			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tre("Aber jetzt bin ich wohl alleine für sich verantwortlich (traurig).", "But now I am probably responsible for them by myself (sad)."), gg_snd_Bjoern51)
			endif
			call speech(info, character, true, tre("Die Falknerei ist eine schwierige Form der Jagd, musst du wissen. Es erfordert viel Geduld und Übung, bis ein Falke ausgebildet ist. Diese Tiere besitzen einen großen persönlichen Wert für mich.", "Falconery is a difficult form of hunting, you know. It requires a lot of patience and practice until a falcon is trained. These animals have a great personal value for me."), gg_snd_Bjoern52)
			call speech(info, character, true, tre("Aber auch für den Adel sind sie von unschätzbarem Wert. Ein ausgebildeter Jagdfalke ist fast unbezahlbar.", "But also for the nobility they are invaluable. A trained falcon is almost priceless."), gg_snd_Bjoern53)
			call speech(info, character, true, tre("Ich hoffe der Herzog geht bald wieder auf eine Jagd mit ihnen. Das ist das größte Erlebnis für einen einfachen Jäger wie mich.", "I hope the duke is soon on a hunt with them. This is the greatest experience for a simple hunter like me."), gg_snd_Bjoern54)
			call speech(info, character, false, tre("Kann man sie auch kaufen?", "Can you buy them, too?"), null)
			call speech(info, character, true, tre("Sicher, wenn du die nötigen Goldmünzen dabei hast. Das glaube ich aber kaum. Vielleicht hat der Herzog ja noch Schulden bei irgendwem, aber er gestattet tatsächlich den Verkauf dieser wunderbaren Tiere.", "Sure, if you have the necessary gold coins with you. But I can hardly believe that. Perhaps the duke has still debts to anyone, but he actually allows the sale of these wonderful animals."), gg_snd_Bjoern55)

			call info.talk().showStartPage(character)
		endmethod

		// Geh mit mir auf die Jagd.
		private static method infoActionHunt takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Geh mit mir auf die Jagd.", "Go with me to hunt."), null)
			call speech(info, character, true, tre("Tut mir leid, ich habe gerade keine Zeit dafür. Kennst du dich denn überhaupt damit aus?", "I'm sorry, I just do not have time for it. Are you even familiar with it?"), gg_snd_Bjoern56)
			call speech(info, character, false, tre("Bestimmt.", "Certainly."), null)
			call speech(info, character, true, tre("Gut, dann geh doch selbst jagen. Wenn du einen Vorstehhund und einen Jagdfalken hast, dann kannst du Rebhühner jagen. Der Vorstehhund zeigt dir, dass er das Huhn gefunden hat. Der Falke wartet in der Luft ab, dann lässt du das Wild vom Vorstehhund aufscheuchen und der Falke stürzt sich darauf.", "Well, then go hunting yourself. If you have a pointing dog and a hunting falcon, then you can hunt patridges. The pointing dog shows you that he has found a patridge. The falcon waits in the air, then you let startle the wild by the pointing dog and the falcon pounces on it."), gg_snd_Bjoern57)
			call speech(info, character, true, tre("Das ist nicht so einfach, aber wenn du ein erfahrener Jäger bist, schaffst du das sicher. Allerdings kann ich mir nicht vorstellen, dass du dir einen Jagdfalken leisten kannst.", "This is not that easy, but if you are an experience hunter, you can do it safely. However, I cannot imagine that you can afford a hunting falcon."), gg_snd_Bjoern58)
			call speech(info, character, true, tre("Der Herzog verspeist Rebhühner als hätte er hunderte davon in der Küche herumliegen. Du würdest mir also einen großen Gefallen tun, wenn du welche für mich jagst.", "The duke eats patridges as if he had hundreds of them lying around in the kitchen. Therefore you would do me a great favor if you hunt some for me."), gg_snd_Bjoern59)
			call speech(info, character, true, tre("Ich könnte dich dafür natürlich auch bezahlen.", "Of course I could pay you for that."), gg_snd_Bjoern60)

			// Neuer Auftrag „Rebhuhnjagd“
			call QuestPerdixHunt.characterQuest(character).enable()

			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Rebhuhnjagd“ ist aktiv)
		private static method infoConditionWhereAnimals takes AInfo info, ACharacter character returns boolean
			return QuestPerdixHunt.characterQuest(character).questItem(0).isNew()
		endmethod

		// Wo finde ich Rebhühner?
		private static method infoActionWhereAnimals takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wo finde ich Rebhühner?", "Where can I find patridges?"), null)
			call speech(info, character, true, tre("Ich gehe immer in der Nähe des Friedhofs am Bauernhof jagen.", "I always go hunting near the cemetery at the farm."), gg_snd_Bjoern61)
			call speech(info, character, true, tre("Westlich davon befindet sich eine kleine Wiese zwischen dem Friedhof und den Kühen. Dort gibt es einige Rebhühner.", "To the west there is a small meadow between the cemetery and the cows. There are some patridges."), gg_snd_Bjoern62)

			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Rebhuhnjagd“ ist aktiv)
		private static method infoConditionExplainHunt takes AInfo info, ACharacter character returns boolean
			return QuestPerdixHunt.characterQuest(character).questItem(0).isNew()
		endmethod

		// Erkläre mir noch mal die Rebhuhnjagd.
		private static method infoActionExplainHunt takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Erkläre mir noch mal die Rebhuhnjagd.", "Explain to me again the patridge hunting."), null)
			call speech(info, character, true, tre("So, ich dachte du bist ein erfahrener Jäger? Schon gut, jeder fängt mal klein an.", "So, I thought you were an experienced hunter? All right, everyone has to start somewhere."), gg_snd_Bjoern63)
			call speech(info, character, true, tre("Du schickst deinen Vorstehhund los, um das Rebhuhn aufzuspüren. Hat er es aufgespürt, schickst du deinen Jagdfalken in die Nähe. Er hält sich bereit.", "You send your pointing dog to track the patridge. Did he track it, you send your hunting falcon near it. He keeps himself ready."), gg_snd_Bjoern64)
			call speech(info, character, true, tre("Dein Vorstehhund muss dann das Rebhuhn aufscheuchen. Es fliegt los und dein Falke greift es sich. Lass dir aber nicht zu viel Zeit, sonst verschwindet das Rebhuhn wieder.", "Your pointing dog must then startle the patridge. It takes off and your falcon grabs it. But do not wait too long, otherwise the patridge disappears."), null)

			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Rebhuhnjagd“ ist abgeschlossen und Charakter hat fünf tote Rebhühner im Rucksack)
		private static method infoConditionAnimals takes AInfo info, ACharacter character returns boolean
			return QuestPerdixHunt.characterQuest(character).questItem(0).isCompleted() and character.inventory().totalItemTypeCharges('I059') == QuestPerdixHunt.maxAnimals
		endmethod

		// Ich habe die Rebhühner.
		private static method infoActionAnimals takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe die Rebhühner.", "I have the patridges."), null)
			call speech(info, character, true, tre("Tatsächlich? Du scheinst ja ein fähiger Mann zu sein. Hier hast du deine Belohnung. Hab vielen Dank für die Mühe, da wird sich der Herzog freuen!", "Really? You seem to be an able man. Here you have your reward. Have many thanks for the effort, the duke will be delighted!"), gg_snd_Bjoern65)
			// Rebhühner aus Rucksack entfernen
			call character.inventory().removeItemTypeCount('I059', QuestPerdixHunt.maxAnimals)
			// Auftrag „Rebhuhnjagd“ abgeschlossen
			call QuestPerdixHunt.characterQuest(character).complete()

			call info.talk().showStartPage(character)
		endmethod


		private static method infoAction0_0And0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Er jagt irgendwo südöstlich der Burg und sollte eigentlich längst schon zurückgekehrt sein.", "He hunts somewhere southeast of the castle and was supposed to have returned long ago."), gg_snd_Bjoern4)
			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tre("Dago ist tot. Die Bären haben ihn gefressen.", "Dago is dead. The bears ate him."), null)
				// (Ist der erste Charakter, der vom Tod Dagos erzählt)
				if (not thistype(info.talk()).m_toldDeath) then
					call speech(info, character, true, tre("So eine Scheiße! Diese verdammten Bären! Moment, bist du dir überhaupt sicher, dass es Dago war?", "What a crap! Those damn bears! One second, are you sure at all that it was Dago?"), gg_snd_Bjoern5)
					call speech(info, character, false, tre("Wenn er einen Bogen bei sich trug und Jagdkleidung an hatte, dann war es wohl Dago.", "If he wore a bow with him and had on hunting clothes, then it was probably Dago."), null)
					call speech(info, character, true, tre("Ja, das tat er. Das gibt’s doch nicht. Getötet von Bären, der Arme.", "Yes, he did. That's impossible. Killed by bears, the poor."), gg_snd_Bjoern6)
					set thistype(info.talk()).m_toldDeath = true
				// (Ist nicht erste Charakter, der vom Tod Dagos erzählt)
				else
					call speech(info, character, true, tre("Dann muss es wahr sein. Du bist nicht der Erste, der mir das erzählt. Verdammter Mist!", "Then it must be true. You're not the first person to tell me this. Bloody hell!"), gg_snd_Bjoern7)
				endif
			// (Dago lebt)
			else
				call speech(info, character, false, tre("Ja, bin ich.", "Yes, I have."), null)
				if (QuestMushroomSearch.characterQuest(character).state() == AAbstractQuest.stateNotUsed and QuestBurnTheBearsDown.characterQuest(character) == AAbstractQuest.stateNotUsed) then
					// (Charakter spielt mit anderen und weiß nichts von den Pilzen oder der Niederbrennung der Bären)
					if (ACharacter.countAllPlaying() > 1) then
						call speech(info, character, false, tre("Meine Gefährten und ich haben ihm geholfen, zwei Bären zu töten, die ihn angriffen.", "My fellows and I have helped him to kill two bears that attacked him."), null)
						// (Ist der erste Charakter, der ihm davon berichtet)
						if (thistype(info.talk()).m_toldBearFight == 0) then
							call speech(info, character, true, tre("Tatsächlich? Hmm, ich werde mich mal umhören und schauen, ob ich dir das glauben kann. Na ja, du hast mir ja immerhin davon berichtet, dass er noch lebt und das glaube ich dir.", "Really? Hmm, I'll ask around and see if I can believe you that. Well, you have reported me that he still lives after all and I believe you this."), gg_snd_Bjoern8)
							call speech(info, character, true, IntegerArg(tre("Diese Information ist mir %i Goldmünzen wert. Da hast du sie.", "This information is worth to me %i gold coins. There you have it."), thistype.smallGoldReward), gg_snd_Bjoern9)
							// Charakter erhält 20 Goldmünzen.
							call character.addGold(thistype.smallGoldReward)
							set thistype(info.talk()).m_toldBearFight = 1
						// (Ist nicht der erste Charakter, der ihm davon berichtet)
						else
							call speech(info, character, true, IntegerArg(tre("Einer deiner Freunde hat mir etwas Ähnliches erzählt. Hier hast du %i Goldmünzen für eure noble Tat!", "One of your friends told me something similar. Here you have %i gold coins for your noble act!"), thistype.bigGoldReward), gg_snd_Bjoern10)
							// Charakter erhält 100 Goldmünzen.
							call character.addGold(thistype.bigGoldReward)
							set thistype(info.talk()).m_toldBearFight = thistype(info.talk()).m_toldBearFight + 1
						endif
					// (Charakter spielt alleine und weiß nichts von den Pilzen oder der Niederbrennung der Bären)
					else
						call speech(info, character, false, tre("Ich habe ihm geholfen, zwei Bären zu töten, die ihn angriffen.", "I helped him to kill two bears that attacked him."), null)
						call speech(info, character, true, tre("Was denn? Du ganz allein? Dass ich nicht lache! Na wenigstens geht es ihm gut. Danke für die Auskunft, Fremder. Hier hast du ein paar Goldmünzen.", "What? You alone? Do not make me laugh! Well at least he's okay. Thanks for the information, stranger. Here you have a few gold coins."), gg_snd_Bjoern11)
						// Charakter erhält 20 Goldmünzen.
						call character.addGold(thistype.smallGoldReward)
					endif
				else
					// (Charakter weiß von den Pilzen)
					if (QuestMushroomSearch.characterQuest(character).state() != AAbstractQuest.stateNotUsed) then
						call speech(info, character, false, tre("Er wollte noch ein paar Pilze sammeln bevor, er in die Burg zurückkehrt.", "He wanted to collect a few more mushrooms before he returns to the castle."), null)
						call speech(info, character, true, tre("Ja, das kann gut sein. Gut dass es ihm gut geht. Ich habe mir schon Sorgen gemacht.", "Yes, that is likely to be true. Good that he's fine. I was worried."), gg_snd_Bjoern12)
						// (Mehr als ein Charakter hat bereits von der Bärentat erzählt)
						if (thistype(info.talk()).m_toldBearFight > 1) then
							call speech(info, character, true, IntegerArg(tre("Mir ist übrigens von eurer noblen Tat zu Ohren gekommen. Danke, dass ihr Dago beschützt habt. Hier hast du %i Goldmünzen. Das ist es mir einfach wert.", "By the way, I heard about your noble act. Thank you for protecting Dago. Here you have %i gold coins. That's just worth it."), thistype.bigGoldReward), gg_snd_Bjoern13)
							// Charakter erhält 100 Goldmünzen.
							call character.addGold(thistype.bigGoldReward)
						endif
					endif
					// (Charakter hat den Auftrag „Brennt die Bären nieder!“ erhalten)
					if (QuestBurnTheBearsDown.characterQuest(character).state() != AAbstractQuest.stateNotUsed) then
						call speech(info, character, false, tre("Er wollte sich an einigen Bären rächen, von denen wir zwei gemeinsam getötet haben.", "He wanted to take revenge on some bears of which we killed two together."), null)
						call speech(info, character, true, tre("Das sieht ihm ähnlich.", "That's just like him."), gg_snd_Bjoern14)
						// (Noch kein Charakter hat von der Sache mit den Bären berichtet)
						if (thistype(info.talk()).m_toldBearFight == 0) then
							call speech(info, character, true, IntegerArg(tre("Klingt nur etwas seltsam, das mit dem Töten zweier Bären meine ich. Dennoch, hier hast du %i Goldmünzen für die Auskunft.", "Sounds just a little strange, I mean the killing of two bears. Yet, here you have %i gold coins for the information."), thistype.smallGoldReward), null)
							// Charakter erhält 20 Goldmünzen
							call character.addGold(thistype.smallGoldReward)
							set thistype(info.talk()).m_toldBearFight = 1
						// (Ist nicht der erste Charakter, der ihm davon berichtet)
						else
							call speech(info, character, true, IntegerArg(tre("Ich habe von eurem gemeinsamen Kampf gehört und bin stolz auf euch, dass ihr ihm geholfen habt. Hier hast du %i Goldmünzen.", "I have heard of your fight which you fought together and am proud of you that you helped him. Here you have %i gold coins."), thistype.bigGoldReward), gg_snd_Bjoern16)
							// Charakter erhält 100 Goldmünzen
							call character.addGold(thistype.bigGoldReward)
							set thistype(info.talk()).m_toldBearFight =  thistype(info.talk()).m_toldBearFight + 1
						endif
					endif
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Von weit her.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Von weit her.", "From far away."), null)
			call speech(info, character, true, tre("So, dann bist du vielleicht meinem Freund Dago begegnet.￼", "So, then you might have met my friend Dago."), gg_snd_Bjoern2)
			call thistype.infoAction0_0And0_1(info, character)
		endmethod

		// Das geht dich überhaupt nichts an!
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Das geht dich überhaupt nichts an!", "That's none of your business!"), null)
			call speech(info, character, true, tre("Ich wollte nur wissen, ob du vielleicht meinen Freund Dago begegnet bist.", "I just wanted to know if you might have met my friend Dago."), gg_snd_Bjoern3)
			call thistype.infoAction0_0And0_1(info, character)
		endmethod

		// %1% Goldmünzen.
		private static method infoAction2_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, Format(tre("%1% Goldmünzen.",  "%1% gold coins.")).i(thistype.goldReward1).result(), null)
			call speech(info, character, true, Format(tre("In Ordnung. Hier hast du %1% Goldmünzen. Damit kriege ich immer noch ein Drittel des Gewinns rein. Vielen Dank.", "Allright. Here you have %1% gold coins. So I get still one third of the profits. Thank you very much.")).i(thistype.goldReward1).result(), gg_snd_Bjoern28)
			// Charakter erhält 600 Goldmünzen.
			call character.addGold(thistype.goldReward1)
			// Auftrag „Felle für die Bauern“ abgeschlossen
			call QuestCoatsForThePeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Die Hälfte deines Gewinns.
		private static method infoAction2_1 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Die Hälfte deines Gewinns.", "Half of your profits."), null)
			call speech(info, character, true, Format(tre("In Ordnung. Hier hast du %1% Goldmünzen und zum Dank schenke ich dir noch einen meiner schönsten Bogen.", "Allright. Here you have %1% gold coins and in gratitude I even give you one of my most beautiful bows.")).i(thistype.goldReward2).result(), gg_snd_Bjoern29)
			// Charakter erhält „Björns Kurzbogen“ und 450 Goldmünzen.
			call character.addGold(thistype.goldReward2)
			/// add bow
			call character.giveItem('I06M')
			// Auftrag „Felle für die Bauern“ abgeschlossen.
			call QuestCoatsForThePeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.bjoern(), thistype.startPageAction)
			set this.m_toldDeath = false
			set this.m_bonus = false
			set this.m_toldBearFight = 0

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoAction0, null)
			set this.m_aboutDago = this.addInfo(false, false, 0, thistype.infoAction1, tre("Woher kennst du Dago?", "Where do you know Dago from?"))
			set this.m_whatAreYouDoingHere = this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tre("Was machst du hier?", "What are you doing here?"))
			set this.m_skins = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Ich habe hier drei Riesen-Felle.", "I have three giant furs here."))
			set this.m_apprentice = this.addInfo(false, false, thistype.infoConditionApprentice, thistype.infoActionApprentice, tre("Suchst du einen Schüler?", "Are you looking for a student?"))
			set this.m_arrows = this.addInfo(false, false, thistype.infoConditionArrows, thistype.infoActionArrows, tre("Kannst du Pfeile herstellen?", "Can you produce arrows?"))
			set this.m_arrowsDone = this.addInfo(true, false, thistype.infoConditionArrowsDone, thistype.infoActionArrowsDone, tre("Sind die Pfeile fertig?", "Are the arrows ready?"))

			set this.m_whatDoYouSell = this.addInfo(true, false, 0, thistype.infoActionWhatDoYouSell, tre("Was verkaufst du?", "What do you sell?"))
			set this.m_yourDogs = this.addInfo(true, false, thistype.infoConditionBjoernIsInCastle, thistype.infoActionYourDogs, tre("Ist das dein Hundezwinger?", "Ist that your dog kennel?"))
			set this.m_yourFalcons = this.addInfo(true, false, thistype.infoConditionBjoernIsInCastle, thistype.infoActionYourFalcons, tre("Ist das dein Falkenkäfig?", "Is that your falcon cage?"))
			set this.m_hunt = this.addInfo(false, false, 0, thistype.infoActionHunt, tre("Geh mit mir auf die Jagd.", "Go with me to hunt."))
			set this.m_whereAnimals = this.addInfo(true, false, thistype.infoConditionWhereAnimals, thistype.infoActionWhereAnimals,  tre("Wo finde ich Rebhühner?", "Where can I find patridges?"))
			set this.m_explainHunt = this.addInfo(true, false, thistype.infoConditionExplainHunt, thistype.infoActionExplainHunt, tre("Erkläre mir noch mal die Rebhuhnjagd.", "Explain to me again the patridge hunting."))
			set this.m_animals = this.addInfo(false, false, thistype.infoConditionAnimals, thistype.infoActionAnimals, tre("Ich habe die Rebhühner.", "I have the patridges."))

			set this.m_exit = this.addExitButton()

			// info 0
			set this.m_fromFarAway = this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Von weit her.", "From far away."))
			set this.m_noneOfYourBusiness = this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Das geht dich überhaupt nichts an!", "That's none of your business!"))

			// info 2
			set this.m_coins = this.addInfo(false, false, 0, thistype.infoAction2_0, Format(tre("%1% Goldmünzen.",  "%1% gold coins.")).i(thistype.goldReward1).result())
			set this.m_halfOfYourReward = this.addInfo(false, false, 0, thistype.infoAction2_1, tre("Die Hälfte deines Gewinns.", "Half of your profits."))

			return this
		endmethod

		implement Talk
	endstruct

endlibrary