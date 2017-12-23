library AStructSystemsWorldSpawnPoint requires AInterfaceSystemsWorldSpawnPointInterface, optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentSound, ALibraryCoreGeneralPlayer, AStructCoreStringFormat, AStructCoreGeneralGroup, AStructCoreGeneralHashTable, AStructCoreGeneralVector

	private struct ASpawnPointMember
		// dynamic members
		private unitpool m_unitPool
		private AItemPoolVector m_itemPools
		private real m_x
		private real m_y
		private real m_facing

		// dynamic members

		public method addUnitType takes integer unitTypeId, real weight returns nothing
			call UnitPoolAddUnitType(this.m_unitPool, unitTypeId, weight)
		endmethod

		public method removeUnitType takes integer unitTypeId returns nothing
			call UnitPoolRemoveUnitType(this.m_unitPool, unitTypeId)
		endmethod

		/**
		 * \return Returns the number of item pools.
		 */
		public method itemPoolsCount takes nothing returns integer
			return this.m_itemPools.size()
		endmethod

		public method addItemType takes integer index, integer itemTypeId, real weight returns nothing
			if (index >= this.itemPoolsCount()) then
				call this.m_itemPools.pushBack(CreateItemPool())
				call ItemPoolAddItemType(this.m_itemPools.back(), itemTypeId, weight)
			elseif (index >= 0 and index < this.itemPoolsCount()) then
				call ItemPoolAddItemType(this.m_itemPools[index], itemTypeId, weight)
			debug else
				debug call Print("Wrong index for adding item type: " + I2S(index))
			endif
		endmethod

		public method addNewItemType takes integer itemTypeId, real weight returns integer
			local integer index = this.itemPoolsCount()
			call this.addItemType(index, itemTypeId, weight)
			return index
		endmethod

		public method removeItemType takes integer index, integer itemTypeId returns nothing
			call ItemPoolRemoveItemType(this.m_itemPools[index], itemTypeId)
		endmethod

		public method setX takes real x returns nothing
			set this.m_x = x
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method setY takes real y returns nothing
			set this.m_y = y
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod

		// methods

		public method placeUnit takes player whichPlayer returns unit
			local real facing
			if (this.m_facing < 0.0) then
				set facing = GetRandomReal(0.0, 360.0)
			else
				set facing = this.m_facing
			endif
			return PlaceRandomUnit(this.m_unitPool, whichPlayer, this.m_x, this.m_y, facing)
		endmethod

		public method placeItem takes integer index, real x, real y returns item
			local item result =  PlaceRandomItem(this.m_itemPools[index], x, y)
			call UpdateStockAvailability(result)
			return result
		endmethod

		/**
		 * Places all items from all item pools of the member.
		 */
		public method placeItems takes real x, real y returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.itemPoolsCount())
				call this.placeItem(i, x, y)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \param facing If this value is smaller than 0 it will be random (between 0 and 360 degrees).
		 */
		public static method create takes real x, real y, real facing returns thistype
			local thistype this = thistype.allocate()
			set this.m_unitPool = CreateUnitPool()
			set this.m_itemPools = AItemPoolVector.create()
			set this.m_x = x
			set this.m_y = y
			set this.m_facing = facing

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i
			call DestroyUnitPool(this.m_unitPool)
			set this.m_unitPool = null
			set i = 0
			loop
				exitwhen (i == this.m_itemPools.size())
				call DestroyItemPool(this.m_itemPools[i])
				set this.m_itemPools[i] = null
				set i = i + 1
			endloop
			call this.m_itemPools.destroy()
			set this.m_itemPools = 0
		endmethod
	endstruct


	/**
	 * \brief ASpawnPoint provides the functionality of common creep spawn points, mostly used in RPG maps.
	 * It offers features such as respawning of creeps in a specific interval when all units of the spawn point are dead.
	 * Besides it can create special effects and sounds on respawning the creeps.
	 * Item pools are supported as well and their items will be placed on the creeps deaths.
	 * The items then could be distributed equally to players setting a player as the owner of the dropped item.
	 * This can prevent players from collecting all items and leaving other players with no items.
	 *
	 * \sa AItemSpawnPoint
	 */
	struct ASpawnPoint extends ASpawnPointInterface
		// static member
		private static integer m_dropOwnerId
		// dynamic members
		private real m_time
		private string m_effectFilePath
		private string m_soundFilePath
		private boolean m_distributeItems
		private player m_owner
		private string m_textDistributeItem
		// members
		private AIntegerVector m_members
		private AGroup m_group
		private trigger m_deathTrigger
		private timer m_spawnTimer

		//! runtextmacro optional A_STRUCT_DEBUG("\"ASpawnPoint\"")

		/**
		 * \param time The time in seconds which has to elapse before the units respawn.
		 */
		public method setTime takes real time returns nothing
			set this.m_time = time
		endmethod

		public method time takes nothing returns real
			return this.m_time
		endmethod

		/**
		 * \param effectFilePath File fath of the effect which is shown when the units respawn. If this value is null there won't be shown any effect.
		 */
		public method setEffectFilePath takes string effectFilePath returns nothing
			set this.m_effectFilePath = effectFilePath
		endmethod

		public method effectFilePath takes nothing returns string
			return this.m_effectFilePath
		endmethod

		/**
		 * \param soundFilePath File path of the sound which is played when the units respawn. If this value is null there won't be played any sound.
		 */
		public method setSoundFilePath takes string soundFilePath returns nothing
			set this.m_soundFilePath = soundFilePath
		endmethod

		public method soundFilePath takes nothing returns string
			return this.m_soundFilePath
		endmethod

		/**
		 * If this value is set to true all dropped items will be distributed between the players equally.
		 * Only human players are considered as owners.
		 * This might prevent looting from specific players who collect all items at the time they drop and do not leave any items for others.
		 */
		public method setDistributeItems takes boolean distributeItems returns nothing
			set this.m_distributeItems = distributeItems
		endmethod

		public method distributeItems takes nothing returns boolean
			return this.m_distributeItems
		endmethod

		/**
		  * \param owner The player who owns all spawn point units.
		  * \note Currently this does not change the owner of existing units only of respawning ones.
		  */
		public method setOwner takes player owner returns nothing
			set this.m_owner = owner
		endmethod

		/**
		 * \return Returns the owner of the units of this spawn point. By default this is Player(PLAYER_NEUTRAL_AGGRESSIVE).
		 */
		public method owner takes nothing returns player
			return this.m_owner
		endmethod

		/**
		 * This text is displayed to all human players when distributing a dropped item.
		 * It gets two arguments: The item name and the player name of the player who got the item.
		 */
		public method setTextDistributeItem takes string textDistributeItems returns nothing
			set this.m_textDistributeItem = textDistributeItems
		endmethod

		public method textDistributeItem takes nothing returns string
			return this.m_textDistributeItem
		endmethod

		public static method spawnPointMember takes unit whichUnit returns ASpawnPointMember
			return ASpawnPointMember(AHashTable.global().handleInteger(whichUnit, A_HASHTABLE_KEY_SPAWNPOINTMEMBER))
		endmethod

		public static method setSpawnPointMember takes unit whichUnit, ASpawnPointMember member returns nothing
			call AHashTable.global().setHandleInteger(whichUnit, A_HASHTABLE_KEY_SPAWNPOINTMEMBER, member)
		endmethod

		public static method clearSpawnPointMember takes unit whichUnit returns nothing
			call AHashTable.global().removeHandleInteger(whichUnit, A_HASHTABLE_KEY_SPAWNPOINTMEMBER)
		endmethod

		// convenience methods

		public method setLocation takes integer memberIndex, location whichLocation returns nothing
			call this.setX.evaluate(memberIndex, GetLocationX(whichLocation))
			call this.setY.evaluate(memberIndex, GetLocationY(whichLocation))
		endmethod

		public method setRect takes integer memberIndex, rect whichRect returns nothing
			call this.setX.evaluate(memberIndex, GetRectCenterX(whichRect))
			call this.setY.evaluate(memberIndex, GetRectCenterX(whichRect))
		endmethod

		// methods

		public method countMembers takes nothing returns integer
			return this.m_members.size()
		endmethod

		public method addMember takes real x, real y, real facing returns integer
			local ASpawnPointMember member = ASpawnPointMember.create(x, y, facing)
			call this.m_members.pushBack(member)
			return this.m_members.backIndex()
		endmethod

		public method removeMember takes integer memberIndex returns nothing
			call this.m_members.erase(memberIndex)
		endmethod

		public method addUnitType takes integer memberIndex, integer unitTypeId, real weight returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).addUnitType(unitTypeId, weight)
		endmethod

		public method removeUnitType takes integer memberIndex, integer unitTypeId returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).removeUnitType(unitTypeId)
		endmethod

		public method addItemType takes integer memberIndex, integer itemPoolIndex, integer itemTypeId, real weight returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).addItemType(itemPoolIndex, itemTypeId, weight)
		endmethod

		public method addNewItemType takes integer memberIndex, integer itemTypeId, real weight returns integer
			return ASpawnPointMember(this.m_members[memberIndex]).addNewItemType(itemTypeId, weight)
		endmethod

		public method removeItemType takes integer memberIndex, integer itemPoolIndex, integer itemTypeId returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).removeItemType(itemPoolIndex, itemTypeId)
		endmethod

		public method setX takes integer memberIndex, real x returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).setX(x)
		endmethod

		public method x takes integer memberIndex returns real
			return ASpawnPointMember(this.m_members[memberIndex]).x()
		endmethod

		public method setY takes integer memberIndex, real y returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).setY(y)
		endmethod

		public method y takes integer memberIndex returns real
			return ASpawnPointMember(this.m_members[memberIndex]).y()
		endmethod

		public method setFacing takes integer memberIndex, real facing returns nothing
			call ASpawnPointMember(this.m_members[memberIndex]).setFacing(facing)
		endmethod

		public method facing takes integer memberIndex returns real
			return ASpawnPointMember(this.m_members[memberIndex]).facing()
		endmethod

		/**
		 * Adds an existing unit to group. If all units of the group has been died, new units will be spawned.
		 */
		public method addUnit takes unit whichUnit, integer memberIndex returns nothing
			call thistype.setSpawnPointMember(whichUnit, this.m_members[memberIndex])
			call this.m_group.units().pushBack(whichUnit)
			call this.onSpawnUnit.evaluate(whichUnit, memberIndex)
		endmethod

		public method setUnit takes unit whichUnit, integer memberIndex returns nothing
			call thistype.setSpawnPointMember(whichUnit, this.m_members[memberIndex])
			set this.m_group.units()[memberIndex] = whichUnit
			call this.onSpawnUnit.evaluate(whichUnit, memberIndex)
		endmethod

		/**
		* Note that this only works before the group was respawned first time since respawning
		* units means that the old ones will be removed from game (not like hero revivals).
		*/
		public method removeUnit takes unit whichUnit returns nothing
			call thistype.clearSpawnPointMember(whichUnit)
			call this.m_group.units().remove(whichUnit)
		endmethod

		public method clearUnits takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_group.units().size())
				call thistype.clearSpawnPointMember(this.m_group.units()[i])
				set i = i + 1
			endloop
			call this.m_group.units().clear()
		endmethod

		/**
		* Counts only alive units.
		* Dying units are removed.
		*/
		public method countUnits takes nothing returns integer
			return this.m_group.units().size()
		endmethod

		public method unit takes integer index returns unit
			return this.m_group.units()[index]
		endmethod

		public method countUnitsIf takes AUnitVectorUnaryPredicate unaryPredicate returns integer
			return this.m_group.units().countIf(unaryPredicate)
		endmethod

		public method countUnitsOfType takes integer unitTypeId returns integer
			return this.m_group.countUnitsOfType(unitTypeId)
		endmethod

		/**
		 * Checks for a member with unit type \p unitTypeId and returns it.
		 * \param unitTypeId The specified unit type ID.
		 * \return Returns the first unit with the specified unit type ID. If no such unit is a member of the spawn point, it returns null.
		 */
		public method firstUnitOfType takes integer unitTypeId returns unit
			local integer i = 0
			loop
				exitwhen (i == this.m_group.units().size())
				if (GetUnitTypeId(this.m_group.units()[i]) == unitTypeId) then
					return this.m_group.units()[i]
				endif
				set i = i + 1
			endloop
			return null
		endmethod

		/**
		 * Kills all members of the spawn point immediately.
		 */
		public method kill takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_group.units().size())
				call KillUnit(this.m_group.units()[i])
				set i = i + 1
			endloop
		endmethod

		/**
		 * \return Returns true if \p whichUnit is a unit of the spawn point.
		 */
		public method contains takes unit whichUnit returns boolean
			return this.m_group.units().contains(whichUnit)
		endmethod

		/**
		 * Note that after unit \p whichUnit has died there will be spawned a new RANDOM unit from unit pool.
		 * \param weight Weight of added unit type. This value has no effects if \p addType is false.
		 * \return Returns the index of the added member.
		 */
		public method addUnitWithType takes unit whichUnit, real weight returns integer
			local integer index = this.addMember(GetUnitX(whichUnit), GetUnitY(whichUnit), GetUnitFacing(whichUnit))
			call this.addUnitType(index, GetUnitTypeId(whichUnit), weight)
			call this.addUnit(whichUnit, index)
			return index
		endmethod

		public method removeUnitWithType takes unit whichUnit returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_members.size())
				call this.removeUnitType(i, GetUnitTypeId(whichUnit))
				set i = i + 1
			endloop
			call this.removeUnit(whichUnit)
			call thistype.clearSpawnPointMember(whichUnit)
		endmethod

		/**
		 * \return Returns the remaining time in seconds for the respawn of all members.
		 */
		public method remainingTime takes nothing returns real
			if (this.m_spawnTimer == null) then
				return 0.0
			endif
			return TimerGetRemaining(this.m_spawnTimer)
		endmethod

		public method runs takes nothing returns boolean
			return this.remainingTime() > 0.0
		endmethod

		/**
		 * Pauses the respawn timer. If it does not run nothing happens and the call returns false.
		 * Otherwise it returns true.
		 */
		public method pause takes nothing returns boolean
			if (not this.runs()) then
				return false
			endif
			call PauseTimer(this.m_spawnTimer)
			return true
		endmethod

		public method resume takes nothing returns boolean
			if (not this.runs()) then
				return false
			endif
			call ResumeTimer(this.m_spawnTimer)
			return true
		endmethod

		public method isEnabled takes nothing returns boolean
			return IsTriggerEnabled(this.m_deathTrigger)
		endmethod

		/// If you want to start a video and there are some spawn points near the scene you can disable them during the video.
		public method enable takes nothing returns nothing
			call EnableTrigger(this.m_deathTrigger)
			call this.resume()
		endmethod

		/**
		 * Disables the spawn point which means that no item drops or respawns will happen anymore. Besides that the respawn timer is
		 * paused.
		 */
		public method disable takes nothing returns nothing
			call DisableTrigger(this.m_deathTrigger)
			call this.pause()
		endmethod

		/**
		 * \return Returns true if the whole group is dead.
		 */
		public method isDead takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_group.units().size())
				if (not IsUnitDeadBJ(this.m_group.units()[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * Called by .evaluate() whenever a unit is respawned or added for the first time.
		 */
		public stub method onSpawnUnit takes unit whichUnit, integer memberIndex returns nothing
		endmethod

		/**
		 * Spawns all members but only if all are dead.
		 * Otherwise it returns false and nothing happens.
		 * \return Returns true if all members are dead and are spawned. Otherwise it returns false.
		 * \sa spawnDeadOnly()
		 */
		public method spawn takes nothing returns boolean
			local integer i
			local effect whichEffect
			local unit whichUnit
			if (not this.isDead()) then
				debug call this.print("Warning: Unit group is not dead yet.")
				return false
			endif
			call this.clearUnits() // clear dead members
			set i = 0
			loop
				exitwhen (i == this.m_members.size())
				set whichUnit = ASpawnPointMember(this.m_members[i]).placeUnit(this.owner())

				if (whichUnit != null) then
					call this.addUnit(whichUnit, i)
					// need global, faster?
					if (this.effectFilePath() != null) then
						set whichEffect = AddSpecialEffect(this.effectFilePath(), GetUnitX(whichUnit), GetUnitY(whichUnit))
						call DestroyEffect(whichEffect)
						set whichEffect = null
					endif
					if (this.soundFilePath() != null) then
						call PlaySoundFileAt(this.soundFilePath(), GetUnitX(whichUnit), GetUnitY(whichUnit), GetUnitZ(whichUnit))
					endif
				debug else
					debug call this.print("Warning: Couldn't place unit.")
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * Spawns only the dead members.
		 * \sa spawn()
		 */
		public method spawnDeadOnly takes nothing returns nothing
			local unit whichUnit = null
			local effect whichEffect = null
			local integer i = 0
			loop
				exitwhen (i == this.m_members.size())
				if (IsUnitDeadBJ(this.m_group.units()[i])) then
					set whichUnit = ASpawnPointMember(this.m_members[i]).placeUnit(this.owner())

					if (whichUnit != null) then
						call this.clearSpawnPointMember(this.m_group.units()[i])
						call this.setUnit(whichUnit, i)
						// need global, faster?
						if (this.effectFilePath() != null) then
							set whichEffect = AddSpecialEffect(this.effectFilePath(), GetUnitX(whichUnit), GetUnitY(whichUnit))
							call DestroyEffect(whichEffect)
							set whichEffect = null
						endif
						if (this.soundFilePath() != null) then
							call PlaySoundFileAt(this.soundFilePath(), GetUnitX(whichUnit), GetUnitY(whichUnit), GetUnitZ(whichUnit))
						endif
					debug else
						debug call this.print("Warning: Couldn't place unit.")
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		/**
		 * \return This returns a new item owner using a uniform distribution.
		 * \note It considers ownly playing users (no computer players).
		 * \note Since thistype.m_dropOwnerId is initialized with a random number it uses always the same values in a game but the initial value might be different.
		 */
		private static method getRandomItemOwner takes nothing returns player
			local player user = null
			local integer oldDropId = thistype.m_dropOwnerId
			set thistype.m_dropOwnerId = thistype.m_dropOwnerId + 1
			loop
				if (thistype.m_dropOwnerId == bj_MAX_PLAYERS) then
					set thistype.m_dropOwnerId = 0
				endif
				set user = Player(thistype.m_dropOwnerId)
				if (IsPlayerPlayingUser(user) or thistype.m_dropOwnerId == oldDropId) then
					return user
				endif
				set user = null
				set thistype.m_dropOwnerId = thistype.m_dropOwnerId + 1
			endloop
			return user
		endmethod

		/**
		 * Assigns a randomly choosen owner to the item \p whichItem and shows the dropping message to all playing users.
		 * If no dropping message has been specified  (\ref textDistributeItem() returns null), no message is shown.
		 */
		public method distributeDroppedItem takes item whichItem returns nothing
			local player itemOwner = thistype.getRandomItemOwner()
			local player user = null
			local integer i = 0
			call SetItemPlayer(whichItem, itemOwner, true)
			if (this.textDistributeItem() != null) then
				loop
					exitwhen (i == bj_MAX_PLAYERS)
					set user = Player(i)
					if (IsPlayerPlayingUser(user)) then
						call DisplayTimedTextToPlayer(user, 0.0, 0.0, 6.0, Format(this.textDistributeItem()).s(GetItemName(whichItem)).s(GetPlayerName(itemOwner)).result())
					endif
					set user = null
					set i = i + 1
				endloop
			endif
			set itemOwner = null
		endmethod

		private method dropItem takes unit whichUnit, ASpawnPointMember member, real x, real y returns nothing
			local item whichItem
			local integer i = 0
			loop
				exitwhen (i == member.itemPoolsCount())
				set whichItem = member.placeItem(i, x, y)
				if (whichItem != null and this.distributeItems()) then // item can be null if member has no item types to place
					call SetItemDropID(whichItem, GetUnitTypeId(whichUnit))
					call this.distributeDroppedItem(whichItem)
				debug else
					debug call this.print("Warning: Couldn't place item.")
				endif
				set i = i + 1
			endloop
		endmethod

		private static method timerFunctionSpawn takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.spawn()
		endmethod

		private method startTimer takes nothing returns nothing
			debug if (this.runs()) then
				debug call this.print("Timer has arleady been started.")
				debug return
			debug endif
			if (this.m_spawnTimer == null) then
				set this.m_spawnTimer = CreateTimer()
				call AHashTable.global().setHandleInteger(this.m_spawnTimer, 0, this)
			endif
			call TimerStart(this.m_spawnTimer, this.time(), false, function thistype.timerFunctionSpawn)
		endmethod

		private static method triggerConditionDeath takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = this.m_group.units().contains(GetTriggerUnit())

			return result
		endmethod

		private static method triggerActionDeath takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local unit triggerUnit = GetTriggerUnit()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			local ASpawnPointMember member = thistype.spawnPointMember(triggerUnit)
			call this.dropItem(triggerUnit, member, GetUnitX(triggerUnit), GetUnitY(triggerUnit)) // drop before removing member
			// NOTE dont remove the unit from the group. Some triggers might rely on the fact that the unit is part of the spawn point
			if (this.isDead()) then
				call this.startTimer()
			endif
			set triggeringTrigger = null
			set triggerUnit = null
		endmethod

		private method createDeathTrigger takes nothing returns nothing
			local filterfunc filterFunction
			local integer i
			set this.m_deathTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS) // register for neutral players, too!
				call TriggerRegisterPlayerUnitEvent(this.m_deathTrigger, Player(i), EVENT_PLAYER_UNIT_DEATH, null)
				set i = i + 1
			endloop
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call AHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_time = 30.0
			set this.m_effectFilePath = null
			set this.m_soundFilePath = null
			set this.m_distributeItems = false
			set this.m_owner = Player(PLAYER_NEUTRAL_AGGRESSIVE)
			set this.m_textDistributeItem = ""
			// members
			set this.m_members = AIntegerVector.create()
			set this.m_group = AGroup.create()
			set this.m_spawnTimer = null

			call this.createDeathTrigger()

			return this
		endmethod

		/// Removes all contained units.
		public method onDestroy takes nothing returns nothing
			// dynamic members
			set this.m_effectFilePath = null
			set this.m_soundFilePath = null
			set this.m_owner = null
			// members
			loop
				exitwhen (this.m_members.empty())
				call ASpawnPointMember(this.m_members.back()).destroy()
				call this.m_members.popBack()
			endloop
			call this.m_members.destroy()
			call this.m_group.destroy()

			call AHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null

			if (this.m_spawnTimer != null) then
				call AHashTable.global().destroyTimer(this.m_spawnTimer)
				set this.m_spawnTimer = null
			endif
		endmethod

		public static method init takes nothing returns nothing
			// static members
			set thistype.m_dropOwnerId = GetRandomInt(0, bj_MAX_PLAYERS - 1)
		endmethod
	endstruct

endlibrary