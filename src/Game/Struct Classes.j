library StructGameClasses requires Asl, StructGameCharacter

	/**
	 * \brief An entry for the class selection for a single class ability.
	 * The entry allows to display a class ability in the grimoire of the unit displayed in the class selection.
	 */
	struct ClassGrimoireEntry
		private integer m_abilityId
		private integer m_grimoireAbilityId
		
		public method abilityId takes nothing returns integer
			return this.m_abilityId
		endmethod
		
		public method grimoireAbilityId takes nothing returns integer
			return this.m_grimoireAbilityId
		endmethod
		
		/**
		 * Shows the given ability as grimoire ability for unit \p whichUnit.
		 */
		public method show takes unit whichUnit returns nothing
			call UnitAddAbility(whichUnit, this.m_grimoireAbilityId)
			call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), this.m_grimoireAbilityId, false)
			call UnitAddAbility(whichUnit, this.m_abilityId)
		endmethod
		
		/**
		 * Hides the given ability from unit \p whichUnit.
		 */
		public method hide takes unit whichUnit returns nothing
			if (GetUnitAbilityLevel(whichUnit, this.m_abilityId) > 0) then
				call UnitRemoveAbility(whichUnit, this.m_abilityId)
				call UnitRemoveAbility(whichUnit, this.m_grimoireAbilityId)
			endif
		endmethod
		
		public static method create takes integer abilityId, integer grimoireAbilityId returns thistype
			local thistype this = thistype.allocate()
			set this.m_abilityId = abilityId
			set this.m_grimoireAbilityId = grimoireAbilityId
			
			return this
		endmethod
	endstruct

	/**
	 * \brief Stores all eight different classes as global instances and provides utility methods for the class abilities.
	 */
	struct Classes
		private static AClass m_cleric
		private static AIntegerVector m_clericGrimoireEntries
		private static AClass m_necromancer
		private static AIntegerVector m_necromancerGrimoireEntries
		private static AClass m_druid
		private static AIntegerVector m_druidGrimoireEntries
		private static AClass m_knight
		private static AIntegerVector m_knightGrimoireEntries
		private static AClass m_dragonSlayer
		private static AIntegerVector m_dragonSlayerGrimoireEntries
		private static AClass m_ranger
		private static AIntegerVector m_rangerGrimoireEntries
		private static AClass m_elementalMage
		private static AIntegerVector m_elementalMageGrimoireEntries
		private static AClass m_wizard
		private static AIntegerVector m_wizardGrimoireEntries
		
		private static ClassGrimoireEntry m_nextPageGrimoireEntry
		private static ClassGrimoireEntry m_previousPageGrimoireEntry

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_nextPageGrimoireEntry = ClassGrimoireEntry.create('A0AB', 'A0AX')
			set thistype.m_previousPageGrimoireEntry = ClassGrimoireEntry.create('A0AA', 'A0AY')
		endmethod
		
		public static method classAbilitiesNextPageAbilityId takes nothing returns integer
			return thistype.m_nextPageGrimoireEntry.abilityId()
		endmethod
		
		public static method classAbilitiesPreviousPageAbilityId takes nothing returns integer
			return thistype.m_previousPageGrimoireEntry.abilityId()
		endmethod
		
		public static method createClassAbilitiesWithEntries takes unit whichUnit, AIntegerVector grimoireEntries, integer page, integer spellsPerPage returns nothing
			local integer i
			local integer index
			// first of all hide them
			set i = 0
			loop
				exitwhen (i == grimoireEntries.size())
				call ClassGrimoireEntry(grimoireEntries[i]).hide(whichUnit)
				set i = i + 1
			endloop
			
			// show next and previous page buttons
			call thistype.m_nextPageGrimoireEntry.show(whichUnit)
			call thistype.m_previousPageGrimoireEntry.show(whichUnit)
			
			set i = 0
			loop
				exitwhen (i == spellsPerPage)
				set index = Index2D(page, i, spellsPerPage)
				if (index >= grimoireEntries.size()) then
					exitwhen (true)
				endif
				call ClassGrimoireEntry(grimoireEntries[index]).show(whichUnit)
				set i = i + 1
			endloop
		endmethod
		
		/**
		 * \note Similar to \ref Grimoire#pages()
		 */
		public static method maxGrimoireEntriesPages takes AIntegerVector grimoireEntries, integer spellsPerPage returns integer
			local integer result = grimoireEntries.size() / spellsPerPage
			if (ModuloInteger(grimoireEntries.size(), spellsPerPage) > 0) then
				set result = result + 1
			endif
			// set at least 1 page
			if (result == 0) then
				set result = 1
			endif
			
			return result
		endmethod
		
		private static method classGrimoireEntries takes AClass class returns AIntegerVector
			if (class == thistype.m_cleric) then
				return thistype.m_clericGrimoireEntries
			elseif (class == thistype.m_necromancer) then
				return thistype.m_necromancerGrimoireEntries
			elseif (class == thistype.m_druid) then
				return thistype.m_druidGrimoireEntries
			elseif (class == thistype.m_knight) then
				return thistype.m_knightGrimoireEntries
			elseif (class == thistype.m_dragonSlayer) then
				return thistype.m_dragonSlayerGrimoireEntries
			elseif (class == thistype.m_ranger) then
				return thistype.m_rangerGrimoireEntries
			elseif (class == thistype.m_elementalMage) then
				return thistype.m_elementalMageGrimoireEntries
			elseif (class == thistype.m_wizard) then
				return thistype.m_wizardGrimoireEntries
			endif
			debug call Print("Invalid class " + I2S(class))
			return 0
		endmethod
		
		
		private static method preloadAbilitiesFromVector takes AIntegerVector vector returns nothing
			local integer i = 0
			loop
				exitwhen (i == vector.size())
				debug call Print("Preloading " + GetAbilityName(ClassGrimoireEntry(vector[i]).abilityId()))
				call AbilityPreload(ClassGrimoireEntry(vector[i]).abilityId())
				call AbilityPreload(ClassGrimoireEntry(vector[i]).grimoireAbilityId())
				set i = i + 1
			endloop
		endmethod
		
		private static method preloadAbilities takes nothing returns nothing
			call thistype.preloadAbilitiesFromVector(thistype.m_clericGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_necromancerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_druidGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_knightGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_dragonSlayerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_rangerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_elementalMageGrimoireEntries)
			call thistype.preloadAbilitiesFromVector(thistype.m_wizardGrimoireEntries)
		endmethod
		
		/**
		 * Creates grimoire abilities of the specified class \p class for \p whichUnit at \p page using at maximum \p spellsPerPage.
		 * The grimoire abilities are used in the class selection to inform the selecting player which spells are available for each class.
		 */
		public static method createClassAbilities takes AClass class, unit whichUnit, integer page, integer spellsPerPage returns nothing
			call thistype.createClassAbilitiesWithEntries(whichUnit, thistype.classGrimoireEntries(class), page, spellsPerPage)
		endmethod
		
		/**
		 * \return Returns the maximum number of pages for class \p class using \p spellsPerPage.
		 */
		public static method maxClassAbilitiesPages takes AClass class, integer spellsPerPage returns integer
			local AIntegerVector grimoireEntries = thistype.classGrimoireEntries(class)
			return thistype.maxGrimoireEntriesPages(grimoireEntries, spellsPerPage)
		endmethod
		
		private static method initCleric takes nothing returns nothing
			set thistype.m_cleric = AClass.create('H000', "spell", "Sound\\Units\\ClassCleric\\Class.wav")
			call thistype.m_cleric.setStrPerLevel(1.50)
			call thistype.m_cleric.setAgiPerLevel(1.50)
			call thistype.m_cleric.setIntPerLevel(3.0)
			call thistype.m_cleric.addDescriptionLine(tre("Kleriker sind meist gottesfürchtige Menschen,", "Clerics are mostly God-fearing humans"))
			call thistype.m_cleric.addDescriptionLine(tre("welche die Gabe der Heilung und des Schutzes erhalten haben. Diese nutzen sie,", "who got the gift of healing and protection. They use it"))
			call thistype.m_cleric.addDescriptionLine(tre("um ihre Verbündeten genesen zu lassen, sie vor Schaden zu schützen", "to let their allies recover, to protect them from damage"))
			call thistype.m_cleric.addDescriptionLine(tre("und sie von dunkler Magie zu befreien.", "and to free them from dark magic."))
			call thistype.m_cleric.addDescriptionLine(tre("Ihre offensiven Fähigkeiten jedoch, sind stark eingeschränkt", "Their offensive abilities are largely limited"))
			call thistype.m_cleric.addDescriptionLine(tre("und alleine sind sie häufig nicht in der Lage, mächtige Feinde", "and they are not capable of defeating"))
			call thistype.m_cleric.addDescriptionLine(tre("zu bezwingen.", "powerful enemies alone."))
			
			set thistype.m_clericGrimoireEntries = AIntegerVector.create()
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMaertyrer.classSelectionAbilityId, SpellMaertyrer.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAbatement.classSelectionAbilityId, SpellAbatement.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlind.classSelectionAbilityId, SpellBlind.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellClarity.classSelectionAbilityId, SpellClarity.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellHolyPower.classSelectionAbilityId, SpellHolyPower.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellImpendingDisaster.classSelectionAbilityId, SpellImpendingDisaster.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPreventIll.classSelectionAbilityId, SpellPreventIll.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellProtect.classSelectionAbilityId, SpellProtect.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRecovery.classSelectionAbilityId, SpellRecovery.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRevive.classSelectionAbilityId, SpellRevive.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlessing.classSelectionAbilityId, SpellBlessing.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellConversion.classSelectionAbilityId, SpellConversion.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellGodsFavor.classSelectionAbilityId, SpellGodsFavor.classSelectionGrimoireAbilityId))
			
			// ultimates on page 2
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellExorcizeEvil.classSelectionAbilityId, SpellExorcizeEvil.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellHolyWill.classSelectionAbilityId, SpellHolyWill.classSelectionGrimoireAbilityId))
		endmethod

		private static method initNecromancer takes nothing returns nothing
			set thistype.m_necromancer = AClass.create('H004', "spell", "Sound\\Units\\ClassNecromancer\\Class.wav")
			call thistype.m_necromancer.setStrPerLevel(1.50)
			call thistype.m_necromancer.setAgiPerLevel(1.50)
			call thistype.m_necromancer.setIntPerLevel(3.0)
			call thistype.m_necromancer.addDescriptionLine(tr("Nekromanten sind die Gegenstücke zu Klerikern: zwar sind auch sie häufig gottesfürchtig,"))
			call thistype.m_necromancer.addDescriptionLine(tr("jedoch verehren sie andere Götter als der Großteil der Menschen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Durch eine harte Ausbildung und finsteren Studien sind sie schließlich in der Lage,"))
			call thistype.m_necromancer.addDescriptionLine(tr("die schwärzeste Magie zu beherrschen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Mit ihrer Hilfe fügen sie ihren Opfern langsam Schmerzen zu und beschwören Kreaturen"))
			call thistype.m_necromancer.addDescriptionLine(tr("aus den tiefen der Unterwelt, die sie für sich kämpfen lassen."))
			call thistype.m_necromancer.addDescriptionLine(tr("Doch eines sollte nicht vergessen werden: Auch wenn die Magie selbst eine dunkle ist,"))
			call thistype.m_necromancer.addDescriptionLine(tr("so muss sie nicht zwangsläufig einem bösen Zweck dienen. Es liegt in jedermanns eigener Hand,"))
			call thistype.m_necromancer.addDescriptionLine(tr("zu entscheiden, wofür sie genutzt wird."))
			
			set thistype.m_necromancerGrimoireEntries = AIntegerVector.create()
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAncestorPact.classSelectionAbilityId, SpellAncestorPact.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellConsume.classSelectionAbilityId, SpellConsume.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDarkServant.classSelectionAbilityId, SpellDarkServant.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDarkSpell.classSelectionAbilityId, SpellDarkSpell.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDeathHerald.classSelectionAbilityId, SpellDeathHerald.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDemonServant.classSelectionAbilityId, SpellDemonServant.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSoulThievery.classSelectionAbilityId, SpellSoulThievery.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellWorldsPortal.classSelectionAbilityId, SpellWorldsPortal.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellNecromancy.classSelectionAbilityId, SpellNecromancy.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPlague.classSelectionAbilityId, SpellPlague.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellParasite.classSelectionAbilityId, SpellParasite.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMasterOfNecromancy.classSelectionAbilityId, SpellMasterOfNecromancy.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEpidemic.classSelectionAbilityId, SpellEpidemic.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDamnedGround.classSelectionAbilityId, SpellDamnedGround.classSelectionGrimoireAbilityId))
		endmethod

		private static method initDruid takes nothing returns nothing
			set thistype.m_druid = AClass.create('H00G', "spell", "Sound\\Units\\ClassDruid\\Class.wav")
			call thistype.m_druid.setStrPerLevel(1.50)
			call thistype.m_druid.setAgiPerLevel(1.50)
			call thistype.m_druid.setIntPerLevel(3.0)
			call thistype.m_druid.addDescriptionLine(tr("Druiden sind naturverbundene, ruhige Wanderer, die in Einklang mit ihrer Umwelt leben."))
			call thistype.m_druid.addDescriptionLine(tr("Sie sind stets darauf bedacht,"))
			call thistype.m_druid.addDescriptionLine(tr("alles im Gleichgewicht zu halten und ziehen von Ort zu Ort,"))
			call thistype.m_druid.addDescriptionLine(tr("um anderen ihre Heil-  und Zauberkünste anzubieten. Ihre jahrelangen Studien der Tiere"))
			call thistype.m_druid.addDescriptionLine(tr("haben ihnen die Fähigkeit verliehen, die Gestalt dieser anzunehmen oder sie als"))
			call thistype.m_druid.addDescriptionLine(tr("unterstützende Gefährten herbeizurufen."))
			
			set thistype.m_druidGrimoireEntries = AIntegerVector.create()
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAwakeningOfTheForest.classSelectionAbilityId, SpellAwakeningOfTheForest.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellCrowForm.classSelectionAbilityId, SpellCrowForm.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDryadSource.classSelectionAbilityId, SpellDryadSource.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBearForm.classSelectionAbilityId, SpellBearForm.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellForestFaeriesSpell.classSelectionAbilityId, SpellForestFaeriesSpell.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellHerbalCure.classSelectionAbilityId, SpellHerbalCure.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRelief.classSelectionAbilityId, SpellRelief.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellZoology.classSelectionAbilityId, SpellZoology.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellGrove.classSelectionAbilityId, SpellGrove.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTreefolk.classSelectionAbilityId, SpellTreefolk.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellForestWoodFists.classSelectionAbilityId, SpellForestWoodFists.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTendrils.classSelectionAbilityId, SpellTendrils.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellWrathOfTheForest.classSelectionAbilityId, SpellWrathOfTheForest.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellForestCastle.classSelectionAbilityId, SpellForestCastle.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAlpha.classSelectionAbilityId, SpellAlpha.classSelectionGrimoireAbilityId))
		endmethod

		private static method initKnight takes nothing returns nothing
			set thistype.m_knight = AClass.create('H006', "spell", "Sound\\Units\\ClassKnight\\Class.wav")
			call thistype.m_knight.setStrPerLevel(2.0)
			call thistype.m_knight.setAgiPerLevel(2.0)
			call thistype.m_knight.setIntPerLevel(2.0)
			call thistype.m_knight.addDescriptionLine(tr("Der Ritter ist ein starker Kämpfer, der an vorderster Front steht und eine dicke Rüstung trägt,"))
			call thistype.m_knight.addDescriptionLine(tr("die ihn besonders überlebensfähig macht."))
			call thistype.m_knight.addDescriptionLine(tr("Er sorgt dafür, dass seine Feinde die weniger gut geschützten Nah- und Fernkämpfer nicht erreichen."))
			call thistype.m_knight.addDescriptionLine(tr("Durch seine kämpferische Ausstrahlung ist er in der Lage, die Moral und Kampfkraft"))
			call thistype.m_knight.addDescriptionLine(tr("seiner Gefährten zu steigern."))
			
			set thistype.m_knightGrimoireEntries = AIntegerVector.create()
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlock.classSelectionAbilityId, SpellBlock.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellConcentration.classSelectionAbilityId, SpellConcentration.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLivingWill.classSelectionAbilityId, SpellLivingWill.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellResolution.classSelectionAbilityId, SpellResolution.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRigidity.classSelectionAbilityId, SpellRigidity.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRush.classSelectionAbilityId, SpellRush.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSelflessness.classSelectionAbilityId, SpellSelflessness.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellStab.classSelectionAbilityId, SpellStab.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTaunt.classSelectionAbilityId, SpellTaunt.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfRedemption.classSelectionAbilityId, SpellAuraOfRedemption.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfAuthority.classSelectionAbilityId, SpellAuraOfAuthority.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfIronSkin.classSelectionAbilityId, SpellAuraOfIronSkin.classSelectionGrimoireAbilityId))
		endmethod

		private static method initDragonSlayer takes nothing returns nothing
			set thistype.m_dragonSlayer = AClass.create('H007', "spell", "Sound\\Units\\ClassDragonSlayer\\Class.wav")
			call thistype.m_dragonSlayer.setStrPerLevel(3.0)
			call thistype.m_dragonSlayer.setAgiPerLevel(1.90)
			call thistype.m_dragonSlayer.setIntPerLevel(1.10)
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Die meisten Drachentöter haben zwar noch nicht einmal einen Drachen zu Gesicht bekommen,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("sind aber dennoch äußerst ernstzunehmende Gegner."))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Sie agieren sehr offensiv und achten nicht besonders auf ihre Verteidigung,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("weshalb sie die Anwesenheit eines Ritters häufig nutzen, jedoch nicht schätzen."))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("Drachentöter beherrschen den Umgang mit ihren Waffen ausgezeichnet und sind in der Lage,"))
			call thistype.m_dragonSlayer.addDescriptionLine(tr("enorm schnell eine ganze Reihe von Gegnern abzuschlachten."))
			
			set thistype.m_dragonSlayerGrimoireEntries = AIntegerVector.create()
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBeastHunter.classSelectionAbilityId, SpellBeastHunter.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDaunt.classSelectionAbilityId, SpellDaunt.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFuriousBloodthirstiness.classSelectionAbilityId, SpellFuriousBloodthirstiness.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSlash.classSelectionAbilityId, SpellSlash.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSupremacy.classSelectionAbilityId, SpellSupremacy.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellWeakPoint.classSelectionAbilityId, SpellWeakPoint.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellColossus.classSelectionAbilityId, SpellColossus.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRaid.classSelectionAbilityId, SpellRaid.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRob.classSelectionAbilityId, SpellRob.classSelectionGrimoireAbilityId))
		endmethod

		private static method initRanger takes nothing returns nothing
			set thistype.m_ranger = AClass.create('H008', "spell", "Sound\\Units\\ClassRanger\\Class.wav")
			call thistype.m_ranger.setStrPerLevel(1.80)
			call thistype.m_ranger.setAgiPerLevel(3.0)
			call thistype.m_ranger.setIntPerLevel(1.20)
			call thistype.m_ranger.addDescriptionLine(tr("Waldläufer sind Bogenschützen, die aus der Ferne agieren und von dort ihren Gegnern Schaden zufügen."))
			call thistype.m_ranger.addDescriptionLine(tr("Mit Hilfe von unterschiedlichen Pfeilarten schwächen und verlangsamen sie ihre Ziele."))
			call thistype.m_ranger.addDescriptionLine(tr("Im Nahkampf haben sie ihren Widersachern jedoch häufig nicht viel entgegenzusetzen,"))
			call thistype.m_ranger.addDescriptionLine(tr("weshalb sie sich auf ihre Distanz zum Gegner verlassen und ihre Agilität verbessern,"))
			call thistype.m_ranger.addDescriptionLine(tr("um schnell auf Abstand kommen zu können."))
			
			set thistype.m_rangerGrimoireEntries = AIntegerVector.create()
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAgility.classSelectionAbilityId, SpellAgility.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEagleEye.classSelectionAbilityId, SpellEagleEye.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellHailOfArrows.classSelectionAbilityId, SpellHailOfArrows.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLieInWait.classSelectionAbilityId, SpellLieInWait.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellShooter.classSelectionAbilityId, SpellShooter.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellShotIntoHeart.classSelectionAbilityId, SpellShotIntoHeart.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSprint.classSelectionAbilityId, SpellSprint.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPoisonedArrows.classSelectionAbilityId, SpellPoisonedArrows.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBurningArrows.classSelectionAbilityId, SpellBurningArrows.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFrozenArrows.classSelectionAbilityId, SpellFrozenArrows.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMultiShot.classSelectionAbilityId, SpellMultiShot.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTrap.classSelectionAbilityId, SpellTrap.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellKennels.classSelectionAbilityId, SpellKennels.classSelectionGrimoireAbilityId))
		endmethod

		private static method initElementalMage takes nothing returns nothing
			set thistype.m_elementalMage = AClass.create('H009', "spell", "Sound\\Units\\ClassElementalMage\\Class.wav")
			call thistype.m_elementalMage.setStrPerLevel(1.50)
			call thistype.m_elementalMage.setAgiPerLevel(1.50)
			call thistype.m_elementalMage.setIntPerLevel(3.0)
			call thistype.m_elementalMage.addDescriptionLine(tr("Elementarmagier sind trotz ihres häufig gebrechlich anmutenden Äußeren erbarmungslose Widersacher,"))
			call thistype.m_elementalMage.addDescriptionLine(tr("die ihre Gegner mit den Kräften der vier Elemente Feuer, Wasser, Luft und Erde vernichten."))
			call thistype.m_elementalMage.addDescriptionLine(tr("Ihre Stärke zeigt sich besonders gegen mehrere Gegner,"))
			call thistype.m_elementalMage.addDescriptionLine(tr("wenn sie die Erde unter den Füßen dieser in Flammen aufgehen oder mit einer Welle"))
			call thistype.m_elementalMage.addDescriptionLine(tr("aus tiefstem Eis die Umwelt erschüttern lassen."))
			
			set thistype.m_elementalMageGrimoireEntries = AIntegerVector.create()
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlaze.classSelectionAbilityId, SpellBlaze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEarthPrison.classSelectionAbilityId, SpellEarthPrison.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellElementalForce.classSelectionAbilityId, SpellElementalForce.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEmblaze.classSelectionAbilityId, SpellEmblaze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFireMissile.classSelectionAbilityId, SpellFireMissile.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFreeze.classSelectionAbilityId, SpellFreeze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellGlisteningLight.classSelectionAbilityId, SpellGlisteningLight.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellIceMissile.classSelectionAbilityId, SpellIceMissile.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellInferno.classSelectionAbilityId, SpellInferno.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLightning.classSelectionAbilityId, SpellLightning.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMastery.classSelectionAbilityId, SpellMastery.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRageOfElements.classSelectionAbilityId, SpellRageOfElements.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPureEnergy.classSelectionAbilityId, SpellPureEnergy.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTeleportation.classSelectionAbilityId, SpellTeleportation.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellUndermine.classSelectionAbilityId, SpellUndermine.classSelectionGrimoireAbilityId))
		endmethod

		private static method initWizard takes nothing returns nothing
			set thistype.m_wizard = AClass.create('H002', "spell", "Sound\\Units\\ClassWizard\\Class.wav")
			call thistype.m_wizard.setStrPerLevel(1.50)
			call thistype.m_wizard.setAgiPerLevel(1.50)
			call thistype.m_wizard.setIntPerLevel(3.0)
			call thistype.m_wizard.addDescriptionLine(tr("Der Zauberer kontrolliert im Gegensatz zum Elementarmagier"))
			call thistype.m_wizard.addDescriptionLine(tr("nicht die Gewalt der Elemente, sondern das feine Gefüge des Arkanen."))
			call thistype.m_wizard.addDescriptionLine(tr("Er kann seinen Gegnern ihre magische Kraft entziehen und auf sich selbst"))
			call thistype.m_wizard.addDescriptionLine(tr("oder Verbündete übertragen, Zauber auf ihre Urheber zurücklenken oder sie sogar absorbieren,"))
			call thistype.m_wizard.addDescriptionLine(tr("ohne selbst verletzt zu werden."))
			
			set thistype.m_wizardGrimoireEntries = AIntegerVector.create()
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAbsorbation.classSelectionAbilityId, SpellAbsorbation.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneHunger.classSelectionAbilityId, SpellArcaneHunger.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneProtection.classSelectionAbilityId, SpellArcaneProtection.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneRuse.classSelectionAbilityId, SpellArcaneRuse.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneTime.classSelectionAbilityId, SpellArcaneTime.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBan.classSelectionAbilityId, SpellBan.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellControlledTimeFlow.classSelectionAbilityId, SpellControlledTimeFlow.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellCurb.classSelectionAbilityId, SpellCurb.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFeedBack.classSelectionAbilityId, SpellFeedBack.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMagicalShockWaves.classSelectionAbilityId, SpellMagicalShockWaves.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaExplosion.classSelectionAbilityId, SpellManaExplosion.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaShield.classSelectionAbilityId, SpellManaShield.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaStream.classSelectionAbilityId, SpellManaStream.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMultiply.classSelectionAbilityId, SpellMultiply.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTransfer.classSelectionAbilityId, SpellTransfer.classSelectionGrimoireAbilityId))
			debug call Print("Size of wizard grimoire entries " + I2S(thistype.m_wizardGrimoireEntries.size()))
		endmethod

		public static method init takes nothing returns nothing
			call thistype.initCleric()
			call thistype.initNecromancer()
			call thistype.initDruid()
			call thistype.initKnight()
			call thistype.initDragonSlayer()
			call thistype.initRanger()
			call thistype.initElementalMage()
			call thistype.initWizard()
			/*
			 * Decreases the lag when changing to classes for the first time.
			 * This might take many many abilities, so start with a new OpLimit.
			 */
			call ForForce(bj_FORCE_PLAYER[0], function thistype.preloadAbilities)
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

		public static method wizard takes nothing returns AClass
			return thistype.m_wizard
		endmethod

		public static method className takes AClass class returns string
			if (class == Classes.cleric()) then
				return tre("Kleriker", "Cleric")
			elseif (class == Classes.necromancer()) then
				return tre("Nekromant", "Necromancer")
			elseif (class == Classes.druid()) then
				return tre("Druide", "Druid")
			elseif (class == Classes.knight()) then
				return tre("Ritter", "Knight")
			elseif (class == Classes.dragonSlayer()) then
				return tre("Drachentöter", "Dragon Slayer")
			elseif (class == Classes.ranger()) then
				return tre("Waldläufer", "Ranger")
			elseif (class == Classes.elementalMage()) then
				return tre("Elementarmagier", "Elemental Mage")
			elseif (class == Classes.wizard()) then
				return tre("Zauberer", "Wizard")
			endif

			return tre("Unbekannt", "Unknown")
		endmethod

		public static method isChaplain takes AClass class returns boolean
			return class == thistype.cleric() or class == thistype.necromancer() or class == thistype.druid()
		endmethod

		public static method isWarrior takes AClass class returns boolean
			return class == thistype.knight() or class == thistype.dragonSlayer() or class == thistype.ranger()
		endmethod

		public static method isMage takes AClass class returns boolean
			return class == thistype.elementalMage() or class == thistype.wizard()
		endmethod
		
		public static method classMeleeAbilityId takes AClass class returns integer
			if (class == thistype.cleric()) then
				debug call Print("Cleric")
				return 'A0C2'
			elseif (class == thistype.necromancer()) then
				debug call Print("Necromancer")
				return 'A0V5'
			elseif (class == thistype.druid()) then
				debug call Print("Druid")
				return 'A0V6'
			elseif (class == thistype.knight()) then
				debug call Print("Knight")
				return 'A0V7'
			elseif (class == thistype.dragonSlayer()) then
				debug call Print("Dragon Slayer")
				return 'A0V8'
			elseif (class == thistype.ranger()) then
				debug call Print("Ranger")
				return 'A0V9'
			elseif (class == thistype.elementalMage()) then
				debug call Print("Elemental Mage")
				return 'A0VA'
			elseif (class == thistype.wizard()) then
				debug call Print("Wizard")
				return 'A0VB'
			endif
			return 0
		endmethod
		
		public static method classRangeAbilityId takes AClass class returns integer
			if (class == thistype.cleric()) then
				debug call Print("Cleric")
				return 'A0C1'
			elseif (class == thistype.necromancer()) then
				debug call Print("Necromancer")
				return 'A0VC'
			elseif (class == thistype.druid()) then
				debug call Print("Druid")
				return 'A0VD'
			elseif (class == thistype.knight()) then
				debug call Print("Knight")
				return 'A0VE'
			elseif (class == thistype.dragonSlayer()) then
				debug call Print("Dragon Slayer")
				return 'A0VF'
			elseif (class == thistype.ranger()) then
				debug call Print("Ranger")
				return 'A0VG'
			elseif (class == thistype.elementalMage()) then
				debug call Print("Elemental Mage")
				return 'A0VH'
			elseif (class == thistype.wizard()) then
				debug call Print("Wizard")
				return 'A0VI'
			endif
			return 0
		endmethod
	endstruct

endlibrary