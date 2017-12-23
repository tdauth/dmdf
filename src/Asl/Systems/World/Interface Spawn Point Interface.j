library AInterfaceSystemsWorldSpawnPointInterface

	/**
	 * Abstract spawn point interface which may be useful for generic code.
	 * \sa AItemSpawnPoint, ASpawnPoint
	 */
	interface ASpawnPointInterface
		public method remainingTime takes nothing returns real defaults 0.0
		public method runs takes nothing returns boolean defaults false
		public method pause takes nothing returns boolean defaults false
		public method resume takes nothing returns boolean defaults false
		public method isEnabled takes nothing returns boolean defaults false
		public method enable takes nothing returns nothing
		public method disable takes nothing returns nothing
		public method spawn takes nothing returns boolean defaults false
	endinterface

endlibrary