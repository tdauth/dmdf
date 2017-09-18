library AStructSystemsMeleeNPIdItem requires AStructSystemsMeleeAbstractIdItem, AStructSystemsMeleeRandomNPIdGenerator

	/**
	 * \brief Id item which uses \ref ARandomNPIdGenerator as generator.
	 * \sa AItemIdItem, ACreepIdItem
	 */
	struct ANPIdItem extends AAbstractIdItem

		public method setRandom takes integer chance returns nothing
			if (this.isSpecific()) then
				call this.setGenerator(ARandomNPIdGenerator.create())
			endif
			call this.setChance(chance)
		endmethod

		public static method createRandom takes integer chance returns thistype
			local thistype this = thistype.create(0, chance)
			call this.setGenerator(ARandomNPIdGenerator.create())
			return this
		endmethod
	endstruct

endlibrary