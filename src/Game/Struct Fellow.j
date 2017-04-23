library StructGameFellow requires Asl, StructGameCharacter, StructGameDmdfHashTable, StructGameGame, StructGameTreeTransparency

	/**
	 * \brief Fellows are hero unit NPCs which can be shared with one or all character owners.
	 * <ul>
	 * <li>Provides a hero revival timer and disables routine and talk (talk is optional).</li>
	 * <li>Besides it shares control with a single player or all players.</li>
	 * <li>Every fellow has an inventory provided by \ref AUnitInventory which allows him/her to at least carry items around and use potions etc.</li>
	 * </ul>
	 * Fellow data is directly assigned to its corresponding unit and can therefore be got by static methods which do only require a unit parameter (\ref Fellow#getByUnit).
	 * When fellows are added to any fellowship their owner is changed to \ref MapSettings.alliedPlayer().
	 * \note Use \ref setDisableSellings() to remove sell ability while fellow is in fellowship. This is oftenly necessary to make all unit abilities of the fellow usable for any controlling user.
	 * \todo If talks are still enabled it should only be available for shared players!
	 * \note Fellow units must be heroes for proper revival.
	 * \note When a fellow is reset all of his items are dropped for all players.
	 */
	struct Fellow
		// static initialization members
		private static string m_infoMessageJoin
		private static sound m_infoSoundJoin
		private static string m_infoMessageLeave
		private static sound m_infoSoundLeave
		private static string m_infoMessageDeath
		private static sound m_infoSoundDeath
		// static members
		private static AIntegerVector m_fellows
		// dynamic members
		private boolean m_hasTalk
		private boolean m_hasRevival
		private string m_description
		private string m_revivalTitle
		private string m_revivalMessage
		private sound m_revivalSound
		private real m_revivalTime
		private boolean m_disableSellings
		private AIntegerVector m_abilities
		// construction members
		private unit m_unit
		private ATalk m_talk
		// members
		private Character m_character
		private trigger m_revivalTrigger
		private timer m_revivalTimer
		private timerdialog m_revivalTimerDialog
		private AIntegerVector m_sellingsAbilities
		private boolean m_trades
		private boolean m_isShared
		private AUnitInventory m_inventory

		//! runtextmacro A_STRUCT_DEBUG("\"Fellow\"")

		// dynamic members

		public method hasTalk takes nothing returns boolean
			return this.m_hasTalk
		endmethod

		public method hasRevival takes nothing returns boolean
			return this.m_hasRevival
		endmethod

		/**
		 * The description is shown when the fellow is shared.
		 * @{
		 */
		public method setDescription takes string description returns nothing
			set this.m_description = description
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod
		/**
		 * @}
		 */

		public method setRevivalTitle takes string title returns nothing
			set this.m_revivalTitle = title
		endmethod

		public method revivalTitle takes nothing returns string
			return this.m_revivalTitle
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

		public method setRevivalTime takes real revivalTime returns nothing
			set this.m_revivalTime = revivalTime
		endmethod

		public method revivalTime takes nothing returns real
			return this.m_revivalTime
		endmethod

		public method disableSellings takes nothing returns boolean
			return this.m_disableSellings
		endmethod

		public method addAbility takes integer abilityId returns nothing
			call this.m_abilities.pushBack(abilityId)
		endmethod

		public method removeAbility takes integer abilityId returns nothing
			call this.m_abilities.remove(abilityId)
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

		private method setShared takes boolean shared returns nothing
			set this.m_isShared = shared
		endmethod

		public method isShared takes nothing returns boolean
			return this.m_isShared
		endmethod

		public method isSharedToCharacter takes nothing returns boolean
			return this.character() != 0 and this.isShared()
		endmethod

		/**
		 * Shares the fellow with a specific character owner or all players.
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
				call character.addFellow(this)
			else
				debug call Print("Share to all characters.")
				/// \todo If player is in arena this won't work.
				call Game.setAlliedPlayerAlliedToAllCharacters()
				call SetUnitOwner(this.m_unit, MapSettings.alliedPlayer(), true)
			endif

			call SetUnitInvulnerable(this.m_unit, false)
			call AUnitRoutine.disableAll(this.m_unit)

			set this.m_trades = (GetUnitAbilityLevel(this.m_unit, 'Aneu') > 0 or GetUnitAbilityLevel(this.m_unit, 'Asid') > 0 or GetUnitAbilityLevel(this.m_unit, 'Apit') > 0)

			if (this.m_trades) then
				debug call Print("Has trades remove the abilities!")
				call UnitRemoveAbility(this.m_unit, 'Aneu')
				call UnitRemoveAbility(this.m_unit, 'Asid')
				call UnitRemoveAbility(this.m_unit, 'Apit')
				call SetItemTypeSlots(this.m_unit, 0)
			endif

			if (not this.m_hasTalk and this.m_talk != 0) then
				call this.m_talk.disable()
				call RemoveUnitFromStock(this.m_unit, 'n05E')
			endif
			if (this.disableSellings()) then
				/// \todo Remove selling ability using m_sellingsAbilities
			endif
			set i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				call UnitAddAbility(this.m_unit, this.m_abilities[i])
				call UnitMakeAbilityPermanent(this.m_unit, true, this.m_abilities[i])
				set i = i + 1
			endloop
			if (this.hasRevival()) then
				call EnableTrigger(this.m_revivalTrigger)
			endif

			// Make sure that the fellow has an inventory ability.
			call UnitAddAbility(this.unit(), 'AInv')
			call UnitMakeAbilityPermanent(this.unit(), true, 'AInv')

			call this.m_inventory.enable()
			call this.m_inventory.enableOnlyBackpack(true)

			if (thistype.m_infoMessageJoin != null) then
				if (character == 0) then
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageJoin).s(this.revivalTitle()).result())
				else
					call character.displayMessage(Character.messageTypeInfo, Format(thistype.m_infoMessageJoin).s(this.revivalTitle()).result())
				endif
			endif
			if (thistype.m_infoSoundJoin != null) then
				if (character == 0) then
					call StartSound(thistype.m_infoSoundJoin)
				else
					call PlaySoundForPlayer(character.player(), thistype.m_infoSoundJoin)
				endif
			endif
			if (this.description() != null) then
				if (character == 0) then
					call Character.displayUnitAcquiredToAll(this.revivalTitle(), this.description())
				else
					call character.displayUnitAcquired(this.revivalTitle(), this.description())
				endif
			endif
		endmethod

		/**
		 * Shares the fellow with all playing players who own a character.
		 * They can control the fellow unit together after it is shared with them since it is owned by the \ref MapSettings.alliedPlayer().
		 */
		public method shareWithAll takes nothing returns nothing
			call this.shareWith(0)
		endmethod

		/**
		 * Revive always at the first character's enabled revival.
		 */
		private method reviveAtActiveShrine takes boolean showEffect returns nothing
			local boolean found = false
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers() or found)
				if (Character.playerCharacter(Player(i)) != 0 and Character.playerCharacter(Player(i)).revival() != 0) then
					call ReviveHero(this.m_unit, Character.playerCharacter(Player(i)).revival().x(), Character.playerCharacter(Player(i)).revival().y(), showEffect)

					set found = true
				endif
				set i = i + 1
			endloop

			if (found) then
				debug call Print("Missing revival!")
				call ReviveHero(this.m_unit, GetUnitX(this.m_unit), GetUnitY(this.m_unit), showEffect)
			endif

			/*
			 * Make sure the timer does not run when the fellow is already being revived.
			 */
			if (this.m_revivalTimer != null) then
				call PauseTimer(this.m_revivalTimer)
			endif

			if (this.m_revivalTimerDialog != null) then
				call TimerDialogDisplay(this.m_revivalTimerDialog, false)
			endif
		endmethod

		/**
		 * Removes fellow from the characters group by resetting its owner and making it a normal NPC again.
		 * It enables the NPCs talk and trading abilities if he had some.
		 */
		public method reset takes nothing returns nothing
			local integer i
			if (not this.isShared()) then
				debug call Print("Fellow is not shared.")
				return
			endif
			if (this.hasRevival()) then
				call DisableTrigger(this.m_revivalTrigger)
			endif
			// makes sure the fellow lives
			if (IsUnitDeadBJ(this.m_unit)) then
				call this.reviveAtActiveShrine(false)
			endif

			/*
			 * Make sure the fellow cannot carry items forever and they become unreachable for the players.
			 */
			call this.m_inventory.dropAllBackpack(GetUnitX(this.m_unit), GetUnitY(this.m_unit), false)
			call this.m_inventory.disable()

			// Make sure that you cannot give a fellow items afterwards.
			call UnitRemoveAbility(this.unit(), 'AInv')

			call SetUnitOwner(this.m_unit, MapSettings.neutralPassivePlayer(), true)
			call SetUnitInvulnerable(this.m_unit, true)
			call SetUnitLifePercentBJ(this.m_unit, 100.0)

			set i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				call UnitRemoveAbility(this.m_unit, this.m_abilities[i])
				set i = i + 1
			endloop

			if (this.m_trades) then
				call UnitAddAbility(this.m_unit, 'Aneu')
				call UnitAddAbility(this.m_unit, 'Asid')
				call UnitAddAbility(this.m_unit, 'Apit')
				call SetItemTypeSlots(this.m_unit, 12)
			endif

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
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageLeave).s(this.revivalTitle()).result())
				else
					call this.m_character.displayMessage(Character.messageTypeInfo, Format(thistype.m_infoMessageLeave).s(this.revivalTitle()).result())
				endif
			endif

			if (thistype.m_infoSoundLeave != null) then
				if (this.m_character == 0) then
					call StartSound(thistype.m_infoSoundLeave)
				else
					call PlaySoundForPlayer(this.m_character.player(), thistype.m_infoSoundLeave)
				endif
			endif

			call AUnitRoutine.enableAll(this.m_unit)
			// restart old routine immediately
			call AUnitRoutine.manualStart(this.m_unit)

			if (this.m_character != 0) then
				call this.m_character.removeFellow(this)
			endif

			set this.m_character = 0
			call this.setShared(false)
		endmethod

		/**
		 * Revives fellow at position of his death.
		 * Does nothing if the fellow is not dead actually.
		 */
		public method revive takes nothing returns nothing

			if (IsUnitDeadBJ(this.m_unit)) then
				call this.reviveAtActiveShrine(true)
				if (this.m_revivalMessage != null) then
					call TransmissionFromUnitWithName(this.m_unit, this.revivalTitle(), this.m_revivalMessage, this.m_revivalSound)
				endif
			debug else
				debug call Print("Unit is not dead?!")
			endif
		endmethod

		/**
		 * If the revival timer is running this resumes or pauses the timer.
		 * Can be useful during video sequences.
		 */
		public method pauseRevival takes boolean pause returns nothing
			if (this.m_revivalTimer != null) then
				if (pause) then
					call PauseTimer(this.m_revivalTimer)
				else
					call ResumeTimer(this.m_revivalTimer)
				endif
			endif
		endmethod

		/**
		 * Ends the revival without actually reviving the fellow.
		 * Has to be used carefully for example when the fellow is being revived manually.
		 */
		public method endRevival takes nothing returns nothing
			if (this.m_revivalTimer != null) then
				call PauseTimer(this.m_revivalTimer)
				call TimerDialogDisplay(this.m_revivalTimerDialog, false)
			endif
		endmethod

		private static method timerFunctionRevive takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call TimerDialogDisplay(this.m_revivalTimerDialog, false)
			call this.revive()
		endmethod

		private static method triggerConditionRevival takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetTriggerUnit() == this.unit()
		endmethod

		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local unit animationUnit
			debug call Print("Unit is " + GetUnitName(this.m_unit))

			if (this.hasRevival()) then

				if (thistype.m_infoMessageDeath != null) then
					call Character.displayMessageToAll(Character.messageTypeInfo, Format(thistype.m_infoMessageDeath).s(this.revivalTitle()).i(R2I(this.m_revivalTime)).result())
				endif

				if (thistype.m_infoSoundDeath != null) then
					call StartSound(thistype.m_infoSoundDeath)
				endif

				if (this.m_revivalTime <= 0.0) then
					call this.revive()
				else
					if (this.m_revivalTimer == null) then
						set this.m_revivalTimer = CreateTimer()
						call DmdfHashTable.global().setHandleInteger(this.m_revivalTimer, 0, this)
						set this.m_revivalTimerDialog = CreateTimerDialog(this.m_revivalTimer)
						call TimerDialogSetTitle(this.m_revivalTimerDialog, this.revivalTitle())
						call TimerDialogSetTitleColor(this.m_revivalTimerDialog, GetPlayerColorRed(GetPlayerColor(GetOwningPlayer(this.m_unit))), GetPlayerColorGreen(GetPlayerColor(GetOwningPlayer(this.m_unit))), GetPlayerColorBlue(GetPlayerColor(GetOwningPlayer(this.m_unit))), 0)
					endif
					call TimerStart(this.m_revivalTimer, this.m_revivalTime, false, function thistype.timerFunctionRevive)
					call TimerDialogDisplay(this.m_revivalTimerDialog, true)
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
					call AddUnitToStock(this.m_unit, 'n05E', 1, 1)
					call this.m_talk.enable()
				else
					call RemoveUnitFromStock(this.m_unit, 'n05E')
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

		/**
		 * Creates a new fellow using \p whichUnit as fellow unit.
		 * \param talk The corresponding talk of the unit. \ref setTalk() affects the talk when the fellow is shared.
		 */
		public static method create takes unit whichUnit, ATalk talk returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_hasTalk = false
			set this.m_hasRevival = true
			set this.m_description = null
			set this.m_revivalTitle = GetUnitName(whichUnit)
			set this.m_revivalMessage = null
			set this.m_revivalSound = null
			set this.m_revivalTime = MapSettings.revivalTime()
			set this.m_disableSellings = false
			set this.m_abilities = AIntegerVector.create()
			// construction members
			set this.m_unit = whichUnit
			set this.m_talk = talk
			// members
			set this.m_character = 0
			set this.m_sellingsAbilities = 0
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_revivalTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call DmdfHashTable.global().setHandleInteger(this.m_revivalTrigger, 0, this)
			call DisableTrigger(this.m_revivalTrigger)
			set this.m_revivalTimer = null
			set this.m_revivalTimerDialog = null
			call DmdfHashTable.global().setHandleInteger(this.m_unit, DMDF_HASHTABLE_KEY_FELLOW, this)
			set this.m_trades = false
			set this.m_isShared = false
			set this.m_inventory = AUnitInventory.create(this.m_unit)
			call UnitRemoveAbility(this.unit(), 'A015') // rucksack only

			call thistype.m_fellows.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_abilities.destroy()
			set this.m_abilities = 0
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

			call this.m_inventory.destroy()

			call DmdfHashTable.global().removeHandleInteger(this.m_unit, DMDF_HASHTABLE_KEY_FELLOW)
			call thistype.m_fellows.remove(this)
		endmethod

		public static method init takes string infoMessageJoin, sound infoSoundJoin, string infoMessageLeave, sound infoSoundLeave, string infoMessageDeath, sound infoSoundDeath returns nothing
			// static initialization members
			set thistype.m_infoMessageJoin = infoMessageJoin
			set thistype.m_infoSoundJoin = infoSoundJoin
			set thistype.m_infoMessageLeave = infoMessageLeave
			set thistype.m_infoSoundLeave = infoSoundLeave
			set thistype.m_infoMessageDeath = infoMessageDeath
			set thistype.m_infoSoundDeath = infoSoundDeath
			// static members
			set thistype.m_fellows = AIntegerVector.create()
		endmethod

		/**
		 * This method can be used to get a \ref Fellow instance by any unit on the map.
		 * It simplifies the access to fellows since you do not have to store the instance anywhere.
		 * \return Returns 0 if \p whichUnit is no fellow. Otherwise it returns the corresponding fellow instance.
		 */
		public static method getByUnit takes unit whichUnit returns thistype
			return DmdfHashTable.global().handleInteger(whichUnit, DMDF_HASHTABLE_KEY_FELLOW)
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

		private method reviveForVideo takes nothing returns nothing
			if (this.m_revivalTimer != null) then
				call PauseTimer(this.m_revivalTimer)
				call TimerDialogDisplay(this.m_revivalTimerDialog, false)
			endif

			if (IsUnitDeadBJ(this.m_unit)) then
				call this.reviveAtActiveShrine(false)
			endif
		endmethod

		/**
		 * Since fellows usually should not be dead in a video they will be revived manually before the video starts.
		 */
		public static method reviveAllForVideo takes nothing returns nothing
			local AIntegerVectorIterator iterator = thistype.m_fellows.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).reviveForVideo()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct

endlibrary