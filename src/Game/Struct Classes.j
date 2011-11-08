library StructGameClasses requires Asl, StructGameCharacter

	struct Classes
		private static AClass m_cleric
		private static AClass m_necromancer
		private static AClass m_druid
		private static AClass m_knight
		private static AClass m_dragonSlayer
		private static AClass m_ranger
		private static AClass m_elementalMage
		private static AClass m_astralModifier
		private static AClass m_illusionist
		private static AClass m_wizard

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_cleric = 0
			set thistype.m_necromancer = 0
			set thistype.m_druid = 0
			set thistype.m_knight = 0
			set thistype.m_dragonSlayer = 0
			set thistype.m_ranger = 0
			set thistype.m_elementalMage = 0
			set thistype.m_astralModifier = 0
			set thistype.m_illusionist = 0
			set thistype.m_wizard = 0
		endmethod

		private static method displayMessageToAllPlayingUsers takes real time, string message, player excludingPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerSlotState(Player(i)) != PLAYER_SLOT_STATE_EMPTY and GetPlayerController(Player(i)) == MAP_CONTROL_USER and Player(i) != excludingPlayer) then
					call DisplayTimedTextToPlayer(Player(i), 0.0, 0.0, time, message)
				endif
				set i = i + 1
			endloop
		endmethod

		private static method selectClassFunction takes Character character, AClass class, boolean last returns nothing
			/**
			* Create all class spells for each character in debug mode.
			*/
			// cleric spells
//static if (not DEBUG_MODE) then
//			if (character.class() == Classes.m_cleric) then
//endif
				call SpellAbatement.create(character)
				call SpellClarity.create(character)
				call SpellExorcizeEvil.create(character)
				call SpellHolyPower.create(character)
				call SpellHolyWill.create(character)
				call SpellImpendingDisaster.create(character)
				call SpellPreventIll.create(character)
				call SpellProtect.create(character)
				call SpellRecovery.create(character)
				call SpellRevive.create(character)
				call SpellTorment.create(character)
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_necromancer) then
//endif
				call SpellAncestorPact.create(character)
				call SpellDarkServant.create(character)
				call SpellDeathHerald.create(character)
				call SpellDemonServant.create(character)
				call SpellSoulThievery.create(character)
				call SpellViolentDeath.create(character)
				
			//elseif (character.class() == thistype.m_druid) then
				call SpellAwakeningOfTheForest.create(character)
				call SpellCrowForm.create(character)
				call SpellBearForm.create(character)
				call SpellForestFaeriesSpell.create(character)
				call SpellHerbalCure.create(character)
				call SpellRelief.create(character)
				call SpellZoology.create(character)
			
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_knight) then
//endif
				call SpellBlock.create(character)
				call SpellConcentration.create(character)
				call SpellLivingWill.create(character)
				call SpellRush.create(character)
				call SpellSelflessness.create(character)
				call SpellStab.create(character)
				call SpellTaunt.create(character)
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_dragonSlayer) then
//endif
				call SpellBeastHunter.create(character)
				call SpellDaunt.create(character)
				call SpellFuriousBloodthirstiness.create(character)
				call SpellSlash.create(character)
				call SpellSupremacy.create(character)
				call SpellWeakPoint.create(character)
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_ranger) then
//endif
				call SpellAgility.create(character)
				call SpellEagleEye.create(character)
				call SpellShooter.create(character)
				call SpellShotIntoHeart.create(character)
				call SpellSprint.create(character)
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_elementalMage) then
//endif
				call SpellBlaze.create(character)
				call SpellEarthPrison.create(character)
				call SpellElementalForce.create(character)
				call SpellEmblaze.create(character)
				call SpellFireMissile.create(character)
				call SpellFreeze.create(character)
				call SpellGlisteningLight.create(character)
				call SpellIceMissile.create(character)
				call SpellInferno.create(character)
				call SpellLightning.create(character)
				call SpellMastery.create(character)
				call SpellRageOfElements.create(character)
				call SpellPureEnergy.create(character)
				call SpellTeleportation.create(character)
				call SpellUndermine.create(character)
				
//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_astralModifier) then
//endif
				call SpellTakeOver.create(character)

//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_illusionist) then
//endif

//static if (not DEBUG_MODE) then
//			elseif (character.class() == Classes.m_wizard) then
//endif
				call SpellAbsorbation.create(character)
				call SpellAdduction.create(character)
				call SpellArcaneBinding.create(character)
				call SpellArcaneHunger.create(character)
				call SpellArcaneProtection.create(character)
				call SpellArcaneRuse.create(character)
				call SpellArcaneTime.create(character)
				call SpellAstralSource.create(character)
				call SpellBan.create(character)
				call SpellControlledTimeFlow.create(character)
				call SpellCurb.create(character)
				call SpellMagicalShockWaves.create(character)
				call SpellManaExplosion.create(character)
				call SpellManaShield.create(character)
				call SpellManaStream.create(character)
				call SpellRepulsion.create(character)

//static if (not DEBUG_MODE) then
//			endif
//endif
			call character.grimoire().addClassSpells.evaluate(class)

			call SpellCowNova.create.evaluate(character) /// @todo test

			call character.setMovable(false)
			call character.revival().setTime(MapData.revivalTime)
			call SetUserInterfaceForPlayer(character.player(), false, false)
			call CameraSetupApplyForPlayer(false, gg_cam_class_selection, character.player(), 0.0)
			call MapData.setCameraBoundsToPlayableAreaForPlayer.evaluate(character.player())
			call thistype.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, StringArg(StringArg(tr("%s hat die Klasse \"%s\" gewählt."), character.name()), GetUnitName(character.unit())), character.player())
			if (not last) then
				call character.displayMessage(ACharacter.messageTypeInfo, tr("Warten Sie bis alle anderen Spieler ihre Klasse gewählt haben."))
			endif
		endmethod

		private static method initCleric takes nothing returns nothing
			set thistype.m_cleric = AClass.create('H000', "spell", "Sound\\Units\\ClassCleric\\Class.wav")
			//thistype.m_cleric.setAbilityIconPath(0, "");
			//thistype.m_cleric.setUsedAbility(0, 0);
			call thistype.m_cleric.addDescriptionLine(tr("Kleriker sind meist gottesfürchtige Menschen,"))
			call thistype.m_cleric.addDescriptionLine(tr("die die Gabe der Heilung erhalten haben. Diese nutzen sie,"))
			call thistype.m_cleric.addDescriptionLine(tr("um ihre Verbündeten genesen zu lassen, sie vor Schaden zu schützen"))
			call thistype.m_cleric.addDescriptionLine(tr("und sie von dunkler Magie zu befreien."))
			call thistype.m_cleric.addDescriptionLine(tr("Ihre offensiven Fähigkeiten jedoch, sind stark eingeschränkt"))
			call thistype.m_cleric.addDescriptionLine(tr("und alleine sind sie häufig nicht in der Lage, mächtige Feinde"))
			call thistype.m_cleric.addDescriptionLine(tr("zu bezwingen."))
		endmethod

		private static method initNecromancer takes nothing returns nothing
			set thistype.m_necromancer = AClass.create('H004', "spell", "Sound\\Units\\ClassNecromancer\\Class.wav")
			call thistype.m_necromancer.addDescriptionLine(tr("Nekromanten sind die Gegenstücke zu Klerikern: zwar sind auch sie häufig gottesfürchtig,"))
			call thistype.m_necromancer.addDescriptionLine(tr("jedoch verehren sie andere Götter als der Großteil der Menschen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Durch eine harte Ausbildung und finsteren Studien sind sie schließlich in der Lage,"))
			call thistype.m_necromancer.addDescriptionLine(tr("die schwärzeste Magie zu beherrschen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Mit ihrer Hilfe fügen sie ihren Opfern langsam Schmerzen zu und beschwören Kreaturen"))
			call thistype.m_necromancer.addDescriptionLine(tr("aus den tiefen der Unterwelt, die sie für sich kämpfen lassen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Doch eines sollte nicht vergessen werden: Auch wenn die Magie selbst eine dunkle ist,"))
			call thistype.m_necromancer.addDescriptionLine(tr("so muss sie nicht zwangsläufig einem bösen Zweck dienen. Es liegt in jedermanns eigener Hand,"))
			call thistype.m_necromancer.addDescriptionLine(tr("zu entscheiden, wofür sie genutzt wird."))
		endmethod
		
		private static method initDruid takes nothing returns nothing
			set thistype.m_druid = AClass.create('H00G', "spell", "Sound\\Units\\ClassDruid\\Class.wav")
			call thistype.m_druid.addDescriptionLine(tr("Druiden sind naturverbundene, ruhige Wanderer, die in Einklang mit ihrer Umwelt leben."))
			call thistype.m_druid.addDescriptionLine(tr("Sie sind stets darauf bedacht,"))
			call thistype.m_druid.addDescriptionLine(tr("alles im Gleichgewicht zu halten und ziehen von Ort zu Ort,"))
			call thistype.m_druid.addDescriptionLine(tr("um anderen ihre Heil-  und Zauberkünste anzubieten. Ihre jahrelangen Studien der Tiere"))
			call thistype.m_druid.addDescriptionLine(tr("haben ihnen die Fähigkeit verliehen, die Gestalt dieser anzunehmen oder sie als"))
			call thistype.m_druid.addDescriptionLine(tr("unterstützende Gefährten herbeizurufen."))
		endmethod

		private static method initKnight takes nothing returns nothing
			set thistype.m_knight = AClass.create('H006', "spell", "Sound\\Units\\ClassKnight\\Class.wav")
			call thistype.m_knight.addDescriptionLine(tr("Der Ritter ist ein starker Kämpfer, der an vorderster Front steht und eine dicke Rüstung trägt,"))
			call thistype.m_knight.addDescriptionLine(tr("die ihn besonders überlebensfähig macht."))
			call thistype.m_knight.addDescriptionLine(tr("Er sorgt dafür, dass seine Feinde die weniger gut geschützten Nah- und Fernkämpfer nicht erreichen."))
			call thistype.m_knight.addDescriptionLine(tr("Durch seine kämpferische Ausstrahlung ist er in der Lage, die Moral und Kampfkraft seiner Gefährten zu steigern."))
		endmethod

		private static method initDragonSlayer takes nothing returns nothing
			set thistype.m_dragonSlayer = AClass.create('H007', "spell", "Sound\\Units\\ClassDragonSlayer\\Class.wav")
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Die meisten Drachentöter haben zwar noch nicht einmal einen Drachen zu Gesicht bekommen,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("sind aber dennoch äußerst ernstzunehmende Gegner."))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Sie agieren sehr offensiv und achten nicht besonders auf ihre Verteidigung,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("weshalb sie die Anwesenheit eines Ritters häufig nutzen, jedoch nicht schätzen."))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Drachentöter beherrschen den Umgang mit ihren Waffen ausgezeichnet und sind in der Lage,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("enorm schnell eine ganze Reihe von Gegnern abzuschlachten."))
		endmethod

		private static method initRanger takes nothing returns nothing
			set thistype.m_ranger = AClass.create('H008', "spell", "Sound\\Units\\ClassRanger\\Class.wav")
			call thistype.m_ranger.addDescriptionLine(tr("Waldläufer sind Bogenschützen, die aus der Ferne agieren und von dort ihren Gegnern Schaden zufügen."))
			call thistype.m_ranger.addDescriptionLine(tr("Mit Hilfe von unterschiedlichen Pfeilarten schwächen und verlangsamen sie ihre Ziele."))
			call thistype.m_ranger.addDescriptionLine(tr("Im Nahkampf haben sie ihren Widersachern jedoch häufig nicht viel entgegenzusetzen,"))
			call thistype.m_ranger.addDescriptionLine(tr("weshalb sie sich auf ihre Distanz zum Gegner verlassen und ihre Agilität verbessern,"))
			call thistype.m_ranger.addDescriptionLine(tr("um schnell auf Abstand kommen zu können."))
		endmethod

		private static method initElementalMage takes nothing returns nothing
			set thistype.m_elementalMage = AClass.create('H009', "spell", "Sound\\Units\\ClassElementalMage\\Class.wav")
			call thistype.m_elementalMage.addDescriptionLine(tr("Elementarmagier sind trotz ihres häufig gebrechlich anmutenden Äußeren erbarmungslose Widersacher,"))
			call thistype.m_elementalMage.addDescriptionLine(tr("die ihre Gegner mit den Kräften der vier Elemente Feuer, Wasser, Luft und Erde vernichten."))
			call thistype.m_elementalMage.addDescriptionLine(tr("Ihre Stärke zeigt sich besonders gegen mehrere Gegner,"))
			call thistype.m_elementalMage.addDescriptionLine(tr("wenn sie die Erde unter den Füßen dieser in Flammen aufgehen oder mit einer Welle"))
			call thistype.m_elementalMage.addDescriptionLine(tr("aus tiefstem Eis die Umwelt erschüttern lassen."))
		endmethod
		
		private static method initAstralModifier takes nothing returns nothing
			set thistype.m_astralModifier = AClass.create('H005', "spell", "Sound\\Units\\ClassAstralModifier\\Class.wav")
			call thistype.m_astralModifier.addDescriptionLine(tr("Astralwandler sind eng mit der Zwischenwelt und den dortigen Geistern verbunden."))
			call thistype.m_astralModifier.addDescriptionLine(tr("Sie sind dazu in der Lage, sich selbst in diese Zwischenebene zu versetzen,"))
			call thistype.m_astralModifier.addDescriptionLine(tr("ihren Körper aufzulösen und nur ihre astralen Ströme wandern zu lassen,"))
			call thistype.m_astralModifier.addDescriptionLine(tr("sodass sie in ihre Feinde eindringen und sie entweder von innen heraus zerstören"))
			call thistype.m_astralModifier.addDescriptionLine(tr("oder sie übernehmen können."))
			call thistype.m_astralModifier.addDescriptionLine(tr("Einige Astralwandler sind in ihrer Herrschaftsgewalt über die Geister so stark,"))
			call thistype.m_astralModifier.addDescriptionLine(tr("dass sie ihnen befehlen können, sie ihrem Willen zu unterwerfen."))
		endmethod

		private static method initIllusionist takes nothing returns nothing
			set thistype.m_illusionist = AClass.create('H00A', "spell", "Sound\\Units\\ClassIllusionist\\Class.wav")
			call thistype.m_illusionist.addDescriptionLine(tr("Illusionisten manipulieren die Gedanken ihrer Opfer und gaukeln ihnen ihr eigenes,"))
			call thistype.m_illusionist.addDescriptionLine(tr("schreckliches Schicksal vor. Dadurch säen sie Verzweiflung oder Unvorsichtigkeit,"))
			call thistype.m_illusionist.addDescriptionLine(tr("was ihre Gegner stark schwächt. Einige besonders mächtige Illusionisten sind sogar in der Lage,"))
			call thistype.m_illusionist.addDescriptionLine(tr("ihre Opfer schreckliche Schmerzen empfinden zu lassen, oder ihnen vorzutäuschen,"))
			call thistype.m_illusionist.addDescriptionLine(tr("sie stünden in Flammen oder ertränken."))
		endmethod

		private static method initWizard takes nothing returns nothing
			set thistype.m_wizard = AClass.create('H002', "spell", "Sound\\Units\\ClassWizard\\Class.wav")
			call thistype.m_wizard.addDescriptionLine(tr("Der Zauberer kontrolliert im Gegensatz zum Elementarmagier"))
			call thistype.m_wizard.addDescriptionLine(tr("nicht die Gewalt der Elemente, sondern das feine Gefüge des Arkanen."))
			call thistype.m_wizard.addDescriptionLine(tr("Er kann seinen Gegnern ihre magische Kraft entziehen und auf sich selbst"))
			call thistype.m_wizard.addDescriptionLine(tr("oder Verbündete übertragen, Zauber auf ihre Urheber zurücklenken oder sie sogar absorbieren,"))
			call thistype.m_wizard.addDescriptionLine(tr("ohne selbst verletzt zu werden."))
		endmethod

		public static method init takes nothing returns nothing
			call thistype.initCleric()
			call thistype.initNecromancer()
			call thistype.initDruid()
			call thistype.initKnight()
			call thistype.initDragonSlayer()
			call thistype.initRanger()
			call thistype.initElementalMage()
			call thistype.initAstralModifier()
			call thistype.initIllusionist()
			call thistype.initWizard()
		endmethod

		private static method characterCreationAction takes AClassSelection classSelection, unit whichUnit returns ACharacter
			return Character.create(classSelection.player(), whichUnit)
		endmethod

		/**
		* Since \ref AClassSelection.init is called which creates a multiboard, this method
		* mustn't be called during map initialization beside you use a \ref TriggerSleepAction call.
		*/
		public static method showClassSelection takes nothing returns nothing
			local AClassSelection classSelection
			local integer i
			local player whichPlayer

			call AClassSelection.init(gg_cam_class_selection, false, GetRectCenterX(gg_rct_class_selection), GetRectCenterY(gg_rct_class_selection), 270.0, 0.01, 2.0, thistype.m_cleric, thistype.m_wizard, thistype.characterCreationAction, Game.start, "", "", "", tr("%s (%i/%i)"), tr("Stärke: %i"), tr("Geschick: %i"), tr("Wissen: %i"), tr("Fähigkeiten"), tr("Beschreibung"))

			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
			call ForceCinematicSubtitles(true)
			call Game.setMapMusic("Music\\CharacterSelection.mp3")

			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set whichPlayer = Player(i)

				if (GetPlayerSlotState(whichPlayer) != PLAYER_SLOT_STATE_EMPTY) then
					set classSelection = AClassSelection.create(whichPlayer, MapData.startX.evaluate(i), MapData.startY.evaluate(i), 0.0, thistype.selectClassFunction)
					call classSelection.show()
				endif

				set whichPlayer = null
				set i = i + 1
			endloop
			call thistype.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, tr("Wählen Sie zunächst Ihre Charakterklasse aus. Diese Auswahl ist für die restliche Spielzeit unwiderruflich."), null)
			call thistype.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, tr("- Drücken Sie die linke oder rechte Pfeiltaste, um die angezeigte Charakterklasse zu wechseln."), null)
			call thistype.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, tr("- Drücken Sie die Escape-Taste, um die angezeigte Charakterklasse auszuwählen."), null)
		endmethod

		public static method cleric takes nothing returns AClass
			return thistype.m_cleric
		endmethod

		public static method necromancer takes nothing returns AClass
			return thistype.m_necromancer
		endmethod

		public static method druid takes nothing returns AClass
			return thistype.m_druid
		endmethod

		public static method knight takes nothing returns AClass
			return thistype.m_knight
		endmethod

		public static method dragonSlayer takes nothing returns AClass
			return thistype.m_dragonSlayer
		endmethod

		public static method ranger takes nothing returns AClass
			return thistype.m_ranger
		endmethod

		public static method elementalMage takes nothing returns AClass
			return thistype.m_elementalMage
		endmethod
		
		public static method astralModifier takes nothing returns AClass
			return thistype.m_astralModifier
		endmethod

		public static method illusionist takes nothing returns AClass
			return thistype.m_illusionist
		endmethod

		public static method wizard takes nothing returns AClass
			return thistype.m_wizard
		endmethod

		public static method className takes AClass class returns string
			if (class == Classes.cleric()) then
				return tr("Kleriker")
			elseif (class == Classes.necromancer()) then
				return tr("Nekromant")
			elseif (class == Classes.druid()) then
				return tr("Druide")
			elseif (class == Classes.knight()) then
				return tr("Ritter")
			elseif (class == Classes.dragonSlayer()) then
				return tr("Drachentöter")
			elseif (class == Classes.ranger()) then
				return tr("Waldläufer")
			elseif (class == Classes.elementalMage()) then
				return tr("Elementarmagier")
			elseif (class == Classes.astralModifier()) then
				return tr("Astralwandler")
			elseif (class == Classes.illusionist()) then
				return tr("Illusionist")
			elseif (class == Classes.wizard()) then
				return tr("Zauberer")
			endif

			return tr("Unbekannt")
		endmethod

		public static method isChaplain takes AClass class returns boolean
			return class == thistype.cleric() or class == thistype.necromancer() or class == thistype.druid()
		endmethod

		public static method isWarrior takes AClass class returns boolean
			return class == thistype.knight() or class == thistype.dragonSlayer() or class == thistype.ranger()
		endmethod

		public static method isMage takes AClass class returns boolean
			return class == thistype.elementalMage() or class == thistype.astralModifier() or class == thistype.illusionist() or class == thistype.wizard()
		endmethod

		public static method classCategoryName takes AClass class returns string
			if (thistype.isChaplain(class)) then
				return tr("Geistliche")
			elseif (thistype.isWarrior(class)) then
				return tr("Krieger")
			elseif (thistype.isMage(class)) then
				return tr("Magier")
			endif
			return tr("Unbekannt")
		endmethod
	endstruct

endlibrary