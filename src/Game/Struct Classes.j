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

			call AbilityPreload('A0AB')
			call AbilityPreload('A0AX')
			call AbilityPreload('A0AA')
			call AbilityPreload('A0AY')
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

		private static method preloadAbilities takes nothing returns nothing
			// use new OpLimit everytime
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_clericGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_necromancerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_druidGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_knightGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_dragonSlayerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_rangerGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_elementalMageGrimoireEntries)
			call thistype.preloadAbilitiesFromVector.evaluate(thistype.m_wizardGrimoireEntries)
		endmethod

		private static method preloadAbilitiesFromVector takes AIntegerVector vector returns nothing
			local ClassGrimoireEntry classGrimoireEntry = 0
			local integer i = 0
			loop
				exitwhen (i == vector.size())
				set classGrimoireEntry = ClassGrimoireEntry(vector[i])
				debug call Print("Preloading " + GetAbilityName(classGrimoireEntry.abilityId()))
				call AbilityPreload(classGrimoireEntry.abilityId())
				debug call Print("After preloading 1")
				call AbilityPreload(classGrimoireEntry.grimoireAbilityId())
				debug call Print("After preloading 2")
				set i = i + 1
			endloop
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
			set thistype.m_cleric = AClass.create('H000', "spell", "Sound\\Units\\ClassCleric\\Class.wav", 1, 1)
			call thistype.m_cleric.setStrPerLevel(1.50)
			call thistype.m_cleric.setAgiPerLevel(1.50)
			call thistype.m_cleric.setIntPerLevel(3.0)
			call thistype.m_cleric.addDescriptionLine(tre("Kleriker sind meist gottesfürchtige Menschen,", "Clerics are mostly God-fearing humans"))
			call thistype.m_cleric.addDescriptionLine(tre("welche die Gabe der Heilung und des Schutzes erhalten haben. Diese nutzen sie,", "who got the gift of healing and protection. They use it"))
			call thistype.m_cleric.addDescriptionLine(tre("um ihre Verbündeten genesen zu lassen, sie vor Schaden zu schützen", "to let their allies recover, to protect them from damage"))
			call thistype.m_cleric.addDescriptionLine(tre("und sie von dunkler Magie zu befreien.", "and to free them from dark magic."))
			call thistype.m_cleric.addDescriptionLine(tre("Ihre offensiven Fähigkeiten sind jedoch stark eingeschränkt", "However, their offensive abilities are very limited"))
			call thistype.m_cleric.addDescriptionLine(tre("und alleine sind sie häufig nicht in der Lage, mächtige Feinde", "and they are not capable of defeating"))
			call thistype.m_cleric.addDescriptionLine(tre("zu bezwingen.", "powerful enemies on their own."))

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

			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_clericGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initNecromancer takes nothing returns nothing
			set thistype.m_necromancer = AClass.create('H004', "spell", "Sound\\Units\\ClassNecromancer\\Class.wav", 1, 1)
			call thistype.m_necromancer.setStrPerLevel(1.50)
			call thistype.m_necromancer.setAgiPerLevel(1.50)
			call thistype.m_necromancer.setIntPerLevel(3.0)
			call thistype.m_necromancer.addDescriptionLine(tre("Nekromanten sind die Gegenstücke zu Klerikern: zwar sind auch sie häufig gottesfürchtig,", "Necromancers are the counterparts of clerics: Although they are also often God-fearing,"))
			call thistype.m_necromancer.addDescriptionLine(tre("jedoch verehren sie andere Götter als der Großteil der Menschen.", "they worship other gods than the majority of people."))
			call thistype.m_necromancer.addDescriptionLine(tre("Durch eine harte Ausbildung und finsteren Studien sind sie schließlich in der Lage,", "Through hard training and sinister studies they are finally able"))
			call thistype.m_necromancer.addDescriptionLine(tre("die schwärzeste Magie zu beherrschen.", "to dominate the blackest magic."))
			call thistype.m_necromancer.addDescriptionLine(tre("Mit ihrer Hilfe fügen sie ihren Opfern langsam Schmerzen zu und beschwören Kreaturen", "With its help they deal slowly pain to their victims and summon creatures"))
			call thistype.m_necromancer.addDescriptionLine(tre("aus den Tiefen der Unterwelt, die sie für sich kämpfen lassen.", "from the depths of the underworld which they let fight for them." ))
			call thistype.m_necromancer.addDescriptionLine(tre("Doch eines sollte nicht vergessen werden: Auch wenn die Magie selbst eine dunkle ist,", "But one thing should not be forgotten: Although the magic itself is a dark one"))
			call thistype.m_necromancer.addDescriptionLine(tre("so muss sie nicht zwangsläufig einem bösen Zweck dienen. Es liegt in jedermanns eigener Hand,", "it has not necessarily to serve an evil purpose. It is in everyone's own hand"))
			call thistype.m_necromancer.addDescriptionLine(tre("zu entscheiden, wofür sie genutzt wird.", "to decide what it is used for."))

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
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDamnedGround.classSelectionAbilityId, SpellDamnedGround.classSelectionGrimoireAbilityId))

			// ultimates on page 2
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDamnation.classSelectionAbilityId, SpellDamnation.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEpidemic.classSelectionAbilityId, SpellEpidemic.classSelectionGrimoireAbilityId))

			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_necromancerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initDruid takes nothing returns nothing
			set thistype.m_druid = AClass.create('H00G', "spell", "Sound\\Units\\ClassDruid\\Class.wav", 1, 1)
			call thistype.m_druid.setStrPerLevel(1.50)
			call thistype.m_druid.setAgiPerLevel(1.50)
			call thistype.m_druid.setIntPerLevel(3.0)
			call thistype.m_druid.addDescriptionLine(tre("Druiden sind naturverbundene, ruhige Wanderer, die in Einklang mit ihrer Umwelt leben.", "Druids are nature-loving, quiet hikers who live in harmony with their environment."))
			call thistype.m_druid.addDescriptionLine(tre("Sie sind stets darauf bedacht,", "They are always eager"))
			call thistype.m_druid.addDescriptionLine(tre("alles im Gleichgewicht zu halten und ziehen von Ort zu Ort,", "to keep everything in balance and move from place to place"))
			call thistype.m_druid.addDescriptionLine(tre("um anderen ihre Heil-  und Zauberkünste anzubieten. Ihre jahrelangen Studien der Tiere", "to offer their healing and magical crafts to others. Their years of studying animals"))
			call thistype.m_druid.addDescriptionLine(tre("haben ihnen die Fähigkeit verliehen, die Gestalt dieser anzunehmen oder sie als", "have given them the ability to take the form of the animals or"))
			call thistype.m_druid.addDescriptionLine(tre("unterstützende Gefährten herbeizurufen.", "to summon them as supporting fellows."))

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

			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_druidGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initKnight takes nothing returns nothing
			set thistype.m_knight = AClass.create('H006', "spell", "Sound\\Units\\ClassKnight\\Class.wav", 1, 1)
			call thistype.m_knight.setStrPerLevel(3.0)
			call thistype.m_knight.setAgiPerLevel(1.5)
			call thistype.m_knight.setIntPerLevel(1.5)
			call thistype.m_knight.addDescriptionLine(tre("Der Ritter ist ein starker Kämpfer, der an vorderster Front steht und eine dicke Rüstung trägt,", "The knight is a strong warrior who stands at the forefront and wears a thick armour"))
			call thistype.m_knight.addDescriptionLine(tre("die ihn besonders überlebensfähig macht.", "which makes him particularly viable."))
			call thistype.m_knight.addDescriptionLine(tre("Er sorgt dafür, dass seine Feinde die weniger gut geschützten Nah- und Fernkämpfer nicht erreichen.", "He makes sure that his enemies do not reach the less well-protected melee and range fighters."))
			call thistype.m_knight.addDescriptionLine(tre("Durch seine kämpferische Ausstrahlung ist er in der Lage, die Moral und Kampfkraft", "Through his combative charisma he is able"))
			call thistype.m_knight.addDescriptionLine(tre("seiner Gefährten zu steigern.", "to push the morale and fighting power of his fellows."))

			set thistype.m_knightGrimoireEntries = AIntegerVector.create()
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlock.classSelectionAbilityId, SpellBlock.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellConcentration.classSelectionAbilityId, SpellConcentration.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPowerOfShrines.classSelectionAbilityId, SpellPowerOfShrines.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellResolution.classSelectionAbilityId, SpellResolution.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRush.classSelectionAbilityId, SpellRush.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSelflessness.classSelectionAbilityId, SpellSelflessness.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellStab.classSelectionAbilityId, SpellStab.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTaunt.classSelectionAbilityId, SpellTaunt.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfRedemption.classSelectionAbilityId, SpellAuraOfRedemption.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfAuthority.classSelectionAbilityId, SpellAuraOfAuthority.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAuraOfIronSkin.classSelectionAbilityId, SpellAuraOfIronSkin.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellConquest.classSelectionAbilityId, SpellConquest.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDefend.classSelectionAbilityId, SpellDefend.classSelectionGrimoireAbilityId))
			// ultimates on page 2
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLivingWill.classSelectionAbilityId, SpellLivingWill.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRigidity.classSelectionAbilityId, SpellRigidity.classSelectionGrimoireAbilityId))

			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_knightGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initDragonSlayer takes nothing returns nothing
			set thistype.m_dragonSlayer = AClass.create('H007', "spell", "Sound\\Units\\ClassDragonSlayer\\Class.wav", 1, 1)
			call thistype.m_dragonSlayer.setStrPerLevel(3.0)
			call thistype.m_dragonSlayer.setAgiPerLevel(1.90)
			call thistype.m_dragonSlayer.setIntPerLevel(1.10)
			call thistype.m_dragonSlayer.addDescriptionLine(tre("Die meisten Drachentöter haben zwar noch nicht einmal einen Drachen zu Gesicht bekommen,", "Most dragon slayers have still not even get a dragon to face"))
			call thistype.m_dragonSlayer.addDescriptionLine(tre("sind aber dennoch äußerst ernstzunehmende Gegner.", "but they are still extremely serious opponents."))
			call thistype.m_dragonSlayer.addDescriptionLine(tre("Sie agieren sehr offensiv und achten nicht besonders auf ihre Verteidigung,", "They act very aggressively and do not pay particular attention to their defense"))
			call thistype.m_dragonSlayer.addDescriptionLine(tre("weshalb sie die Anwesenheit eines Ritters häufig nutzen, jedoch nicht schätzen.", "which is why they use the presence of a knight often but do not appreciate it."))
			call thistype.m_dragonSlayer.addDescriptionLine(tre("Drachentöter beherrschen den Umgang mit ihren Waffen ausgezeichnet und sind in der Lage,", "Dragon slayers know how to user their weapons excellent and are able"))
			call thistype.m_dragonSlayer.addDescriptionLine(tre("sehr schnell eine ganze Reihe von Gegnern abzuschlachten.", "to slaughter a number of opponents very quickly."))

			set thistype.m_dragonSlayerGrimoireEntries = AIntegerVector.create()
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBeastHunter.classSelectionAbilityId, SpellBeastHunter.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellDaunt.classSelectionAbilityId, SpellDaunt.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSlash.classSelectionAbilityId, SpellSlash.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellSupremacy.classSelectionAbilityId, SpellSupremacy.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellWeakPoint.classSelectionAbilityId, SpellWeakPoint.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellColossus.classSelectionAbilityId, SpellColossus.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRaid.classSelectionAbilityId, SpellRaid.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRob.classSelectionAbilityId, SpellRob.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMercilessness.classSelectionAbilityId, SpellMercilessness.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRage.classSelectionAbilityId, SpellRage.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellReserves.classSelectionAbilityId, SpellReserves.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAnEyeForAnEye.classSelectionAbilityId, SpellAnEyeForAnEye.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellJumpAttackDragonSlayer.classSelectionAbilityId, SpellJumpAttackDragonSlayer.classSelectionGrimoireAbilityId))
			// ultimates on page 2
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellThrillOfVictory.classSelectionAbilityId, SpellThrillOfVictory.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFuriousBloodthirstiness.classSelectionAbilityId, SpellFuriousBloodthirstiness.classSelectionGrimoireAbilityId))

			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_dragonSlayerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initRanger takes nothing returns nothing
			set thistype.m_ranger = AClass.create('H008', "spell", "Sound\\Units\\ClassRanger\\Class.wav", 1, 1)
			call thistype.m_ranger.setStrPerLevel(1.80)
			call thistype.m_ranger.setAgiPerLevel(3.0)
			call thistype.m_ranger.setIntPerLevel(1.20)
			call thistype.m_ranger.addDescriptionLine(tre("Waldläufer sind Bogenschützen, die aus der Ferne agieren und von dort ihren Gegnern Schaden zufügen.", "Rangers are archers who act from a distance and who inflict damage to their opponents from there."))
			call thistype.m_ranger.addDescriptionLine(tre("Mit Hilfe von unterschiedlichen Pfeilarten schwächen und verlangsamen sie ihre Ziele.", "With the help of different kinds of arrows they weaken and slow down their targets."))
			call thistype.m_ranger.addDescriptionLine(tre("Im Nahkampf haben sie ihren Widersachern jedoch häufig nicht viel entgegenzusetzen,", "However, in melee they have not much to oppose their opponents mostly"))
			call thistype.m_ranger.addDescriptionLine(tre("weshalb sie sich auf ihre Distanz zum Gegner verlassen und ihre Agilität verbessern,", "which is why they rely on their distance to the opponent and improve their agility"))
			call thistype.m_ranger.addDescriptionLine(tre("um schnell auf Abstand kommen zu können.", "to be able to come to distance quickly."))

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
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTrap.classSelectionAbilityId, SpellTrap.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellKennels.classSelectionAbilityId, SpellKennels.classSelectionGrimoireAbilityId))
			// ultimates on page 2
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLeprechaun.classSelectionAbilityId, SpellLeprechaun.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMultiShot.classSelectionAbilityId, SpellMultiShot.classSelectionGrimoireAbilityId))

			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_rangerGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initElementalMage takes nothing returns nothing
			set thistype.m_elementalMage = AClass.create('H009', "spell", "Sound\\Units\\ClassElementalMage\\Class.wav", 1, 1)
			call thistype.m_elementalMage.setStrPerLevel(1.50)
			call thistype.m_elementalMage.setAgiPerLevel(1.50)
			call thistype.m_elementalMage.setIntPerLevel(3.0)
			call thistype.m_elementalMage.addDescriptionLine(tre("Elementarmagier sind trotz ihres häufig gebrechlich anmutenden Äußeren erbarmungslose Widersacher,", "Elemental mages are merciless adversaries despite their often frail-looking outward appearance"))
			call thistype.m_elementalMage.addDescriptionLine(tre("die ihre Gegner mit den Kräften der vier Elemente Feuer, Wasser, Luft und Erde vernichten.", "who destroy their opponents with the forces of the four elements fire, water, air and earth."))
			call thistype.m_elementalMage.addDescriptionLine(tre("Ihre Stärke zeigt sich besonders gegen mehrere Gegner,", "Their strength especially shows against multiple opponents"))
			call thistype.m_elementalMage.addDescriptionLine(tre("wenn sie die Erde unter den Füßen dieser in Flammen aufgehen oder mit einer Welle", "if they set the ground underneath their opponents on fire or"))
			call thistype.m_elementalMage.addDescriptionLine(tre("aus Eis die Umwelt erschüttern lassen.",  "let shake the environment with a wave of ice."))

			set thistype.m_elementalMageGrimoireEntries = AIntegerVector.create()
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBlaze.classSelectionAbilityId, SpellBlaze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellElementalCreatures.classSelectionAbilityId, SpellElementalCreatures.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEarthPrison.classSelectionAbilityId, SpellEarthPrison.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellEmblaze.classSelectionAbilityId, SpellEmblaze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFireMissile.classSelectionAbilityId, SpellFireMissile.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFreeze.classSelectionAbilityId, SpellFreeze.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellIceMissile.classSelectionAbilityId, SpellIceMissile.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellInferno.classSelectionAbilityId, SpellInferno.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellLightning.classSelectionAbilityId, SpellLightning.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMastery.classSelectionAbilityId, SpellMastery.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRageOfElements.classSelectionAbilityId, SpellRageOfElements.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTeleportation.classSelectionAbilityId, SpellTeleportation.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellUndermine.classSelectionAbilityId, SpellUndermine.classSelectionGrimoireAbilityId))
			// ultimates on page 2
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellElementalForce.classSelectionAbilityId, SpellElementalForce.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellPureEnergy.classSelectionAbilityId, SpellPureEnergy.classSelectionGrimoireAbilityId))

			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_elementalMageGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
		endmethod

		private static method initWizard takes nothing returns nothing
			set thistype.m_wizard = AClass.create('H002', "spell", "Sound\\Units\\ClassWizard\\Class.wav", 1, 1)
			call thistype.m_wizard.setStrPerLevel(1.50)
			call thistype.m_wizard.setAgiPerLevel(1.50)
			call thistype.m_wizard.setIntPerLevel(3.0)
			call thistype.m_wizard.addDescriptionLine(tre("Der Zauberer kontrolliert im Gegensatz zum Elementarmagier", "The wizard does not control unlike the elemental mage"))
			call thistype.m_wizard.addDescriptionLine(tre("nicht die Gewalt der Elemente, sondern das feine Gefüge des Arkanen.", "the force of the elements but the fine structure of the arcane."))
			call thistype.m_wizard.addDescriptionLine(tre("Er kann seinen Gegnern ihre magische Kraft entziehen und auf sich selbst", "He can withdraw the magical power from his opponents and transfer it to"))
			call thistype.m_wizard.addDescriptionLine(tre("oder Verbündete übertragen, Zauber auf ihre Urheber zurücklenken oder sie sogar absorbieren,", "himself or his allies, retrace spells to their caster or even absorb them"))
			call thistype.m_wizard.addDescriptionLine(tre("ohne selbst verletzt zu werden.", "without being hurt himself."))

			set thistype.m_wizardGrimoireEntries = AIntegerVector.create()
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneHunger.classSelectionAbilityId, SpellArcaneHunger.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneProtection.classSelectionAbilityId, SpellArcaneProtection.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneRuse.classSelectionAbilityId, SpellArcaneRuse.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellArcaneTime.classSelectionAbilityId, SpellArcaneTime.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellBan.classSelectionAbilityId, SpellBan.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellCurb.classSelectionAbilityId, SpellCurb.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellFeedBack.classSelectionAbilityId, SpellFeedBack.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMagicalShockWaves.classSelectionAbilityId, SpellMagicalShockWaves.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaExplosion.classSelectionAbilityId, SpellManaExplosion.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaShield.classSelectionAbilityId, SpellManaShield.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellManaStream.classSelectionAbilityId, SpellManaStream.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellMultiply.classSelectionAbilityId, SpellMultiply.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellTransfer.classSelectionAbilityId, SpellTransfer.classSelectionGrimoireAbilityId))
			// ultimates on page 2
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAbsorbation.classSelectionAbilityId, SpellAbsorbation.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellControlledTimeFlow.classSelectionAbilityId, SpellControlledTimeFlow.classSelectionGrimoireAbilityId))

			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellAttributeBonus.classSelectionAbilityId, SpellAttributeBonus.classSelectionGrimoireAbilityId))
			call thistype.m_wizardGrimoireEntries.pushBack(ClassGrimoireEntry.create(SpellRideHorse.classSelectionAbilityId, SpellRideHorse.classSelectionGrimoireAbilityId))
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
			call NewOpLimit(function thistype.preloadAbilities)
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

		public static method classRangeAbilityIdByCharacter takes Character character returns integer
			// dragon slayer on sheep
			if (GetUnitTypeId(character.unit()) == 'H01J') then
				return 'A16I'
			// cleric on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01L') then
				return 'A16J'
			// necromancer on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01N') then
				return 'A16K'
			// druid on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01P') then
				return 'A16L'
			// knight on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01R') then
				return 'A16M'
			// ranger on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01T') then
				return 'A16N'
			// elemental mage on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01V') then
				return 'A16O'
			// wizard on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01X') then
				return 'A16P'
			// dragon slayer on horse
			elseif (GetUnitTypeId(character.unit()) == 'H02W') then
				return 'A1T9'
			// druid on horse
			elseif (GetUnitTypeId(character.unit()) == 'H02Z') then
				return 'A1TA'
			// elemental mage on horse
			elseif (GetUnitTypeId(character.unit()) == 'H031') then
				return 'A1TB'
			// cleric on horse
			elseif (GetUnitTypeId(character.unit()) == 'H033') then
				return 'A1TC'
			// necromancer on horse
			elseif (GetUnitTypeId(character.unit()) == 'H035') then
				return 'A1TD'
			// knight on horse
			elseif (GetUnitTypeId(character.unit()) == 'H037') then
				return 'A1TE'
			// ranger on horse
			elseif (GetUnitTypeId(character.unit()) == 'H039') then
				return 'A1TF'
			// wizard on horse
			elseif (GetUnitTypeId(character.unit()) == 'H03B') then
				return 'A1TG'
			endif
			return Classes.classRangeAbilityId(character.class())
		endmethod

		public static method classMeleeAbilityIdByCharacter takes Character character returns integer
			// dragon slayer on sheep
			if (GetUnitTypeId(character.unit()) == 'H01K') then
				return 'A16H'
			// cleric on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01M') then
				return 'A16S'
			// necromancer on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01O') then
				return 'A16T'
			// druid on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01Q') then
				return 'A16Q'
			// knight on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01S') then
				return 'A16U'
			// ranger on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01U') then
				return 'A16V'
			// elemental mage on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01W') then
				return 'A16R'
			// wizard on sheep
			elseif (GetUnitTypeId(character.unit()) == 'H01Y') then
				return 'A16W'
			// dragon slayer on horse
			elseif (GetUnitTypeId(character.unit()) == 'H02X') then
				return 'A1T1'
			// druid on horse
			elseif (GetUnitTypeId(character.unit()) == 'H030') then
				return 'A1T2'
			// elemental mage on horse
			elseif (GetUnitTypeId(character.unit()) == 'H032') then
				return 'A1T3'
			// cleric on horse
			elseif (GetUnitTypeId(character.unit()) == 'H034') then
				return 'A1T4'
			// necromancer on horse
			elseif (GetUnitTypeId(character.unit()) == 'H036') then
				return 'A1T5'
			// knight on horse
			elseif (GetUnitTypeId(character.unit()) == 'H038') then
				return 'A1T6'
			// ranger on horse
			elseif (GetUnitTypeId(character.unit()) == 'H03A') then
				return 'A1T7'
			// wizard on horse
			elseif (GetUnitTypeId(character.unit()) == 'H03C') then
				return 'A1T8'
			endif
			return Classes.classMeleeAbilityId(character.class())
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createDefaultClassSelectionItems takes AClass class, unit whichUnit returns nothing
			if (class == Classes.ranger()) then
				// Hunting Bow
				call UnitAddItemToSlotById(whichUnit, 'I020', 2)
			elseif (class == Classes.cleric() or class == Classes.necromancer() or class == Classes.elementalMage() or class == Classes.wizard()) then
				// Haunted Staff
				call UnitAddItemToSlotById(whichUnit, 'I03V', 2)
			else
				call UnitAddItemToSlotById(whichUnit, 'I01Y', 2)
				call UnitAddItemToSlotById(whichUnit, 'I00N', 3)
			endif
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call UnitAddItemToSlotById(whichUnit, 'I01N', 0)
			call UnitAddItemToSlotById(whichUnit, 'I061', 1)

			call UnitAddItemToSlotById(whichUnit, 'I00A', 4)
			call UnitAddItemToSlotById(whichUnit, 'I00D', 5)
		endmethod

		/**
		 * Creates the starting items for the \p character depending on the character's class.
		 */
		public static method createDefaultClassItems takes Character character returns nothing
			local integer i = 0
			if (character.class() == Classes.ranger()) then
				// Hunting Bow
				call character.giveItem('I020')
			elseif (character.class() == Classes.cleric() or character.class() == Classes.necromancer() or character.class() == Classes.elementalMage() or character.class() == Classes.wizard()) then
				// Haunted Staff
				call character.giveItem('I03V')
			else
				call character.giveItem('I01Y')
				call character.giveItem('I00N')
			endif

			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call character.giveItem('I01N')
			call character.giveQuestItem('I061')

			set i = 0
			loop
				exitwhen (i == 10)
				call character.giveItem('I00A')
				call character.giveItem('I00D')
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary