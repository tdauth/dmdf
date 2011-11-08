library StructGameNpcRevival requires Asl, StructGameDmdfHashTable

	/**
	 * NPC revivals provide a character-like revival functionality for non-hero units (NPCs).
	 * Additionally there will be a fake hero icon for all playing users to control the NPC.
	 * Fake hero icons are necessary because units aren't real heroes. AHeroIcon should consider that and create an icon despite this fact.
	 */
	struct NpcRevival
		private unit m_unit
		private real m_time
		private real m_x
		private real m_y
		private real m_facing
		private string m_infoMessage
		private sound m_infoSound
		private string m_revivalMessage
		private sound m_revivalSound
		private trigger m_trigger
		private timer m_timer
		private timerdialog m_timerDialog
		private AHeroIcon array m_heroIcon[6] /// @todo MapData.maxPlayers

		public method revive takes nothing returns nothing
			debug call Print("Revive")
			debug call Print("NPC Revival: " + GetUnitName(this.m_unit))

			if (DmdfHashTable.global().handleBoolean(this.m_unit, "NpcRevival:Active")) then
				call PauseUnit(this.m_unit, false)
				call SetUnitInvulnerable(this.m_unit, false)
				call SetUnitPosition(this.m_unit, this.m_x, this.m_y)
				call SetUnitFacing(this.m_unit, this.m_facing)
				call SetUnitLifePercentBJ(this.m_unit, 100)
				call SetUnitManaPercentBJ(this.m_unit, 30)
				call ShowUnit(this.m_unit, true)
				if (this.m_revivalMessage != null) then
					call TransmissionFromUnit(this.m_unit, this.m_revivalMessage, this.m_revivalSound)
				endif
				call DmdfHashTable.global().setHandleBoolean(this.m_unit, "NpcRevival:Active", false)
			debug else
				debug call Print("Unit is not dead?!")
			endif
		endmethod

		private static method timerFunctionRevive takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this")
			call TimerDialogDisplay(this.m_timerDialog, false)
			call this.revive()
		endmethod

		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call DisableTrigger(GetTriggeringTrigger())
			debug call Print("Unit is " + GetUnitName(this.m_unit))

			call SetUnitInvulnerable(this.m_unit, true)
			call PauseUnit(this.m_unit, true)
			call ShowUnit(this.m_unit, false)
			call SetUnitLifePercentBJ(this.m_unit, 100)
			call DmdfHashTable.global().setHandleBoolean(this.m_unit, "NpcRevival:Active", true)

			// create death animation
			call KillUnit(CreateUnit(GetOwningPlayer(this.m_unit), GetUnitTypeId(this.m_unit), GetUnitX(this.m_unit), GetUnitY(this.m_unit), GetUnitFacing(this.m_unit))) /// @todo Copy unit?

			if (this.m_infoMessage != null) then
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, this.m_infoMessage)
			endif

			if (this.m_infoSound != null) then
				call StartSound(this.m_infoSound)
			endif

			if (this.m_time <= 0.0) then
				call this.revive()
			else
				if (this.m_timer == null) then
					set this.m_timer = CreateTimer()
					call DmdfHashTable.global().setHandleInteger(this.m_timer, "this", this)
					set this.m_timerDialog = CreateTimerDialog(this.m_timer)
					call TimerDialogSetTitle(this.m_timerDialog, StringArg(tr("%s:"), GetUnitName(this.m_unit)))
					call TimerDialogSetTitleColor(this.m_timerDialog, 0, 255, 255, 255) /// @todo set player color
				endif
				call TimerStart(this.m_timer, this.m_time, false, function thistype.timerFunctionRevive)
				call TimerDialogDisplay(this.m_timerDialog, true)
			endif

			call EnableTrigger(GetTriggeringTrigger())
		endmethod

		public static method create takes unit whichUnit, real time, real x, real y, real facing, string infoMessage, sound infoSound, string revivalMessage, sound revivalSound returns thistype
			local thistype this = thistype.allocate()
			local integer i
			set this.m_unit = whichUnit
			set this.m_time = time
			set this.m_x = x
			set this.m_y = y
			set this.m_facing = facing
			set this.m_facing = facing
			set this.m_infoMessage = infoMessage
			set this.m_infoSound = infoSound
			set this.m_revivalMessage = revivalMessage
			set this.m_revivalSound = revivalSound
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (IsPlayerPlayingUser(Player(i))) then
					set this.m_heroIcon[i] = AHeroIcon.create(whichUnit, Player(i), Character.heroIconRefreshTime, GetRectCenterX(gg_rct_character), GetRectCenterY(gg_rct_character), 0.0)
					call this.m_heroIcon[i].start()
				else
					set this.m_heroIcon[i] = 0
				endif
				set i = i + 1
			endloop
			set this.m_trigger = CreateTrigger()
			call TriggerRegisterUnitStateEvent(this.m_trigger, whichUnit, UNIT_STATE_LIFE, LESS_THAN, 2.0)
			call TriggerAddAction(this.m_trigger, function thistype.triggerActionRevival)
			call DmdfHashTable.global().setHandleInteger(this.m_trigger, "this", this)
			set this.m_timer = null
			set this.m_timerDialog = null
			call DmdfHashTable.global().setHandleBoolean(this.m_unit, "NpcRevival:Active", false)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (this.m_heroIcon[i] != 0) then
					call this.m_heroIcon[i].destroy()
				endif
				set i = i + 1
			endloop
			call DmdfHashTable.global().destroyTrigger(this.m_trigger)
			set this.m_trigger = null
			if (this.m_timer != null) then
				call PauseTimer(this.m_timer)
				call DmdfHashTable.global().destroyTimer(this.m_timer)
				set this.m_timer = null
				call DestroyTimerDialog(this.m_timerDialog)
				set this.m_timerDialog = null
			endif
			call DmdfHashTable.global().removeHandleBoolean(this.m_unit, "NpcRevival:Active")
		endmethod
	endstruct

endlibrary