library StructGameFellow requires Asl, StructGameCharacter, StructGameDmdfHashTable, StructGameGame

	/**
	 * Provides unit revival, hero icon, disables routine and talk (talk is optional), shared control with single player or all players.
	 * Fellow data is directly assigned to its corresponding unit and can therefore be got by static methods which do only require a unit parameter (\ref Fellow#getByUnit).
	 * When fellows are added to any fellowship their owner is changed to \ref MapData.alliedPlayer.
	 * \note Use \ref setDisableSellings() to remove sell ability while fellow is in fellowship. This is oftenly necessary to make all unit abilities of the fellow usable for any controlling user.
	 * \todo If talks are still enabled it should only be available for shared players!
	 */
	struct Fellow
		// static initialization members
		private static string m_infoMessageJoin
		private static sound m_infoSoundJoin
		private static string m_infoMessageLeave
		private static sound m_infoSoundLeave
		private static string m_infoMessageDeath
		private static sound m_infoSoundDeath
		// dynamic members
		private boolean m_hasHeroIcon
		private boolean m_hasTalk
		private boolean m_hasRevival
		private string m_description
		private string m_revivalMessage
		private sound m_revivalSound
		private AVector3 m_revivalLocation
		private real m_revivalTime
		private boolean m_disableSellings
		// construction members
		private unit m_unit
		private ATalk m_talk
		// members
		private Character m_character
		private trigger m_revivalTrigger
		private timer m_revivalTimer
		private timerdialog m_revivalTimerDialog
		private AHeroIcon array m_heroIcon[6] /// @todo MapData.maxPlayers
		private AIntegerVector m_sellingsAbilities

		//! runtextmacro A_STRUCT_DEBUG("\"Fellow\"")

		// dynamic members

		public method setHeroIcon takes boolean active returns nothing
			local integer i
			if (active == this.m_hasHeroIcon) then
				return
			endif
			set this.m_hasHeroIcon = active
			set i = 0
			loop
				if (this.m_heroIcon[i] != 0) then
					call this.m_heroIcon[i].setEnabled(active)
				endif
				set i = i + 1
				exitwhen (i == MapData.maxPlayers)
			endloop
		endmethod

		public method hasHeroIcon takes nothing returns boolean
			return this.m_hasHeroIcon
		endmethod

		public method hasTalk takes nothing returns boolean
			return this.m_hasTalk
		endmethod

		public method hasRevival takes nothing returns boolean
			return this.m_hasRevival
		endmethod

		public method setDescription takes string description returns nothing
			set this.m_description = description
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod

		public method setRevivalMessage takes string revivalMessage returns nothing
			set this.m_revivalMessage = revivalMessage
		endmethod

		public method revivalMessage takes nothing returns string
			return this.m_revivalMessage
		endmethod

		public method setRevivalSound takes sound revivalSound returns nothing
			set this.m_revivalSound = revivalSound
		endmethod

		public method revivalSound takes nothing returns sound
			return this.m_revivalSound
		endmethod

		public method setRevivalLocation takes AVector3 revivalLocation returns nothing
			set this.m_revivalLocation = revivalLocation
		endmethod

		public method revivalLocation takes nothing returns AVector3
			return this.m_revivalLocation
		endmethod

		public method setRevivalTime takes real revivalTime returns nothing
			set this.m_revivalTime = revivalTime
		endmethod

		public method revivalTime takes nothing returns real
			return this.m_revivalTime
		endmethod

		public method disableSellings takes nothing returns boolean
			return this.m_disableSellings
		endmethod

		// construction members

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method talk takes nothing returns ATalk
			return this.m_talk
		endmethod

		// members

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		// methods

		public method isShared takes nothing returns boolean
			return DmdfHashTable.global().handleBoolean(this.m_unit, "Fellow:Shared")
		endmethod

		private method setShared takes boolean shared returns nothing
			call DmdfHashTable.global().setHandleBoolean(this.m_unit, "Fellow:Shared", shared)
		endmethod

		private method setActive takes boolean active returns nothing
			call DmdfHashTable.global().setHandleBoolean(this.m_unit, "Fellow:Active", active)
		endmethod

		/**
		* \return Returns true if revival (timer) of fellow is active.
		*/
		private method isActive takes nothing returns boolean
			return DmdfHashTable.global().handleBoolean(this.m_unit, "Fellow:Active")
		endmethod

		public method isSharedToCharacter takes nothing returns boolean
			return this.character() != 0 and this.isShared()
		endmethod

		/**
		* \param character If this value is 0 control is shared with all players (allied player).
		*/
		public method shareWith takes Character character returns nothing
			local integer i
			debug call Print("Fellow: Unit name is " + GetUnitName(this.unit()))
			debug call Print("Before setShared(true)")
			call this.setShared(true)
			set this.m_character = character
			if (character != 0) then
				debug call Print("Share to character " + GetPlayerName(character.player()))
				call SetUnitOwner(this.m_unit, character.player(), true)
			else
				debug call Print("Share to all characters.")
				/// \todo If player is in arena this won't work.
				call Game.setAlliedPlayerAlliedToAllCharacters()
				call SetUnitOwner(this.m_unit, MapData.alliedPlayer, true)
			endif
			debug call Print("Fellow 1: " + GetUnitName(this.m_unit))
			call SetUnitInvulnerable(this.m_unit, false)
			call AUnitRoutine.disableAll(this.m_unit)
			debug call Print("Fellow 2.")
			if (not this.m_hasTalk and this.m_talk != 0) then
				call this.m_talk.disable()
			endif
			if (this.disableSellings()) then
				/// \todo Remove selling ability using m_sellingsAbilities
			endif
			debug call Print("Fellow 3.")
			if (this.m_hasHeroIcon) then
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (this.m_heroIcon[i] != 0 and (character == 0 or GetPlayerId(character.player()) == i)) then
						call this.m_heroIcon[i].start()
					endif
					set i = i + 1
				endloop
			endif
			debug call Print("Fellow 4.")
			if (this.hasRevival()) then
				call EnableTrigger(this.m_revivalTrigger)
			endif
			debug call Print("Fellow 5.")
			if (thistype.m_infoMessageJoin != null) then
				if (character == 0) then
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageJoin).u(this.m_unit).result())
				else
					call character.displayMessage(Character.messageTypeInfo, Format(thistype.m_infoMessageJoin).u(this.m_unit).result())
				endif
			endif
			debug call Print("Fellow 6.")
			if (thistype.m_infoSoundJoin != null) then
				if (character == 0) then
					call StartSound(thistype.m_infoSoundJoin)
				else
					call PlaySoundForPlayer(character.player(), thistype.m_infoSoundJoin)
				endif
			endif
			debug call Print("Fellow 7.")
			if (this.description() != null) then
				if (character == 0) then
					call Character.displayUnitAcquiredToAll(GetUnitName(this.unit()), this.description())
				else
					call character.displayUnitAcquired(GetUnitName(this.unit()), this.description())
				endif
			endif
			debug call Print("Fellow 8.")
		endmethod

		public method reset takes nothing returns nothing
			local integer i
			if (this.hasRevival()) then
				call DisableTrigger(this.m_revivalTrigger)
			endif
			call SetUnitOwner(this.m_unit, Player(PLAYER_NEUTRAL_PASSIVE), true)
			call SetUnitInvulnerable(this.m_unit, true)
			call AUnitRoutine.enableAll(this.m_unit)
			if (this.m_talk != 0) then
				call this.m_talk.enable()
			endif
			if (this.disableSellings()) then
				set i = 0
				loop
					exitwhen (i == this.m_sellingsAbilities.size())
						call UnitAddAbility(this.unit(), this.m_sellingsAbilities[i])
					set i = i + 1
				endloop
			endif
			if (thistype.m_infoMessageLeave != null) then
				if (this.m_character == 0) then
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageLeave).u(this.m_unit).result())
				else
					call this.m_character.displayMessage(Character.messageTypeInfo, Format(thistype.m_infoMessageLeave).u(this.m_unit).result())
				endif
			endif

			if (thistype.m_infoSoundLeave != null) then
				if (this.m_character == 0) then
					call StartSound(thistype.m_infoSoundLeave)
				else
					call PlaySoundForPlayer(this.m_character.player(), thistype.m_infoSoundLeave)
				endif
			endif
			call this.setShared(false)
		endmethod

		public method revive takes nothing returns nothing
			debug call Print("Revive")
			debug call Print("NPC Revival: " + GetUnitName(this.m_unit))

			if (this.isActive()) then
				call PauseUnit(this.m_unit, false)
				call SetUnitInvulnerable(this.m_unit, false)
				call SetUnitPosition(this.m_unit, this.m_revivalLocation.x(), this.m_revivalLocation.y())
				call SetUnitFacing(this.m_unit, this.m_revivalLocation.z())
				call SetUnitLifePercentBJ(this.m_unit, 100)
				call SetUnitManaPercentBJ(this.m_unit, 30)
				call ShowUnit(this.m_unit, true)
				call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Awaken\\Awaken.mdx", this.m_unit, "origin"))
				call PlaySoundFileOnUnit("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.wav", this.m_unit)
				if (this.m_revivalMessage != null) then
					call TransmissionFromUnit(this.m_unit, this.m_revivalMessage, this.m_revivalSound)
				endif
				call this.setActive(false)
			debug else
				debug call Print("Unit is not dead?!")
			endif
		endmethod

		private static method timerFunctionRevive takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this")
			call TimerDialogDisplay(this.m_revivalTimerDialog, false)
			call this.revive()
		endmethod

		private static method triggerConditionRevival takes nothing returns boolean
			return GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) - GetEventDamage() <= 0.0
		endmethod

		private static method timerFunctionRemoval takes nothing returns nothing
			call RemoveUnit(DmdfHashTable.global().handleUnit(GetExpiredTimer(), "Unit"))
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		/// Uses synchronized time!
		private static method removeUnitAfter takes unit whichUnit, real time returns nothing
			local timer t = CreateTimer()
			call TimerStart(t, time, false, function thistype.timerFunctionRemoval)
			call DmdfHashTable.global().setHandleUnit(t, "Unit", whichUnit)
			set t = null
		endmethod

		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local unit animationUnit
			call DisableTrigger(GetTriggeringTrigger())
			debug call Print("Unit is " + GetUnitName(this.m_unit))

			if (this.m_hasRevival) then
				call SetUnitInvulnerable(this.m_unit, true)
				call PauseUnit(this.m_unit, true)
				call ShowUnit(this.m_unit, false)
				call SetUnitLifePercentBJ(this.m_unit, 100)
				call this.setActive(true)

				// apply dissipate animation
				set animationUnit = CopyUnit(this.m_unit, GetUnitX(this.m_unit), GetUnitY(this.m_unit), GetUnitFacing(this.m_unit), bj_UNIT_STATE_METHOD_MAXIMUM)
				call ShowUnit(animationUnit, true)
				call SetUnitAnimation(animationUnit, "Dissipate")
				call thistype.removeUnitAfter(animationUnit, 2.0)

				if (thistype.m_infoMessageDeath != null) then
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageDeath).u(this.m_unit).i(R2I(this.m_revivalTime)).result())
				endif

				if (thistype.m_infoSoundDeath != null) then
					call StartSound(thistype.m_infoSoundDeath)
				endif

				if (this.m_revivalTime <= 0.0) then
					call this.revive()
				else
					if (this.m_revivalTimer == null) then
						set this.m_revivalTimer = CreateTimer()
						call DmdfHashTable.global().setHandleInteger(this.m_revivalTimer, "this", this)
						set this.m_revivalTimerDialog = CreateTimerDialog(this.m_revivalTimer)
						call TimerDialogSetTitle(this.m_revivalTimerDialog, StringArg(tr("%s:"), GetUnitName(this.m_unit)))
						call TimerDialogSetTitleColor(this.m_revivalTimerDialog, GetPlayerColorRed(GetPlayerColor(GetOwningPlayer(this.m_unit))), GetPlayerColorGreen(GetPlayerColor(GetOwningPlayer(this.m_unit))), GetPlayerColorBlue(GetPlayerColor(GetOwningPlayer(this.m_unit))), 0)
					endif
					call TimerStart(this.m_revivalTimer, this.m_revivalTime, false, function thistype.timerFunctionRevive)
					call TimerDialogDisplay(this.m_revivalTimerDialog, true)
					call EnableTrigger(GetTriggeringTrigger())
				endif
			else
				call this.reset()
			endif
		endmethod

		/**
		* \param active If this value is true the NPC's talk will be left enabled during fellowship.
		*/
		public method setTalk takes boolean active returns nothing
			if (this.m_hasTalk == active) then
				return
			endif
			set this.m_hasTalk = active
			if (this.m_talk != 0 and this.isShared()) then
				if (active) then
					call this.m_talk.enable()
				else
					call this.m_talk.disable()
				endif
			endif
		endmethod

		/**
		* \param active If this value is true NPC will be revived if he dies during fellowship.
		*/
		public method setRevival takes boolean active returns nothing
			if (this.m_hasRevival == active) then
				return
			endif
			set this.m_hasRevival = active
			if (this.isShared()) then
				if (active) then
					call EnableTrigger(this.m_revivalTrigger)
				else
					call DisableTrigger(this.m_revivalTrigger)
				endif
			endif
		endmethod

		public method setDisableSellings takes boolean disable returns nothing
			if (disable == this.m_disableSellings) then
				return
			endif
			set this.m_disableSellings = disable
			if (disable) then
				set this.m_sellingsAbilities = AIntegerVector.create()
			else
				debug if (this.isShared()) then
					debug call this.print("Warning: Fellow is already in fellowship. Disabling sellings leads to losing selling ability information.")
				debug endif
				call this.m_sellingsAbilities.destroy()
				set this.m_sellingsAbilities = 0
			endif
		endmethod

		public static method create takes unit whichUnit, ATalk talk returns thistype
			local thistype this = thistype.allocate()
			local integer i
			debug call this.print("Creating for unit " + GetUnitName(whichUnit))
			// dynamic members
			set this.m_hasHeroIcon = true
			set this.m_hasTalk = false
			set this.m_hasRevival = true
			set this.m_description = null
			set this.m_revivalMessage = null
			set this.m_revivalSound = null
			set this.m_revivalLocation = AVector3.create(0.0, 0.0, 0.0)
			set this.m_revivalTime = MapData.revivalTime
			set this.m_disableSellings = false
			// construction members
			set this.m_unit = whichUnit
			set this.m_talk = talk
			// members
			set this.m_character = 0
			set this.m_sellingsAbilities = 0
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_revivalTrigger, whichUnit, EVENT_UNIT_DAMAGED)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call DmdfHashTable.global().setHandleInteger(this.m_revivalTrigger, "this", this)
			call DisableTrigger(this.m_revivalTrigger)
			set this.m_revivalTimer = null
			set this.m_revivalTimerDialog = null
			set i = 0
			loop
				if (IsPlayerPlayingUser(Player(i))) then
					set this.m_heroIcon[i] = AHeroIcon.create(whichUnit, Player(i), Character.heroIconRefreshTime, GetRectCenterX(gg_rct_character), GetRectCenterY(gg_rct_character), 0.0)
				else
					set this.m_heroIcon[i] = 0
				endif
				set i = i + 1
				exitwhen (i == MapData.maxPlayers)
			endloop
			call this.setActive(false)
			call DmdfHashTable.global().setHandleInteger(this.m_unit, "Fellow", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i
			call this.m_revivalLocation.destroy()
			if (this.m_sellingsAbilities != 0) then
				call this.m_sellingsAbilities.destroy()
			endif
			call DmdfHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
			if (this.m_revivalTimer != null) then
				call PauseTimer(this.m_revivalTimer)
				call DmdfHashTable.global().destroyTimer(this.m_revivalTimer)
				set this.m_revivalTimer = null
				call DestroyTimerDialog(this.m_revivalTimerDialog)
				set this.m_revivalTimerDialog = null
			endif
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (this.m_heroIcon[i] != 0) then
					call this.m_heroIcon[i].destroy()
				endif
				set i = i + 1
			endloop
			call DmdfHashTable.global().removeHandleBoolean(this.m_unit, "Fellow:Shared")
			call DmdfHashTable.global().removeHandleBoolean(this.m_unit, "Fellow:Active")
			call DmdfHashTable.global().removeHandleInteger(this.m_unit, "Fellow")
		endmethod

		public static method init takes string infoMessageJoin, sound infoSoundJoin, string infoMessageLeave, sound infoSoundLeave, string infoMessageDeath, sound infoSoundDeath returns nothing
			// static initialization members
			set thistype.m_infoMessageJoin = infoMessageJoin
			set thistype.m_infoSoundJoin = infoSoundJoin
			set thistype.m_infoMessageLeave = infoMessageLeave
			set thistype.m_infoSoundLeave = infoSoundLeave
			set thistype.m_infoMessageDeath = infoMessageDeath
			set thistype.m_infoSoundDeath = infoSoundDeath
		endmethod

		public static method getByUnit takes unit whichUnit returns thistype
			return DmdfHashTable.global().handleInteger(whichUnit, "Fellow")
		endmethod

		public static method shareWithByUnit takes unit whichUnit, Character character returns boolean
			local thistype this = thistype.getByUnit(whichUnit)
			if (this == 0) then
				return false
			endif
			call this.shareWith(character)
			return true
		endmethod

		public static method resetByUnit takes unit whichUnit returns boolean
			local thistype this = thistype.getByUnit(whichUnit)
			if (this == 0) then
				return false
			endif
			call this.reset()
			return true
		endmethod

		public static method reviveByUnit takes unit whichUnit returns boolean
			local thistype this = thistype.getByUnit(whichUnit)
			if (this == 0) then
				return false
			endif
			call this.revive()
			return true
		endmethod
	endstruct

endlibrary