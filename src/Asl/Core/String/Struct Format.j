library AStructCoreStringFormat requires ALibraryCoreStringMisc, optional ALibraryCoreDebugMisc

	/**
	 * Use this struct to format strings which should be internationalized.
	 * \code
	 local string message = Format(tr("It's %1% o'clock and you're going to die in %2% hours. Maybe you should ask %3% why you're still alive.")).t(GetTimeOfDay()).i(3).s("Peter").result()
	 * \endcode
	 * Instead of \ref thistype.create you can use the global function Format.
	 * Instead of \ref thistype.result you can use the global function String.
	 * This structure has been inspired by <a href="http://www.boost.org/doc/libs/1_43_0/libs/format/index.html">Boost C++ Libraries projects's format module</a>.
	 * Unfortunately vJass does not allow operator and method overloading.
	 * \sa String, Format, tr, sc, IntegerArg, RealArg, RealArgW, StringArg, HandleArg
	 * \author Tamino Dauth
	 */
	struct AFormat
		private integer m_position
		private string m_text

		//! runtextmacro A_STRUCT_DEBUG("\"AFormat\"")

		/**
		 * Ordered arguments formatting is implemented by storing the current format position.
		 * \return Returns the current formatting position/argument.
		 */
		public method position takes nothing returns integer
			return this.m_position
		endmethod

		/**
		 * \return Returns the current formatted text/string.
		 */
		public method text takes nothing returns string
			return this.m_text
		endmethod

		/**
		 * This text macro generates a new method for a specified argument type which can be used when formatting strings.
		 * Searches for the first type token \p TYPECHARS (in form of %<type char like i>) and replaces it by \p value.
		 * If none is found it searches for the next position token (in form of %1% or %2% ...) and replaces it by \p value.
		 * \param NAME Name of the argument method (usually it is equal to its type char).
		 * \param TYPE JASS/vJass type of the argument.
		 * \param CONVERSION Conversion call from argument to string (like "I2S(value)").
		 * \param PARAMETERS Optional parameter list which can be accessed in the \p CONVERSION parameter as well (useful for real precision parameters).
		 */
		//! textmacro AFormatMethod takes NAME, TYPE, TYPECHARS, CONVERSION, PARAMETERS
			public method $NAME$ takes $TYPE$ value $PARAMETERS$ returns thistype
				local string positionString = "%$TYPECHARS$"
				local integer index = FindString(this.m_text, positionString)
				if (index == -1) then
					set positionString = "%" + I2S(this.m_position + 1) + "%"
					set index = FindString(this.m_text, positionString)
				endif
				
				if (index != -1) then
					set this.m_text = SubString(this.m_text, 0, index) + $CONVERSION$ + SubString(this.m_text, index + StringLength(positionString), StringLength(this.m_text))
					set this.m_position = this.m_position + 1
				else
					debug call this.print("Format error in string \"" + this.m_text + "\" at position " + I2S(this.m_position) + " for token argument \"" + $CONVERSION$ + "\".")
				endif
				
				return this
			endmethod
		//! endtextmacro

		//! runtextmacro AFormatMethod("i", "integer", "i", "I2S(value)", "")
		//! runtextmacro AFormatMethod("integer", "integer", "i", "I2S(value)", "")
		//! runtextmacro AFormatMethod("r", "real", "r", "R2S(value)", "")
		//! runtextmacro AFormatMethod("real", "real", "r", "R2S(value)", "")
		//! runtextmacro AFormatMethod("rw", "real", "r", "R2SW(value, width, precision)", ", integer width, integer precision")
		//! runtextmacro AFormatMethod("realWidth", "real", "r", "R2SW(value, width, precision)", ", integer width, integer precision")
		//! runtextmacro AFormatMethod("s", "string", "s", "value", "")
		//! runtextmacro AFormatMethod("string", "string", "s", "value", "")
		//! runtextmacro AFormatMethod("h", "handle", "h", "I2S(GetHandleId(value))", "")
		//! runtextmacro AFormatMethod("handle", "handle", "h", "I2S(GetHandleId(value))", "")
		//! runtextmacro AFormatMethod("u", "unit", "u", "GetUnitName(value)", "")
		//! runtextmacro AFormatMethod("unit", "unit", "u", "GetUnitName(value)", "")
		//! runtextmacro AFormatMethod("it", "item", "it", "GetItemName(value)", "")
		//! runtextmacro AFormatMethod("item", "item", "it", "GetItemName(value)", "")
		//! runtextmacro AFormatMethod("d", "destructable", "d", "GetDestructableName(value)", "")
		//! runtextmacro AFormatMethod("destructable", "destructable", "d", "GetDestructableName(value)", "")
		//! runtextmacro AFormatMethod("p", "player", "p", "GetPlayerName(value)", "")
		//! runtextmacro AFormatMethod("player", "player", "p", "GetPlayerName(value)", "")
		//! runtextmacro AFormatMethod("he", "unit", "he", "GetHeroProperName(value)", "")
		//! runtextmacro AFormatMethod("hero", "unit", "he", "GetHeroProperName(value)", "")
		//! runtextmacro AFormatMethod("o", "integer", "o", "GetObjectName(value)", "")
		//! runtextmacro AFormatMethod("object", "integer", "o", "GetObjectName(value)", "")
		//! runtextmacro AFormatMethod("l", "string", "l", "GetLocalizedString(value)", "")
		//! runtextmacro AFormatMethod("localizedString", "string", "l", "GetLocalizedString(value)", "")
		//! runtextmacro AFormatMethod("k", "string", "k", "I2S(GetLocalizedHotkey(value))", "")
		//! runtextmacro AFormatMethod("localizedHotkey", "string", "k", "I2S(GetLocalizedHotkey(value))", "")
		//! runtextmacro AFormatMethod("e", "integer", "e", "GetExternalString.evaluate(value)", "")
		//! runtextmacro AFormatMethod("externalString", "integer", "e", "GetExternalString.evaluate(value)", "")
		/// Use seconds as parameter!
		//! runtextmacro AFormatMethod("t", "integer", "t", "GetTimeString.evaluate(value)", "")
		/// Use seconds as parameter!
		//! runtextmacro AFormatMethod("time", "integer", "t", "GetTimeString.evaluate(value)", "")

		/**
		 * \return Returns the formatted string result and destroys the instance.
		 * \note Don't use the destroyed instance afterwards!
		 * \sa String()
		 */
		public method result takes nothing returns string
			local string result = this.m_text
			call this.destroy()
			return result
		endmethod

		/**
		 * Creates a new instance based on text \p text.
		 * \sa Format()
		 */
		public static method create takes string text returns AFormat
			local thistype this = thistype.allocate()
			set this.m_position = 0
			set this.m_text = text
			return this
		endmethod
	endstruct

	/**
	 * Global function and alternative to \ref AFormat.result().
	 * \return Returns the formatted result and destroys the formatting instance.
	 * \sa AFormat.result()
	 */
	function String takes AFormat format returns string
		return format.result()
	endfunction

	/**
	 * Global function and alternative to \ref AFormat.create().
	 * \return Returns a newly created formatting instance.
	 * \sa AFormat.create()
	 */
	function Format takes string text returns AFormat
		return AFormat.create(text)
	endfunction

endlibrary