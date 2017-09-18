library AStructSystemsMeleeItemTypeIdItem requires AStructSystemsMeleeAbstractIdItem

	/**
	* Represents one single item of an item drop set.
	* \sa AItemDrop
	*/
	struct AItemTypeIdItem extends AAbstractIdItem

		public method setRandom takes integer level, itemtype itemType, integer chance returns nothing
			if (this.isSpecific()) then
				call this.setGenerator(ARandomItemTypeIdGenerator.create(level, itemType))
			else
				call ARandomItemTypeIdGenerator(this.generator()).setLevel(level)
				call ARandomItemTypeIdGenerator(this.generator()).setItemType(itemType)
			endif
			call this.setChance(chance)
		endmethod

		public static method createRandom takes integer level, itemtype itemType, integer chance returns thistype
			local thistype this = thistype.create(0, chance)
			call this.setGenerator(ARandomItemTypeIdGenerator.create(level, itemType))
			return this
		endmethod
	endstruct

endlibrary