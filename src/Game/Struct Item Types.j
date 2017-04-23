library StructGameItemTypes requires Asl, StructGameClasses, StructGameCharacter, StructGameGrimoire

	/**
	 * \brief Default item type struct for all item types in The Power of Fire.
	 */
	struct ItemType extends ACharacterItemType
		private static AIntegerVector m_twoSlotItems

		public static method itemTypeIdRequiresTwoSlots takes integer itemTypeId returns boolean
			return thistype.m_twoSlotItems.contains(itemTypeId)
		endmethod

		public stub method checkRequirement takes unit whichUnit returns boolean
			local integer i = 0
			local AUnitInventory inventory = AUnitInventory.getUnitsInventory(whichUnit)
			if (this.equipmentType() == AItemType.equipmentTypeSecondaryWeapon and inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0) then
				set i = 0
				loop
					exitwhen (i == thistype.m_twoSlotItems.size())
					if (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId() == thistype.m_twoSlotItems[i]) then
						call SimError(GetOwningPlayer(whichUnit), tre("Charakter trägt Gegenstand, der beide Slots benötigt.", "Character wears item which requires both slots."))
						return false
					endif
					set i = i + 1
				endloop
			elseif (inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0) then
				set i = 0
				loop
					exitwhen (i == thistype.m_twoSlotItems.size())
					if (this.itemTypeId() == thistype.m_twoSlotItems[i]) then
						call SimError(GetOwningPlayer(whichUnit), tre("Gegenstand benötigt beide Slots.", "The item requires both slots."))
						return false
					endif
					set i = i + 1
				endloop
			endif

			return super.checkRequirement(whichUnit)
		endmethod

		private static method onInit takes nothing returns nothing
			/**
			 * All items which require two slots have to be registered here.
			 * TODO maybe store a boolean attribute instead which can be set?
			 */
			set thistype.m_twoSlotItems = AIntegerVector.create()
			call thistype.m_twoSlotItems.pushBack('I013')
			call thistype.m_twoSlotItems.pushBack('I020')
			call thistype.m_twoSlotItems.pushBack('I021')
			call thistype.m_twoSlotItems.pushBack('I04T')
			call thistype.m_twoSlotItems.pushBack('I05B')
			call thistype.m_twoSlotItems.pushBack('I05C')
			call thistype.m_twoSlotItems.pushBack('I06Y')
			call thistype.m_twoSlotItems.pushBack('I075')
			call thistype.m_twoSlotItems.pushBack('I07L')
			call thistype.m_twoSlotItems.pushBack('I07M')
		endmethod

		public static method create takes integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns thistype
			local thistype this = thistype.allocate(itemType, equipmentType, requiredLevel, requiredStrength, requiredAgility, requiredIntelligence, requiredClass)

			return this
		endmethod
	endstruct

	/**
	 * \brief Item type for all range based weapons.
	 * This item type should enable the proper attack animations for characters as well as range attack when being equipped.
	 * Since disabling techs does not work in Warcraft III we use the followig solution:
	 * http://www.hiveworkshop.com/forums/general-mapping-tutorials-278/hero-passive-transformation-198482/
	 * For this solution two unit types must exist. One with range attack and the other with melee attack.
	 *
	 * \note For specifying any missile graphics you can use a damage ability based on 'AIsb' and specify one. Set the chance for the effect to 0.0 to disable it.
	 * \note Note that orbs do not stack so it can only be used if there is only one weapon.
	 */
	struct RangeItemType extends ItemType

		public static method createSimpleRange takes integer itemType, integer equipmentType returns thistype
			return thistype.allocate(itemType, equipmentType, 0, 0, 0, 0, 0)
		endmethod

		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			local Character character = ACharacter.getCharacterByUnit(whichUnit)
			local AGlobalHashTable realSpellLevels = 0
			local integer i
			debug call Print("Range item attach")

			if (character != 0) then
				debug call Print("Adding and removing ability " + GetObjectName(Classes.classRangeAbilityIdByCharacter(character)) + " to unit " + GetUnitName(whichUnit))
				/**
				 * Make sure the current spell levels are up to date for later restoration.
				 */
				set realSpellLevels = character.grimoire().spellLevels()

				/*
				 * These two lines of code do the passive transformation to a range fighting unit.
				 */
				call UnitAddAbility(whichUnit, Classes.classRangeAbilityIdByCharacter(character))
				call UnitRemoveAbility(whichUnit, Classes.classRangeAbilityIdByCharacter(character))
				/*
				 * Now the spell levels have to be readded and the grimoire needs to be updated since all abilities are gone.
				 */
				call character.grimoire().readd(realSpellLevels)
				call realSpellLevels.destroy()
				set realSpellLevels = 0
				call character.grimoire().updateUi()
			endif
		endmethod

		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			local Character character = ACharacter.getCharacterByUnit(whichUnit)
			local AGlobalHashTable realSpellLevels = 0
			debug call Print("Range item drop")

			if (character != 0) then
				debug call Print("Adding and removing ability " + GetObjectName(Classes.classMeleeAbilityIdByCharacter(character)) + " to unit " + GetUnitName(whichUnit))
				set realSpellLevels = character.grimoire().spellLevels()
				call UnitAddAbility(whichUnit, Classes.classMeleeAbilityIdByCharacter(character))
				call UnitRemoveAbility(whichUnit, Classes.classMeleeAbilityIdByCharacter(character))
				call character.grimoire().readd(realSpellLevels)
				call realSpellLevels.destroy()
				set realSpellLevels = 0
				call character.grimoire().updateUi()
			endif
		endmethod

	endstruct

	/**
	 * \brief Item type for defense items like bucklers.
	 */
	struct DefenceItemType extends ItemType
		public static constant string animationProperties = "Defend"

		public static method createSimpleDefence takes integer itemType, integer equipmentType returns thistype
			return thistype.allocate(itemType, equipmentType, 0, 0, 0, 0, 0)
		endmethod

		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			debug call Print("Defend item attach")
			call AddUnitAnimationProperties(whichUnit, thistype.animationProperties, true)
		endmethod

		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			debug call Print("Defend item drop")
			call AddUnitAnimationProperties(whichUnit, thistype.animationProperties, false)
		endmethod

	endstruct

	struct MeleeItemType extends ItemType

		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			debug call Print("Melee item attach")
		endmethod

		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			debug call Print("Melee item drop")
		endmethod
	endstruct

	/**
	 * \brief The saddle is a special item which can only be carried if the character rides on a horse.
	 */
	struct SaddleItemType extends ItemType
		public static method isUnitOnHorse takes integer unitTypeId returns boolean
			return unitTypeId == 'H02W' or unitTypeId == 'H02Z' or unitTypeId == 'H031' or unitTypeId == 'H033' or unitTypeId == 'H035' or unitTypeId == 'H037' or unitTypeId == 'H039' or unitTypeId == 'H03B' or unitTypeId == 'H02X' or unitTypeId == 'H030' or unitTypeId == 'H032' or unitTypeId == 'H034' or unitTypeId == 'H036' or unitTypeId == 'H038' or unitTypeId == 'H03A' or unitTypeId == 'H03C'
		endmethod

		public stub method checkRequirement takes unit whichUnit returns boolean
			local integer unitTypeId = GetUnitTypeId(whichUnit)

			if (not thistype.isUnitOnHorse(unitTypeId)) then
				call SimError(GetOwningPlayer(whichUnit), tre("Charakter muss Pferd reiten.", "Character has to ride a horse."))
				return false
			endif

			return super.checkRequirement(whichUnit)
		endmethod

		public static method create takes integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns thistype
			local thistype this = thistype.allocate(itemType, equipmentType, requiredLevel, requiredStrength, requiredAgility, requiredIntelligence, requiredClass)

			return this
		endmethod
	endstruct

	/**
	 * The bronze set of items is a quest reward in the map The North.
	 * If all items are equipped, bonuses will be added.
	 */
	struct BronzeSetItemType extends ItemType

		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			local Character character = Character.getCharacterByUnit(whichUnit)
			debug call Print("Bronze item attach")
			if (GetUnitAbilityLevel(whichUnit, 'A1W4') < 1 and character != 0 and character.inventory().equipmentItemData(thistype.equipmentTypeHeaddress) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeHeaddress).itemTypeId() == 'I07Q' and character.inventory().equipmentItemData(thistype.equipmentTypeArmour) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeArmour).itemTypeId() == 'I07X' and character.inventory().equipmentItemData(thistype.equipmentTypePrimaryWeapon) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypePrimaryWeapon).itemTypeId() == 'I080' and character.inventory().equipmentItemData(thistype.equipmentTypeSecondaryWeapon) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeSecondaryWeapon).itemTypeId() == 'I07Z' and ((character.inventory().equipmentItemData(thistype.equipmentTypeAmulet) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeAmulet).itemTypeId() == 'I07Y' and character.inventory().equipmentItemData(thistype.equipmentTypeAmulet + 1) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeAmulet + 1).itemTypeId() == 'I081') or (character.inventory().equipmentItemData(thistype.equipmentTypeAmulet) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeAmulet).itemTypeId() == 'I081' and character.inventory().equipmentItemData(thistype.equipmentTypeAmulet + 1) != 0 and  character.inventory().equipmentItemData(thistype.equipmentTypeAmulet + 1).itemTypeId() == 'I07Y'))) then
				call UnitAddAbility(whichUnit, 'A1W4')
				call UnitMakeAbilityPermanent(whichUnit, true, 'A1W4')
				call character.displayHint(tre("Gesamte Bronzerüstung ausgerüstet. Die Rüstung Ihres Charakters wird zusätzlich erhöht.", "Equipped the whole bronze armour. The armour of your character is increased additionally."))
				debug call Print("Add Bronze bonus!")
			endif
		endmethod

		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			debug call Print("Bronze item drop")
			if (GetUnitAbilityLevel(whichUnit, 'A1W4') > 0) then
				call UnitRemoveAbility(whichUnit, 'A1W4')
			endif
		endmethod
	endstruct

	/**
	 * \brief Static struct which stores all global item types of the mod.
	 * The object data and item types must be available in EVERY map of the campaign since the character can travel from map to map.
	 * Therefore the item types need to be specified globally (here) and not per map.
	 * \note Do not add usable abilities, only permanents!
	 * \note Only equipable item types have to be added. Charged usable items or quest items for the bagpack only do not have to be added at all.
	 */
	struct ItemTypes
		// start items
		private static RangeItemType m_simpleDruidStaff

		private static ItemType m_blessedSword // Markwards item
		private static ItemType m_preciousClericHelmet
		private static ItemType m_bigDoubleAxe
		private static ItemType m_vassalLance

		// Ricman
		private static DefenceItemType m_ricmansShield
		private static ItemType m_ricmansSpear
		private static ItemType m_ringOfLatency
		private static ItemType m_staffOfNecromancer
		private static ItemType m_staffOfWizard

		// Agihard
		private static ItemType m_amuletOfFight
		private static DefenceItemType m_expandedShield
		private static DefenceItemType m_knightBuckler
		private static ItemType m_axe
		private static DefenceItemType m_woodenShield
		private static DefenceItemType m_lightWoodenShield
		private static ItemType m_protectionRing
		private static DefenceItemType m_heavyWoodenShield
		private static ItemType m_staff
		private static DefenceItemType m_vassalShield
		private static ItemType m_mace
		private static ItemType m_morningStar
		private static ItemType m_morningStarSecondary
		private static ItemType m_halberd
		private static ItemType m_shortsword
		private static ItemType m_longsword
		private static ItemType m_magicAmulet
		private static ItemType m_magicCoat
		private static ItemType m_magicHat
		private static ItemType m_powerfulMagicHat
		private static ItemType m_magicRing
		private static RangeItemType m_bonesBow
		private static ItemType m_torch
		private static ItemType m_bannerOfTheBlackLegion
		private static ItemType m_bannerOfTheWhiteLegion
		private static RangeItemType m_circleOfElements
		private static ItemType m_spear
		// Ricman's items
		private static ItemType m_nasalHelmet
		private static ItemType m_kettleHat
		private static ItemType m_leatherArmourPlate
		private static ItemType m_dragonArmourPlate
		private static DefenceItemType m_largeRoundedBuckler
		private static RangeItemType m_dart
		private static ItemType m_nordicWarHammer
		private static ItemType m_nordicWarHelmet
		// Wieland's items
		private static ItemType m_knightsArmour
		private static ItemType m_bascinet
		private static ItemType m_greatHelm
		private static ItemType m_knightHelmet
		private static ItemType m_fineKnightHelmet
		private static ItemType m_ironArmour
		private static ItemType m_amuletOfStrength
		private static ItemType m_decoratedAmuletOfStrength
		private static ItemType m_ringOfStrength3
		// Björn's items
		private static ItemType m_cloak
		private static ItemType m_hood
		private static RangeItemType m_huntingBow
		private static RangeItemType m_longBow
		private static RangeItemType m_bjoernsShortBow
		private static ItemType m_huntingKnife
		private static ItemType m_bootsOfSpeed
		private static ItemType m_quiver
		private static ItemType m_simpleClothes
		// artefacts
		private static ItemType m_amuletOfForesight
		private static ItemType m_amuletOfTerror
		private static ItemType m_swordOfDarkness

		private static ItemType m_amuletOfPower
		private static ItemType m_amuletOfLife
		private static ItemType m_bloodyDragonAxe
		private static ItemType m_hornOfFighting
		private static ItemType m_hornOfLife
		private static ItemType m_hornOfProtection
		private static ItemType m_demonSkull
		private static RangeItemType m_staffOfFreezing
		private static RangeItemType m_staffOfSlowing
		// slaughter quest
		private static ItemType m_bloodAmulet
		// Tellborn's items
		private static RangeItemType m_staffOfClarity
		private static ItemType m_shamanMask
		private static ItemType m_skullMask
		// NEW
		private static ItemType m_dagosDagger
		private static ItemType m_wingsOfDeathAngel
		private static ItemType m_vampireNecklace
		private static RangeItemType m_hauntedStaff
		// Sisgard's reward
		private static ItemType m_necromancerHelmet
		// Sisgard's items
		private static ItemType m_amuletOfWisdom
		private static ItemType m_mageArmour
		// Ursula's items
		private static ItemType m_druidCloak
		private static RangeItemType m_druidStaff
		private static RangeItemType m_staffOfBan
		private static ItemType m_druidBoots
		// Deranor's artefact
		private static ItemType m_deranorsCrownPiece

		// corn eaters items
		private static ItemType m_manaAmulet

		// bandits drops
		private static ItemType m_ringOfProtection2

		// wild creatures
		private static ItemType m_amuletOfLore
		private static ItemType m_ringOfProtection3

		// orcs
		private static ItemType m_crownOfKarornForest
		private static ItemType m_orcAxe
		private static ItemType m_orcCrossBow
		// Markward
		private static ItemType m_ringOfStrength
		private static ItemType m_ringOfWisdom
		private static ItemType m_ringOfDexterity
		private static ItemType m_ringOfLoyality
		private static ItemType m_amuletFromTalras
		// death vault drops
		private static ItemType m_deathScythe

		// Tanka's Totems
		private static ItemType m_attackTotem
		private static ItemType m_defenseTotem

		// map Gardonar
		private static ItemType m_demonicShoulderPlate
		private static ItemType m_demonicFireBow

		// map Gardonar's Hell
		private static ItemType m_tridentOfTheDevil

		// map Deranor's Swamp
		// Models\Items\DunklerSchild1.mdx

		// map Holzbruck
		private static SaddleItemType m_saddle
		private static ItemType m_twoHandedSword
		private static ItemType m_helmetOfTheCommander

		// map Holzbruck's underworld
		private static ItemType m_warDrums

		// map The North
		private static ItemType m_enchantedDwarfBlade
		private static ItemType m_twoHandedSwordCold
		private static ItemType m_cursedHammer // Objects\InventoryItems\Cursed Hammer\CursedHummer.mdx
		private static ItemType m_huntingArmor // Models\Items\LeatherPlate.mdx
		private static ItemType m_nordicBuckler // Models\Items\RicmansSchild.mdx
		private static ItemType m_nordicSpear // Models\Items\RicmansSpeer.mdx
		private static BronzeSetItemType m_bronzeHelmet
		private static BronzeSetItemType m_bronzePlate
		private static BronzeSetItemType m_bronzeBoots
		private static BronzeSetItemType m_bronzeBuckler
		private static BronzeSetItemType m_bronzeSword
		private static BronzeSetItemType m_bronzeBracers

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			local integer i = 0
			// disable the spell book ability to get a passive ability without icon
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				call SetPlayerAbilityAvailable(Player(i), 'A19N', false)
				call SetPlayerAbilityAvailable(Player(i), 'A19S', false)
				call SetPlayerAbilityAvailable(Player(i), 'A19T', false)
				call SetPlayerAbilityAvailable(Player(i), 'A19U', false)
				call SetPlayerAbilityAvailable(Player(i), 'A19V', false)
				call SetPlayerAbilityAvailable(Player(i), 'A19W', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1AF', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1AG', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1B6', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1B7', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1B8', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1B9', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1BA', false)
				call SetPlayerAbilityAvailable(Player(i), 'A0RU', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DC', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DE', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DO', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DP', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1S9', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DQ', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1EB', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1E7', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1EJ', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1R4', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1TL', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1TN', false)
				call SetPlayerAbilityAvailable(Player(i), 'A0KE', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1VN', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1WD', false)
				set i = i + 1
			endloop
		endmethod

		/**
		 * Call this method during the map initialization to create all item types.
		 * The map has to contain the corresponding object data, otherwise the object IDs are invalid.
		 */
		public static method init takes nothing returns nothing
			//integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns AItemType
			set thistype.m_simpleDruidStaff = RangeItemType.createSimpleRange('I06J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_simpleDruidStaff.addAbility('A1HX')

			set thistype.m_blessedSword = ItemType.createSimple('I03R', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_blessedSword.addAbility('Alcs')
			call thistype.m_blessedSword.addAbility('A04M')

			set thistype.m_preciousClericHelmet = ItemType.createSimple('I00I', AItemType.equipmentTypeHeaddress)
			call thistype.m_preciousClericHelmet.addAbility('A02E')

			set thistype.m_bigDoubleAxe = ItemType.createSimple('I00J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bigDoubleAxe.addAbility('A02F')
			call thistype.m_bigDoubleAxe.addAbility('A19S')

			set thistype.m_vassalLance = ItemType.createSimple('I00K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_vassalLance.addAbility('A02G')

			set thistype.m_ricmansShield = DefenceItemType.createSimpleDefence('I00M', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_ricmansShield.addAbility('A02K')
			call thistype.m_ricmansShield.addAbility('AIs6')

			set thistype.m_ricmansSpear = ItemType.createSimple('I002', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_ricmansSpear.addAbility('A02J')
			call thistype.m_ricmansSpear.addAbility('AIs6')

			set thistype.m_ringOfLatency = ItemType.createSimple('I00V', AItemType.equipmentTypeAmulet)
			//call thistype.m_ringOfLatency.addAbility('A02Y', false)

			set thistype.m_staffOfNecromancer = ItemType.create('I00L', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.necromancer())
			call thistype.m_staffOfNecromancer.addAbility('A02H')
			call thistype.m_staffOfNecromancer.addAbility('AIrm')
			//call thistype.m_staffOfNecromancer.addAbility('A02I', false)
			call thistype.m_staffOfNecromancer.addAbility('AIi4')

			set thistype.m_staffOfWizard = ItemType.create('I00H', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.wizard())
			call thistype.m_staffOfWizard.addAbility('A086')
			call thistype.m_staffOfWizard.addAbility('AIrm')
			//call thistype.m_staffOfWizard.addAbility('A02N', false)
			call thistype.m_staffOfWizard.addAbility('AIi6')

			set thistype.m_amuletOfFight = ItemType.create('I06K', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_amuletOfFight.addAbility('A01K')

			set thistype.m_expandedShield = DefenceItemType.createSimpleDefence('I006', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_expandedShield.addAbility('A01S')

			set thistype.m_knightBuckler = DefenceItemType.createSimpleDefence('I068', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_knightBuckler.addAbility('A1E7')
			call thistype.m_knightBuckler.addAbility('A1E5')

			set thistype.m_axe = ItemType.create('I00Q', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_axe.addAbility('A02P')

			set thistype.m_woodenShield = DefenceItemType.createSimpleDefence('I005', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_woodenShield.addAbility('A01T')

			set thistype.m_lightWoodenShield = DefenceItemType.createSimpleDefence('I00N', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_lightWoodenShield.addAbility('A02M')

			set thistype.m_protectionRing = ItemType.create('I00W', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_protectionRing.addAbility('AId3')

			set thistype.m_heavyWoodenShield = DefenceItemType.createSimpleDefence('I00O', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_heavyWoodenShield.addAbility('A016')

			set thistype.m_staff = ItemType.create('I003', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_staff.addAbility('A02L')

			set thistype.m_vassalShield = DefenceItemType.createSimpleDefence('I00Y', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_vassalShield.addAbility('A049')

			set thistype.m_mace = ItemType.create('I011', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_mace.addAbility('A04L')

			set thistype.m_morningStar = ItemType.create('I014', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_morningStar.addAbility('A04O')

			set thistype.m_morningStarSecondary = ItemType.create('I06I', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_morningStarSecondary.addAbility('A1GX')

			set thistype.m_halberd = ItemType.create('I01X', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_halberd.addAbility('A07G')
			call thistype.m_halberd.addAbility('A19N')

			set thistype.m_shortsword = ItemType.createSimple('I01Y', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_shortsword.addAbility('A07H')

			set thistype.m_longsword = ItemType.create('I012', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_longsword.addAbility('A04M')

			set thistype.m_magicAmulet = ItemType.create('I01Q', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicAmulet.addAbility('AI2m')
			call thistype.m_magicAmulet.addAbility('A19U')

			set thistype.m_magicCoat = ItemType.create('I01R', AItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_magicCoat.addAbility('AIrm')
			call thistype.m_magicCoat.addAbility('A19V')

			set thistype.m_magicHat = ItemType.create('I01S', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_magicHat.addAbility('AImv')
			call thistype.m_magicHat.addAbility('A06H')
			call thistype.m_magicHat.addAbility('A06G')

			set thistype.m_powerfulMagicHat = ItemType.create('I05A', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_powerfulMagicHat.addAbility('A17J')

			set thistype.m_magicRing = ItemType.create('I01P', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicRing.addAbility('AImz')
			call thistype.m_magicRing.addAbility('AIi3')

			set thistype.m_bonesBow = RangeItemType.createSimpleRange('I013', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bonesBow.addAbility('A1DO')

			set thistype.m_torch = ItemType.createSimple('I02G', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_torch.addAbility('A088')
			call thistype.m_torch.addAbility('A087')

			set thistype.m_bannerOfTheBlackLegion = ItemType.createSimple('I01B', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheBlackLegion.addAbility('A1AF')

			set thistype.m_bannerOfTheWhiteLegion = ItemType.createSimple('I01C', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheWhiteLegion.addAbility('A1AG')

			set thistype.m_circleOfElements = RangeItemType.create('I02H', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.elementalMage())
			call thistype.m_circleOfElements.addAbility('A08A')
			call thistype.m_circleOfElements.addAbility('AIrm')
			call thistype.m_circleOfElements.addAbility('AIi6')
			call thistype.m_circleOfElements.addAbility('A089')

			set thistype.m_spear = ItemType.createSimple('I01W', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_spear.addAbility('A07F')

			// Ricman's items
			set thistype.m_nasalHelmet = ItemType.createSimple('I02D', AItemType.equipmentTypeHeaddress)
			call thistype.m_nasalHelmet.addAbility('A084')

			set thistype.m_kettleHat = ItemType.createSimple('I02E', AItemType.equipmentTypeHeaddress)
			call thistype.m_kettleHat.addAbility('A085')

			set thistype.m_leatherArmourPlate = ItemType.createSimple('I02B', AItemType.equipmentTypeArmour)
			call thistype.m_leatherArmourPlate.addAbility('A082')

			set thistype.m_dragonArmourPlate = ItemType.createSimple('I02C', AItemType.equipmentTypeArmour)
			call thistype.m_dragonArmourPlate.addAbility('A083')

			set thistype.m_largeRoundedBuckler = DefenceItemType.create('I02A', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_largeRoundedBuckler.addAbility('A081')

			set thistype.m_dart = RangeItemType.createSimpleRange('I029', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dart.addAbility('A080')

			set thistype.m_nordicWarHammer = ItemType.create('I05C', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_nordicWarHammer.addAbility('A17M')
			call thistype.m_nordicWarHammer.addAbility('A0RU')

			set thistype.m_nordicWarHelmet = ItemType.create('I05E', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_nordicWarHelmet.addAbility('A18J')

			// Wieland's items
			set thistype.m_knightsArmour = ItemType.createSimple('I026', AItemType.equipmentTypeArmour)
			call thistype.m_knightsArmour.addAbility('A07X')

			set thistype.m_bascinet = ItemType.createSimple('I027', AItemType.equipmentTypeHeaddress)
			call thistype.m_bascinet.addAbility('A07Y')

			set thistype.m_greatHelm = ItemType.createSimple('I028', AItemType.equipmentTypeHeaddress)
			call thistype.m_greatHelm.addAbility('A07Z')
			call thistype.m_greatHelm.addAbility('AIs6')

			set thistype.m_knightHelmet = ItemType.createSimple('I05F', AItemType.equipmentTypeHeaddress)
			call thistype.m_knightHelmet.addAbility('A18K')

			set thistype.m_fineKnightHelmet = ItemType.createSimple('I05N', AItemType.equipmentTypeHeaddress)
			call thistype.m_fineKnightHelmet.addAbility('A18W')
			call thistype.m_fineKnightHelmet.addAbility('AIs3')

			set thistype.m_ironArmour = ItemType.createSimple('I067', AItemType.equipmentTypeArmour)
			call thistype.m_ironArmour.addAbility('A1E4')

			set thistype.m_amuletOfStrength = ItemType.createSimple('I07H', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfStrength.addAbility('AIs4')

			set thistype.m_decoratedAmuletOfStrength = ItemType.createSimple('I07I', AItemType.equipmentTypeAmulet)
			call thistype.m_decoratedAmuletOfStrength.addAbility('AIs6')

			set thistype.m_ringOfStrength3 = ItemType.createSimple('I07J', AItemType.equipmentTypeAmulet)
			call thistype.m_ringOfStrength3.addAbility('AIs3')

			// Björn's items
			set thistype.m_cloak = ItemType.createSimple('I023', AItemType.equipmentTypeArmour)
			call thistype.m_cloak.addAbility('A1DC')
			call thistype.m_cloak.addAbility('A07S')

			set thistype.m_hood = ItemType.createSimple('I022', AItemType.equipmentTypeHeaddress)
			call thistype.m_hood.addAbility('A04N')
			call thistype.m_hood.addAbility('A1DE')

			set thistype.m_huntingBow = RangeItemType.createSimpleRange('I020', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingBow.addAbility('A07N')

			set thistype.m_longBow = RangeItemType.createSimpleRange('I021', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_longBow.addAbility('A19T')
			call thistype.m_longBow.addAbility('A07P')

			set thistype.m_bjoernsShortBow = RangeItemType.createSimpleRange('I06M', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bjoernsShortBow.addAbility('A1HZ')
			call thistype.m_bjoernsShortBow.addAbility('A1I0')

			set thistype.m_huntingKnife = ItemType.createSimple('I025', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingKnife.addAbility('A07W')

			set thistype.m_bootsOfSpeed = ItemType.createSimple('I04M', AItemType.equipmentTypeAmulet)
			call thistype.m_bootsOfSpeed.addAbility('AIms')

			set thistype.m_quiver = ItemType.createSimple('I04W', AItemType.equipmentTypeAmulet)
			call thistype.m_quiver.addAbility('A1EC')
			call thistype.m_quiver.addAbility('A1EJ')

			set thistype.m_simpleClothes = ItemType.createSimple('I06B', AItemType.equipmentTypeArmour)
			call thistype.m_simpleClothes.addAbility('A1EG')

			// artefacts
			set thistype.m_amuletOfForesight = ItemType.createSimple('I02J', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfForesight.addAbility('A08X')
			call thistype.m_amuletOfForesight.addAbility('AIuv')

			set thistype.m_amuletOfTerror = ItemType.createSimple('I01M', AItemType.equipmentTypeAmulet)

			set thistype.m_swordOfDarkness = ItemType.createSimple('I02K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_swordOfDarkness.addAbility('A095')
			call thistype.m_swordOfDarkness.addAbility('S005')

			set thistype.m_amuletOfPower = ItemType.createSimple('I04D', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfPower.addAbility('AIs1')

			set thistype.m_amuletOfLife = ItemType.createSimple('I04K', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfLife.addAbility('A0VS')

			set thistype.m_bloodyDragonAxe = ItemType.create('I04E', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.dragonSlayer())
			call thistype.m_bloodyDragonAxe.addAbility('A0VM')

			set thistype.m_hornOfFighting = ItemType.createSimple('I04G', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfFighting.addAbility('A1B6')

			set thistype.m_hornOfLife = ItemType.createSimple('I04I', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfLife.addAbility('A1B7')

			set thistype.m_hornOfProtection = ItemType.createSimple('I04H', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfProtection.addAbility('A1B8')

			set thistype.m_demonSkull = ItemType.create('I04L', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, Classes.necromancer())
			call thistype.m_demonSkull.addAbility('A0VT')
			call thistype.m_demonSkull.addAbility('AIi4')

			set thistype.m_staffOfFreezing = RangeItemType.createSimpleRange('I04J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfFreezing.addAbility('A0VR')

			set thistype.m_staffOfSlowing = RangeItemType.createSimpleRange('I04F', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfSlowing.addAbility('A1DP')
			// hides the orb effect as well
			call thistype.m_staffOfSlowing.addAbility('A1S9')

			// slaughter quest
			set thistype.m_bloodAmulet = ItemType.createSimple('I02L', AItemType.equipmentTypeAmulet)
			call thistype.m_bloodAmulet.addAbility('A1B9')

			// Tellborn's items
			set thistype.m_staffOfClarity = RangeItemType.create('I02N', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_staffOfClarity.addAbility('AIrm')
			call thistype.m_staffOfClarity.addAbility('A0AD')
			call thistype.m_staffOfClarity.addAbility('A19W')
			call thistype.m_staffOfClarity.addAbility('AIi4')

			set thistype.m_shamanMask = ItemType.createSimple('I05V', ItemType.equipmentTypeHeaddress)
			call thistype.m_shamanMask.addAbility('AIi4')
			call thistype.m_shamanMask.addAbility('A1AE')

			set thistype.m_skullMask = ItemType.createSimple('I069', ItemType.equipmentTypeHeaddress)
			call thistype.m_skullMask.addAbility('A1E9')
			call thistype.m_skullMask.addAbility('A1E8')
			call thistype.m_skullMask.addAbility('A1EB')

			set thistype.m_dagosDagger = ItemType.createSimple('I02O', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dagosDagger.addAbility('A020')
			call thistype.m_dagosDagger.addAbility('A021')

			set thistype.m_wingsOfDeathAngel = ItemType.createSimple('I02Q', ItemType.equipmentTypeArmour)
			call thistype.m_wingsOfDeathAngel.addAbility('A030')
			call thistype.m_wingsOfDeathAngel.addAbility('A02B')
			call thistype.m_wingsOfDeathAngel.addAbility('A0KE')

			set thistype.m_vampireNecklace = ItemType.createSimple('I02T', ItemType.equipmentTypeArmour)
			call thistype.m_vampireNecklace.addAbility('AIi4')
			call thistype.m_vampireNecklace.addAbility('A03X')

			set thistype.m_hauntedStaff = RangeItemType.create('I03V', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_hauntedStaff.addAbility('A0B8')

			// Sisgard's reward
			set thistype.m_necromancerHelmet = ItemType.createSimple('I044', ItemType.equipmentTypeHeaddress)
			call thistype.m_necromancerHelmet.addAbility('A18X')
			call thistype.m_necromancerHelmet.addAbility('AIi4')
			//call thistype.m_necromancerHelmet.addAbility('AIva', false)

			// Sisgard's items
			set thistype.m_amuletOfWisdom = ItemType.createSimple('I048', ItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfWisdom.addAbility('AIrm')

			set thistype.m_mageArmour = ItemType.createSimple('I06A', ItemType.equipmentTypeArmour)
			call thistype.m_mageArmour.addAbility('A1ED')
			call thistype.m_mageArmour.addAbility('A1EF')
			call thistype.m_mageArmour.addAbility('A1EE')

			// Ursuala's items
			set thistype.m_druidCloak = ItemType.createSimple('I015', ItemType.equipmentTypeArmour)
			call thistype.m_druidCloak.addAbility('AIi3')
			call thistype.m_druidCloak.addAbility('AId3')

			set thistype.m_druidStaff = RangeItemType.createSimpleRange('I02X', AItemType.equipmentTypePrimaryWeapon)
			//call thistype.m_druidStaff.addAbility('A044', false)
			call thistype.m_druidStaff.addAbility('A1HX')

			set thistype.m_staffOfBan = RangeItemType.createSimpleRange('I04Z', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfBan.addAbility('A16F')
			//call thistype.m_staffOfBan.addAbility('A16G', false)

			set thistype.m_druidBoots = ItemType.createSimple('I033', ItemType.equipmentTypeAmulet)
			call thistype.m_druidBoots.addAbility('A1R4')

			// Deranor's artefact
			set thistype.m_deranorsCrownPiece =  ItemType.createSimple('I04A', ItemType.equipmentTypeAmulet)
			call thistype.m_deranorsCrownPiece.addAbility('A1BA')
			call thistype.m_deranorsCrownPiece.addAbility('AIx2')

			// corn eaters items
			set thistype.m_manaAmulet = ItemType.createSimple('I046', ItemType.equipmentTypeAmulet)
			call thistype.m_manaAmulet.addAbility('AIbm')

			set thistype.m_ringOfProtection2 = ItemType.createSimple('I04C', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfProtection2.addAbility('AId2')

			// wild creatures
			set thistype.m_amuletOfLore = ItemType.createSimple('I04O', ItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfLore.addAbility('AIi1')
			set thistype.m_ringOfProtection3 = ItemType.createSimple('I04P', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfProtection3.addAbility('AId3')

			// orcs
			set thistype.m_crownOfKarornForest = ItemType.createSimple('I04R', ItemType.equipmentTypeHeaddress)
			call thistype.m_crownOfKarornForest.addAbility('AIi3')
			call thistype.m_crownOfKarornForest.addAbility('AId3')

			set thistype.m_orcAxe = ItemType.createSimple('I04S', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_orcAxe.addAbility('A13T')
			call thistype.m_orcAxe.addAbility('A13S')

			set thistype.m_orcCrossBow = RangeItemType.create('I04T', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_orcCrossBow.addAbility('AItk')

			// Markward
			set thistype.m_ringOfStrength = ItemType.createSimple('I053', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfStrength.addAbility('AIs3')
			set thistype.m_ringOfWisdom = ItemType.createSimple('I052', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfWisdom.addAbility('AIi3')
			set thistype.m_ringOfDexterity = ItemType.createSimple('I054', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfDexterity.addAbility('AIa3')
			set thistype.m_ringOfLoyality = ItemType.createSimple('I055', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfLoyality.addAbility('AIx2')
			set thistype.m_amuletFromTalras = ItemType.createSimple('I06P', ItemType.equipmentTypeAmulet)
			call thistype.m_amuletFromTalras.addAbility('A1IZ')

			// death vault drops
			set thistype.m_deathScythe = ItemType.create('I05B', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_deathScythe.addAbility('A17K')
			call thistype.m_deathScythe.addAbility('A1DQ')

			// Tanka's Totems
			set thistype.m_attackTotem = ItemType.createSimple('I085', ItemType.equipmentTypeAmulet)
			call thistype.m_attackTotem.addAbility('A1WD')

			set thistype.m_defenseTotem = ItemType.createSimple('I086', ItemType.equipmentTypeAmulet)
			call thistype.m_defenseTotem.addAbility('A1WE')

			// Gardonar

			// demonic shoulder plate
			set thistype.m_demonicShoulderPlate = ItemType.create('I06W', ItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_demonicShoulderPlate.addAbility('A1Q7')
			call thistype.m_demonicShoulderPlate.addAbility('A1Q8')

			set thistype.m_demonicFireBow = RangeItemType.createSimpleRange('I06Y', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_demonicFireBow.addAbility('A1QB')

			// Gardonar's Hell
			// trident of the devil
			set thistype.m_tridentOfTheDevil = ItemType.create('I06X', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_tridentOfTheDevil.addAbility('A1QA')
			call thistype.m_tridentOfTheDevil.addAbility('A1Q9')

			// Holzbruck
			set thistype.m_saddle = SaddleItemType.create('I074', ItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_saddle.addAbility('A1TH')
			call thistype.m_saddle.addAbility('A1TI')

			set thistype.m_twoHandedSword = ItemType.create('I075', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_twoHandedSword.addAbility('A1TJ')
			call thistype.m_twoHandedSword.addAbility('A1TL')

			set thistype.m_helmetOfTheCommander = ItemType.create('I072', ItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_twoHandedSword.addAbility('A1V1')
			call thistype.m_twoHandedSword.addAbility('A1V0')

			// Holzbruck's underworld
			set thistype.m_warDrums = ItemType.create('I076', ItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_warDrums.addAbility('A1TN')

			// The North
			set thistype.m_enchantedDwarfBlade = ItemType.create('I07E', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_enchantedDwarfBlade.addAbility('A1VF')

			set thistype.m_twoHandedSwordCold = ItemType.create('I07L', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_twoHandedSwordCold.addAbility('A1VN')
			call thistype.m_twoHandedSwordCold.addAbility('A1VL')

			set thistype.m_cursedHammer = ItemType.create('I07M', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_cursedHammer.addAbility('A1VP')
			call thistype.m_cursedHammer.addAbility('A1VR')
			call thistype.m_cursedHammer.addAbility('A1VQ')

			set thistype.m_huntingArmor = ItemType.create('I07P', ItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_huntingArmor.addAbility('A1VV')

			set thistype.m_nordicBuckler = ItemType.create('I07N', ItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_nordicBuckler.addAbility('A1VS')

			set thistype.m_nordicSpear = ItemType.create('I07O', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_nordicSpear.addAbility('A1VU')
			call thistype.m_nordicSpear.addAbility('A1VT')

			set thistype.m_bronzeHelmet = BronzeSetItemType.create('I07Q', ItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_bronzeHelmet.addAbility('A1W2')

			set thistype.m_bronzePlate = BronzeSetItemType.create('I07X', ItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_bronzePlate.addAbility('A1W3')

			set thistype.m_bronzeBoots = BronzeSetItemType.create('I07Y', ItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_bronzeBoots.addAbility('A1W5')

			set thistype.m_bronzeBuckler = BronzeSetItemType.create('I07Z', ItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_bronzeBuckler.addAbility('A1W6')

			set thistype.m_bronzeSword = BronzeSetItemType.create('I080', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_bronzeSword.addAbility('A1W7')

			set thistype.m_bronzeBracers = BronzeSetItemType.create('I081', ItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_bronzeBracers.addAbility('A1W8')
		endmethod

		public static method lightWoodenShield takes nothing returns ItemType
			return thistype.m_lightWoodenShield
		endmethod

		public static method shortword takes nothing returns ItemType
			return thistype.m_shortsword
		endmethod

		public static method longsword takes nothing returns ItemType
			return thistype.m_longsword
		endmethod

		public static method swordOfDarkness takes nothing returns ItemType
			return thistype.m_swordOfDarkness
		endmethod

		public static method itemTypeIdIsBuckler takes integer itemTypeId returns boolean
			return itemTypeId == 'I00M' or itemTypeId == 'I006' or itemTypeId == 'I02A' or itemTypeId == 'I005' or itemTypeId == 'I00N' or itemTypeId == 'I00O' or itemTypeId == 'I00Y' or itemTypeId == 'I068' or itemTypeId == 'I07N'
		endmethod

		public static method itemTypeIdIsBow takes integer itemTypeId returns boolean
			return itemTypeId == 'I013' or itemTypeId == 'I020' or itemTypeId == 'I021' or itemTypeId == 'I06Y'
		endmethod

		public static method itemTypeIdIsThrowingSpear takes integer itemTypeId returns boolean
			return itemTypeId == 'I029'
		endmethod

		public static method itemTypeIdIsMeleeSpear takes integer itemTypeId returns boolean
			return itemTypeId == 'I002' or itemTypeId == 'I01W' or itemTypeId == 'I00K' or itemTypeId == 'I01X' or itemTypeId == 'I07O'
		endmethod

		public static method itemTypeIdIsTwoHandedLance takes integer itemTypeId returns boolean
			return itemTypeId == 'I05B'
		endmethod

		public static method itemTypeIdIsTwoHandedHammer takes integer itemTypeId returns boolean
			return itemTypeId == 'I05C' or itemTypeId == 'I075' or itemTypeId == 'I07M'
		endmethod
	endstruct

endlibrary