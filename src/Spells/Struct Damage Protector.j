library StructSpellsDamageProtector requires Asl

	/**
	 * \brief The damage protector allows to protect a unit from a certain percentage of damage.
	 * It might be useful for some protection spells.
	 */
	struct DamageProtector extends ADamageRecorder
		private real m_protectedDamage
		private real m_protectedDamagePercentage
		private real m_lastPreventedDamage

		public method setProtectedDamage takes real protectedDamage returns nothing
			set this.m_protectedDamage = protectedDamage
		endmethod

		public method protectedDamage takes nothing returns real
			return this.m_protectedDamage
		endmethod

		public method setProtectedDamagePercentage takes real protectedDamagePercentage returns nothing
			set this.m_protectedDamagePercentage = protectedDamagePercentage
		endmethod

		public method protectedDamagePercentage takes nothing returns real
			return this.m_protectedDamagePercentage
		endmethod

		public method lastPreventedDamage takes nothing returns real
			return this.m_lastPreventedDamage
		endmethod

		public stub method onSufferDamage takes nothing returns nothing
			local real protectedDamage = RMinBJ(GetEventDamage(), GetEventDamage() * this.protectedDamagePercentage() + this.protectedDamage())
			local unit target = this.target()
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + protectedDamage)
			set this.m_lastPreventedDamage = protectedDamage
			debug call Print("Prevented " + R2S(protectedDamage) + " damage.")
			set target = null
			call super.onSufferDamage() // call user-defined action
		endmethod

		public static method create takes unit target returns thistype
			local thistype this = thistype.allocate(target)
			set this.m_protectedDamage = 0.0
			set this.m_protectedDamagePercentage = 0.0
			set this.m_lastPreventedDamage = 0.0

			return this
		endmethod
	endstruct

endlibrary