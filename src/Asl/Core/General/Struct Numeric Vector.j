library AStructCoreGeneralNumericVector requires AStructCoreGeneralVector

	/**
	 * Text macro which can generate a numeric container based on a vector structure (usually generated with \ref A_VECTOR).
	 * Provides various numeric functions which help users to calculate values based on their container elements.
	 * \todo At the moment many functions don't work because of the corrupted JassHelper implementation.
	 * \sa containers
	 */
	//! textmacro A_NUMERIC_VECTOR takes STRUCTPREFIX, NAME, PARENTNAME, ELEMENTTYPE

		$STRUCTPREFIX$ struct $NAME$ extends $PARENTNAME$
			public static constant string parentName = "$PARENTNAME$"

			/**
			 * \return Returns the maximum element of the vector.
			 */
			public method max takes nothing returns $ELEMENTTYPE$
				local integer i = 0
				local $ELEMENTTYPE$ result = 0
				loop
					exitwhen (i == this.size())
					if (this[i] > result) then
						set result = this[i]
					endif
					set i = i + 1
				endloop
				return result
			endmethod

			/**
			 * \return Returns the minimum element of the vector.
			 */
			public method min takes nothing returns $ELEMENTTYPE$
				local integer i
				local $ELEMENTTYPE$ result
				if (this.empty()) then
					return 0
				endif
				set result = this[0]
				set i = 1
				loop
					exitwhen (i == this.size())
					if (this[i] < result) then
						set result = this[i]
					endif
					set i = i + 1
				endloop
				return result
			endmethod

			/**
			 * \return Returns the sum of all elements from the vector.
			 */
			public method sum takes nothing returns $ELEMENTTYPE$
				local integer i = 0
				local $ELEMENTTYPE$ result = 0
				loop
					exitwhen (i == this.size())
					set result = result + this[i]
					set i = i + 1
				endloop
				return result
			endmethod

			/// \todo FIXME JassHelper bug.
			public method add takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "add", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] + value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method substract takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "substract", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] - value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method multiply takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "multiply", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] * value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method divide takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "divide", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] / value
					set i = i + 1
				endloop
			endmethod

			/**
			 * Compares the sums of two vectors.
			 * \param other Compared vector.
			 * \return Returns true if this vector has a greater sum than \p other.
			 */
			public method greaterThan takes thistype other returns boolean
				return this.sum() > other.sum()
			endmethod

			/**
			 * Compares the sums of two vectors.
			 * \param other Compared vector.
			 * \return Returns true if this vector has a smaller sum than \p other.
			 */
			public method lessThan takes thistype other returns boolean
				return this.sum() < other.sum()
			endmethod

			/**
			 * Compares the sums of two vectors.
			 * \param other Compared vector.
			 * \return Returns true if the sums of this vector and \p other are equal.
			 */
			public method equal takes thistype other returns boolean
				return this.sum() == other.sum()
			endmethod

			/**
			 * Compares the sums of two vectors.
			 * \param other Compared vector.
			 * \return Returns true if the sums of this vector and \p other are not equal.
			 */
			public method unequal takes thistype other returns boolean
				return this.sum() != other.sum()
			endmethod
		endstruct

	//! endtextmacro

	//! runtextmacro A_NUMERIC_VECTOR("", "AIntegerNumericVector", "AIntegerVector", "integer")
	//! runtextmacro A_NUMERIC_VECTOR("", "ARealNumericVector", "ARealVector", "real")

endlibrary