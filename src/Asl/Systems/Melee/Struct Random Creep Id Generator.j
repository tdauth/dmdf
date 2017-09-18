library AStructSystemsMeleeRandomCreepIdGenerator requires AStructSystemsMeleeAbstractIdLevelGenerator

	/**
	* Generates a randomly chosen creep unit type id.
	* Creeps are all units marked as "neutral aggressive".
	* \sa ACreepSpawn, ARandomItemTypeIdGenerator, ARandomNPGenerator
	*/
	struct ARandomCreepIdGenerator extends AAbstractIdLevelGenerator

		public stub method generate takes nothing returns integer
			return ChooseRandomCreep(this.level())
		endmethod
	endstruct

endlibrary