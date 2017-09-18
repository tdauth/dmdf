library AStructSystemsMeleeRandomNPIdGenerator requires AStructSystemsMeleeAbstractIdGenerator

	/**
	* Generates a randomly chosen neutral passive building unit type id.
	* Neutral passive buildings are all units with classification/unit type "neutral" being true.
	* \sa ARandomItemTypeIdGenerator, ARandomCreepIdGenerator, AItemIdItem, ACreepIdItem, ANPIdItem
	*/
	struct ARandomNPIdGenerator extends AAbstractIdGenerator

		public stub method generate takes nothing returns integer
			return ChooseRandomNPBuilding()
		endmethod
	endstruct

endlibrary