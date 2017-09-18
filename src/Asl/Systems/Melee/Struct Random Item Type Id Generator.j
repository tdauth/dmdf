library AStructSystemsMeleeRandomItemTypeIdGenerator requires AStructSystemsMeleeAbstractIdLevelGenerator

	/**
	* Allows you to generate a random item type id with specified item type and level as optional criterion.
	* \sa ARandomCreepGenerator, ARandomNPGenerator
	*/
	struct ARandomItemTypeIdGenerator extends AAbstractIdLevelGenerator
		private itemtype m_itemType // ITEM_TYPE_ANY is random

		/**
		* \param itemType ITEM_TYPE_ANY means random.
		*/
		public method setItemType takes itemtype itemType returns nothing
			set this.m_itemType = itemType
		endmethod

		public method itemType takes nothing returns itemtype
			return this.m_itemType
		endmethod

		public stub method generate takes nothing returns integer
			return ChooseRandomItemEx(this.itemType(), this.level())
		endmethod

		/**
		* @copydoc AAbstractIdLevelGenerator#setLevel
		* @copydoc ARandomItemTypeIdGenerator#setItemType
		*/
		public static method create takes integer level, itemtype itemType returns thistype
			local thistype this = thistype.allocate(level)
			set this.m_itemType = itemType

			return this
		endmethod
	endstruct

endlibrary