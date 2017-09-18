library AStructSystemsMeleeCreepIdItem requires AStructSystemsMeleeAbstractIdItem, AStructSystemsMeleeRandomCreepIdGenerator

	/**
	* Can by used by \ref AUnitSpawn to spawn randomly chosen or user-specified creeps.
	* \sa AUnitSpawn, ANPIdItem
	*/
	struct ACreepIdItem extends AAbstractIdItem

		public method setRandom takes integer level, integer chance returns nothing
			if (this.isSpecific()) then
				call this.setGenerator(ARandomCreepIdGenerator.create(level))
			else
				call AAbstractIdLevelGenerator(this.generator()).setLevel(level)
			endif
			call this.setChance(chance)
		endmethod

		public static method createRandom takes integer level, integer chance returns thistype
			local thistype this = thistype.create(0, chance)
			call this.setGenerator(ARandomCreepIdGenerator.create(level))
			return this
		endmethod
	endstruct

endlibrary