library AStructSystemsGuiLayout requires optional ALibraryCoreDebugMisc, AStructSystemsGuiWidget, AStructSystemsGuiButton, AStructSystemsGuiText, AStructSystemsGuiImage

	private struct ALayoutMemberData
		private integer m_data
		private boolean m_isLayout

		public method data takes nothing returns integer
			return this.m_data
		endmethod

		/**
		 * \return If it returns true \ref ALayoutMemberData.data returns a \ref ALayout instance otherwise it returns a \ref AWidgetData instance.
		 */
		public method isLayout takes nothing returns boolean
			return this.m_isLayout
		endmethod

		public static method create takes integer data, boolean isLayout returns thistype
			local thistype this = thistype.allocate()
			set this.m_data = data
			set this.m_isLayout = isLayout
			return this
		endmethod
	endstruct

	/**
	 * Note that this struct repesents a static layout!
	 * Either call \ref ALayout.orderHorizontally or \ref ALayout.orderVertically to order all contained widgets and layouts.
	 * Do this before showing any of them to set their right position.
	 * After they were shown first time you shouldn't change their x and y values since widgets are static (because of trackables).
	 * Besides you should note that layouts use \ref AWidget.sizeX and \ref AWidget.sizeY to get widget's size.
	 * \todo Untested!
	 */
	struct ALayout
		// construction members
		private AMainWindow m_mainWindow
		private real m_x
		private real m_y
		// members
		private real m_sizeX
		private real m_sizeY
		private AIntegerVector m_members

		//! runtextmacro optional A_STRUCT_DEBUG("\"ALayout\"")

		// construction members

		public method mainWindow takes nothing returns AMainWindow
			return this.m_mainWindow
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		// members

		public method sizeX takes nothing returns real
			return this.m_sizeX
		endmethod

		public method sizeY takes nothing returns real
			return this.m_sizeY
		endmethod

		// methods

		public method addWidget takes AWidget whichWidget returns nothing
static if (DEBUG_MODE) then
			if (whichWidget.mainWindow() != this.m_mainWindow) then
				call this.print("Widget " + I2S(whichWidget) + " has not the same main window (id " + I2S(whichWidget.mainWindow()) + ").")
			endif
endif
			call this.m_members.pushBack(ALayoutMemberData.create(whichWidget, false))
		endmethod

		public method addLayout takes ALayout whichLayout returns nothing
static if (DEBUG_MODE) then
			if (whichLayout.mainWindow() != this.m_mainWindow) then
				call this.print("Layout " + I2S(whichLayout) + " has not the same main window (id " + I2S(whichLayout.mainWindow()) + ").")
			endif
endif
			call this.m_members.pushBack(ALayoutMemberData.create(whichLayout, true))
		endmethod

		public method orderHorizontally takes nothing returns nothing
			local real x = this.m_x
			local real y = this.m_y
			local integer i = 0
			loop
				exitwhen (i == this.m_members.size())
				if (ALayoutMemberData(this.m_members[i]).isLayout()) then
					set thistype(ALayoutMemberData(this.m_members[i]).data()).m_x = x
					call thistype(ALayoutMemberData(this.m_members[i]).data()).orderHorizontally()
					set x = x + thistype(ALayoutMemberData(this.m_members[i]).data()).sizeX()
					set this.m_sizeY = RMaxBJ(this.m_sizeY, thistype(ALayoutMemberData(this.m_members[i]).data()).sizeY())
				else
					call AWidget(ALayoutMemberData(this.m_members[i]).data()).setX(x)
					call AWidget(ALayoutMemberData(this.m_members[i]).data()).setX(y)
					set x = x + AWidget(ALayoutMemberData(this.m_members[i]).data()).sizeX()
					set this.m_sizeY = RMaxBJ(this.m_sizeY, AWidget(ALayoutMemberData(this.m_members[i]).data()).sizeY())
				endif
				set i = i + 1
			endloop
			set this.m_sizeX = x - this.m_x
		endmethod

		public method orderVertically takes nothing returns nothing
			debug call this.printMethodError("orderVertically", "Not implemented yet.")
		endmethod

		/**
		 * \param X Relative x coordinate to the main window one's.
		 * \param Y Relative y coordinate to the main window one's.
		 */
		public static method create takes AMainWindow mainWindow, real x, real y returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_mainWindow = mainWindow
			set this.m_x = x
			set this.m_y = y
			// members
			set this.m_sizeX = 0.0
			set this.m_sizeY = 0.0
			set this.m_members = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.m_members.destroy()
		endmethod
	endstruct

endlibrary