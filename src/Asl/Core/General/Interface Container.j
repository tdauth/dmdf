library AInterfaceCoreGeneralContainer

	/// \todo Each container iterator struct should be extended by this interface, vJass bug.
	interface AIteratorInterface
		public method isValid takes nothing returns boolean
		public method hasNext takes nothing returns boolean
		public method hasPrevious takes nothing returns boolean
		/// Similar to C++'s ++ iterators operator.
		public method next takes nothing returns nothing
		/// Similar to C++'s -- iterators operator.
		public method previous takes nothing returns nothing
		/// \todo JassHelper bug
		//public method operator== takes thistype other returns boolean
	endinterface

	/// \todo Each iterator-using container should be extended by this interface, vJass bug.
	interface AContainerInterface
		public method begin takes nothing returns AIteratorInterface
		public method end takes nothing returns AIteratorInterface
		public method size takes nothing returns integer
		public method empty takes nothing returns boolean
		public method eraseNumber takes AIteratorInterface first, AIteratorInterface last returns nothing
		public method erase takes AIteratorInterface position returns nothing
		public method randomIterator takes nothing returns AIteratorInterface
		public method clear takes nothing returns nothing
		/// \todo JassHelper bug
		//public method operator< takes thistype other returns boolean
	endinterface

	globals
		/// Global iterator variable which has to be used in ASL foreach statements.
		AIteratorInterface aIterator = 0
	endglobals

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_FOREACH takes CONTAINERVARIABLE
		set aIterator = $CONTAINERVARIABLE$.begin()
		loop
			exitwhen (not aIterator.isValid())
	//! endtextmacro

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_FOREACH_2 takes VARIABLE, CONTAINERVARIABLE, ITERATORTYPE
		set aIterator = $CONTAINERVARIABLE$.begin()
		loop
			exitwhen (not aIterator.isValid())
			set $VARIABLE$ = $CONTAINERVARIABLE$(aIterator).data()
	//! endtextmacro

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_FOREACH_END
			call aIterator.next()
		endloop
		call aIterator.destroy()
	//! endtextmacro

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_REVERSE_FOREACH takes CONTAINERVARIABLE
		set aIterator = $CONTAINERVARIABLE$.end()
		loop
			exitwhen (not aIterator.isValid())
	//! endtextmacro

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_REVERSE_FOREACH_2 takes VARIABLE, CONTAINERVARIABLE, ITERATORTYPE
		set aIterator = $CONTAINERVARIABLE$.end()
		loop
			exitwhen (not aIterator.isValid())
			set $VARIABLE$ = $CONTAINERVARIABLE$(aIterator).data()
	//! endtextmacro

	/**
	 * \warning There should not be any \ref TriggerSleepAction() call in foreach block.
	 * \ingroup foreach
	 */
	//! textmacro A_REVERSE_FOREACH_END
			call aIterator.previous()
		endloop
		call aIterator.destroy()
	//! endtextmacro

	/// Use this to clean up integer containers which store struct instances which has to be destroyed before removing them from container.
	/// \ingroup foreach
	//! textmacro A_DESTROY takes CONTAINERVARIABLE, MEMBERTYPE
		loop
			exitwhen ($CONTAINERVARIABLE$.empty())
			call $MEMBERTYPE$($CONTAINERVARIABLE$.back()).destroy()
			call $CONTAINERVARIABLE$.popBack()
		endloop
		call $CONTAINERVARIABLE$.destroy()
	//! endtextmacro

endlibrary