library AStructSystemsCharacterClass requires AStructCoreGeneralVector

	/**
	 * \brief A simple struct to provide character class information which is mainly used in \ref AClassSelection.
	 * To provide more attributes per class it could easily be extended by a custom struct which then may be passed to AClassSelection.
	 */
	struct AClass
		// dynamic members
		private AStringVector m_descriptionLines // for character class selection
		private real m_strPerLevel
		private real m_agiPerLevel
		private real m_intPerLevel
		private integer m_startLevel
		private integer m_startSkillPoints
		// construction members
		private integer m_unitType
		private string m_animation
		private string m_soundPath

		// dynamic members

		public method addDescriptionLine takes string descriptionLine returns integer
			call this.m_descriptionLines.pushBack(descriptionLine)
			return this.m_descriptionLines.backIndex()
		endmethod

		public method descriptionLine takes integer index returns string
			return this.m_descriptionLines[index]
		endmethod

		public method descriptionLines takes nothing returns integer
			return this.m_descriptionLines.size()
		endmethod
		
		public method setStrPerLevel takes real strPerLevel returns nothing
			set this.m_strPerLevel = strPerLevel
		endmethod
		
		public method strPerLevel takes nothing returns real
			return this.m_strPerLevel
		endmethod
		
		public method setAgiPerLevel takes real agiPerLevel returns nothing
			set this.m_agiPerLevel = agiPerLevel
		endmethod
		
		public method agiPerLevel takes nothing returns real
			return this.m_agiPerLevel
		endmethod
		
		public method setIntPerLevel takes real intPerLevel returns nothing
			set this.m_intPerLevel = intPerLevel
		endmethod
		
		public method intPerLevel takes nothing returns real
			return this.m_intPerLevel
		endmethod

		// construction members

		/// Friend relation to \ref AClassSelection, don't use.
		public method unitType takes nothing returns integer
			return this.m_unitType
		endmethod

		/// Friend relation to \ref AClassSelection, don't use.
		public method animation takes nothing returns string
			return this.m_animation
		endmethod

		/// Friend relation to \ref AClassSelection, don't use.
		public method soundPath takes nothing returns string
			return this.m_soundPath
		endmethod

		// methods

		/**
		 * Creates a unit for the given player at the given position with unit type of class and its start level and start skill point if unit type is hero.
		 * Since this method is stub you can overwrite it and create another unit.
		 * This can be useful if you want to provide various unit types for the same class for example.
		 */
		public stub method generateUnit takes player whichPlayer, real x, real y, real facing returns unit
			local unit whichUnit = CreateUnit(whichPlayer, this.m_unitType, x, y, facing)
			if (IsUnitType(whichUnit, UNIT_TYPE_HERO)) then
				call SetHeroLevelBJ(whichUnit, this.m_startLevel, false)
				call UnitModifySkillPoints(whichUnit, (this.m_startSkillPoints - GetHeroSkillPoints(whichUnit))) // sets the skill points
			endif
			return whichUnit
		endmethod

		/// \param unitType Should be the type of a hero
		public static method create takes integer unitType, string animation, string soundPath, integer startLevel, integer startSkillPoints returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_descriptionLines = AStringVector.create()
			set this.m_strPerLevel = 0.0
			set this.m_agiPerLevel = 0.0
			set this.m_intPerLevel = 0.0
			// construction members
			set this.m_unitType = unitType
			set this.m_animation = animation
			set this.m_soundPath = soundPath
			set this.m_startLevel = startLevel
			set this.m_startSkillPoints = startSkillPoints

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// dynamic members
			call this.m_descriptionLines.destroy()
		endmethod
	endstruct

endlibrary