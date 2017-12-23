library AStructSystemsInventoryItemType requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector, ALibraryCoreMathsConversion, ALibraryCoreInterfaceMisc

	/**
	 * \brief Represents a custom item type corresponding to one item type ID of Warcraft III like 'I000'.
	 * Custom item types have to exist during the whole game.
	 * They provide more information about item types than is reachable by default JASS item natives.
	 * You can add some usual item type requirements such as hero strength, level etc. for carrying an item of a custom item type
	 * as equipment.
	 * Besides you can specify all item type abilities to get real inventory support since
	 * permanent abilities have to be added to the unit when backpack/equipment is closed.
	 * Non-equipment item types usually do not have to be created explicitly. If an item type ID
	 * has no custom item type it is treated like a usual backpack item.
	 * \note The requirement is only checked by \ref AUnitInventory when item is equipped, not when it is added to the backpack!
	 * \note The hash table key \ref A_HASHTABLE_GLOBAL_KEY_ITEMTYPES is used to store custom item types for corresponding item type IDs.
	 * \todo Add struct AEquipmentType as more abstract type, to allow more than the 5 equipment types.
	 */
	struct AItemType
		// static constant members
		/// Use this as equipment type if it's a backpack item only and cannot be equipped.
		public static constant integer equipmentTypeNone = -1
		public static constant integer equipmentTypeHeaddress = 0
		public static constant integer equipmentTypeArmour = 1
		public static constant integer equipmentTypePrimaryWeapon = 2
		public static constant integer equipmentTypeSecondaryWeapon = 3
		public static constant integer equipmentTypeAmulet = 4
		// static construction members
		private static string textLevel
		private static string textStrength
		private static string textAgility
		private static string textIntelligence
		// construction members
		private integer m_itemTypeId
		private integer m_equipmentType
		private integer m_requiredLevel
		private integer m_requiredStrength
		private integer m_requiredAgility
		private integer m_requiredIntelligence
		// members
		private AIntegerVector m_abilities

		//! runtextmacro optional A_STRUCT_DEBUG("\"AItemType\"")

		// construction members

		public method itemTypeId takes nothing returns integer
			return this.m_itemTypeId
		endmethod

		public method equipmentType takes nothing returns integer
			return this.m_equipmentType
		endmethod

		public method requiredLevel takes nothing returns integer
			return this.m_requiredLevel
		endmethod

		public method requiredStrength takes nothing returns integer
			return this.m_requiredStrength
		endmethod

		public method requiredAgility takes nothing returns integer
			return this.m_requiredAgility
		endmethod

		public method requiredIntelligence takes nothing returns integer
			return this.m_requiredIntelligence
		endmethod

		// methods

		/**
		 * Adds an ability to the custom item type by its ID.
		 * Abilities are added to the unit when it has an item equipped of the corresponding item type and opens the backpack.
		 * Besides it is removed when the item is not equipped to make sure the item only affects the unit when it is equipped.
		 * \param abilityId The ID of the ability which is being added. For example 'A000'.
		 * \return Returns the index of the added element in the vector of abilities.
		 */
		public method addAbility takes integer abilityId returns integer
			call this.m_abilities.pushBack(abilityId)
			return this.m_abilities.backIndex()
		endmethod

		/**
		 * This method can be overwritten to check requirements manually.
		 * It is used by \ref AUnitInventory for instance and called to check if the unit \p whichUnit can carry an item
		 * of this item type as equipment.
		 * \note It is not used when an item is picked up into the backpack.
		 * \param whichUnit The unit for which the requirements of this item type are checked.
		 * \return Returns true if the item of this item type can be carried as equipment. Returns false if not.
		 */
		public stub method checkRequirement takes unit whichUnit returns boolean
			if (GetHeroLevel(whichUnit) < this.m_requiredLevel) then
				call SimError(GetOwningPlayer(whichUnit), thistype.textLevel)
				return false
			elseif (GetHeroStr(whichUnit, true) < this.m_requiredStrength) then
				call SimError(GetOwningPlayer(whichUnit), thistype.textStrength)
				return false
			elseif (GetHeroAgi(whichUnit, true) < this.m_requiredAgility) then
				call SimError(GetOwningPlayer(whichUnit), thistype.textAgility)
				return false
			elseif (GetHeroInt(whichUnit, true) < this.m_requiredIntelligence) then
				call SimError(GetOwningPlayer(whichUnit), thistype.textIntelligence)
				return false
			endif
			return true
		endmethod

		/**
		 * This method is called automatically by \ref AUnitInventory whenever an item is being equipped.
		 * You may overwrite this method to add additionally behaviour.
		 * This method is called by .evaluate() to allow TriggerSleepAction calls.
		 */
		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
		endmethod

		/**
		 * This method is called automatically by \ref AUnitInventory whenever an item is being unequipped.
		 * You may overwrite this method to add additionally behaviour.
		 * This method is called by .evaluate() to allow TriggerSleepAction calls.
		 */
		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
		endmethod

		/**
		 * This method is called automatically by .evaluate() whenever the abilities are being added to a unit.
		 * \param who The unit to which the abilities are added.
		 */
		public stub method onAddAbilities takes unit who returns nothing
		endmethod

		/**
		 * Adds the abilities of the item type to the unit \p who.
		 * \param who The unit to which the abilities are added.
		 * \note The abilities are added permanently. On unit transformations they are kept. One must remove them explicitly.
		 */
		public method addAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				debug call this.print("Adding ability " + GetObjectName(this.m_abilities[i]) + " to unit " + GetUnitName(who))
				call UnitAddAbility(who, this.m_abilities[i])
				// keep on unit transformation
				call UnitMakeAbilityPermanent(who, true, this.m_abilities[i])
				set i = i + 1
			endloop
			call this.onAddAbilities.evaluate(who)
		endmethod

		/**
		 * This method is called automatically by .evaluate() whenever the abilities are removed from to a unit.
		 * \param who The unit from which the abilities are removed.
		 */
		public stub method onRemoveAbilities takes unit who returns nothing
		endmethod

		/**
		 * Removes the abilities of the item type from the unit \p who.
		 * \param who The unit from which the abilities are removed.
		 */
		public method removeAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				call UnitRemoveAbility(who, this.m_abilities[i])
				set i = i + 1
			endloop
			call this.onRemoveAbilities.evaluate(who)
		endmethod

		/**
		 * Creates a new custom item type for a corresponding item type ID of Warcraft III.
		 * Each custom item type is associated with an item type ID when it is created.
		 * Each item type ID should only have one custom item type!
		 * \param itemTypeId The item type ID for which the custom item type is created. For example 'I000'.
		 * \param equipmentType If this value is -1 (\ref AItemType.equipmentTypeNone) it will always be added to the backpack.
		 * \param requiredLevel The minimum required hero level to carry an item of this item type as equipment item. If it is no equipment item type this value is ignored.
		 * \param requiredStrength The minimum required hero strength to carry an item of this item type as equipment item. If it is no equipment item type this value is ignored.
		 * \param requiredAgility The minimum required hero agility to carry an item of this item type as equipment item. If it is no equipment item type this value is ignored.
		 * \param requiredIntelligence The minimum required hero intelligence to carry an item of this item type as equipment item. If it is no equipment item type this value is ignored.
		 * \return Returns a newly allocated custom item type instance.
		 */
		public static method create takes integer itemTypeId, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_itemTypeId = itemTypeId
			set this.m_equipmentType = equipmentType
			set this.m_requiredLevel = requiredLevel
			set this.m_requiredStrength = requiredStrength
			set this.m_requiredAgility = requiredAgility
			set this.m_requiredIntelligence = requiredIntelligence
			// members
			set this.m_abilities = AIntegerVector.create()

			debug if (AGlobalHashTable.global().hasInteger(A_HASHTABLE_GLOBAL_KEY_ITEMTYPES, itemTypeId)) then
				debug call this.print("Item type " + I2S(itemTypeId) + " already has a custom item type.")
			debug endif
			call AGlobalHashTable.global().setInteger(A_HASHTABLE_GLOBAL_KEY_ITEMTYPES, itemTypeId, this)
			return this
		endmethod

		/**
		 * A simplified constructor which has no requirements as parameter.
		 */
		public static method createSimple takes integer itemTypeId, integer equipmentType returns thistype
			return thistype.create(itemTypeId, equipmentType, 0, 0, 0, 0)
		endmethod

		/// Custom item types should never be destroyed since they're heavily used by systems like \ref AUnitInventory at game runtime (equipment).
		private method onDestroy takes nothing returns nothing
			// members
			call this.m_abilities.destroy()

			call AGlobalHashTable.global().removeInteger(A_HASHTABLE_GLOBAL_KEY_ITEMTYPES, this.m_itemTypeId)
		endmethod

		/**
		 * Initializes the system and sets static variables which are required by all instances.
		 * \param textLevel This text is shown whenever the hero level of the equipping unit is lower than the required one.
		 * \param textStrength This text is shown whenever the strength of the equipping unit is lower than the required strength.
		 * \param textAgility This text is shown whenever the agility of the equipping unit is lower than the required agility.
		 * \param textIntelligence This text is shown whenever the intelligence of the equipping unit is lower than the required intelligence.
		 */
		public static method init takes string textLevel, string textStrength, string textAgility, string textIntelligence returns nothing
			// static construction members
			set thistype.textLevel = textLevel
			set thistype.textStrength = textStrength
			set thistype.textAgility = textAgility
			set thistype.textIntelligence = textIntelligence
		endmethod

		/**
		 * Checks whether the item type ID has a corresponding custom item type.
		 * \param itemTypeId The item type ID for which it is checked if there exists a custom item type.
		 * \return Returns true if there exists a custom item type. Returns false if there exists none.
		 */
		public static method itemTypeIdHasItemType takes integer itemTypeId returns boolean
			return AGlobalHashTable.global().hasInteger(A_HASHTABLE_GLOBAL_KEY_ITEMTYPES, itemTypeId)
		endmethod

		/**
		 * Returns the custom item type for an item type ID if there exists one.
		 * Every item type ID can have exactly one corresponding custom item type.
		 * \param itemTypeId The custom item type is returned corresponding to this item type ID.
		 * \return Returns the corresponding custom item type of the item type ID. If there is none it returns 0.
		 */
		public static method itemTypeOfItemTypeId takes integer itemTypeId returns thistype
			return AGlobalHashTable.global().integer(A_HASHTABLE_GLOBAL_KEY_ITEMTYPES, itemTypeId)
		endmethod

		/**
		 * Helper method for \ref itemTypeOfItemTypeId(). which uses the item type ID of the passed item.
		 * \param whichItem The item type ID of this item is used to return its custom item type.
		 * \return Returns the corresponding custom item type of the item type ID. If there is none it returns 0.
		 */
		public static method itemTypeOfItem takes item whichItem returns thistype
			return thistype.itemTypeOfItemTypeId(GetItemTypeId(whichItem))
		endmethod
	endstruct

endlibrary