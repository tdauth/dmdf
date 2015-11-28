library StructMapTalksTalkOsman requires Asl, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestWitchingHour, StructMapQuestsQuestTheDarkCult

	struct TalkOsman extends Talk
		private static constant integer brotherGoldReward = 20
		private boolean array m_wasOffended[6] /// \todo \ref Game.maxPlayers, vJass bug.
		private boolean array m_gaveHealPotion[6] /// \todo \refGame.maxPlayers, vJass bug.
		
		private AInfo m_hi
		private AInfo m_whatAreYouDoingHere
		private AInfo m_doYouHaveMoreHealing
		private AInfo m_guntrichNeedsHelp
		private AInfo m_aboutTheGods
		private AInfo m_area
		private AInfo m_help
		private AInfo m_moreAboutTheCult
		private AInfo m_searchForTheCult
		private AInfo m_foundTheCult
		private AInfo m_cultIsHistory
		private AInfo m_exit
		private AInfo m_youAreKnowBeliever
		private AInfo m_itsMyPleasure
		private AInfo m_youLikeYoungBoys
		private AInfo m_iAmSorry
		private AInfo m_shutUp
		private AInfo m_back

		implement Talk

		private method offend takes player whichPlayer returns nothing
			set this.m_wasOffended[GetPlayerId(whichPlayer)] = true
		endmethod

		private method wasOffended takes player whichPlayer returns boolean
			return this.m_wasOffended[GetPlayerId(whichPlayer)]
		endmethod

		private method giveHealPotion takes ACharacter character returns nothing
			local player user = character.player()
			local unit characterUnit = character.unit()
			local item healPotion = CreateItem('I00A', GetUnitX(characterUnit), GetUnitY(characterUnit))
			call UnitAddItem(characterUnit, healPotion)
			set this.m_gaveHealPotion[GetPlayerId(user)] = true
			set user = null
			set characterUnit = null
			set healPotion = null
		endmethod

		private method gaveHealPotion takes ACharacter character returns boolean
			local player user = character.player()
			local boolean result = this.m_gaveHealPotion[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Hallo."), null)
			if (character.class() == Classes.cleric()) then
				call speech(info, character, true, tr("Sei gegrüßt werter Bruder. Es ist selten geworden, dass ich einen Glaubensgenossen treffe."), null)
				call info.talk().showRange(this.m_youAreKnowBeliever.index(), this.m_itsMyPleasure.index(), character)
			else
				call speech(info, character, true, tr("Ich grüße dich."), null)
				call info.talk().showStartPage(character)
			endif
		endmethod

		// (Nach der Begrüßung, Osman steht vor den Gräbern und betet)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_waypoint_osman_0, gg_unit_n00R_0101)
		endmethod

		// Was machst du hier?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Was machst du hier?"), null)
			if (not TalkOsman(info.talk()).wasOffended(character.player())) then
				call speech(info, character, true, tr("Nun, ich bin Osman, der Kleriker des Herzogs und wie du vielleicht gesehen hast, habe ich hier gebetet, um in meinem Glauben Kraft zu finden und unseren geliebten Herzog zu stärken."), null)
				call speech(info, character, true, tr("Dies hier sind die Gräber der Ahnen unseres Herzogs. Mögen Sie in Frieden ruhen."), null)
				call info.talk().showStartPage(character)
			else
				call speech(info, character, true, tr("Was maßt du dir an, mich weiterhin zu belästigen? Soll ich dich etwa der Ketzerei beschuldigen?"), null)
				call info.talk().showRange(this.m_youLikeYoungBoys.index(), this.m_iAmSorry.index(), character)
			endif
		endmethod

		// (Charakter hat den Heiltrank erhalten)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return TalkOsman(info.talk()).gaveHealPotion(character)
		endmethod

		// Hast du noch mehr Heilmittel?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast du noch mehr Heilmittel?"), null)
			// (Wird zum ersten Mal aufgerufen)
			if (not info.talk().infoHasBeenShownToCharacter(2, character)) then
				call speech(info, character, true, tr("So, der Trank ist dir also gut bekommen? Das freut mich zu hören. Selbstverständlich habe ich noch mehr Heilmittel, allerdings wird dich das auch eine Kleinigkeit kosten."), null)
			// (Wird nicht zum ersten Mal aufgerufen)
			else
				call speech(info, character, true, tr("Noch mehr? Mann, wo treibst du dich denn rum? Wie auch immer, selbstverständlich habe ich noch ein paar."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach der Begrüßung, Auftragsziel 1 des Auftrags „Geisterstunde“ ist aktiv)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and QuestWitchingHour.characterQuest(character).questItem(0).isNew()
		endmethod

		// Guntrich braucht deine Hilfe.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Guntrich braucht deine Hilfe. Er sagt, auf dem Berg, auf dem seine Mühle steht, würde es spuken und …"), null)
			call speech(info, character, true, tr("Verdammt! Ich hab schon genug zu tun, hier in der Burg. Soll er sich doch selbst drum kümmern. Solange er das nicht bezahlen kann, werde ich keinen Finger krumm machen!"), null)
			// Auftragsziel 1 des Auftrags „Geisterstunde“ ist abgeschlossen
			call QuestWitchingHour.characterQuest(character).questItem(0).setState(AAbstractQuest.stateCompleted)
			call QuestWitchingHour.characterQuest(character).questItem(1).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung, permanent)
		private static method infoConditionAboutTheGods takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Erzähl mir etwas über die Götter.
		private static method infoActionAboutTheGods takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir etwas über die Götter."), null)
			call speech(info, character, true, tr("Die Götter wachen über uns. Sie blicken herab auf uns Diener, uns winzige Kreaturen. Sie beobachten jeden unserer Schritte und bewerten uns aufgrund unseres Willens, unserer Taten und unseres Glaubens."), null)
			call speech(info, character, true, tr("Wendest du dich von ihnen ab, wird es dein Untergang sein! Sie vergeben nicht, sie vergessen nicht, aber sie werden letztendlich immer ihre Rache vollziehen!"), null)
			call speech(info, character, true, tr("Nimm dich in Acht vor dir selbst und wache über deine Taten auf dass du nicht ihren Zorn auf dich lenkst."), null)
			call speech(info, character, false, tr("Interessant."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung, permanent)
		private static method infoConditionArea takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Was weißt du über diese Gegend?
		private static method infoActionArea takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was weißt du über diese Gegend?"), null)
			call speech(info, character, true, tr("Eine ganze Menge. Vor vielen Jahren ging ich von meinem Kloster auf Pilgerfahrt und zog durch das Königreich, um Antworten zu finden. Antworten auf alle Fragen, die ich mir in der langen Zeit im Kloster gestellt hatte."), null)
			call speech(info, character, true, tr("Als ich schließlich Talras erreichte, traf ich auf den damaligen Herzog, Heimrichs Vater, der mich als persönlichen Burgkleriker anstellte."), null)
			call speech(info, character, true, tr("Seitdem lebe ich hier in der Burg und studiere die Götter und ihre Geschichte."), null)
			call speech(info, character, true, tr("Die Leute in dieser Gegend sind dem Glauben sehr verbunden, besonders die Familie des Herzogs. Aber auch auf dem Bauernhof sind die Menschen äußerst fromm."), null)
			call speech(info, character, true, tr("Im Norden und Nordosten jedoch befinden sich finstere Wälder, geplagt von Unheil und Abtrünnigen des Glaubens."), null)
			call speech(info, character, true, tr("An deiner Stelle würde ich diese Gegenden meiden."), null)
			call speech(info, character, true, tr("Aber da die Orks und Dunkelelfen bereits in das Königreich eingefallen sind, werden wird uns vermutlich bald mit übleren Kreaturen auseinandersetzen müssen."), null)
			call speech(info, character, true, tr("Mögen uns die Götter dabei beistehen!"), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Helfen? Sicherlich, Hilfe kann ich immer gebrauchen. Ein alter Mann wie ich spürt, dass es mit ihm zu Ende geht."), null)
			call speech(info, character, true, tr("Wenn mein Ende gekommen ist, wird die Frage im Raume stehen, ob ich meinem Glauben so gewissenhaft gedient habe, wie es die Götter von mir verlangt haben."), null)
			call speech(info, character, false, tr("Schon gut."), null)
			call speech(info, character, true, tr("Hm, es gibt da etwas, was mir auf dem Herzen liegt seit ich nach Talras gekommen bin, vor so vielen Jahren."), null)
			call speech(info, character, false, tr("Und das wäre?"), null)
			call speech(info, character, true, tr("Du musst wissen, die Bewohner von Talras sind womöglich nicht die einzigen Menschen, die sich hier herumtreiben. Damals als ich in Talras ankam gab es eine Auseinandersetzung unter den Bewohnern."), null)
			call speech(info, character, true, tr("Ein Teil der Bewohner spaltete sich vom damaligen Herzog, dem Vater Heimrichs, ab und verließ die Burg und den Bauernhof."), null)
			call speech(info, character, true, tr("Sie schworen den Göttern ab und zogen in den Wald, um etwas ... anderem zu dienen."), null)
			call speech(info, character, true, tr("Der dunkle Kult belästigte daraufhin die Bewohner der Burg und des Dorfes. Sie stahlen, verschleppten und mordeten sogar bis schließlich der Herzog selbst ausritt und dem Ganzen ein Ende bereitete."), null)
			call speech(info, character, true, tr("Wie du dir denken kannst, wurden nicht alle Anhänger des Kultes gefasst und erschlagen. Ich frage mich seitdem, ob der Kult danach seine Existenz aufgegeben hat, haben wir doch so lange nichts mehr von ihm gehört."), null)
			call speech(info, character, true, tr("Diese ungeklärte Frage muss ich wohl mit ins Grab nehmen."), null)
			
			call QuestTheDarkCult.characterQuest(character).enable()
			
			call info.talk().showStartPage(character)
		endmethod
			
		// (Nach „Kann ich dir irgendwie helfen?“ und Auftrag „Der dunkle Kult“ ist noch aktiv, permanent)
		private static method infoConditionMoreAboutTheCult takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_help.index(), character) and QuestTheDarkCult.characterQuest(character).isNew()
		endmethod
		
		// Erzähl mir mehr über den dunklen Kult.
		private static method infoActionMoreAboutTheCult takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir mehr über den dunklen Kult."), null)
			call speech(info, character, true, tr("Dieser Kult hatte einen Anführer, einen dunklen Diakon. Er versprach seinen Gefolgsleuten das ewige Leben und so schlossen sich ihm einige Bewohner an."), null)
			call speech(info, character, true, tr("Ich weiß nicht, woher er die Gewissheit nahm, das Leben kontrollieren zu können, aber anscheinend war er sehr überzeugend. Seine Leute taten alles für ihn und gehorchten ihm aufs Wort."), null)
			call speech(info, character, true, tr("Sie vergingen sich an Dorfbewohnern in einer Art und Weise, die selbst erfahrene Kriegsleute abschrecken würde."), null)
			call speech(info, character, true, tr("Die Leichen schleppten sie danach mit in ihr Versteck. Die Götter allein wissen, was sie damit vor hatten."), null)
			call speech(info, character, false, tr("Wo befand sich ihr Versteck?"), null)
			call speech(info, character, true, tr("Hm, wenn ich das noch wüsste. Ich glaube, sie hielten sich irgendwo im nördlichen Wald versteckt."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach „Kann ich dir irgendwie helfen?“ und Auftrag „Der dunkle Kult“ ist noch aktiv)
		private static method infoConditionSearchForTheCult takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_help.index(), character) and QuestTheDarkCult.characterQuest(character).isNew()
		endmethod
		
		// Warum sucht keiner nach den verbliebenen Kultanhängern?
		private static method infoActionSearchForTheCult takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Warum sucht keiner nach den verbliebenen Kultanhängern?"), null)
			call speech(info, character, true, tr("Ach … das ist eine lange Geschichte. Heimrich wuchs mit diesem dunklen Kapitel in der Geschichte seiner Heimat auf. Später wollte er nichts mehr davon wissen."), null)
			call speech(info, character, true, tr("Auch die anderen Bewohner schweigen lieber darüber. Es scheint, den Leuten wird bei dem Gedanken an diese Geschichte sehr unbehaglich."), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Der dunkle Kult“ ist abgeschlossen und Auftragsziel 2 des Auftrags ist noch aktiv)
		private static method infoConditionFoundTheCult takes AInfo info, ACharacter character returns boolean
			return QuestTheDarkCult.characterQuest(character).questItem(0).isCompleted() and QuestTheDarkCult.characterQuest(character).questItem(1).isNew()
		endmethod
		
		// Ich habe den dunklen Kult ausfindig gemacht.
		private static method infoActionFoundTheCult takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ich habe den dunklen Kult ausfindig gemacht."), null)
			call speech(info, character, true, tr("Was sagst du da? Der Kult existiert noch? Sprich rasch!"), null)
			call speech(info, character, false, tr("Sie haben eine Halle in einem Berg im Norden. Dort halten sie irgendwelche Predigten ab."), null)
			call speech(info, character, true, tr("Wie bitte?! Bei den Göttern, dagegen müssen wir sofort vorgehen!"), null)
			call speech(info, character, false, tr("Es sieht so aus, als hätte ihr Anführer etwas mit seinen Gefolgsleuten herumexperimentiert."), null)
			call speech(info, character, true, tr("Wie meinst du das?"), null)
			call speech(info, character, false, tr("Ihre Körper sehen nicht sehr natürlich aus. Einige von ihnen haben drei Beine, andere die Füße von Vögeln und wieder andere Flügel aus Knochen."), null)
			call speech(info, character, false, tr("Bist du sicher, dass alle Menschen waren?"), null)
			call speech(info, character, true, tr("Götter steht uns bei! Dunkle Magie, anders lässt sich das nicht erklären! Geh da hin und vernichte diese Ketzer, diese Frevler, diese ungläubigen Sünder! Du hast meinen Segen!"), null)
			call speech(info, character, true, tr("Nimm diese Gegenstände. Sie werden dir bei deiner Reinigung von Nutzen sein. Mögen die Götter über dich wachen."), null)
			
			call QuestTheDarkCult.characterQuest(character).questItem(1).complete()
			call QuestTheDarkCult.characterQuest(character).questItem(2).enable()
			call QuestTheDarkCult.characterQuest(character).questItem(3).enable()
			// TODO give items
			//call character.giveItem()
			
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 3 des Auftrags „Der dunkle Kult“ ist abgeschlossen und Auftragsziel 4 ist aktiv)
		private static method infoConditionCultIsHistory takes AInfo info, ACharacter character returns boolean
			return QuestTheDarkCult.characterQuest(character).questItem(2).isCompleted() and QuestTheDarkCult.characterQuest(character).questItem(3).isNew()
		endmethod
		
		// Der Kult ist Geschichte.
		private static method infoActionCultIsHistory takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Der Kult ist Geschichte."), null)
			call speech(info, character, true, tr("Gepriesen seist du, Gottgesandter! Das Übel hat nun endlich ein Ende und ich muss nicht unwissend sterben. Nimm dies als Belohnung. Du hast es dir verdient."), null)

			call QuestTheDarkCult.characterQuest(character).complete()
			// TODO give items
			//call character.giveItem()
			
			call info.talk().showStartPage(character)
		endmethod
			

		// Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben."), null)
			call speech(info, character, true, tr("Hüte deine Zunge elender Wurm!"), null)
			call TalkOsman(info.talk()).offend(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// Die Freude ist ganz meinerseits.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Die Freude ist ganz meinerseits."), null)
			call speech(info, character, true, tr("Na das ist mir doch glatt ein paar Goldmünzen wert. Hier, nimm Bruder!"), null)
			call character.addGold(thistype.brotherGoldReward)
			call speech(info, character, false, tr("Danke."), null)
			call info.talk().showStartPage(character)
		endmethod

		// So so, du stehst wohl auf junge Knaben.
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("So so, du stehst wohl auf junge Knaben."), null)
			call speech(info, character, true, tr("Jetzt reicht's mir! Ich werde mich beim Herzog persönlich über dich beschweren!"), null)
			call QuestThePaedophilliacCleric.characterQuest(character).enable()
			call speech(info, character, false, tr("Es war mir ein Vergnügen."), null)
			call speech(info, character, true, tr("Du wirst schon noch dein blaues Wunder erleben!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Das vorhin tut mir leid. Ich hab das nicht so gemeint.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Das vorhin tut mir leid. Ich hab das nicht so gemeint."), null)
			call speech(info, character, true, tr("Schon gut. Ich weiß ja wie angespannt die Lage ist, da kann einem so etwas schon mal raus rutschen."), null)
			call speech(info, character, true, tr("Verdammter Krieg eben."), null)
			call info.talk().showRange(this.m_shutUp.index(), this.m_back.index(), character)
		endmethod

		// Halt den Mund du Tölpel!
		private static method infoAction1_0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Halt den Mund du Tölpel!"), null)
			call speech(info, character, true, tr("Du scheinst wohl unter Stimmungsschwankungen zu leiden. Ich glaube, ich hab da was für dich. Wäre doch gelacht, wenn dir ein alter Kleriker wie ich nicht helfen könnte. Hier, nimm das!"), null)
			call TalkOsman(info.talk()).giveHealPotion(character)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.osman(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_wasOffended[i] = false
				set this.m_gaveHealPotion[i] = false
				set i = i + 1
			endloop

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo."))
			set this.m_whatAreYouDoingHere = this.addInfo(true, false, thistype.infoCondition1, thistype.infoAction1, tr("Was machst du hier?"))
			set this.m_doYouHaveMoreHealing = this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tr("Hast du noch mehr Heilmittel?"))
			set this.m_guntrichNeedsHelp = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Guntrich braucht deine Hilfe."))
			set this.m_aboutTheGods = this.addInfo(true, false, thistype.infoConditionAboutTheGods, thistype.infoActionAboutTheGods, tr("Erzähl mir etwas über die Götter."))
			set this.m_area = this.addInfo(true, false, thistype.infoConditionArea, thistype.infoActionArea, tr("Was weißt du über diese Gegend?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Kann ich dir irgendwie helfen?"))
			set this.m_moreAboutTheCult = this.addInfo(true, false, thistype.infoConditionMoreAboutTheCult, thistype.infoActionMoreAboutTheCult, tr("Erzähl mir mehr über den dunklen Kult."))
			set this.m_searchForTheCult = this.addInfo(false, false, thistype.infoConditionSearchForTheCult, thistype.infoActionSearchForTheCult, tr("Warum sucht keiner nach den verbliebenen Kultanhängern?"))
			set this.m_foundTheCult = this.addInfo(false, false, thistype.infoConditionFoundTheCult, thistype.infoActionFoundTheCult, tr("Ich habe den dunklen Kult ausfindig gemacht."))
			set this.m_cultIsHistory = this.addInfo(false, false, thistype.infoConditionCultIsHistory, thistype.infoActionCultIsHistory, tr("Der Kult ist Geschichte."))
			set this.m_exit = this.addExitButton()

			// m_hi
			set this.m_youAreKnowBeliever = this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Du bist kein Glaubensgenosse. Du bist nur ein Feigling, der sich beim Herzog versteckt. Ein wahrer Kleriker zieht umher und kämpft für seinen Glauben."))
			set this.m_itsMyPleasure = this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Die Freude ist ganz meinerseits."))

			// m_whatAreYouDoingHere
			set this.m_youLikeYoungBoys = this.addInfo(false, false, 0, thistype.infoAction1_0, tr("So so, du stehst wohl auf junge Knaben."))
			set this.m_iAmSorry = this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Das vorhin tut mir leid. Ich hab das nicht so gemeint."))

			// m_youLikeYoungBoys
			set this.m_shutUp = this.addInfo(false, false, 0, thistype.infoAction1_0_0, tr("Halt den Mund du Tölpel!"))
			set this.m_back = this.addBackToStartPageButton()

			return this
		endmethod
	endstruct

endlibrary