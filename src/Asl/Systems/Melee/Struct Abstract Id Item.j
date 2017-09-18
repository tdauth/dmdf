library AStructSystemsMeleeAbstractIdItem requires AStructSystemsMeleeAbstractIdGenerator

	/**
	 * Provides an item of an item set (\ref AIdSet) which can either be a specific or random object id.
	 * Random ids can be influenced by corresponding criteria of the created generator (e. g. a unit's level).
	 * To use your customized id generator structure you should implement a method called setRandom which gets all required filter criteria and sets the generator.
	 * \sa AAbstractIdGenerator, AIdSet, AIdTable
	 */
	struct AAbstractIdItem
		private integer m_id
		private integer m_chance
		private AAbstractIdGenerator m_generator
		
		/// @todo Has to be protected!
		public method setId takes integer id returns nothing
			set this.m_id = id
		endmethod

		/// @todo Has to be protected!
		public method setChance takes integer chance returns nothing
			set this.m_chance = chance
		endmethod

		/// @todo Has to be protected!
		public method setGenerator takes AAbstractIdGenerator generator returns nothing
			set this.m_generator = generator
		endmethod

		/// @todo Has to be protected!
		public method generator takes nothing returns AAbstractIdGenerator
			return this.m_generator
		endmethod

		public method id takes nothing returns integer
			return this.m_id
		endmethod

		public method chance takes nothing returns integer
			return this.m_chance
		endmethod

		/**
		 * \return Returns true if the item does not use any generator to generate the ID randomly. Otherwise it returns false.
		 * If it is specific it uses \ref id() as ID.
		 */
		public method isSpecific takes nothing returns boolean
			return this.m_generator == 0
		endmethod

		public method isRandom takes nothing returns boolean
			return this.m_generator != 0
		endmethod
		
		public stub method generate takes nothing returns integer
			if (this.isRandom()) then
				return this.m_generator.generate()
			endif
			return this.m_id
		endmethod

		public stub method setSpecific takes integer id, integer chance returns nothing
			call this.setId(id)
			call this.setChance(chance)
		endmethod

		public static method create takes integer id, integer chance returns thistype
			local thistype this = thistype.allocate()
			set this.m_id = id
			set this.m_chance = chance
			set this.m_generator = 0
			return this
		endmethod
		
		public static method createWithGenerator takes AAbstractIdGenerator generator, integer chance returns thistype
			local thistype this = thistype.allocate()
			set this.m_id = 0
			set this.m_chance = chance
			set this.m_generator = generator
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary