library AStructCoreGeneralStack requires optional ALibraryCoreDebugMisc

	/**
	 * \sa containers
	 */
	//! textmacro A_STACK takes STRUCTPREFIX, NAME, TYPE, NULLVALUE, STRUCTSPACE, NODESPACE
		$STRUCTPREFIX$ struct $NAME$DataNode[$NODESPACE$]
			// construction members
			private $TYPE$ m_data
			private thistype m_next

			// construction members

			public method data takes nothing returns $TYPE$
				return this.m_data
			endmethod

			public method next takes nothing returns thistype
				return this.m_next
			endmethod

			// methods

			public static method create takes $TYPE$ data, thistype next returns thistype
				local thistype this = thistype.allocate()
				// construction members
				set this.m_data = data
				set this.m_next = next

				return this
			endmethod

			public method onDestroy takes nothing returns nothing
				set this.m_data = $NULLVALUE$
			endmethod
		endstruct

		$STRUCTPREFIX$ struct $NAME$[$STRUCTSPACE$]
			public static constant string structPrefix = "$STRUCTPREFIX$"
			public static constant string name = "$NAME$"
			public static constant $ELEMENTTYPE$ nullValue = $NULLVALUE$
			public static constant integer structSpace = $STRUCTSPACE$
			public static constant integer nodeSpace = $NODESPACE$
			// members
			private $NAME$DataNode m_dataNode
			private integer m_size

			// dynamic members

			public method setMaxSize takes integer maxSize returns nothing
				set this.m_maxSize = maxSize
			endmethod

			public method maxSize takes nothing returns integer
				return this.m_maxSize
			endmethod

			// members

			public method size takes nothing returns integer
				return this.m_size
			endmethod

			// methods

			public method empty takes nothing returns boolean
				return this.m_size == 0
			endmethod

			/// Adds a new elment to stack.
			public method push takes thistype data returns nothing
				local $NAME$DataNode dataNode = $NAME$DataNode.create(data, this.m_dataNode)
				debug if (dataNode != 0) then
					set this.m_dataNode = dataNode
					set this.m_size = this.m_size + 1
				debug else
					debug call Print("Stack is full - By Jass limit.")
				debug endif
			endmethod

			/// Returns the supreme element and removes it from stack.
			public method pop takes nothing returns integer
				local integer nodeData = 0
				local $NAME$DataNode oldDataNode
				debug if (this.m_dataNode != 0) then
					set oldDataNode = this.m_dataNode
					set this.m_dataNode = this.m_dataNode.next()
					set nodeData = oldDataNode.data()
					call oldDataNode.destroy()
					set this.m_size = this.m_size - 1
				debug else
					debug call Print("Stack is empty.")
				debug endif
				return nodeData
			endmethod

			public method clear takes nothing returns nothing
				loop
					exitwhen (this.empty())
					call this.pop()
				endloop
			endmethod

			public static method create takes integer maxSize returns thistype
				local thistype this = thistype.allocate()
				// dynamic members
				set this.m_maxSize = maxSize
				// members
				set this.m_dataNode = 0
				set this.m_size = 0

				return this
			endmethod

			public method onDestroy takes nothing returns nothing
				call this.clear()
			endmethod
		endstruct
	//! endtextmacro

	/**
	 * Default stacks with JASS data types.
	 * max instances = required struct space / biggest array member size
	 * 400000 is struct space maximum
	 * max instances = 5000 / 1 = 5000 - no array member
	 */
	///! runtextmacro A_STACK("", "AIntegerStack", "integer", "0", "150000", "150000")
	///! runtextmacro A_STACK("", "AStringStack", "string", "null", "150000", "150000")
	///! runtextmacro A_STACK("", "ABooleanStack", "boolean", "false", "150000", "150000")
	///! runtextmacro A_STACK("", "ARealStack", "real", "0.0", "150000", "150000")
	///! runtextmacro A_STACK("", "AHandleStack", "handle", "null", "150000", "150000")

endlibrary