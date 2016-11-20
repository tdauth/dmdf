library StructGameQuestArea requires Asl, StructGameCharacter, StructGameDmdfHashTable

	/**
	 * \brief A quest are is a visible marked rect on the map for all players where all characters must move to to activate an event.
	 * It is mostly used to ensure that all characters are at a certain point when the event starts and are movable and not in talks or something else.
	 */
	struct QuestArea
		private fogmodifier array m_assemblyPointFogModifier[12] /// \todo MapSettings.maxPlayers()
		private destructable array m_assemblyPointMarker[4]
		private rect m_rect
		private trigger m_enterTrigger
		// dynamic members
		private boolean m_destroyOnActivation
		/**
		 * The destructable type ID of an energie wall.
		 */
		private static constant integer destructableId = 'B00N'
		/**
		 * The length of an energie wall with scaling 1.0.
		 */
		private static constant real defaultLength = 6 * bj_CELLWIDTH

		public method setDestroyOnActivation takes boolean destroyOnActivation returns nothing
			set this.m_destroyOnActivation = destroyOnActivation
		endmethod

		public method destroyOnActivation takes nothing returns boolean
			return this.m_destroyOnActivation
		endmethod

		public method rect takes nothing returns rect
			return this.m_rect
		endmethod

		/**
		 * Checks for a user specified condition which must be true to activate the event at all.
		 * Otherwise not even a message is shown when a character enters.
		 * \note Is called with .evaluate().
		 * \return Returns true if the event can be activated yet.
		 */
		public stub method onCheck takes nothing returns boolean
			return true
		endmethod

		/**
		 * \note Is called with .execute().
		 */
		public stub method onStart takes nothing returns nothing
			debug call Print("Super onStart")
		endmethod

		public method setFogModifiersEnabled takes boolean enabled returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (this.m_assemblyPointFogModifier[i] != null) then
					if (enabled) then
						call FogModifierStart(this.m_assemblyPointFogModifier[i])
					else
						call FogModifierStop(this.m_assemblyPointFogModifier[i])
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		private method cleanupRect takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (this.m_assemblyPointFogModifier[i] != null) then
					call DestroyFogModifier(this.m_assemblyPointFogModifier[i])
					set this.m_assemblyPointFogModifier[i] = null
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == 4)
				call RemoveDestructable(this.m_assemblyPointMarker[i])
				set this.m_assemblyPointMarker[i] = null
				set i = i + 1
			endloop
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local ACharacter enteringCharacter = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local integer i = 0
			local integer charactersCount = 0
			debug call Print("Entering: " + GetUnitName(GetTriggerUnit()) + " character: " + I2S(enteringCharacter))
			if (enteringCharacter != 0 and this.onCheck.evaluate()) then
				set i = 0
				/*
				 * Start with count of one since the entering character will always be counted with.
				 * Sometimes he is not recognized to be already in the rect so just assume he is in it.
				 */
				set charactersCount = 1
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (ACharacter.playerCharacter(Player(i)) != 0 and ACharacter.playerCharacter(Player(i)) != enteringCharacter and RectContainsUnit(this.m_rect, ACharacter.playerCharacter(Player(i)).unit()) and  ACharacter.playerCharacter(Player(i)).isMovable()) then
						set charactersCount = charactersCount + 1
					endif
					set i = i + 1
				endloop

				call Character.displayHintToAll(Format(tre("%1%/%2% Charakteren bereit.", "%1%/%2% characters are ready.")).i(charactersCount).i(ACharacter.countAll()).result())

				// TODO if condition is true immediately make characters unmovable and make them movable after the action call?
				return charactersCount == ACharacter.countAll()
			endif
			return false
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			/*
			 * A quest are should only be used once.
			 * Therefore it will be disabled automatically.
			 */
			if (this.destroyOnActivation()) then
				debug call Print("Destroy on activation")
				call this.cleanupRect()
				call DisableTrigger(GetTriggeringTrigger())
			endif
			/*
			 * Must be executed since it contains TriggerSleepAction() calls most of the time like playing videos and waiting for them.
			 */
			call this.onStart.execute()
		endmethod

		/**
		 * Creates a new quest area in rect \p whichRect.
		 * This shows an energie wall around the rect and checks for condition \ref onCheck() when a character enters.
		 */
		public static method create takes rect whichRect, boolean withFogModifier returns thistype
			local thistype this = thistype.allocate()
			local integer i
			local real leftX
			local real leftY
			local real rightX
			local real rightY
			local real topX
			local real topY
			local real bottomX
			local real bottomY
			local real verticalScaling
			local real horizontalScaling
			set this.m_rect = whichRect
			// create a visible effect on the map that it is easier to find the rect
			if (withFogModifier) then
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					set this.m_assemblyPointFogModifier[i] = CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, this.m_rect, true, true)
					call FogModifierStart(this.m_assemblyPointFogModifier[i])
					set i = i + 1
				endloop
			endif

			set leftX = GetRectMinX(this.m_rect)
			set leftY = GetRectCenterY(this.m_rect)
			set rightX = GetRectMaxX(this.m_rect)
			set rightY = GetRectCenterY(this.m_rect)
			set topX = GetRectCenterX(this.m_rect)
			set topY = GetRectMaxY(this.m_rect)
			set bottomX = GetRectCenterX(this.m_rect)
			set bottomY = GetRectMinY(this.m_rect)

			set verticalScaling = (GetRectMaxY(this.m_rect) - GetRectMinY(this.m_rect)) / thistype.defaultLength
			set horizontalScaling = (GetRectMaxX(this.m_rect) - GetRectMinX(this.m_rect)) / thistype.defaultLength

			// right
			set this.m_assemblyPointMarker[0] = CreateDestructable(thistype.destructableId, rightX, rightY, 0.0, verticalScaling,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[0], true)

			// left
			set this.m_assemblyPointMarker[1] = CreateDestructable(thistype.destructableId, leftX, leftY, 0.0, verticalScaling,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[1], true)

			// top
			set this.m_assemblyPointMarker[2] = CreateDestructable(thistype.destructableId, topX, topY, 90.0, horizontalScaling,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[2], true)

			// bottom
			set this.m_assemblyPointMarker[3] = CreateDestructable(thistype.destructableId, bottomX, bottomY, 90.0, horizontalScaling,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[3], true)

			call this.setDestroyOnActivation(true)

			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_enterTrigger, this.m_rect)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(this.m_enterTrigger, function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.cleanupRect()
			set this.m_rect = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null
		endmethod
	endstruct

endlibrary