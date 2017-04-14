library StructGameOrderAnimations requires Asl, StructGameDmdfHashTable, StructGameCharacter, StructGameItemTypes

	/**
	 * \brief Handles attack animations of the Villager255 model. Whenever the unit attacks the attack animation is replaced depending on the equipped items.
	 *
	 * This can be used for copies of a character unit as well as illusions.
	 * Otherwise animations of the copy in videos and illusions from spells won't be played properly!
	 */
	struct OrderAnimations
		private Character m_character
		private unit m_unit

		public method setUnit takes unit whichUnit returns nothing
			set this.m_unit = whichUnit
		endmethod

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		/**
		 * Since the Villager255 model is used, animation indices have to be set manually depending on the weapon.
		 * In this trigger the attack animation of the character is determined.
		 */
		private trigger m_animationOrderTrigger

		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return this.unit() == GetAttacker()
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AUnitInventory inventory = this.m_character.inventory()
			local AIntegerVector values = 0
			/*
			 * If the character is morphed it has not the villager255 model.
			 * Illusions are only created from non-morphed characters.
			 */
			if (not this.m_character.isMorphed() or IsUnitIllusion(this.unit())) then
				// Attack 1 - 15, no weapon
				if (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) == 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(13, 20))
					//debug call Print("Attack without weapon")
				// Attack Alternate 1 - 9, two handed sword
				elseif (false) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(27, 29))
				// Attack Defend 1 - 2, attack with buckler
				// basically this should be already provided by the animation tag "defend"
				elseif (inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and ItemTypes.itemTypeIdIsBuckler(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 112)
					//debug call Print("Attack with buckler")
				// Attack throw 6 - 7, bow
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsBow(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(122, 123))
					//debug call Print("Attack with bow")
				// throwing spear
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsThrowingSpear(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 118) //  119
					//debug call Print("Attack with a throwing spear")
				// attacking with spear in melee
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsMeleeSpear(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 117)
					//debug call Print("Attack with spear in melee")
				// attacking with two handed lance
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedLance(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 61)
					//debug call Print("Attack with two handed lance")
				// attacking with two handed hammer
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedHammer(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 62)
					//debug call Print("Attack with two handed hammer")
				// attack with a weapon in each hand -> no buckler in right hand
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and not ItemTypes.itemTypeIdIsBuckler(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					// attack either with left or right hand TODO animation for both hands?
					set values = AIntegerVector.create()
					call values.pushBack(21)
					call values.pushBack(22)
					call values.pushBack(40)
					call values.pushBack(41)
					call values.pushBack(23)
					call values.pushBack(24)
					call values.pushBack(25)
					call values.pushBack(26)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					//debug call Print("Attack with two weapons")
				// Attack with one left handed weapon
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					set values = AIntegerVector.create()
					call values.pushBack(21)
					call values.pushBack(41)
					call values.pushBack(42)
					call values.pushBack(23)
					call values.pushBack(25)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					//debug call Print("Attack with one left handed weapon")
				// Attack with one right handed weapon
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) == 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and not ItemTypes.itemTypeIdIsBuckler(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					set values = AIntegerVector.create()
					call values.pushBack(22)
					call values.pushBack(39)
					call values.pushBack(40)
					call values.pushBack(24)
					call values.pushBack(26)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					//debug call Print("Attack with one right handed weapon")
				debug else
					debug call Print("Unknown attack style! Implement animation!")
				endif
			endif
		endmethod

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_unit = whichUnit

			set this.m_animationOrderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_animationOrderTrigger, EVENT_PLAYER_UNIT_ATTACKED)
			call TriggerAddCondition(this.m_animationOrderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_animationOrderTrigger, function thistype.triggerActionOrder)
			call DmdfHashTable.global().setHandleInteger(this.m_animationOrderTrigger, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_animationOrderTrigger)
			set this.m_animationOrderTrigger = null
		endmethod
	endstruct

endlibrary