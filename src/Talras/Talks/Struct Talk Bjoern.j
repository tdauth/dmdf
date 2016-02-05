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

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (not this.infoHasBeenShownToCharacter(this.m_hi.index(), character)) then
				call this.showInfo(this.m_hi.index(), character)
			else
				call this.showUntil(this.m_exit.index(), character)
			endif
		endmethod

		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("He Fremder! Woher kommst du?", "Hey stranger! Where are you from?"), null)
			call info.talk().showRange(this.m_fromFarAway.index(), this.m_noneOfYourBusiness.index(), character)
		endmethod

		// Woher kennst du Dago?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Woher kennst du Dago?", "Where do you know Dago from?"), null)
			call speech(info, character, true, tre("Er wohnt in der unteren Hütte und ist mit mir der einzige Jäger in Talras.", "He lives in the lower hut and is with me the only hunter in Talras."), null)
			call speech(info, character, true, tre("Ich bin übrigens Björn.", "Anyway, I'm Björn."), null)
			// (Björns Frau ist in der Nähe)
			if (IsUnitInRange(gg_unit_n02U_0142, gg_unit_n02V_0146, 600.0)) then
				call speech(info, character, false, tre("Ist das deine Frau?", "Is that your wife?"), null)
				call speech(info, character, true, tre("Ja und lass dir bloß nichts Dummes einfallen. Wenn du sie blöd anmachst oder anquatscht, prügel ich dir deine Dreck￼sfresse zu Brei, verstanden?", "Yes, and don't think about anything stupid. If you pick her up stupidly or talk to her I beat your dirt face to mush, understood?"), null)
				// (Auftrag ￼„Felle für die Bauern￼“ nicht abgeschlossen)
				if (not QuestCoatsForThePeasants.characterQuest(character).isCompleted()) then
					call speech(info, character, false, tre("Komm mal wieder runter! Ich hab doch nur gefragt.", "Calm down! I just asked."), null)
					call speech(info, character, true, tre("Schon gut, aber bei sowas verstehe ich keinen Spaß und habe schon schlechte Erfahrung mit Landstreichern gemacht.", "All right, but with this don't understand any fun and have already had bad experience with vagrants."), null)
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
			call speech(info, character, true, tre("Ich verkaufe dem Bauern Manfred Felle. Allerdings fehlen mir noch ￼Riesen-Felle. Die Viecher sind einfach zu stark für mich und ich bleibe lieber am Leben als dass ich ein besseres Geschäft mache.", "I sell furs to the farmer Manfred. However, I still need some giant furs. These critters are just too strong for me and I prefer to stay alive than doing a better business."), null)
			call speech(info, character, false, tre("￼Riesen-Felle?", "Giant furs?"), null)
			call speech(info, character, true, tre("Ja, östlich vom Fluss leben einige ￼Riesen. Die sind groß und haben folglich große Felle, die man sehr teuer verkaufen kann. Du müsstest mit Trommons Fähre rüberfahren.", "Yes, east of the river live some giants. They are large and therefore have large furs which you can sell very expensive. You'd have to cross the river with Trommon's ferryboat."), null)
			call speech(info, character, true, tre("Allerdings würde ich dir das nicht empfehlen, da die Viecher einfach verdammt aggressiv und stark sind. Mit drei dieser verdammten Felle hätte ich bestimmt den Gewinn eines ganzen Jahres drinnen.", "However, I would not recommend you this because the critters are just damn aggressive and strong. WIth three of those damned furs I certainly would have the profit of a whole year."), null)
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
			call speech(info, character, true, tre("Willst du mich verarschen oder was? ... Tatsächlich! Verdammt, wie hast du das angestellt?", "Are you kidding me or what? ... Indeed! Damn, how did you do that?"), null)
			call speech(info, character, false, tre("Mit Gewalt.", "With violence."), null)
			call speech(info, character, true, tre("Mann, vor dir sollte man sich besser in Acht nehmen. Scheinst ja ein harter Brocken zu sein. Wie viel willst du für die Felle?", "Man, in front of you one should better be careful. You seem to be a tough one indeed. How much do you want for the furs?"), null)
			call info.talk().showRange(this.m_coins.index(), this.m_halfOfYourReward.index(), character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ aktiv und nicht abgeschlossen)
		private static method infoConditionApprentice takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isNew()
		endmethod

		// Suchst du einen Schüler?
		private static method infoActionApprentice takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Suchst du einen Schüler?", "Are you looking for a student?"), null)
			call speech(info, character, true, tre("Einen Schüler? Du meinst ich soll jemandem das Jagen beibringen?", "A student? You mean I should teach someone to hunt?"), null)
			call speech(info, character, false, tre("Ganz genau.", "Exactly."), null)
			call speech(info, character, true, tre("Möglich, ich würde es jedoch nicht umsonst tun! Um wen geht es denn?", "Possible, I would however not do it for free! Who is this about, anwyway?"), null)
			call speech(info, character, false, tre("Um Kunos Tochter.", "It's about Kuno's daughter."), null)
			call speech(info, character, true, tre("Kunos Tochter?! Na sowas, damit hätte ich jetzt nicht gerechnet. Also wenn das so ist …", "Kuno's daughter?! Well, that's something I would not have expected. So if it is like that ..."), null)
			call speech(info, character, true, tre("Kuno liefert Holz an den Bauernhof auf dem ich selbst Felle verkaufe. Er ist ein anständiger Kerl.", "Kuno delivers wood to the farm on which I myself sell furs. He's a decent guy."), null)
			call speech(info, character, true, tre("Er lebt da draußen ganz alleine mit seiner Tochter im Wald. Es könnte nicht schaden, wenn sie sich in der Wildnis besser zurechtfände. Immerhin ist das ein verdammt gefährlicher Wald.", "He lives far outside alone with his daughter in the woods. It would not hurt if she gets used to the wild better. After all, this is a damn dangerous forest."), null)
			call speech(info, character, true, tre("Sag ihm, ich werde seine Tochter ausbilden, wenn er sie vorbeischickt. Es kostet ihn natürlich nichts.", "Tell him I'm going to train his daughter when he sends her over. Of course, it will cost him nothing."), null)
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
			call speech(info, character, false, tre("Kannst du Pfeile herstellen?", "Can you produce arrows?"), null)
			call speech(info, character, true, tre("Klar, wieso fragst du?", "Sure, why do you ask?"), null)
			call speech(info, character, false, tre("Markward benötigt Pfeile zur Verteidigung der Burg.", "Markward needs arrows to defend the castle."), null)
			call speech(info, character, true, tre("Ich sehe schon es handelt sich um eine wichtige Angelegenheit. Pass auf ich fertige neue Pfeile an und gebe ihm noch ein paar von mir.", "I can see it is an important matter. Look, I make new arrows and still give him a couple of mine."), null)
			call speech(info, character, true, tre("Das dauert allerdings eine Weile. Komm später noch einmal vorbei.", "However, this takes a while. Come back later."), null)
			// Auftragsziel 3 des Auftrags „Die Befestigung von Talras“ abgeschlossen
			call QuestReinforcementForTalras.characterQuest(character).questItem(2).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ aktiviert
			call QuestReinforcementForTalras.characterQuest(character).questItem(3).setState(AAbstractQuest.stateNew)
			call QuestReinforcementForTalras.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ ist aktiv)
		private static method infoConditionArrowsDone takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(3).isNew()
		endmethod

		// Sind die Pfeile fertig?
		private static method infoActionArrowsDone takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Sind die Pfeile fertig?", "Are the arrows ready?"), null)
			// (Genügend Zeit ist vergangen)
			if (QuestReinforcementForTalras(QuestReinforcementForTalras.characterQuest(character)).oneMinutePassed()) then
				call speech(info, character, true, tr("Ja, hier hast du sie. Am besten du platzierst sie an strategisch wichtigen Orten in der Burg."), null)
				call speech(info, character, true, tr("Markward wird dich sowieso früher oder später mit den Pfeilen losschicken."), null)
				// Charakter erhält Pfeilbündel
				call character.giveQuestItem('I03U')
				// Auftragsziel 4 des Auftrags „Die Befestigung von Talras“ abgeschlossen
				call QuestReinforcementForTalras.characterQuest(character).questItem(3).setState(AAbstractQuest.stateCompleted)
				// Auftragsziel 5 des Auftrags „Die Befestigung von Talras“ aktiviert
				call QuestReinforcementForTalras.characterQuest(character).questItem(4).setState(AAbstractQuest.stateNew)
				call QuestReinforcementForTalras.characterQuest(character).displayUpdate()
			// (Weniger als fünf Sekunden sind vergangen)
			elseif (QuestReinforcementForTalras(QuestReinforcementForTalras.characterQuest(character)).lessThanFiveSecondsPassed() and not this.m_bonus) then
				call speech(info, character, true, tr("Du bist ja lustig. Es sind noch nicht einmal fünf Sekunden vergangen!"), null)
				// Erfahrungsbonus „Ungeduld“
				call character.xpBonus(50, tr("Ungeduld"))
				set this.m_bonus = true
			// (Noch keine zwei Tage vergangen)
			else
				call speech(info, character, false, tr("Nein, du musst dich noch etwas gedulden."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod
		
		// Was verkaufst du?
		private static method infoActionWhatDoYouSell takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Was verkaufst du?"), null)
			call speech(info, character, true, tr("Alles was ein Jäger so gebrauchen kann. Einen guten Bogen, warme Bekleidung, Pfeile, Fallen und Messer. Sieh es dir einfach an."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Björn befindet sich in der Burg)
		private static method infoConditionBjoernIsInCastle takes AInfo info, ACharacter character returns boolean
			return RectContainsUnit(gg_rct_area_bjoern, Npcs.bjoern())
		endmethod
		
		// Ist das dein Hundezwinger?
		private static method infoActionYourDogs takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ist das dein Hundezwinger?"), null)
			
			call speech(info, character, true, tr("In der Tat, aber eigentlich gehört er dem Herzog. Dago und ich kümmern uns jedoch um die Hunde."), null)
			
			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tr("Nun muss ich mich wohl alleine um sie kümmern."), null)
			endif
		
			call speech(info, character, true, tr("Die Hunde wurden von uns zu den besten Jagdhunden weit und breit ausgebildet. Sie spüren jeden Fuchs und jeden Hasen auf. Ich bin ganz besonders stolz auf sie."), null)
			call speech(info, character, true, tr("Der Herzog veranstaltet nur selten eine Treibjagd, zu besonderen Anlässen. Wenn es soweit ist, dann müssen sie gut vorbereitet sein."), null)
			call speech(info, character, false, tr("Verkaufst du auch Hunde?"), null)
			call speech(info, character, true, tr("Was?! Was erlaubst du dir? Diese Hunde sind mir ans Herz gewachsen. Nie würde ich sie hergeben."), null)
			call speech(info, character, false, tr("Ich dachte sie gehören dem Herzog."), null)
			call speech(info, character, true, tr("Ja, sicher … also gut. Der Herzog hat tatsächlich zu viele Hunde. Die vermehren sich auch wie die Karnickel. Wenn du einen angemessenen Preis bezahlst, dann kannst du einen Hund haben."), null)
			call speech(info, character, true, tr("Aber bitte behandele sie gut. Du weißt nicht wie lange ich mit einigen schon zusammenlebe. Da baut man eine Bindung auf die stärker ist als zu manchem Menschen."), null)

			call info.talk().showStartPage(character)
		endmethod
		
		// Ist das dein Falkenkäfig?
		private static method infoActionYourFalcons takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ist das dein Falkenkäfig?"), null)
			
			call speech(info, character, true, tr("Ja das ist er. Die Falken darin gehören allerdings dem Herzog. Dago und ich haben diese Falken für ihn ausgebildet."), null)
		
			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tr("Aber jetzt bin ich wohl alleine für sich verantwortlich (traurig)."), null)
			endif
			call speech(info, character, true, tr("Die Falknerei ist eine schwierige Form der Jagd, musst du wissen. Es erfordert viel Geduld und Übung, bis ein Falke ausgebildet ist. Diese Tiere besitzen einen großen persönlichen Wert für mich."), null)
			call speech(info, character, true, tr("Aber auch für den Adel sind sie von unschätzbarem Wert. Ein ausgebildeter Jagdfalke ist fast unbezahlbar."), null)
			call speech(info, character, true, tr("Ich hoffe der Herzog geht bald wieder auf eine Jagd mit ihnen. Das ist das größte Erlebnis für einen einfachen Jäger wie mich."), null)
			call speech(info, character, false, tr("Kann man sie auch kaufen?"), null)
			call speech(info, character, true, tr("Sicher, wenn du die nötigen Goldmünzen dabei hast. Das glaube ich aber kaum. Vielleicht hat der Herzog ja noch Schulden bei irgendwem, aber er gestattet tatsächlich den Verkauf dieser wunderbaren Tiere."), null)
		
			call info.talk().showStartPage(character)
		endmethod
		
		// Geh mit mir auf die Jagd.
		private static method infoActionHunt takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Geh mit mir auf die Jagd."), null)
			
			call speech(info, character, true, tr("Tut mir leid, ich habe gerade keine Zeit dafür. Kennst du dich denn überhaupt damit aus?"), null)
			call speech(info, character, false, tr("Bestimmt."), null)
			call speech(info, character, true, tr("Gut, dann geh doch selbst jagen. Wenn du einen Vorstehhund und einen Jagdfalken hast, dann kannst du Rebhühner jagen. Der Vorstehhund zeigt dir, dass er das Huhn gefunden hat. Der Falke wartet in der Luft ab, dann lässt du das Wild vom Vorstehhund aufscheuchen und der Falke stürzt sich darauf."), null)
			call speech(info, character, true, tr("Das ist nicht so einfach, aber wenn du ein erfahrener Jäger bist, schaffst du das sicher. Allerdings kann ich mir nicht vorstellen, dass du dir einen Jagdfalken leisten kannst."), null)
			call speech(info, character, true, tr("Der Herzog verspeist Rebhühner als hätte er hunderte davon in der Küche herumliegen. Du würdest mir also einen großen Gefallen tun, wenn du welche für mich jagst."), null)
			call speech(info, character, true, tr("Ich könnte dich dafür natürlich auch bezahlen."), null)
		
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
			call speech(info, character, false, tr("Wo finde ich Rebhühner?"), null)
			call speech(info, character, true, tr("Ich gehe immer in der Nähe des Friedhofs am Bauernhof jagen."), null)
			call speech(info, character, true, tr("Westlich davon befindet sich eine kleine Wiese zwischen dem Friedhof und den Kühen. Dort gibt es einige Rebhühner."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Rebhuhnjagd“ ist aktiv)
		private static method infoConditionExplainHunt takes AInfo info, ACharacter character returns boolean
			return QuestPerdixHunt.characterQuest(character).questItem(0).isNew()
		endmethod
		
		// Erkläre mir noch mal die Rebhuhnjagd.
		private static method infoActionExplainHunt takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erkläre mir noch mal die Rebhuhnjagd."), null)
			
			call speech(info, character, true, tr("So, ich dachte du bist ein erfahrener Jäger? Schon gut, jeder fängt mal klein an."), null)
			call speech(info, character, true, tr("Du schickst deinen Vorstehhund los, um das Rebhuhn aufzuspüren. Hat er es aufgespürt, schickst du deinen Jagdfalken in die Nähe. Er hält sich bereit."), null)
			call speech(info, character, true, tr("Dein Vorstehhund muss dann das Rebhuhn aufscheuchen. Es fliegt los und dein Falke greift es sich. Lass dir aber nicht zu viel Zeit, sonst verschwindet das Rebhuhn wieder."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Rebhuhnjagd“ ist abgeschlossen und Charakter hat fünf tote Rebhühner im Rucksack)
		private static method infoConditionAnimals takes AInfo info, ACharacter character returns boolean
			return QuestPerdixHunt.characterQuest(character).questItem(0).isCompleted() and character.inventory().totalItemTypeCharges('I059') == QuestPerdixHunt.maxAnimals
		endmethod
		
		// Ich habe die Rebhühner.
		private static method infoActionAnimals takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe die Rebhühner."), null)
			call speech(info, character, true, tr("Tatsächlich? Du scheinst ja ein fähiger Mann zu sein. Hier hast du deine Belohnung. Hab vielen Dank für die Mühe, da wird sich der Herzog freuen!"), null)
			// Rebhühner aus Rucksack entfernen
			call character.inventory().removeItemTypeCount('I059', QuestPerdixHunt.maxAnimals)
			// Auftrag „Rebhuhnjagd“ abgeschlossen
			call QuestPerdixHunt.characterQuest(character).complete()
		
			call info.talk().showStartPage(character)
		endmethod
		

		private static method infoAction0_0And0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Er jagt irgendwo südöstlich der Burg und sollte eigentlich längst schon zurückgekehrt sein."), null)
			// (Dago ist tot)
			if (IsUnitDeadBJ(Npcs.dago())) then
				call speech(info, character, false, tr("Dago ist tot. Die Bären haben ihn gefressen."), null)
				// (Ist der erste Charakter, der vom Tod Dagos erzählt)
				if (not thistype(info.talk()).m_toldDeath) then
					call speech(info, character, true, tr("So eine Scheiße! Diese verdammten Bären!  Moment, bist du dir überhaupt sicher, dass es Dago war?"), null)
					call speech(info, character, false, tr("Wenn er einen Bogen bei sich trug und Jagdkleidung an hatte, dann war es wohl Dago."), null)
					call speech(info, character, true, tr("Ja, das tat er. Das gibt’s doch nicht. Getötet von Bären, der Arme."), null)
					set thistype(info.talk()).m_toldDeath = true
				// (Ist nicht erste Charakter, der vom Tod Dagos erzählt)
				else
					call speech(info, character, true, tr("Dann muss es wahr sein. Du bist nicht der Erste, der mir das erzählt. Verdammter Mist!"), null)
				endif
			// (Dago lebt)
			else
				call speech(info, character, false, tr("Ja, bin ich."), null)
				if (QuestMushroomSearch.characterQuest(character).state() == AAbstractQuest.stateNotUsed and QuestBurnTheBearsDown.characterQuest(character) == AAbstractQuest.stateNotUsed) then
					// (Charakter spielt mit anderen und weiß nichts von den Pilzen oder der Niederbrennung der Bären)
					if (ACharacter.countAllPlaying() > 1) then
						call speech(info, character, false, tr("Meine Gefährten und ich haben ihm geholfen, zwei Bären zu töten, die ihn angriffen."), null)
						// (Ist der erste Charakter, der ihm davon berichtet)
						if (thistype(info.talk()).m_toldBearFight == 0) then
							call speech(info, character, true, tr("Tatsächlich? Hmm, ich werde mich mal umhören und schauen, ob ich dir das glauben kann. Na ja, du hast mir ja immerhin davon berichtet, dass er noch lebt und das glaube ich dir."), null)
							call speech(info, character, true, IntegerArg(tr("Diese Information ist mir %i Goldmünzen wert. Da hast du sie."), thistype.smallGoldReward), null)
							// Charakter erhält 20 Goldmünzen.
							call character.addGold(thistype.smallGoldReward)
							set thistype(info.talk()).m_toldBearFight = 1
						// (Ist nicht der erste Charakter, der ihm davon berichtet)
						else
							call speech(info, character, true, IntegerArg(tr("Einer deiner Freunde hat mir etwas Ähnliches erzählt. Hier hast du %i Goldmünzen für eure noble Tat!"), thistype.bigGoldReward), null)
							// Charakter erhält 100 Goldmünzen.
							call character.addGold(thistype.bigGoldReward)
							set thistype(info.talk()).m_toldBearFight = thistype(info.talk()).m_toldBearFight + 1
						endif
					// (Charakter spielt alleine und weiß nichts von den Pilzen oder der Niederbrennung der Bären)
					else
						call speech(info, character, false, tr("Ich habe ihm geholfen, zwei Bären zu töten, die ihn angriffen."), null)
						call speech(info, character, true, tr("Was denn? Du ganz allein? Dass ich nicht lache! Na wenigstens geht es ihm gut. Danke für die Auskunft, Fremder. Hier hast du ein paar Goldmünzen."), null)
						// Charakter erhält 20 Goldmünzen.
						call character.addGold(thistype.smallGoldReward)
					endif
				else
					// (Charakter weiß von den Pilzen)
					if (QuestMushroomSearch.characterQuest(character).state() != AAbstractQuest.stateNotUsed) then
						call speech(info, character, false, tr("Er wollte noch ein paar Pilze sammeln bevor, er in die Burg zurückkehrt."), null)
						call speech(info, character, true, tr("Ja, das kann gut sein. Gut dass es ihm gut geht. Ich habe mir schon Sorgen gemacht."), null)
						// (Mehr als ein Charakter hat bereits von der Bärentat erzählt)
						if (thistype(info.talk()).m_toldBearFight > 1) then
							call speech(info, character, true, IntegerArg(tr("Mir ist übrigens von eurer noblen Tat zu Ohren gekommen. Danke, dass ihr Dago beschützt habt. Hier hast du %i Goldmünzen. Das ist es mir einfach wert."), thistype.bigGoldReward), null)
							// Charakter erhält 100 Goldmünzen.
							call character.addGold(thistype.bigGoldReward)
						endif
					endif
					// (Charakter hat den Auftrag „Brennt die Bären nieder!“ erhalten)
					if (QuestBurnTheBearsDown.characterQuest(character).state() != AAbstractQuest.stateNotUsed) then
						call speech(info, character, false, tr("Er wollte sich an einigen Bären rächen, von denen wir zwei gemeinsam getötet haben."), null)
						call speech(info, character, true, tr("Das sieht ihm ähnlich."), null)
						// (Noch kein Charakter hat von der Sache mit den Bären berichtet)
						if (thistype(info.talk()).m_toldBearFight == 0) then
							call speech(info, character, true, IntegerArg(tr("Klingt nur etwas seltsam, das mit dem Töten zweier Bären meine ich. Dennoch, hier hast du %i Goldmünzen für die Auskunft."), thistype.smallGoldReward), null)
							// Charakter erhält 20 Goldmünzen
							call character.addGold(thistype.smallGoldReward)
							set thistype(info.talk()).m_toldBearFight = 1
						// (Ist nicht der erste Charakter, der ihm davon berichtet)
						else
							call speech(info, character, true, IntegerArg(tr("Ich habe von eurem gemeinsamen Kampf gehört und bin stolz auf euch, dass ihr ihm geholfen habt. Hier hast du %i Goldmünzen."), thistype.bigGoldReward), null)
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
			call speech(info, character, false, tr("Von weit her."), null)
			call speech(info, character, true, tr("So, dann bist du vielleicht meinem Freund Dago begegnet.￼"), null)
			call thistype.infoAction0_0And0_1(info, character)
		endmethod

		// Das geht dich überhaupt nichts an!
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Das geht dich überhaupt nichts an!"), null)
			call speech(info, character, true, tr("Ich wollte nur wissen, ob du vielleicht meinen Freund Dago begegnet bist."), null)
			call thistype.infoAction0_0And0_1(info, character)
		endmethod

		// %1% Goldmünzen.
		private static method infoAction2_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, Format(tr("%1% Goldmünzen.")).i(thistype.goldReward1).result(), null)
			call speech(info, character, true, Format(tr("In Ordnung. Hier hast du %1% Goldmünzen. Damit kriege ich immer noch ein Drittel des Gewinns rein. Vielen Dank.")).i(thistype.goldReward1).result(), null)
			// Charakter erhält 600 Goldmünzen.
			call character.addGold(thistype.goldReward1)
			// Auftrag „Felle für die Bauern“ abgeschlossen
			call QuestCoatsForThePeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Die Hälfte deines Gewinns.
		private static method infoAction2_1 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Die Hälfte deines Gewinns."), null)
			call speech(info, character, true, Format(tr("In Ordnung. Hier hast du %1% Goldmünzen und zum Dank schenke ich dir noch einen meiner schönsten Bogen.")).i(thistype.goldReward2).result(), null)
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
			set this.m_aboutDago = this.addInfo(false, false, 0, thistype.infoAction1, tr("Woher kennst du Dago?"))
			set this.m_whatAreYouDoingHere = this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Was machst du hier?"))
			set this.m_skins = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Ich habe hier drei Riesen-Felle."))
			set this.m_apprentice = this.addInfo(false, false, thistype.infoConditionApprentice, thistype.infoActionApprentice, tr("Suchst du einen Schüler?"))
			set this.m_arrows = this.addInfo(false, false, thistype.infoConditionArrows, thistype.infoActionArrows, tr("Kannst du Pfeile herstellen?"))
			set this.m_arrowsDone = this.addInfo(true, false, thistype.infoConditionArrowsDone, thistype.infoActionArrowsDone, tr("Sind die Pfeile fertig?"))
			
			set this.m_whatDoYouSell = this.addInfo(true, false, 0, thistype.infoActionWhatDoYouSell, tr("Was verkaufst du?"))
			set this.m_yourDogs = this.addInfo(true, false, thistype.infoConditionBjoernIsInCastle, thistype.infoActionYourDogs, tr("Ist das dein Hundezwinger?"))
			set this.m_yourFalcons = this.addInfo(true, false, thistype.infoConditionBjoernIsInCastle, thistype.infoActionYourFalcons, tr("Ist das dein Falkenkäfig?"))
			set this.m_hunt = this.addInfo(false, false, 0, thistype.infoActionHunt, tr("Geh mit mir auf die Jagd."))
			set this.m_whereAnimals = this.addInfo(true, false, thistype.infoConditionWhereAnimals, thistype.infoActionWhereAnimals, tr("Wo finde ich Rebhühner?"))
			set this.m_explainHunt = this.addInfo(true, false, thistype.infoConditionExplainHunt, thistype.infoActionExplainHunt, tr("Erkläre mir noch mal die Rebhuhnjagd."))
			set this.m_animals = this.addInfo(false, false, thistype.infoConditionAnimals, thistype.infoActionAnimals, tr("Ich habe die Rebhühner."))
			
			set this.m_exit = this.addExitButton()

			// info 0
			set this.m_fromFarAway = this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Von weit her."))
			set this.m_noneOfYourBusiness = this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Das geht dich überhaupt nichts an!"))

			// info 2
			set this.m_coins = this.addInfo(false, false, 0, thistype.infoAction2_0, Format(tr("%1% Goldmünzen.")).i(thistype.goldReward1).result())
			set this.m_halfOfYourReward = this.addInfo(false, false, 0, thistype.infoAction2_1, tr("Die Hälfte deines Gewinns."))

			return this
		endmethod
	endstruct

endlibrary