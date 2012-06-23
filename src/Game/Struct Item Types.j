library StructGameItemTypes requires Asl, StructGameClasses

	/**
	* Provides advanced information for GUI inventories etc.
	*/
	struct ItemType extends AItemType
		// dynamic members
		private integer m_goldCost
		private string m_iconFilePath
		private string m_name
		private string m_description

		public method setGoldCost takes integer goldCost returns nothing
			set this.m_goldCost = goldCost
		endmethod

		public method goldCost takes nothing returns integer
			return this.m_goldCost
		endmethod

		public method setIconFilePath takes string iconFilePath returns nothing
			set this.m_iconFilePath = iconFilePath
		endmethod

		public method iconFilePath takes nothing returns string
			return this.m_iconFilePath
		endmethod

		public method setName takes string name returns nothing
			set this.m_name = name
		endmethod

		public method name takes nothing returns string
			return this.m_name
		endmethod

		public method setDescription takes string description returns nothing
			set this.m_description = description
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod

		public static method create takes integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns thistype
			local thistype this = thistype.allocate(itemType, equipmentType, requiredLevel, requiredStrength, requiredAgility, requiredIntelligence, requiredClass)
			set this.m_goldCost = 0
			set this.m_iconFilePath = ""
			set this.m_name = ""
			set this.m_description = ""
			return this
		endmethod
	endstruct

	/// Do not add usable abilities, only permanents!
	struct ItemTypes
		private static ItemType m_preciousClericHelmet
		private static ItemType m_bigDoubleAxe
		private static ItemType m_vassalLance
		private static ItemType m_ricmansShield
		private static ItemType m_ricmansSpear
		private static ItemType m_ringOfLatency
		private static ItemType m_staffOfNecromancer
		private static ItemType m_staffOfWizard
		private static ItemType m_expandedShield
		private static ItemType m_axe
		private static ItemType m_woodenShield
		private static ItemType m_lightWoodenShield
		private static ItemType m_protectionRing
		private static ItemType m_heavyWoodenShield
		private static ItemType m_staff
		private static ItemType m_vassalShield
		private static ItemType m_mace
		private static ItemType m_morningStar
		private static ItemType m_halberd
		private static ItemType m_shortsword
		private static ItemType m_longsword
		private static ItemType m_magicAmulet
		private static ItemType m_magicCoat
		private static ItemType m_magicHat
		private static ItemType m_magicRing
		private static ItemType m_bonesBow
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
		private static ItemType m_largeRoundedBuckler
		private static ItemType m_dart
		// Wieland's items
		private static ItemType m_knightsArmour
		private static ItemType m_bascinet
		private static ItemType m_greatHelm
		// Björn's items
		private static ItemType m_cloak
		private static ItemType m_hood
		private static ItemType m_huntingBow
		private static ItemType m_longBow
		private static ItemType m_huntingKnife
		// artefacts
		private static ItemType m_amuletOfForesight
		private static ItemType m_amuletOfTerror
		private static ItemType m_swordOfDarkness
		// slaughter quest
		private static ItemType m_bloodAmulet
		// Tellborn's items
		private static ItemType m_staffOfClarity
		// NEW
		private static ItemType m_dagosDagger
		private static ItemType m_wingsOfDeathAngel
		private static ItemType m_vampireWarp

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			//integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns AItemType
			set thistype.m_preciousClericHelmet = ItemType.createSimple('I00I', AItemType.equipmentTypeHeaddress)
			call thistype.m_preciousClericHelmet.addAbility('A02E', true)

			set thistype.m_bigDoubleAxe = ItemType.createSimple('I00J', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bigDoubleAxe.addAbility('A02F', true)
			call thistype.m_bigDoubleAxe.addAbility('AIcs', true)

			set thistype.m_vassalLance = ItemType.createSimple('I00K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_vassalLance.addAbility('A02G', true)

			set thistype.m_ricmansShield = ItemType.createSimple('I00M', AItemType.equipmentTypeSecondaryWeapon)
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

			set thistype.m_expandedShield = ItemType.create('I006', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_expandedShield.addAbility('A01S', true)

			set thistype.m_axe = ItemType.create('I00Q', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_axe.addAbility('A02P', true)

			set thistype.m_woodenShield = ItemType.create('I005', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_woodenShield.addAbility('A01T', true)

			set thistype.m_lightWoodenShield = ItemType.create('I00N', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_lightWoodenShield.addAbility('A02M', true)

			set thistype.m_protectionRing = ItemType.create('I00W', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_protectionRing.addAbility('AId3', true)

			set thistype.m_heavyWoodenShield = ItemType.create('I00O', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_heavyWoodenShield.addAbility('A016', true)

			set thistype.m_staff = ItemType.create('I003', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_staff.addAbility('A02L', true)

			set thistype.m_vassalShield = ItemType.create('I00Y', AItemType.equipmentTypeSecondaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_vassalShield.addAbility('A049', true)

			set thistype.m_mace = ItemType.create('I011', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_mace.addAbility('A04L', true)

			set thistype.m_morningStar = ItemType.create('I014', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_morningStar.addAbility('A04O', true)

			set thistype.m_halberd = ItemType.create('I01X', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_halberd.addAbility('A07G', true)
			call thistype.m_halberd.addAbility('A07Q', true)

			set thistype.m_shortsword = ItemType.createSimple('I01Y', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_shortsword.addAbility('A07H', true)

			set thistype.m_longsword = ItemType.create('I012', AItemType.equipmentTypePrimaryWeapon, 0, 0, 0, 0, 0)
			call thistype.m_longsword.addAbility('A04M', true)

			set thistype.m_magicAmulet = ItemType.create('I01Q', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicAmulet.addAbility('AI2m', true)
			call thistype.m_magicAmulet.addAbility('ANss', true)

			set thistype.m_magicCoat = ItemType.create('I01R', AItemType.equipmentTypeArmour, 0, 0, 0, 0, 0)
			call thistype.m_magicAmulet.addAbility('AIrm', true)
			call thistype.m_magicAmulet.addAbility('A06I', true)

			set thistype.m_magicHat = ItemType.create('I01S', AItemType.equipmentTypeHeaddress, 0, 0, 0, 0, 0)
			call thistype.m_magicHat.addAbility('AImv', true)
			call thistype.m_magicHat.addAbility('A06H', true)
			call thistype.m_magicHat.addAbility('A06G', true)

			set thistype.m_magicRing = ItemType.create('I01P', AItemType.equipmentTypeAmulet, 0, 0, 0, 0, 0)
			call thistype.m_magicRing.addAbility('AImz', true)
			call thistype.m_magicRing.addAbility('AIi3', true)

			/// \todo two-handed
			set thistype.m_bonesBow = ItemType.createSimple('I013', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_bonesBow.addAbility('A07M', true)

			set thistype.m_torch = ItemType.createSimple('I02G', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_torch.addAbility('A088', true)
			call thistype.m_torch.addAbility('A087', true)

			set thistype.m_bannerOfTheBlackLegion = ItemType.createSimple('I01B', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheBlackLegion.addAbility('A058', true)

			set thistype.m_bannerOfTheWhiteLegion = ItemType.createSimple('I01C', ItemType.equipmentTypeAmulet)
			call thistype.m_bannerOfTheWhiteLegion.addAbility('A059', true)

			set thistype.m_circleOfElements = ItemType.createSimple('I02H', ItemType.equipmentTypePrimaryWeapon)
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

			set thistype.m_dart = ItemType.createSimple('I029', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dart.addAbility('A080', true)

			// Wieland's items
			set thistype.m_knightsArmour = ItemType.createSimple('I026', AItemType.equipmentTypeArmour)
			call thistype.m_knightsArmour.addAbility('A07X', true)

			set thistype.m_bascinet = ItemType.createSimple('I027', AItemType.equipmentTypeHeaddress)
			call thistype.m_bascinet.addAbility('A07Y', true)

			set thistype.m_greatHelm = ItemType.createSimple('I028', AItemType.equipmentTypeHeaddress)
			call thistype.m_greatHelm.addAbility('A07Z', true)

			// Björn's items
			set thistype.m_cloak = ItemType.createSimple('I023', AItemType.equipmentTypeArmour)
			call thistype.m_cloak.addAbility('A07R', true)
			call thistype.m_cloak.addAbility('A07S', true)

			set thistype.m_hood = ItemType.createSimple('I022', AItemType.equipmentTypeHeaddress)
			call thistype.m_hood.addAbility('A04N', true)
			call thistype.m_hood.addAbility('S003', true)

			set thistype.m_huntingBow = ItemType.createSimple('I020', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingBow.addAbility('A07N', true)

			set thistype.m_longBow = ItemType.createSimple('I021', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_longBow.addAbility('A07O', true)
			call thistype.m_longBow.addAbility('A07P', true)

			set thistype.m_huntingKnife = ItemType.createSimple('I025', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_huntingKnife.addAbility('A07W', true)
			
			// artefacts
			set thistype.m_amuletOfForesight = ItemType.createSimple('I02J', AItemType.equipmentTypeAmulet)
			call thistype.m_amuletOfForesight.addAbility('A08X', true)
			call thistype.m_amuletOfForesight.addAbility('AIuv', true)
		
			set thistype.m_amuletOfTerror = ItemType.createSimple('I01M', AItemType.equipmentTypeAmulet)
			
			set thistype.m_swordOfDarkness = ItemType.createSimple('I02K', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_swordOfDarkness.addAbility('A095', true)
			call thistype.m_swordOfDarkness.addAbility('S005', true)
			
			// slaughter quest
			set thistype.m_bloodAmulet = ItemType.createSimple('I02L', AItemType.equipmentTypeAmulet)
			call thistype.m_bloodAmulet.addAbility('A09V', true)
			
			// Tellborn's items
			set thistype.m_staffOfClarity = ItemType.createSimple('I02N', AItemType.equipmentTypePrimaryWeapon)
			call thistype.m_staffOfClarity.addAbility('AIrm', true)
			call thistype.m_staffOfClarity.addAbility('A0AD', true)
			call thistype.m_staffOfClarity.addAbility('A0AE', true)
			call thistype.m_staffOfClarity.addAbility('AIi4', true)
			
			// NEW
			set thistype.m_dagosDagger = ItemType.createSimple('I02O', ItemType.equipmentTypePrimaryWeapon)
			call thistype.m_dagosDagger.addAbility('A020', true)
			call thistype.m_dagosDagger.addAbility('A021', true)
			
			set thistype.m_wingsOfDeathAngel = ItemType.createSimple('I02Q', ItemType.equipmentTypeArmour)
			call thistype.m_wingsOfDeathAngel.addAbility('A030', true)
			call thistype.m_wingsOfDeathAngel.addAbility('A02B', true)
			call thistype.m_wingsOfDeathAngel.addAbility('A022', true)
			
			set thistype.m_vampireWarp = ItemType.createSimple('I02T', ItemType.equipmentTypeArmour)
			call thistype.m_vampireWarp.addAbility('AIi4', true)
			call thistype.m_vampireWarp.addAbility('A03X', true)
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