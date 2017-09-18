library AStructCoreGeneralGroup requires AStructCoreGeneralVector, ALibraryCoreGeneralUnit

	/**
	 * \brief This structure is a kind of wrapper for data type \ref group.
	 * Since \ref group does not allow direct accesses to internally stored units it's
	 * very annoying to get any group member which is not the first one.
	 * You'll always have to iterate the whole group, remove the first member and copying it into
	 * another group which should replace your first one in the end since \ref FirstOfGroup() is the only function
	 * which is available to access any member.
	 * This process has to go on until you found your required unit.
	 * Another possibility is to use filters but they have to be global functions and therefore
	 * you will either have to attach data anywhere or have to use a global variable.
	 * Instead of using filter functions this struct allows you direct access to a vector
	 * which contains all units.
	 * Additionally it provides various \ref thistype#addGroup methods which do use the \ref GroupEnum functions from JASS.
	 * Methods like \ref thistype#removeUnitsOfPlayer or \ref thistype#removeAlliesOfUnit are very useful for spell functions.
	 * The only disadvantage of this struct its decreased performance compared to native type \ref group (especially when adding other groups e. g. by using \ref thistypep#addUnitsOfType).
	 * \sa AForce
	 * \sa wrappers
	 */
	struct AGroup
		// members
		private AUnitVector m_units

		// members

		public method units takes nothing returns AUnitVector
			return this.m_units
		endmethod

		// methods

		/**
		 * Fills an existing Warcraft-3-like group with all members of the group.
		 * \param whichGroup Group which is filled with all group members.
		 */
		public method fillGroup takes group whichGroup returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				call GroupAddUnit(whichGroup, this.m_units[i])
				set i = i + 1
			endloop
		endmethod

		/**
		 * Creates a new Warcraft-III-like group from the group.
		 * \return Returns a newly created group.
		 */
		public method group takes nothing returns group
			local group whichGroup = CreateGroup()
			call this.fillGroup(whichGroup)
			return whichGroup
		endmethod

		/**
		 * Simple forEach wrapper (equal to units.forEach).
		 */
		public method forGroup takes AUnitVectorUnaryFunction forFunction returns nothing
			call this.m_units.forEach(forFunction)
		endmethod
		
		/**
		 * Adds all units of \p other to this group.
		 */
		public method addOther takes thistype other returns nothing
			local integer i = 0
			loop
				exitwhen (i == other.units().size())
				call this.units().pushBack(other.units()[i])
				set i = i + 1
			endloop
		endmethod

		/**
		 * Adds all units of group \p whichGroup to the group.
		 * \param destroy If this value is true group \p whichGroup will be destroyed after it has been added.
		 * \param clear If this value is true group \p whichGroup will be cleared after it has been added. This value has no effect if \p destroy is already true. If both parameters are false group \p whichGroup won't change. Unfortunately the method has to re-add all units (limited Warcraft III natives).
		 */
		public method addGroup takes group whichGroup, boolean destroy, boolean clear returns nothing
			local unit firstOfGroup
			local integer i
			loop
				exitwhen (IsUnitGroupEmptyBJ(whichGroup))
				set firstOfGroup = FirstOfGroupSave(whichGroup)
				call this.m_units.pushBack(firstOfGroup)
				call GroupRemoveUnit(whichGroup, firstOfGroup)
				set firstOfGroup = null
			endloop
			call GroupClear(whichGroup)
			if (destroy) then
				call DestroyGroup(whichGroup)
				set whichGroup = null
			elseif (not clear) then
				set i = 0
				loop
					exitwhen (i == this.m_units.size())
					call GroupAddUnit(whichGroup, this.m_units[i])
					set i = i + 1
				endloop
			endif
		endmethod

		public method addUnitsOfType takes string unitTypeName, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfType(whichGroup, unitTypeName, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsOfPlayer takes player whichPlayer, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfPlayer(whichGroup, whichPlayer, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsOfTypeCounted takes string unitTypeName, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfTypeCounted(whichGroup, unitTypeName, filter, countLimit)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRect takes rect whichRect, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRect(whichGroup, whichRect, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRectCounted takes rect whichRect, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRectCounted(whichGroup, whichRect, filter, countLimit)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRange takes real x, real y, real radius, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRange(whichGroup, x, y, radius, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeOfLocation takes location whichLocation, real radius, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeOfLoc(whichGroup, whichLocation, radius, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeCounted takes real x, real y, real radius, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeCounted(whichGroup, x, y, radius, filter, countLimit)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeOfLocationCounted takes location whichLocation, real radius, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeOfLocCounted(whichGroup, whichLocation, radius, filter, countLimit)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method addUnitsSelected takes player whichPlayer, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsSelected(whichGroup, whichPlayer, filter)
			call this.addGroup(whichGroup, true, false)
			set whichGroup = null
		endmethod

		public method immediateOrder takes string order returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupImmediateOrder(whichGroup, order)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method immediateOrderById takes integer order returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupImmediateOrderById(whichGroup, order)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method pointOrder takes string order, real x, real y returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrder(whichGroup, order, x, y)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method locationOrder takes string order, location whichLocation returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderLoc(whichGroup, order, whichLocation)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method pointOrderById takes integer order, real x, real y returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderById(whichGroup, order, x, y)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method locationOrderById takes integer order, location whichLocation returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderByIdLoc(whichGroup, order, whichLocation)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method targetOrder takes string order, widget targetWidget returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupTargetOrder(whichGroup, order, targetWidget)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method targetOrderById takes integer order, widget targetWidget returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupTargetOrderById(whichGroup, order, targetWidget)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method isInGroup takes group whichGroup returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				if (not IsUnitInGroup(this.m_units[i], whichGroup)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method isDead takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				if (not IsUnitDeadBJ(this.m_units[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method hasUnitsOfPlayer takes player whichPlayer returns boolean
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (owner == whichPlayer) then
					set owner = null
					return true
				endif
				set i = i + 1
				set owner = null
			endloop
			return false
		endmethod

		public method removeUnitsOfPlayer takes player whichPlayer returns nothing
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (owner == whichPlayer) then
					call this.m_units.erase(i)
				else
					set i = i + 1
				endif
				set owner = null
			endloop
		endmethod

		public method hasAlliesOfPlayer takes player whichPlayer returns boolean
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (IsPlayerAlly(owner, whichPlayer)) then
					set owner = null
					return true
				endif
				set i = i + 1
				set owner = null
			endloop
			return false
		endmethod

		public method hasAlliesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasAlliesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeAlliesOfPlayer takes player whichPlayer returns nothing
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (IsPlayerAlly(owner, whichPlayer)) then
					call this.m_units.erase(i)
				else
					set i = i + 1
				endif
				set owner = null
			endloop
		endmethod

		public method removeAlliesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeAlliesOfPlayer(owner)
			set owner = null
		endmethod

		public method hasEnemiesOfPlayer takes player whichPlayer returns boolean
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (not IsPlayerAlly(owner, whichPlayer)) then
					set owner = null
					return true
				endif
				set i = i + 1
				set owner = null
			endloop
			return false
		endmethod

		public method hasEnemiesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasEnemiesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeEnemiesOfPlayer takes player whichPlayer returns nothing
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (not IsPlayerAlly(owner, whichPlayer)) then
					call this.m_units.erase(i)
				else
					set i = i + 1
				endif
				set owner = null
			endloop
		endmethod

		public method removeEnemiesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeEnemiesOfPlayer(owner)
			set owner = null
		endmethod

		public method select takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				call SelectUnit(this.m_units[i], true)
				set i = i + 1
			endloop
		endmethod

		public method deselect takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				call SelectUnit(this.m_units[i], false)
				set i = i + 1
			endloop
		endmethod

		public method selectOnly takes nothing returns nothing
			call ClearSelection()
			call this.select()
		endmethod

		public method selectForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.select()
			endif
		endmethod

		public method deselectForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.deselect()
			endif
		endmethod

		public method selectOnlyForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.selectOnly()
			endif
		endmethod

		public method countUnitsOfType takes integer unitTypeId returns integer
			local integer i = 0
			local integer result = 0
			loop
				exitwhen (i == this.m_units.size())
				if (GetUnitTypeId(this.m_units[i]) == unitTypeId) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_units = AUnitVector.create()
			return this
		endmethod

		public static method createWithGroup takes group whichGroup, boolean destroy, boolean clear returns thistype
			local thistype this = thistype.create()
			call this.addGroup(whichGroup, destroy, clear)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.m_units.destroy()
		endmethod
	endstruct

endlibrary