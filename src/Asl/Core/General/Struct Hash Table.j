library AStructCoreGeneralHashTable

	/**
	 * Every key used for a global handle such as a unit or player must be unique.
	 * This list contains all unique keys which never should be used on any handle for storing a hashtable value.
	 * These keys are used for attaching values to handles and should never be reused for attaching a value to a handle since they must be unique.
	 * These keys are used by \ref AHashTable.global().
	 */
	globals
		constant integer A_HASHTABLE_KEY_SPAWNPOINTMEMBER = 1000
		constant integer A_HASHTABLE_KEY_VOTE = 1001
		constant integer A_HASHTABLE_KEY_ACTOR = 1002
		constant integer A_HASHTABLE_KEY_INVENTORYINDEX = 1003
		constant integer A_HASHTABLE_KEY_BUFFCOUNTER = 1004
		constant integer A_HASHTABLE_KEY_CHARACTER = 1005
		constant integer A_HASHTABLE_KEY_GLOBALDAMAGERECORDER = 1006
		constant integer A_HASHTABLE_KEY_UNITPAUSE = 1007
		constant integer A_HASHTABLE_KEY_BONUSTYPE_DAMAGE = 1008
		constant integer A_HASHTABLE_KEY_BONUSTYPE_ARMOR = 1009
		constant integer A_HASHTABLE_KEY_BONUSTYPE_LIFE = 1010
		constant integer A_HASHTABLE_KEY_BONUSTYPE_MANA = 1011
		constant integer A_HASHTABLE_KEY_BONUSTYPE_SIGHT_RANGE = 1012
		constant integer A_HASHTABLE_KEY_BONUSTYPE_MANA_REGENERATION = 1013
		constant integer A_HASHTABLE_KEY_BONUSTYPE_LIFE_REGENERATION = 1014
		constant integer A_HASHTABLE_KEY_ROUTINE_CURRENT = 1015
		constant integer A_HASHTABLE_KEY_ROUTINE_NEXT = 1016
		constant integer A_HASHTABLE_KEY_ROUTINES = 1017
		constant integer A_HASHTABLE_KEY_INVENTORY = 1018
		constant integer A_HASHTABLE_KEY_MAX = 1019
	endglobals

	/**
	 * \brief Singleton struct which provides access to a single hashtable instance used for storing values for handles.
	 *
	 * ASL internally uses \ref thistype.global() instance. Do not use this method to prevent conflicts with the ASL!
	 * There are various methods which allow you to save values of different types or attach them on handles since handle objects do have an unique key (use \ref GetHandleId()).
	 * \note For storing global values in the ASL use \ref AGlobalHashTable instead to prevent conflicts.
	 * \author Tamino Dauth
	 * \sa wrappers
	 * \sa containers
	 */
	struct AHashTable
		// static members
		private static thistype m_global
		// members
		private hashtable m_hashTable

		//! textmacro AHashTableOperationMacro takes TYPE, TYPENAME, METHODTYPENAME, SAVELOADSUFFIX, HAVEREMOVESUFFIX
			public method setHandle$TYPENAME$ takes handle whichHandle, integer childKey, $TYPE$ value returns nothing
				call Save$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey, value)
			endmethod

			public method handle$TYPENAME$ takes handle whichHandle, integer childKey returns $TYPE$
				return Load$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod

			public method hasHandle$TYPENAME$ takes handle whichHandle, integer childKey returns boolean
				return HaveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod

			public method removeHandle$TYPENAME$ takes handle whichHandle, integer childKey returns nothing
				call RemoveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod
		//! endtextmacro

		//! runtextmacro AHashTableOperationMacro("integer", "Integer", "integer", "", "Integer")
		//! runtextmacro AHashTableOperationMacro("boolean", "Boolean", "boolean", "", "Boolean")
		//! runtextmacro AHashTableOperationMacro("real", "Real", "real", "", "Real")
		//! runtextmacro AHashTableOperationMacro("string", "Str", "string", "", "String")

		//! runtextmacro AHashTableOperationMacro("player", "Player", "player", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("widget", "Widget", "widget", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("destructable", "Destructable", "destructable", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("item", "Item", "item", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("unit", "Unit", "unit", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("ability", "Ability", "ability", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("timer", "Timer", "timer", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("trigger", "Trigger", "trigger", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("triggercondition", "TriggerCondition", "triggerCondition", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("triggeraction", "TriggerAction", "triggerAction", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("event", "TriggerEvent", "triggerEvent", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("force", "Force", "force", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("group", "Group", "group", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("location", "Location", "location", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("rect", "Rect", "rect", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("boolexpr", "BooleanExpr", "boolexpr", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("sound", "Sound", "sound", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("effect", "Effect", "effect", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("unitpool", "UnitPool", "unitPool", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("itempool", "ItemPool", "itemPool", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("quest", "Quest", "quest", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("questitem", "QuestItem", "questitem", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("defeatcondition", "DefeatCondition", "defeatCondition", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("timerdialog", "TimerDialog", "timerDialog", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("leaderboard", "Leaderboard", "leaderboard", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("multiboard", "Multiboard", "multiboard", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("multiboarditem", "MultiboardItem", "multiboardItem", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("trackable", "Trackable", "trackable", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("dialog", "Dialog", "dialog", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("button", "Button", "button", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("texttag", "TextTag", "textTag", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("lightning", "Lightning", "lightning", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("image", "Image", "image", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("ubersplat", "Ubersplat", "ubersplat", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("region", "Region", "region", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("fogstate", "FogState", "fogState", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("fogmodifier", "FogModifier", "fogModifier", "Handle", "Handle")
		///! runtextmacro AHashTableOperationMacro("agent", "Agent", "agent", "Handle", "Handle") /// \todo Missing native
		//! runtextmacro AHashTableOperationMacro("hashtable", "Hashtable", "hashtable", "Handle", "Handle")

		/// Flushes all data of the hashtable.
		public method flush takes nothing returns nothing
			call FlushParentHashtable(this.m_hashTable)
		endmethod

		public method flushHandle takes handle whichHandle returns nothing
			call FlushChildHashtable(this.m_hashTable, GetHandleId(whichHandle))
		endmethod

		//! textmacro AHashTableDestructionMacro takes TYPE, TYPENAME, DESTRUCTIONNAME
			public method destroy$TYPENAME$ takes $TYPE$ $TYPENAME$ returns nothing
				call this.flushHandle($TYPENAME$)
				call $DESTRUCTIONNAME$$TYPENAME$($TYPENAME$)
			endmethod
		//! endtextmacro

		//! runtextmacro AHashTableDestructionMacro("trigger", "Trigger", "Destroy")
		//! runtextmacro AHashTableDestructionMacro("timer", "Timer", "Destroy")
		//! runtextmacro AHashTableDestructionMacro("unit", "Unit", "Remove")
		//! runtextmacro AHashTableDestructionMacro("item", "Item", "Remove")
		//! runtextmacro AHashTableDestructionMacro("destructable", "Destructable", "Remove")

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_hashTable = InitHashtable()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.flush()
			set this.m_hashTable = null
		endmethod

		private static method onInit takes nothing returns nothing
			// static members
			set thistype.m_global = 0
		endmethod

		/**
		 * Global hash table is used by the ASL itself.
		 * \warning Please do not use this method outside of the ASL to prevent conflicts with the ASL.
		 * The global hash table is used in all ASL systems to store data for handles.
		 * For example whenever a system uses triggers which are created for specific instance of an object
		 * the reference "this" can be stored using the trigger's handle ID as child key.
		 * When the trigger is run it loads the reference from this global hash table again using handle ID of the triggering trigger.
		 */
		public static method global takes nothing returns thistype
			if (thistype.m_global == 0) then
				set thistype.m_global = thistype.create()
			endif
			return thistype.m_global
		endmethod
	endstruct

	/**
	 * Global unique keys. These keys are not used for attaching handle values but for unique global entries.
	 * These keys are used by \ref AGlobalHashTable.global().
	 */
	globals
		constant integer A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES = 1000
		constant integer A_HASHTABLE_GLOBAL_KEY_ITEMCOSTS = 1001
		constant integer A_HASHTABLE_GLOBAL_KEY_ITEMTYPES = 1002
		constant integer A_HASHTABLE_GLOBAL_KEY_MAX = 1003
	endglobals

	/**
	 * \brief Global hash table for the ASL only to store global values by unique keys.
	 * \note Does not allow attaching values to handle IDs to prevent conflicts. Use \ref AHashTable for this.
	 * \author Tamino Dauth
	 * \sa wrappers
	 * \sa containers
	 */
	struct AGlobalHashTable
		// static members
		private static thistype m_global
		// members
		private hashtable m_hashTable

		//! textmacro AGlobalHashTableOperationMacro takes TYPE, TYPENAME, METHODTYPENAME, SAVELOADSUFFIX, HAVEREMOVESUFFIX
			public method set$TYPENAME$ takes integer parentKey, integer childKey, $TYPE$ value returns nothing
				call Save$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, parentKey, childKey, value)
			endmethod

			public method $METHODTYPENAME$ takes integer parentKey, integer childKey returns $TYPE$
				return Load$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod

			public method has$TYPENAME$ takes integer parentKey, integer childKey returns boolean
				return HaveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod

			public method remove$TYPENAME$ takes integer parentKey, integer childKey returns nothing
				call RemoveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod
		//! endtextmacro

		//! runtextmacro AGlobalHashTableOperationMacro("integer", "Integer", "integer", "", "Integer")
		//! runtextmacro AGlobalHashTableOperationMacro("boolean", "Boolean", "boolean", "", "Boolean")
		//! runtextmacro AGlobalHashTableOperationMacro("real", "Real", "real", "", "Real")
		//! runtextmacro AGlobalHashTableOperationMacro("string", "Str", "string", "", "String")

		//! runtextmacro AGlobalHashTableOperationMacro("player", "Player", "player", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("widget", "Widget", "widget", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("destructable", "Destructable", "destructable", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("item", "Item", "item", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("unit", "Unit", "unit", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("ability", "Ability", "ability", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("timer", "Timer", "timer", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("trigger", "Trigger", "trigger", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("triggercondition", "TriggerCondition", "triggerCondition", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("triggeraction", "TriggerAction", "triggerAction", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("event", "TriggerEvent", "triggerEvent", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("force", "Force", "force", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("group", "Group", "group", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("location", "Location", "location", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("rect", "Rect", "rect", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("boolexpr", "BooleanExpr", "boolexpr", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("sound", "Sound", "sound", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("effect", "Effect", "effect", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("unitpool", "UnitPool", "unitPool", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("itempool", "ItemPool", "itemPool", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("quest", "Quest", "quest", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("questitem", "QuestItem", "questitem", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("defeatcondition", "DefeatCondition", "defeatCondition", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("timerdialog", "TimerDialog", "timerDialog", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("leaderboard", "Leaderboard", "leaderboard", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("multiboard", "Multiboard", "multiboard", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("multiboarditem", "MultiboardItem", "multiboardItem", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("trackable", "Trackable", "trackable", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("dialog", "Dialog", "dialog", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("button", "Button", "button", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("texttag", "TextTag", "textTag", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("lightning", "Lightning", "lightning", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("image", "Image", "image", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("ubersplat", "Ubersplat", "ubersplat", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("region", "Region", "region", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("fogstate", "FogState", "fogState", "Handle", "Handle")
		//! runtextmacro AGlobalHashTableOperationMacro("fogmodifier", "FogModifier", "fogModifier", "Handle", "Handle")
		///! runtextmacro AGlobalHashTableOperationMacro("agent", "Agent", "agent", "Handle", "Handle") /// \todo Missing native
		//! runtextmacro AGlobalHashTableOperationMacro("hashtable", "Hashtable", "hashtable", "Handle", "Handle")

		/// Flushes all data of the hashtable.
		public method flush takes nothing returns nothing
			call FlushParentHashtable(this.m_hashTable)
		endmethod

		public method flushKey takes integer key returns nothing
			call FlushChildHashtable(this.m_hashTable, key)
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_hashTable = InitHashtable()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.flush()
			set this.m_hashTable = null
		endmethod

		private static method onInit takes nothing returns nothing
			// static members
			set thistype.m_global = 0
		endmethod

		/**
		 * Global hash table is used by the ASL itself for non-attached values.
		 */
		public static method global takes nothing returns thistype
			if (thistype.m_global == 0) then
				set thistype.m_global = thistype.create()
			endif
			return thistype.m_global
		endmethod
	endstruct

endlibrary