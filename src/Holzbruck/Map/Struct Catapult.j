library StructMapMapCatapult requires Asl

	struct Catapult
		// dynamic members
		private unit m_unit
		private ADamageMissileType m_damageMissileType
		private string m_throwAnimation
		private real m_throwAnimationDuration
		private real m_throwX
		private real m_throwY
		private real m_throwZ

		public method setUnit takes unit whichUnit returns nothing
			set this.m_unit = whichUnit
		endmethod

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method setDamageMissileType takes ADamageMissileType damageMissileType returns nothing
			set this.m_damageMissileType = damageMissileType
		endmethod

		public method damageMissileType takes nothing returns ADamageMissileType
			return this.m_damageMissileType
		endmethod

		public method fire takes real targetX, real targetY, real targetZ returns nothing
			local AMissile missile
			call QueueUnitAnimation(this.m_unit, this.m_throwAnimation)
			call TriggerSleepAction(this.m_throwAnimationDuration)
			set missile = AMissile.create()
			call missile.setMissileType(this.m_damageMissileType)
			call missile.setTargetX(targetX)
			call missile.setTargetY(targetY)
			call missile.setTargetZ(targetZ)
			call missile.start(this.m_throwX, this.m_throwY, this.m_throwZ)
		endmethod
	endstruct

endlibrary