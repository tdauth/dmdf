library StructGameItemTypes requires Asl, StructGameClasses, StructGameCharacter

	/**
	 * \brief Default item type struct for all item types in DMdF.
	 */
	struct ItemType extends AItemType
		public static constant string twoSlotAnimationProperties = "Alternate"
		private static AIntegerVector m_twoSlotItems
		
		public stub method checkRequirement takes ACharacter character returns boolean
			local integer i
			if (this.equipmentType() == AItemType.equipmentTypeSecondaryWeapon and character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0) then
				set i = 0
				loop
					exitwhen (i == thistype.m_twoSlotItems.size())
					if (character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId() == thistype.m_twoSlotItems[i]) then
						call character.displayMessage(ACharacter.messageTypeError, tr("Charakter trägt Gegenstand, der beide Slots benötigt."))
						return false
					endif
					set i = i + 1
				endloop
			elseif (character.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0) then
				set i = 0
				loop
					exitwhen (i == thistype.m_twoSlotItems.size())
					if (this.itemType() == thistype.m_twoSlotItems[i]) then
						call character.displayMessage(ACharacter.messageTypeError, tr("Gegenstand benötigt beide Slots."))
						return false
					endif
					set i = i + 1
				endloop
			endif
		
			return super.checkRequirement(character)
		endmethod
		
		private static method onInit takes nothing returns nothing
			// TODO Alle Zweihandwaffen
			set thistype.m_twoSlotItems = AIntegerVector.create()
			call thistype.m_twoSlotItems.pushBack('I013')
			call thistype.m_twoSlotItems.pushBack('I020')
			call thistype.m_twoSlotItems.pushBack('I021')
			call thistype.m_twoSlotItems.pushBack('I04T')
			call thistype.m_twoSlotItems.pushBack('I05B')
			call thistype.m_twoSlotItems.pushBack('I05C')
		endmethod
		
		/*
		* TODO
		 * Knight has the ability to increase armory from items.
		 * Get the item's armor bonus by adding a dummy unit with inventory and calculating it when adding and removing the item.
		 */
		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			local ACharacter character = ACharacter.getCharacterByUnit(whichUnit)
			local boolean twoSlotItem = thistype.m_twoSlotItems.contains(this.itemType())
			
			/*
			 * If he carries only one weapon there is only these sword fight animations for melee weapons.
			 * Therefore if he carries no buckler and it is a melee item use the same animations.
			 */
			if (twoSlotItem or (not twoSlotItem and this.equipmentType() == thistype.equipmentTypePrimaryWeapon and character.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0)) then
				/**
				 * The "Alternate" tag should lead the character to do two hand melee fighting animations instead normal ones.
				 */
				call AddUnitAnimationProperties(whichUnit, thistype.twoSlotAnimationProperties, true)
			endif
		endmethod
		
		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			local ACharacter character = ACharacter.getCharacterByUnit(whichUnit)
			local boolean twoSlotItem = thistype.m_twoSlotItems.contains(this.itemType())
			
			/*
			 * If he carries only one weapon there is only these sword fight animations for melee weapons.
			 * Therefore if he carries no buckler and it is a melee item use the same animations.
			 */
			if (twoSlotItem or (not twoSlotItem and this.equipmentType() == thistype.equipmentTypePrimaryWeapon and character.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0)) then
				/**
				 * The "Alternate" tag should lead the character to do two hand melee fighting animations instead normal ones.
				 */
				call AddUnitAnimationProperties(whichUnit, thistype.twoSlotAnimationProperties, false)
			endif
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
		public static constant string animationProperties = "Throw 7"
	
		public static method createSimpleRange takes integer itemType, integer equipmentType returns thistype
			return thistype.allocate(itemType, equipmentType, 0, 0, 0, 0, 0)
		endmethod
	
		// Attack Throw 6
		// Attack Throw 7
		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
			local Character character = ACharacter.getCharacterByUnit(whichUnit)
			local integer i
			debug call Print("Range item attach")
			
			// TODO unmorph before if it is morphed already
			if (character != 0) then
				debug call Print("Adding and removing ability " + GetObjectName(MapData.classRangeAbilityId.evaluate(character)) + " to unit " + GetUnitName(whichUnit))
				/**
				 * Make sure the current spell levels are up to date for later restoration.
				 */
				call character.updateRealSpellLevels()
				/*
				 * These two lines of code do the passive transformation to a range fighting unit.
				 */
				call UnitAddAbility(whichUnit, MapData.classRangeAbilityId.evaluate(character))
				call UnitRemoveAbility(whichUnit, MapData.classRangeAbilityId.evaluate(character))
				/*
				 * Now the spell levels have to be readded and the grimoire needs to be updated since all abilities are gone.
				 */
				call character.restoreRealSpellLevels()
				call character.clearRealSpellLevels()
				call character.grimoire().updateUi.evaluate()
				
				/**
				 * The throw tag should lead the character to do range fighting animations instead of melee ones.
				 */
				 // TODO the index is not recognized
				call AddUnitAnimationProperties(whichUnit, thistype.animationProperties, true)
			endif
		endmethod
		
		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
			local Character character = ACharacter.getCharacterByUnit(whichUnit)
			debug call Print("Range item drop")
			
			if (character != 0) then
				debug call Print("Adding and removing ability " + GetObjectName(MapData.classMeleeAbilityId.evaluate(character)) + " to unit " + GetUnitName(whichUnit))
				call character.updateRealSpellLevels()
				call UnitAddAbility(whichUnit, MapData.classMeleeAbilityId.evaluate(character))
				call UnitRemoveAbility(whichUnit, MapData.classMeleeAbilityId.evaluate(character))
				call character.restoreRealSpellLevels()
				call character.clearRealSpellLevels()
				call character.grimoire().updateUi.evaluate()
				
				// TODO the index is not recognized
				call AddUnitAnimationProperties(whichUnit, thistype.animationProperties, false)
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
	 * \brief Static class which stores all global item types of the mod.
	 * \note Do not add usable abilities, only permanents!
	 * \note Only equipable item types have to be added. Charged usable items or quest items for the bagpack only do not have to be added at all.
	 */
	struct ItemTypes
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
		private static DefenceItemType m_expandedShield
		private static ItemType m_axe
		private static DefenceItemType m_woodenShield
		private static DefenceItemType m_lightWoodenShield
		private static ItemType m_protectionRing
		private static DefenceItemType m_heavyWoodenShield
		private static ItemType m_staff
		private static DefenceItemType m_vassalShield
		private static ItemType m_mace
		private static ItemType m_morningStar
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
		private static ItemType m_circleOfElements
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
		// Björn's items
		private static ItemType m_cloak
		private static ItemType m_hood
		private static RangeItemType m_huntingBow
		private static RangeItemType m_longBow
		private static ItemType m_huntingKnife
		private static ItemType m_bootsOfSpeed
		private static ItemType m_quiver
		// artefacts
		private static ItemType m_amuletOfForesight
		private static ItemType m_amuletOfTerror
		private static ItemType m_swordOfDarkness
		
		private static ItemType m_amuletOfStrength
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
		// NEW
		private static ItemType m_dagosDagger
		private static ItemType m_wingsOfDeathAngel
		private static ItemType m_vampireNecklace
		private static RangeItemType m_hauntedStaff
		// Sisgard's reward
		private static ItemType m_necromancerHelmet
		// Sisgard's items
		private static ItemType m_amuletOfWisdom
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
		
		// death vault drops
		private static ItemType m_deathScythe

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		private static method onInit takes nothing returns nothing
			local integer i
			// disable the spell book ability to get a passive ability without icon
			set i = 0
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
				set i = i + 1
			endloop
		endmethod

		public static method init takes nothing returns nothing
			//integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns AItemType
			set thistype.m_blessedSword = ItemType.createSimple('I03R', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_blessedSword.addAbility('Alcs', true)
			call thistype.m_blessedSword.addAbility('A04M', true)
			
			set thistype.m_preciousClericHelmet = ItemType.createSimple('I00I', AItemType.equipmentTypeHeaddress)
			call thistype.m_preciousClericHelmet.addAbility('A02E', true)

			set thistype.m_bigDoubleAxe = ItemType.createSimple('I00J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bigDoubleAxe.addAbility('A02F', true)
			call thistype.m_bigDoubleAxe.addAbility('A19S', true)

			set thistype.m_vassalLance = ItemType.createSimple('I00K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_vassalLance.addAbility('A02G', true)

			set thistype.m_ricmansShield = DefenceItemType.createSimpleDefence('I00M', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_ricmansShield.addAbility('A02K', true)
			call thistype.m_ricmansShield.addAbility('AIs6', true)

			set thistype.m_ricmansSpear = ItemType.createSimple('I002', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_ricmansSpear.addAbility('A02J', true)
			call thistype.m_ricmansSpear.addAbility('AIs6', true)

			set thistype.m_ringOfLatency = ItemType.createSimple('I00V', AItemType.equipmentTypeAmulet)
			call thistype.m_ringOfLatency.addAbility('A02Y', false)

			set thistype.m_staffOfNecromancer = ItemType.create('I00L', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.necromancer())
			call thistype.m_staffOfNecromancer.addAbility('A02H', true)
			call thistype.m_staffOfNecromancer.addAbility('AIrm', true)
			call thistype.m_staffOfNecromancer.addAbility('A02I', false)
			call thistype.m_staffOfNecromancer.addAbility('AIi4', true)

			set thistype.m_staffOfWizard = ItemType.create('I00H', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.wizard())
			call thistype.m_staffOfWizard.addAbility('A086', true)
			call thistype.m_staffOfWizard.addAbility('AIrm', true)
			call thistype.m_staffOfWizard.addAbility('A02N', false)
			call thistype.m_staffOfWizard.addAbility('AIi6', true)

			set thistype.m_expandedShield = DefenceItemType.createSimpleDefence('I006', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_expandedShield.addAbility('A01S', true)

			set thistype.m_axe = ItemType.create('I00Q', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_axe.addAbility('A02P', true)

			set thistype.m_woodenShield = DefenceItemType.createSimpleDefence('I005', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_woodenShield.addAbility('A01T', true)

			set thistype.m_lightWoodenShield = DefenceItemType.createSimpleDefence('I00N', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_lightWoodenShield.addAbility('A02M', true)

			set thistype.m_protectionRing = ItemType.create('I00W', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_protectionRing.addAbility('AId3', true)

			set thistype.m_heavyWoodenShield = DefenceItemType.createSimpleDefence('I00O', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_heavyWoodenShield.addAbility('A016', true)

			set thistype.m_staff = ItemType.create('I003', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_staff.addAbility('A02L', true)

			set thistype.m_vassalShield = DefenceItemType.createSimpleDefence('I00Y', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_vassalShield.addAbility('A049', true)

			set thistype.m_mace = ItemType.create('I011', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_mace.addAbility('A04L', true)

			set thistype.m_morningStar = ItemType.create('I014', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_morningStar.addAbility('A04O', true)

			set thistype.m_halberd = ItemType.create('I01X', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_halberd.addAbility('A07G', true)
			call thistype.m_halberd.addAbility('A19N', true)

			set thistype.m_shortsword = ItemType.createSimple('I01Y', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_shortsword.addAbility('A07H', true)

			set thistype.m_longsword = ItemType.create('I012', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_longsword.addAbility('A04M', true)

			set thistype.m_magicAmulet = ItemType.create('I01Q', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicAmulet.addAbility('AI2m', true)
			call thistype.m_magicAmulet.addAbility('A19U', true)

			set thistype.m_magicCoat = ItemType.create('I01R', AItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_magicCoat.addAbility('AIrm', true)
			call thistype.m_magicCoat.addAbility('A19V', true)

			set thistype.m_magicHat = ItemType.create('I01S', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_magicHat.addAbility('AImv', true)
			call thistype.m_magicHat.addAbility('A06H', true)
			call thistype.m_magicHat.addAbility('A06G', true)
			
			set thistype.m_powerfulMagicHat = ItemType.create('I05A', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_powerfulMagicHat.addAbility('A17J', true)

			set thistype.m_magicRing = ItemType.create('I01P', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicRing.addAbility('AImz', true)
			call thistype.m_magicRing.addAbility('AIi3', true)

			/// \todo two-handed
			set thistype.m_bonesBow = RangeItemType.createSimpleRange('I013', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bonesBow.addAbility('A07M', true)

			set thistype.m_torch = ItemType.createSimple('I02G', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_torch.addAbility('A088', true)
			call thistype.m_torch.addAbility('A087', true)

			set thistype.m_bannerOfTheBlackLegion = ItemType.createSimple('I01B', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheBlackLegion.addAbility('A1AF', true)

			set thistype.m_bannerOfTheWhiteLegion = ItemType.createSimple('I01C', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheWhiteLegion.addAbility('A1AG', true)

			set thistype.m_circleOfElements = ItemType.create('I02H', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.elementalMage())
			call thistype.m_circleOfElements.addAbility('A08A', true)
			call thistype.m_circleOfElements.addAbility('AIrm', true)
			call thistype.m_circleOfElements.addAbility('AIi6', true)
			call thistype.m_circleOfElements.addAbility('A089', true)

			set thistype.m_spear = ItemType.createSimple('I01W', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_spear.addAbility('A07F', true)

			// Ricman's items
			set thistype.m_nasalHelmet = ItemType.createSimple('I02D', AItemType.equipmentTypeHeaddress)
			call thistype.m_nasalHelmet.addAbility('A084', true)

			set thistype.m_kettleHat = ItemType.createSimple('I02E', AItemType.equipmentTypeHeaddress)
			call thistype.m_kettleHat.addAbility('A085', true)

			set thistype.m_leatherArmourPlate = ItemType.createSimple('I02B', AItemType.equipmentTypeArmour)
			call thistype.m_leatherArmourPlate.addAbility('A082', true)

			set thistype.m_dragonArmourPlate = ItemType.createSimple('I02C', AItemType.equipmentTypeArmour)
			call thistype.m_dragonArmourPlate.addAbility('A083', true)

			set thistype.m_largeRoundedBuckler = ItemType.createSimple('I02A', AItemType.equipmentTypeSecondaryWeapon)
			call thistype.m_largeRoundedBuckler.addAbility('A081', true)

			set thistype.m_dart = RangeItemType.createSimpleRange('I029', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dart.addAbility('A080', true)
			
			set thistype.m_nordicWarHammer = ItemType.create('I05C', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_nordicWarHammer.addAbility('A17M', true)
			call thistype.m_nordicWarHammer.addAbility('A17N', true)
			
			set thistype.m_nordicWarHelmet = ItemType.create('I05E', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_nordicWarHelmet.addAbility('A18J', true)

			// Wieland's items
			set thistype.m_knightsArmour = ItemType.createSimple('I026', AItemType.equipmentTypeArmour)
			call thistype.m_knightsArmour.addAbility('A07X', true)

			set thistype.m_bascinet = ItemType.createSimple('I027', AItemType.equipmentTypeHeaddress)
			call thistype.m_bascinet.addAbility('A07Y', true)

			set thistype.m_greatHelm = ItemType.createSimple('I028', AItemType.equipmentTypeHeaddress)
			call thistype.m_greatHelm.addAbility('A07Z', true)
			call thistype.m_greatHelm.addAbility('AIs6', true)
			
			set thistype.m_knightHelmet = ItemType.createSimple('I05F', AItemType.equipmentTypeHeaddress)
			call thistype.m_knightHelmet.addAbility('A18K', true)
			
			set thistype.m_fineKnightHelmet = ItemType.createSimple('I05N', AItemType.equipmentTypeHeaddress)
			call thistype.m_fineKnightHelmet.addAbility('A18W', true)
			call thistype.m_fineKnightHelmet.addAbility('AIs3', true)

			// Björn's items
			set thistype.m_cloak = ItemType.createSimple('I023', AItemType.equipmentTypeArmour)
			call thistype.m_cloak.addAbility('A07R', true)
			call thistype.m_cloak.addAbility('A07S', true)

			set thistype.m_hood = ItemType.createSimple('I022', AItemType.equipmentTypeHeaddress)
			call thistype.m_hood.addAbility('A04N', true)
			call thistype.m_hood.addAbility('S003', true)

			set thistype.m_huntingBow = RangeItemType.createSimpleRange('I020', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingBow.addAbility('A07N', true)

			set thistype.m_longBow = RangeItemType.createSimpleRange('I021', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_longBow.addAbility('A19T', true)
			call thistype.m_longBow.addAbility('A07P', true)

			set thistype.m_huntingKnife = ItemType.createSimple('I025', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingKnife.addAbility('A07W', true)
			
			set thistype.m_bootsOfSpeed = ItemType.createSimple('I04M', AItemType.equipmentTypeAmulet)
			call thistype.m_bootsOfSpeed.addAbility('AIms', true)
			
			set thistype.m_quiver = ItemType.createSimple('I04W', AItemType.equipmentTypeAmulet)
			call thistype.m_quiver.addAbility('A160', true)
			

			// artefacts
			set thistype.m_amuletOfForesight = ItemType.createSimple('I02J', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfForesight.addAbility('A08X', true)
			call thistype.m_amuletOfForesight.addAbility('AIuv', true)

			set thistype.m_amuletOfTerror = ItemType.createSimple('I01M', AItemType.equipmentTypeAmulet)

			set thistype.m_swordOfDarkness = ItemType.createSimple('I02K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_swordOfDarkness.addAbility('A095', true)
			call thistype.m_swordOfDarkness.addAbility('S005', true)
			
			set thistype.m_amuletOfStrength = ItemType.createSimple('I04D', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfStrength.addAbility('AIs1', true)
			
			set thistype.m_amuletOfLife = ItemType.createSimple('I04K', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfLife.addAbility('A0VS', true)
			
			set thistype.m_bloodyDragonAxe = ItemType.create('I04E', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, Classes.dragonSlayer())
			call thistype.m_bloodyDragonAxe.addAbility('A0VM', true)
			
			set thistype.m_hornOfFighting = ItemType.createSimple('I04G', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfFighting.addAbility('A1B6', true)
			
			set thistype.m_hornOfLife = ItemType.createSimple('I04I', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfLife.addAbility('A1B7', true)
			
			set thistype.m_hornOfProtection = ItemType.createSimple('I04H', AItemType.equipmentTypeAmulet)
			call thistype.m_hornOfProtection.addAbility('A1B8', true)
			
			set thistype.m_demonSkull = ItemType.create('I04L', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, Classes.necromancer())
			call thistype.m_demonSkull.addAbility('A0VT', true)
			call thistype.m_demonSkull.addAbility('AIi4', true)

			set thistype.m_staffOfFreezing = RangeItemType.createSimpleRange('I04J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfFreezing.addAbility('A0VR', true)
			
			set thistype.m_staffOfSlowing = RangeItemType.createSimpleRange('I04F', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfSlowing.addAbility('A0VL', true)

			// slaughter quest
			set thistype.m_bloodAmulet = ItemType.createSimple('I02L', AItemType.equipmentTypeAmulet)
			call thistype.m_bloodAmulet.addAbility('A1B9', true)

			// Tellborn's items
			set thistype.m_staffOfClarity = RangeItemType.create('I02N', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_staffOfClarity.addAbility('AIrm', true)
			call thistype.m_staffOfClarity.addAbility('A0AD', true)
			call thistype.m_staffOfClarity.addAbility('A19W', true)
			call thistype.m_staffOfClarity.addAbility('AIi4', true)
			
			set thistype.m_shamanMask = ItemType.createSimple('I05V', ItemType.equipmentTypeHeaddress)
			call thistype.m_shamanMask.addAbility('AIi4', true)
			call thistype.m_shamanMask.addAbility('A1AE', true)

			// NEW
			set thistype.m_dagosDagger = ItemType.createSimple('I02O', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dagosDagger.addAbility('A020', true)
			call thistype.m_dagosDagger.addAbility('A021', true)

			set thistype.m_wingsOfDeathAngel = ItemType.createSimple('I02Q', ItemType.equipmentTypeArmour)
			call thistype.m_wingsOfDeathAngel.addAbility('A030', true)
			call thistype.m_wingsOfDeathAngel.addAbility('A02B', true)
			call thistype.m_wingsOfDeathAngel.addAbility('A022', true)

			set thistype.m_vampireNecklace = ItemType.createSimple('I02T', ItemType.equipmentTypeArmour)
			call thistype.m_vampireNecklace.addAbility('AIi4', true)
			call thistype.m_vampireNecklace.addAbility('A03X', true)
			
			set thistype.m_hauntedStaff = RangeItemType.create('I03V', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_hauntedStaff.addAbility('A0B8', true)
			
			// Sisgard's reward
			set thistype.m_necromancerHelmet = ItemType.createSimple('I044', ItemType.equipmentTypeHeaddress)
			call thistype.m_necromancerHelmet.addAbility('A18X', true)
			call thistype.m_necromancerHelmet.addAbility('AIi4', true)
			call thistype.m_necromancerHelmet.addAbility('AIva', false)
			
			// Sisgard's items
			set thistype.m_amuletOfWisdom = ItemType.createSimple('I048', ItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfWisdom.addAbility('AIrm', true)
			
			// Ursuala's items
			set thistype.m_druidCloak = ItemType.createSimple('I015', ItemType.equipmentTypeArmour)
			call thistype.m_druidCloak.addAbility('AIi3', true)
			call thistype.m_druidCloak.addAbility('AId3', true)
			
			set thistype.m_druidStaff = RangeItemType.createSimpleRange('I02X', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_druidStaff.addAbility('A044', false)
			call thistype.m_druidStaff.addAbility('A01K', true)
			
			set thistype.m_staffOfBan = RangeItemType.createSimpleRange('I04Z', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfBan.addAbility('A16F', true)
			call thistype.m_staffOfBan.addAbility('A16G', false)
			
			set thistype.m_druidBoots = ItemType.createSimple('I033', ItemType.equipmentTypeAmulet)
			call thistype.m_druidBoots.addAbility('A04V', true)
			
			// Deranor's artefact
			set thistype.m_deranorsCrownPiece =  ItemType.createSimple('I04A', ItemType.equipmentTypeAmulet)
			call thistype.m_deranorsCrownPiece.addAbility('A1BA', true)
			call thistype.m_deranorsCrownPiece.addAbility('AIx2', true)
			
			// corn eaters items
			set thistype.m_manaAmulet = ItemType.createSimple('I046', ItemType.equipmentTypeAmulet)
			call thistype.m_manaAmulet.addAbility('AIbm', true)
			
			set thistype.m_ringOfProtection2 = ItemType.createSimple('I04C', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfProtection2.addAbility('AId2', true)
			
			// wild creatures
			set thistype.m_amuletOfLore = ItemType.createSimple('I04O', ItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfLore.addAbility('AIi1', true)
			set thistype.m_ringOfProtection3 = ItemType.createSimple('I04P', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfProtection3.addAbility('AId3', true)
			
			// orcs
			set thistype.m_crownOfKarornForest = ItemType.createSimple('I04R', ItemType.equipmentTypeHeaddress)
			call thistype.m_crownOfKarornForest.addAbility('AIi3', true)
			call thistype.m_crownOfKarornForest.addAbility('AId3', true)
			
			set thistype.m_orcAxe = ItemType.createSimple('I04S', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_orcAxe.addAbility('A13T', true)
			call thistype.m_orcAxe.addAbility('A13S', true)
			
			set thistype.m_orcCrossBow = RangeItemType.create('I04T', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_orcCrossBow.addAbility('AItk', true)
			
			// Markward
			set thistype.m_ringOfStrength = ItemType.createSimple('I053', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfStrength.addAbility('AIs3', true)
			set thistype.m_ringOfWisdom = ItemType.createSimple('I052', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfWisdom.addAbility('AIi3', true)
			set thistype.m_ringOfDexterity = ItemType.createSimple('I054', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfDexterity.addAbility('AIa3', true)
			set thistype.m_ringOfLoyality = ItemType.createSimple('I055', ItemType.equipmentTypeAmulet)
			call thistype.m_ringOfLoyality.addAbility('AIx2', true)
			
			// death vault drops
			set thistype.m_deathScythe = ItemType.create('I05B', ItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_deathScythe.addAbility('A17K', true)
			call thistype.m_deathScythe.addAbility('A17L', true)
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
	endstruct

endlibrary