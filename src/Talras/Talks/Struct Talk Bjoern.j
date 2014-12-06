library StructMapTalksTalkBjoern requires Asl, StructMapQuestsQuestBurnTheBearsDown, StructMapQuestsQuestCoatsForThePeasants, StructMapQuestsQuestKunosDaughter

	struct TalkBjoern extends ATalk
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
		private AInfo m_fromFarAway
		private AInfo m_noneOfYourBusiness
		private AInfo m_coins
		private AInfo m_halfOfYourReward
		private boolean m_toldDeath
		private integer m_toldBearFight

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (not this.infoHasBeenShownToCharacter(this.m_hi.index(), character)) then
				call this.showInfo(this.m_hi.index(), character)
			else
				call this.showUntil(this.m_apprentice.index() + 1, character)
			endif
		endmethod

		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("He Fremder! Woher kommst du?"), null)
			call info.talk().showRange(this.m_fromFarAway.index(), this.m_noneOfYourBusiness.index(), character)
		endmethod

		// Woher kennst du Dago?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kennst du Dago?"), null)
			call speech(info, character, true, tr("Er wohnt in der unteren Hütte und ist mit mir der einzige Jäger in Talras."), null)
			call speech(info, character, true, tr("Ich bin übrigens Björn."), null)
			// (Björns Frau ist in der Nähe)
			if (IsUnitInRange(gg_unit_n02U_0142, gg_unit_n02V_0146, 600.0)) then
				call speech(info, character, false, tr("Ist das deine Frau?"), null)
			endif
			call speech(info, character, true, tr("Ja und lass dir bloß nichts Dummes einfallen. Wenn du sie blöd anmachst oder anquatscht, prügel ich dir deine Dreck￼sfresse zu Brei, verstanden?"), null)
			// (Auftrag ￼„Felle für die Bauern￼“ nicht abgeschlossen)
			if (not QuestCoatsForThePeasants.characterQuest(character).isCompleted()) then
				call speech(info, character, false, tr("Komm mal wieder runter! Ich hab doch nur gefragt."), null)
				call speech(info, character, true, tr("Schon gut, aber bei sowas verstehe ich keinen Spaß und habe schon schlechte Erfahrung mit Landstreichern gemacht."), null)
			// (Auftrag ￼„Felle für die Bauern￼“ abgeschlossen)
			else
				call speech(info, character, false, tr("So so, du ￼Riese."), null)
				call speech(info, character, true, tr("Ich ... äh ... ich, ich meine ... ich wollte nicht ... ich wollte nur ..."), null)
				call speech(info, character, false, tr("Höflich sagen, dass ich deine Frau gut behandeln soll?"), null)
				call speech(info, character, true, tr("Ja, ich meine ... ja, genau das!"), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (￼Björn befindet sich auf dem Bauernhof und nach ￼„Woher kennst du Dago?￼“)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return not RectContainsUnit(gg_rct_music_talras, Npcs.bjoern()) and info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Was machst du hier?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du hier?"), null)
			call speech(info, character, true, tr("Ich verkaufe dem Bauern Manfred Felle. Allerdings fehlen mir noch ￼Riesen-Felle. Die Viecher sind einfach zu stark für mich und ich bleibe lieber am Leben als dass ich ein besseres Geschäft mache."), null)
			call speech(info, character, false, tr("￼Riesen-Felle?"), null)
			call speech(info, character, true, tr("Ja, östlich vom Fluss leben einige ￼Riesen. Die sind großen und haben folglich große Felle, die man sehr teuer verkaufen kann. Du müsstest mit Trommons Fähre rüberfahren."), null)
			call speech(info, character, true, tr("Allerdings würde ich dir das nicht empfehlen, da die Viecher einfach verdammt aggressiv und stark sind. Mit drei dieser verdammten Felle hätte ich bestimmt den Gewinn eines ganzen Jahres drinnen."), null)
			// Neuer Auftrag ￼„Felle für die Bauern￼“
			call QuestCoatsForThePeasants.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags ￼„Felle für die Bauern￼“ abgeschlossen und Charakter hat tatsächlich drei Riesen-Felle)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestCoatsForThePeasants.characterQuest(character).questItem(0).isCompleted() and true /// @todo FIXME
		endmethod

		// Ich habe hier drei Riesen-Felle.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Ich habe hier drei Riesen-Felle."), null)
			call speech(info, character, true, tr("Willst du mich verarschen oder was? ... Tatsächlich! Verdammt, wie hast du das angestellt?"), null)
			call speech(info, character, false, tr("Mit Gewalt."), null)
			call speech(info, character, true, tr("Mann, vor dir sollte man sich besser in Acht nehmen. Scheinst ja ein harter Brocken zu sein. Wie viel willst du für die Felle?"), null)
			call info.talk().showRange(this.m_coins.index(), this.m_halfOfYourReward.index(), character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ aktiv und nicht abgeschlossen)
		private static method infoConditionApprentice takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isNew()
		endmethod

		// Suchst du einen Schüler?
		private static method infoActionApprentice takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Suchst du einen Schüler?"), null)
			call speech(info, character, true, tr("Einen Schüler? Du meinst ich soll jemandem das Jagen beibringen?"), null)
			call speech(info, character, false, tr("Ganz genau."), null)
			call speech(info, character, true, tr("Möglich, ich würde es jedoch nicht umsonst tun! Um wen geht es denn?"), null)
			call speech(info, character, false, tr("Um Kunos Tochter."), null)
			call speech(info, character, true, tr("Kunos Tochter?! Na sowas, damit hätte ich jetzt nicht gerechnet. Also wenn das so ist …"), null)
			call speech(info, character, true, tr("Kuno liefert Holz an den Bauernhof auf dem ich als Kind aufgewachsen bin. Er ist ein anständiger Kerl."), null)
			call speech(info, character, true, tr("Er lebt da draußen ganz alleine mit seiner Tochter im Wald. Es könnte nicht schaden, wenn sie sich in der Wildnis besser zurechtfände. Immerhin ist das ein verdammt gefährlicher Wald."), null)
			call speech(info, character, true, tr("Sag ihm, ich werde seine Tochter ausbilden, wenn er sie vorbeischickt. Es kostet ihn natürlich nichts."), null)
			call speech(info, character, false, tr("Mache ich."), null)
			call QuestKunosDaughter.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method infoAction0_0And0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Er jagt irgendwo südöstlich der Burg und sollte eigentlich längst schon zurückgekehrt sein."), null)
			// (Dago ist tot)
			if (IsUnitDeadBJ(gg_unit_n00Q_0028)) then
				call speech(info, character, false, tr("Dago ist tot. Die Bären haben ihn gefressen."), null)
				// (Ist der erste Charakter, der vom Tod Dagos erzählt)
				if (not thistype(info.talk()).m_toldDeath) then
					call speech(info, character, true, tr("So eine Scheiße! Diese verdammten Bären!  Moment, bist du dir überhaupt sicher, dass es Dago war?"), null)
					call speech(info, character, false, tr("Wenn er eine Armbrust bei sich trug und einen Mantel an hatte, dann war es wohl Dago."), null)
					call speech(info, character, true, tr("Ja, das tat er. Das gibt’s doch nicht. Getötet von Bären, der Arme."), null)
					set thistype(info.talk()).m_toldDeath = true
				// (Ist nicht erste Charakter, der vom Tod Dagos erzählt)
				else
					call speech(info, character, true, tr("Dann muss es wahr sein. Du bist nicht der Erste, der mir das erzählt. Verdammter Mist!"), null)
				endif
			// (Dago lebt)
			else
				call speech(info, character, false, tr("Ja, habe ich."), null)
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
			call speech(info, character, true, tr("Ich wollte nur wissen, ob du vielleicht meinen Freund Dago getroffen hast."), null)
			call thistype.infoAction0_0And0_1(info, character)
		endmethod

		// %1% Goldmünzen.
		private static method infoAction2_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, Format(tr("%1% Goldmünzen.")).i(thistype.goldReward1).result(), null)
			call speech(info, character, true, Format(tr("In Ordnung. Hier hast du %1% Goldmünzen. Damit kriege ich immer noch ein Drittel des Gewinns rein. Vielen Dank.")).i(thistype.goldReward1).result(), null)
			// Charakter erhält 600 Goldmünzen.
			call character.addGold(600)
			// Auftrag „Felle für die Bauern“ abgeschlossen
			call QuestCoatsForThePeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Die Hälfte deines Gewinns.
		private static method infoAction2_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Die Hälfte deines Gewinns."), null)
			call speech(info, character, true, Format(tr("In Ordnung. Hier hast du %1% Goldmünzen und zum Dank schenke ich dir noch einen meiner schönsten Bogen.")).i(thistype.goldReward2).result(), null)
			// Charakter erhält „Björns Kurzbogen“ und 450 Goldmünzen.
			call character.addGold(400)
			/// TODO ADD BOW
			// Auftrag „Felle für die Bauern“ abgeschlossen.
			call QuestCoatsForThePeasants.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n02U_0142, thistype.startPageAction)
			set this.m_toldDeath = false
			set this.m_toldBearFight = 0

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			set this.m_aboutDago = this.addInfo(false, false, 0, thistype.infoAction1, tr("Woher kennst du Dago?")) // 1
			set this.m_whatAreYouDoingHere = this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Was machst du hier?")) // 2
			set this.m_skins = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Ich habe hier drei Riesen-Felle.")) // 3
			set this.m_apprentice = this.addInfo(false, false, thistype.infoConditionApprentice, thistype.infoActionApprentice, tr("Suchst du einen Schüler?")) // 4
			call this.addExitButton() // 5

			// info 0
			set this.m_fromFarAway = this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Von weit her.")) // 6
			set this.m_noneOfYourBusiness = this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Das geht dich überhaupt nichts an!")) // 7

			// info 2
			set this.m_coins = this.addInfo(false, false, 0, thistype.infoAction2_0, Format(tr("%1% Goldmünzen.")).i(thistype.goldReward1).result()) // 8
			set this.m_halfOfYourReward = this.addInfo(false, false, 0, thistype.infoAction2_1, tr("Die Hälfte deines Gewinns.")) // 9

			return this
		endmethod
	endstruct

endlibrary