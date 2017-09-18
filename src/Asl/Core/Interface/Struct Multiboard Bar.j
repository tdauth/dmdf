library AStructCoreInterfaceMultiboardBar requires AInterfaceCoreInterfaceBarInterface, optional ALibraryCoreDebugMisc, ALibraryCoreMathsReal, AStructCoreGeneralHashTable, AStructCoreGeneralVector

	private struct AMultiboardBarItem
		private string m_valueIcon
		private string m_emptyIcon
		private real m_width

		public method setValueIcon takes string valueIcon returns nothing
			set this.m_valueIcon = valueIcon
		endmethod

		public method valueIcon takes nothing returns string
			return this.m_valueIcon
		endmethod

		public method setEmptyIcon takes string emptyIcon returns nothing
			set this.m_emptyIcon = emptyIcon
		endmethod

		public method emptyIcon takes nothing returns string
			return this.m_emptyIcon
		endmethod
		
		public method setWidth takes real width returns nothing
			set this.m_width = width
		endmethod
		
		public method width takes nothing returns real
			return this.m_width
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			set this.m_valueIcon = ""
			set this.m_emptyIcon = ""
			set this.m_width = 0.01
			return this
		endmethod
	endstruct

	/**
	 * \todo vJass bug, should be a part of \ref AMultiboardBar.
	 * This represents the function which controls both MultiboardBar values:
	 * Value and maximum value.
	 */
	function interface AMultiboardBarValueFunction takes AMultiboardBar multiboardBar returns real

	/**
	 * \brief Multiboard bars display \ref real values in form of progress bars in the Warcraft III: The Frozen Throne multiboard.
	 * They can either be horizontal or vertical and use custom icons.
	 */
	struct AMultiboardBar extends ABarInterface
		// construction members
		private multiboard m_multiboard
		private integer m_column
		private integer m_row
		private real m_refreshRate
		private boolean m_horizontal
		// dynamic members
		private real m_value
		private real m_maxValue
		private AMultiboardBarValueFunction m_valueFunction
		private AMultiboardBarValueFunction m_maxValueFunction
		// members
		private AIntegerVector m_items
		private integer m_colouredPart
		private timer m_refreshTimer

		//! runtextmacro optional A_STRUCT_DEBUG("\"AMultiboardBar\"")

		debug private method checkLength takes integer length returns boolean
			debug if (length >= this.m_items.size() or length < 0) then
				debug call this.print("Wrong length " + I2S(length) + " has to be between 0 and " + I2S(this.m_items.size() - 1) + ".")
				debug return true
			debug endif
			debug return false
		debug endmethod

		// dynamic member methods

		public method setValue takes real value returns nothing
			set this.m_value = value
		endmethod

		public method value takes nothing returns real
			return this.m_value
		endmethod

		public method setMaxValue takes real maxValue returns nothing
			set this.m_maxValue = maxValue
		endmethod

		public method maxValue takes nothing returns real
			return this.m_maxValue
		endmethod

		public method setValueIcon takes integer length, string valueIcon returns nothing
			debug if (this.checkLength(length)) then
				debug return
			debug endif
			call AMultiboardBarItem(this.m_items[length]).setValueIcon(valueIcon)
		endmethod

		public method valueIcon takes integer length returns string
			debug if (this.checkLength(length)) then
				debug return null
			debug endif
			return AMultiboardBarItem(this.m_items[length]).valueIcon()
		endmethod

		public method setEmptyIcon takes integer length, string emptyIcon returns nothing
			debug if (this.checkLength(length)) then
				debug return
			debug endif
			call AMultiboardBarItem(this.m_items[length]).setEmptyIcon(emptyIcon)
		endmethod

		public method emptyIcon takes integer length returns string
			debug if (this.checkLength(length)) then
				debug return null
			debug endif
			return AMultiboardBarItem(this.m_items[length]).emptyIcon()
		endmethod
		
		public method setWidth takes integer length, real width returns nothing
			debug if (this.checkLength(length)) then
				debug return
			debug endif
			call AMultiboardBarItem(this.m_items[length]).setWidth(width)
		endmethod

		public method width takes integer length returns real
			debug if (this.checkLength(length)) then
				debug return 0.0
			debug endif
			return AMultiboardBarItem(this.m_items[length]).width()
		endmethod

		/**
		 * Sets the function which should return the value of the multiboard bar when it is being refreshed.
		 * If this function is 0 nothing will be called.
		 * Consider that you can also overwrite method \ref onRefresh().
		 */
		public method setValueFunction takes AMultiboardBarValueFunction valueFunction returns nothing
			set this.m_valueFunction = valueFunction
		endmethod

		public method valueFunction takes nothing returns AMultiboardBarValueFunction
			return this.m_valueFunction
		endmethod

		/**
		 * Sets the function which should return the maximum value of the multiboard bar when it is being refreshed.
		 * If this function is 0 nothing will be called.
		 * Consider that you can also overwrite method \ref onRefresh().
		 */
		public method setMaxValueFunction takes AMultiboardBarValueFunction maxValueFunction returns nothing
			set this.m_maxValueFunction = maxValueFunction
		endmethod

		public method maxValueFunction takes nothing returns AMultiboardBarValueFunction
			return this.m_maxValueFunction
		endmethod

		// construction member methods

		public method multiboard takes nothing returns multiboard
			return this.m_multiboard
		endmethod

		public method column takes nothing returns integer
			return this.m_column
		endmethod

		public method row takes nothing returns integer
			return this.m_row
		endmethod

		public method length takes nothing returns integer
			return this.m_items.size()
		endmethod

		public method refreshRate takes nothing returns real
			return this.m_refreshRate
		endmethod

		public method horizontal takes nothing returns boolean
			return this.m_horizontal
		endmethod

		// methods

		public method enable takes nothing returns nothing
			call ResumeTimer(this.m_refreshTimer)
		endmethod

		public method disable takes nothing returns nothing
			call PauseTimer(this.m_refreshTimer)
		endmethod

		/**
		 * This method is called before the multiboard bar evaluates the coloured part so users can set value and max value in this method instead of using function values.
		 * Usually it calls the function which are refered by the two function pointers of the value and the maximum value function.
		 * If they're 0 nothing will be set.
		 * \sa setValue()
		 * \sa setMaxValue()
		 * \sa setValueFunction()
		 * \sa setMaxValueFunction()
		 */
		public stub method onRefresh takes nothing returns nothing
			if (this.m_valueFunction != 0) then
				set this.m_value = this.m_valueFunction.evaluate(this)
			endif
			if (this.m_maxValueFunction != 0) then
				set this.m_maxValue = this.m_maxValueFunction.evaluate(this)
			endif
		endmethod

		/**
		 * Refreshes multiboard bar.
		 * \ref AMultiboardBar.onRefresh will be called before evaluating the coloured part.
		 */
		public method refresh takes nothing returns nothing
			local integer i
			local multiboarditem multiboardItem
			call this.onRefresh()
			if (this.m_maxValue != 0) then
				set this.m_colouredPart = R2I(this.m_value / this.m_maxValue * I2R(this.length()))
			else
				set this.m_colouredPart = 0
			endif
			set i = 0
			loop
				exitwhen (i == this.length())
				if (this.m_horizontal) then
					set multiboardItem = MultiboardGetItem(this.m_multiboard, this.m_row, this.m_column + i)
				else
					set multiboardItem = MultiboardGetItem(this.m_multiboard, this.m_row + i, this.m_column)
				endif
				// coloured part
				if (i < this.m_colouredPart) then
					call MultiboardSetItemIcon(multiboardItem, AMultiboardBarItem(this.m_items[i]).valueIcon())
				// plain Part
				else
					call MultiboardSetItemIcon(multiboardItem, AMultiboardBarItem(this.m_items[i]).emptyIcon())
				endif
				call MultiboardSetItemWidth(multiboardItem,  AMultiboardBarItem(this.m_items[i]).width()) // set each item to prevent changing the whole multiboard
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				set i = i + 1
			endloop
		endmethod

		// convenience methods

		public method setIcons takes integer start, integer end, string icon, boolean valueIcon returns nothing
			local integer i
			debug if ((start >= 0) and (start < this.length())) then
				debug if ((end > 0) and (end < this.length())) then
					set i = start
					loop
						exitwhen(i == end + 1)
						if (valueIcon) then
							call AMultiboardBarItem(this.m_items[i]).setValueIcon(icon)
						else
							call AMultiboardBarItem(this.m_items[i]).setEmptyIcon(icon)
						endif
						set i = i + 1
					endloop
				debug else
					debug call this.print("The value 'end' has an invalid size: " + I2S(end) + ".")
				debug endif
			debug else
				debug call this.print("The value 'start' has an invalid size: " + I2S(start) + ".")
			debug endif
		endmethod

		public method setAllIcons takes string icon, boolean valueIcon returns nothing
			call this.setIcons(0, this.length() - 1, icon, valueIcon)
		endmethod
		
		public method setWidths takes integer start, integer end, real width returns nothing
			local integer i
			debug if ((start >= 0) and (start < this.length())) then
				debug if ((end > 0) and (end < this.length())) then
					set i = start
					loop
						exitwhen(i == end + 1)
						call AMultiboardBarItem(this.m_items[i]).setWidth(width)
						set i = i + 1
					endloop
				debug else
					debug call this.print("The value 'end' has an invalid size: " + I2S(end) + ".")
				debug endif
			debug else
				debug call this.print("The value 'start' has an invalid size: " + I2S(start) + ".")
			debug endif
		endmethod

		public method setAllWidths takes real width returns nothing
			call this.setWidths(0, this.length() - 1, width)
		endmethod

		/// \return The index of the first field (column or row) which is not used by the bar (alignment is left to right and up to bottom).
		public method firstFreeField takes nothing returns integer
			if (this.m_horizontal) then
				return this.m_column + this.length()
			endif
			return this.m_row + this.length()
		endmethod

		private method resizeMultiboard takes nothing returns nothing
			if (this.m_horizontal) then
				if (MultiboardGetColumnCount(this.m_multiboard) < (this.m_column + this.length())) then
					call MultiboardSetColumnCount(this.m_multiboard, this.m_column + this.length())
				endif
				if (MultiboardGetRowCount(this.m_multiboard) <= this.m_row) then
					call MultiboardSetRowCount(this.m_multiboard, this.m_row + 1)
				endif
			else
				if (MultiboardGetColumnCount(this.m_multiboard) <= this.m_column) then
					call MultiboardSetColumnCount(this.m_multiboard, this.m_column + 1)
				endif
				if (MultiboardGetRowCount(this.m_multiboard) < (this.m_row + this.length())) then
					call MultiboardSetRowCount(this.m_multiboard, (this.m_row + this.length()))
				endif
			endif
		endmethod

		private method setupMultiboardItems takes nothing returns nothing
			local integer i
			local multiboarditem multiboardItem
			set i = 0
			loop
				exitwhen (i == this.length())
				set this.m_items[i] = AMultiboardBarItem.create()
				if (this.m_horizontal) then
					set multiboardItem = MultiboardGetItem(this.m_multiboard, this.m_row, this.m_column + i)
				else
					set multiboardItem = MultiboardGetItem(this.m_multiboard, this.m_row + i, this.m_column)
				endif
				call MultiboardSetItemStyle(multiboardItem, false, true)
				call MultiboardSetItemWidth(multiboardItem, AMultiboardBarItem(this.m_items[i]).width()) // set each item to prevent changing the whole multiboard
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				set i = i + 1
			endloop
		endmethod

		private static method timerFunctionRefresh takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.refresh()
		endmethod

		private method createRefreshTimer takes nothing returns nothing
			if (this.m_refreshRate > 0.0) then
				set this.m_refreshTimer = CreateTimer()
				call AHashTable.global().setHandleInteger(this.m_refreshTimer, 0, this)
				call TimerStart(this.m_refreshTimer, this.m_refreshRate, true, function thistype.timerFunctionRefresh)
			endif
		endmethod

		/**
		 * If there aren't enough items in multiboard yet required onces will be added automatically.
		 * \param refreshRate If this value is bigger than 0 multiboard bar will be refreshed.
		 * \param horizontal This value is not dynamic.
		 */
		public static method create takes multiboard whichMultiboard, integer column, integer row, integer length, real refreshRate, boolean horizontal returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_multiboard = whichMultiboard
			set this.m_column = column
			set this.m_row = row
			set this.m_refreshRate = refreshRate
			set this.m_horizontal = horizontal
			// dynamic members
			set this.m_value = 0
			set this.m_maxValue = 0
			set this.m_valueFunction = 0
			set this.m_maxValueFunction = 0
			// members
			set this.m_items = AIntegerVector.createWithSize(length, 0) // are filled in setupMultiboardItems
			set this.m_colouredPart = 0

			call this.resizeMultiboard()
			call this.setupMultiboardItems()
			call this.createRefreshTimer()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_multiboard = null
			// members
			loop
				exitwhen (this.m_items.empty())
				call AMultiboardBarItem(this.m_items.back()).destroy()
				call this.m_items.popBack()
			endloop
			call this.m_items.destroy()
			if (this.m_refreshRate > 0.0) then
				call AHashTable.global().destroyTimer(this.m_refreshTimer)
				set this.m_refreshTimer = null
			endif
		endmethod
	endstruct

endlibrary