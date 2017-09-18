library AStructSystemsMeleeItemDrop requires AStructSystemsMeleeIdTable

	/**
	 * Allows a specified widget to drop one or several items on its death or owner changement.
	 * Consider that changing the owner is only possible for units at the moment.
	 * \todo Add item owner changement support.
	 * \todo Add widget changement support (m_widget should become dynamic) - low priority, usually you just create a new item drop for each widget.
	 */
	struct AItemDrop
		// construction members
		private widget m_widget
		// dynamic members
		private AIdTable m_table
		// members
		private player m_owner
		private trigger m_trigger
		debug private effect m_effect

		public method setTable takes AIdTable table returns nothing
			set this.m_table = table
		endmethod

		public method table takes nothing returns AIdTable
			return this.m_table
		endmethod

		/**
		 * This method is called when the widget is going to drop one or several items.
		 * This does not necessarily mean that it actually drops anything.
		 */
		public stub method onDrop takes nothing returns nothing
		endmethod

		public stub method onDropItem takes item whichItem returns nothing
		endmethod

static if (DEBUG_MODE) then
		public method show takes nothing returns nothing
			if (this.m_effect == null) then
				set this.m_effect = AddSpecialEffectTarget("Objects\\StartLocation\\StartLocation.mdl", this.m_widget, "overhead")
			endif
		endmethod

		public method hide takes nothing returns nothing
			if (this.m_effect != null) then
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif
		endmethod
endif

		private static method triggerActionUnit takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean canDrop = true
			local AIntegerList itemTypeIds
			local AIntegerListIterator iterator
			set canDrop = not IsUnitHidden(GetTriggerUnit())
			if (canDrop and GetChangingUnit() != null) then
				set canDrop = GetChangingUnitPrevOwner() == this.m_owner
			endif

			if (canDrop) then
				call this.onDrop.evaluate()
				if (this.m_table != 0) then
					set itemTypeIds = this.m_table.generate()
					if (itemTypeIds != 0) then
						debug call Print("Dropped " + I2S(itemTypeIds.size()) + " items")
						set iterator = itemTypeIds.begin()
						loop
							exitwhen (not iterator.isValid())
							call this.onDropItem.evaluate(UnitDropItem(GetTriggerUnit(), iterator.data()))
							call iterator.next()
						endloop
						call iterator.destroy()
						call itemTypeIds.destroy()
					endif
				endif
			endif
			call this.destroy()
		endmethod

		private static method triggerActionWidget takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AIntegerList itemTypeIds = 0
			local AIntegerListIterator iterator

			call this.onDrop.evaluate()

			if (this.m_table != 0) then
				set itemTypeIds = this.m_table.generate()
				if (itemTypeIds != 0) then
					set iterator = itemTypeIds.begin()
					loop
						exitwhen (not iterator.isValid())
						call this.onDropItem.evaluate(WidgetDropItem(GetTriggerWidget(), iterator.data()))
						call iterator.next()
					endloop
					call iterator.destroy()
					call itemTypeIds.destroy()
				endif
			endif

			call this.destroy()
		endmethod

		private static method create takes widget whichWidget returns thistype
			local thistype this = thistype.allocate()
			set this.m_widget = whichWidget
			set this.m_table = 0
			set this.m_trigger = CreateTrigger()
			call AHashTable.global().setHandleInteger(this.m_trigger, 0, this)
			debug set this.m_effect = null

			return this
		endmethod

		public static method createForUnit takes unit whichUnit returns thistype
			local thistype this = thistype.create(whichUnit)
			set this.m_owner = GetOwningPlayer(whichUnit)
			call TriggerRegisterUnitEvent(this.m_trigger, whichUnit, EVENT_UNIT_DEATH)
			call TriggerRegisterUnitEvent(this.m_trigger, whichUnit, EVENT_UNIT_CHANGE_OWNER)
			call TriggerAddAction(this.m_trigger, function thistype.triggerActionUnit)
			return this
		endmethod

		/// \todo Usually you should check if item is owned/hidden but we can't use GetTriggerItem nor convert trigger widget to an item object.
		public static method createForItem takes item whichItem returns thistype
			local thistype this = thistype.create(whichItem)
			set this.m_owner = null
			call TriggerRegisterDeathEvent(this.m_trigger, whichItem)
			call TriggerAddAction(this.m_trigger, function thistype.triggerActionWidget)
			return this
		endmethod

		public static method createForDestructable takes destructable whichDestructable returns thistype
			local thistype this = thistype.create(whichDestructable)
			set this.m_owner = null
			call TriggerRegisterDeathEvent(this.m_trigger, whichDestructable)
			call TriggerAddAction(this.m_trigger, function thistype.triggerActionWidget)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_widget = null
			set this.m_owner = null
			set this.m_table = 0
			debug call this.hide()
			call AHashTable.global().destroyTrigger(this.m_trigger)
			set this.m_trigger = null
		endmethod
	endstruct

endlibrary