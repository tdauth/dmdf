/**
 * Provides a simple signal template struct (oriented on Qt and the Boost signal library).
 * \note Does not support signal return values.
 * \author Tamino Dauth
 */
library AStructCoreGeneralSignal requires AStructCoreGeneralVector, optional ALibraryCoreDebugMisc

	//! textmacro A_SIGNAL takes STRUCTPREFIX, NAME, PARAMETERS, PARAMETERNAMES
		function interface $NAME$FunctionInterface takes $PARAMETERS$ returns nothing

		$STRUCTPREFIX$ struct $NAME$
			private AIntegerVector m_slots
			private ABooleanVector m_slotIsBlocked

			public method connect takes $NAME$FunctionInterface slot returns integer
				call this.m_slots.pushBack(slot)
				call this.m_slotIsBlocked.pushBack(false)
				return this.m_slots.backIndex()
			endmethod

			public method disconnectByIndex takes integer index returns nothing
				call this.m_slots.erase(index)
				call this.m_slotIsBlocked.erase(index)
			endmethod

			public method disconnect takes $NAME$FunctionInterface slot returns integer
				local integer index = this.m_slots.find(slot)
				if (index != -1) then
					call this.disconnectByIndex(index)
				endif
				return index
			endmethod

			public method isConnected takes $NAME$FunctionInterface slot returns boolean
				return this.m_slots.contains(slot)
			endmethod

			public method isBlocked takes $NAME$FunctionInterface slot returns boolean
				local integer index = this.m_slots.find(slot)
				if (index == -1) then
					debug call Print("Can't check if slot is blocked because it does not exist.")
					return true
				endif
				return this.m_slotIsBlocked[index]
			endmethod

			public method isBlockedByIndex takes integer index returns boolean
				return this.m_slotIsBlocked[index]
			endmethod

			public method emit takes $PARAMETERS$ returns nothing
				local integer i = 0
				loop
					exitwhen (i == this.m_slots.size())
					if (not this.m_slotIsBlocked[i]) then
						call $NAME$FunctionInterface(this.m_slots[i]).execute($PARAMETERNAMES$)
					endif
					set i = i + 1
				endloop
			endmethod

			public static method create takes nothing returns thistype
				local thistype this = thistype.allocate()
				set this.m_slots = AIntegerVector.create()
				set this.m_slotIsBlocked = ABooleanVector.create()

				return this
			endmethod

			public method onDestroy takes nothing returns nothing
				call this.m_slots.destroy()
				call this.m_slotIsBlocked.destroy()
			endmethod
		endstruct
	//! endtextmacro

endlibrary