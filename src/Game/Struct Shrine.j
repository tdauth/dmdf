library StructGameShrine requires Asl

	struct Shrine extends AShrine
		private unit m_unit
		private static AIntegerVector m_shrines

		public method setUnit takes unit whichUnit returns nothing
			call UnitSetUsesAltIcon(this.m_unit, false)
			call UnitSetUsesAltIcon(whichUnit, true)
			set this.m_unit = whichUnit
		endmethod

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public stub method onEnter takes Character character returns nothing
			call super.onEnter(character)
			if (character.tutorial().isEnabled() and not character.tutorial().hasEnteredShrine()) then
				call character.tutorial().showShrineInfo()
			endif
		endmethod

		public static method create takes unit whichUnit, destructable usedDestructable, rect discoverRect, rect revivalRect, real facing returns thistype
			local thistype this = thistype.allocate(usedDestructable, discoverRect, revivalRect, facing)
			call UnitSetUsesAltIcon(whichUnit, true)
			set this.m_unit = whichUnit
			call thistype.m_shrines.pushBack(this)
			return this
		endmethod

		public static method init2 takes nothing returns nothing
			set thistype.m_shrines = AIntegerVector.create()
		endmethod

		public static method shrines takes nothing returns AIntegerVector
			return thistype.m_shrines
		endmethod

	endstruct

endlibrary