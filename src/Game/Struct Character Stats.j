library StructGameCharacterStats requires Asl, StructGameCharacter, StructGameDmdfHashTable

	/**
	* @todo Member data should be set by triggers or DMdF code (e. g. spells - caused damage)
	* @todo Note that all data has to be real (e. g. if there is a damage spell which causes 1000 damage points and the target has only 200 HP, 200 will be added to character's caused damage not 1000)
	*/
	struct CharacterStats
		// construction members
		private Character m_character
		// members
		private real m_causedDamage
		private real m_healedHitPoints
		private real m_healedTargetPoints
		private real m_regeneratedMana
		private real m_regeneratedTargetMana
		private integer m_killHits
		private integer m_deaths
		private ADamageRecorder m_damageRecorder
		private trigger m_killTrigger
		private trigger m_deathTrigger

		public method takenDamage takes nothing returns real
			return this.m_damageRecorder.totalDamage()
		endmethod

		public method killHits takes nothing returns integer
			return this.m_killHits
		endmethod

		public method deaths takes nothing returns integer
			return this.m_deaths
		endmethod

		public method show takes nothing returns nothing
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, tr("Charakterstatistik:"))
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, RealWidthArg(tr("Erlittener Schaden: %r"), this.takenDamage(), 0, 2))
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Volltreffer: %i"), this.killHits()))
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Tode: %i"), this.deaths()))
		endmethod

		private static method triggerConditionKill takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			if (GetKillingUnit() == this.m_character.unit()) then
				set this.m_killHits = this.m_killHits + 1
				return true
			endif

			return false
		endmethod

		private static method triggerActionDeath takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			set this.m_deaths = this.m_deaths + 1
			return true
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_character = character
			// members
			set this.m_causedDamage = 0.0
			set this.m_healedHitPoints = 0.0
			set this.m_healedTargetPoints = 0.0
			set this.m_regeneratedMana = 0.0
			set this.m_regeneratedTargetMana = 0.0
			set this.m_killHits = 0
			set this.m_deaths = 0
			set this.m_damageRecorder = ADamageRecorder.create(character.unit())
			set this.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_killTrigger, Condition(function thistype.triggerConditionKill))
			call DmdfHashTable.global().setHandleInteger(this.m_killTrigger, "this", this)
			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_deathTrigger, character.unit(), EVENT_UNIT_DEATH)
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call DmdfHashTable.global().setHandleInteger(this.m_deathTrigger, "this", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_damageRecorder.destroy()
			call DmdfHashTable.global().destroyTrigger(this.m_killTrigger)
			call DmdfHashTable.global().destroyTrigger(this.m_deathTrigger)
		endmethod
	endstruct

endlibrary