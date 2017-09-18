library AStructSystemsMeleeIdSet requires AStructCoreGeneralList, AStructSystemsMeleeAbstractIdItem

	/**
	 * \brief List of \ref AAbstractIdItem instances.
	 * One single set can only generate one single id from multiple id items.
	 * For multiple id generation use #AIdTable.
	 * \sa AAbstractIdItem, AIdTable
	 * \todo Should actually be a set not a list.
	 */
	struct AIdSet extends AIntegerList

		public method addItem takes AAbstractIdItem idItem returns nothing
			call this.pushBack(idItem)
		endmethod

		public method removeItem takes AAbstractIdItem idItem returns nothing
			call this.remove(idItem)
		endmethod

		/**
		 * \return Returns the sum of all item chances.
		 * \note In Warcraft III for creep spots this is usually automatically 100 % if there is at least one item in the set.
		 */
		public method totalChance takes nothing returns integer
			local AIntegerListIterator iterator = this.begin()
			local integer total = 0
			loop
				exitwhen (not iterator.isValid())
				set total = total + AAbstractIdItem(iterator.data()).chance()
				call iterator.next()
			endloop
			call iterator.destroy()
			return total
		endmethod

		/**
		 * \return Returns 0 if no valid item id was found.
		 */
		public method generate takes nothing returns integer
			local integer sum
			local integer chance
			local AIntegerListIterator iterator
			local integer result
			if (this.empty()) then
				return 0
			endif
			// http://stackoverflow.com/questions/1761626/weighted-random-numbers
			set sum = this.totalChance()
			set chance = GetRandomInt(0, sum - 1)
			set iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (chance < AAbstractIdItem(iterator.data()).chance()) then
					set result = AAbstractIdItem(iterator.data()).generate()
					debug call Print("Generated randomly: " + GetObjectName(result))
					return result
				endif
				set chance = chance - AAbstractIdItem(iterator.data()).chance()
				call iterator.next()
			endloop
			call iterator.destroy()
			
			debug call Print("Error: Did not find any ID in set " + I2S(this))

			return 0
		endmethod
	endstruct

endlibrary