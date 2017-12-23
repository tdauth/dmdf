library StructGameQuestArea requires Asl, StructGameCharacter, StructGameDmdfHashTable

	function interface QuestAreaEnterCondition takes QuestArea questArea returns boolean

	function interface QuestAreaEnterAction takes QuestArea questArea returns nothing

	/**
	 * \brief A quest are is a visible marked rect on the map for all players where all characters must move to to activate an event.
	 * It is mostly used to ensure that all characters are at a certain point when the event starts and are movable and not in talks or something else.
	 */
	struct QuestArea
		// static members
		private static constant integer maxAssemblyPointMarkers = 4
		private static AIntegerVector m_questAreas
		// members
		private fogmodifier array m_assemblyPointFogModifier[12] /// \todo MapSettings.maxPlayers()
		private destructable array m_assemblyPointMarker[4] /// \todo thistype.maxAssemblyPointMarkers
		private rect m_rect
		private trigger m_enterTrigger
		// dynamic members
		private QuestAreaEnterCondition m_enterCondition
		private QuestAreaEnterAction m_enterAction
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

		public method setEnterCondition takes QuestAreaEnterCondition enterCondition returns nothing
			set this.m_enterCondition = enterCondition
		endmethod

		public method enterCondition takes nothing returns QuestAreaEnterCondition
			return this.m_enterCondition
		endmethod

		public method setEnterAction takes QuestAreaEnterAction enterAction returns nothing
			set this.m_enterAction = enterAction
		endmethod

		public method enterAction takes nothing returns QuestAreaEnterAction
			return this.m_enterAction
		endmethod

		/**
		 * Checks for a user specified condition which must be true to activate the event at all.
		 * Otherwise not even a message is shown when a character enters.
		 * \note Is called with .evaluate().
		 * \return Returns true if the event can be activated yet.
		 */
		public stub method onCheck takes nothing returns boolean
			if (this.enterCondition() != 0) then
				return this.enterCondition().evaluate(this)
			endif
			return true
		endmethod

		/**
		 * \note Is called with .execute().
		 */
		public stub method onStart takes nothing returns nothing
			debug call Print("Super onStart")
			if (this.enterAction() != 0) then
				call this.enterAction().execute(this)
			endif
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
				exitwhen (i == thistype.maxAssemblyPointMarkers)
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
			local ACharacter playerCharacter = 0
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
					set playerCharacter = ACharacter.playerCharacter(Player(i))
					if (playerCharacter != 0 and playerCharacter != enteringCharacter and RectContainsUnit(this.m_rect, playerCharacter.unit()) and playerCharacter.isMovable()) then
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

		public stub method show takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxAssemblyPointMarkers)
				call ShowDestructable(this.m_assemblyPointMarker[i], true)
				set i = i + 1
			endloop
		endmethod

		public stub method hide takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxAssemblyPointMarkers)
				call ShowDestructable(this.m_assemblyPointMarker[i], false)
				set i = i + 1
			endloop
		endmethod

		public stub method enable takes nothing returns nothing
			call EnableTrigger(this.m_enterTrigger)
		endmethod

		public stub method disable takes nothing returns nothing
			call DisableTrigger(this.m_enterTrigger)
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

			set this.m_enterCondition = 0
			set this.m_enterAction = 0
			call this.setDestroyOnActivation(true)

			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_enterTrigger, this.m_rect)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(this.m_enterTrigger, function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, 0, this)

			call thistype.m_questAreas.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.cleanupRect()
			set this.m_rect = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null

			call thistype.m_questAreas.remove(this)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_questAreas = AIntegerVector.create()
		endmethod

		public static method questAreas takes nothing returns AIntegerVector
			return thistype.m_questAreas
		endmethod

		public static method showAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.questAreas().size())
				call thistype(thistype.questAreas()[i]).show()
				set i = i + 1
			endloop
		endmethod

		public static method hideAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.questAreas().size())
				call thistype(thistype.questAreas()[i]).hide()
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary