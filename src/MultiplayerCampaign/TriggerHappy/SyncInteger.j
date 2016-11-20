library SyncInteger initializer Init uses optional UnitDex, optional GroupUtils
/***************************************************************
*
*   v1.0.7a, by TriggerHappy
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
*   This library allows you to send integers to all other players.
*
*   _________________________________________________________________________
*   1. Installation
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   Copy the script to your map and save it (requires JassHelper *or* JNGP)
*   _________________________________________________________________________
*   2. How it works
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*       1. Creates 12 dummy units and assigns 10 of them an integer from 0-9.
*          The 11th dummy is used to signal when the sequence of numbers is over.
*          The 12h signifies a negative number.
*
*       2. Breaks down the number you want to sync to one or more base 10 integers,
*          then selects each unit assoicated with that integer.
*
*       4. The selection event fires for all players when the selection has been sycned
*
*       5. The ID of the selected unit is one of the base 10 numbers. The current
*          total (starts at 0) is multiplied by 10 and the latest synced integer is
*          added to that. The process will repeat until it selects the 11th dummy,
*          and the total is our result.
*   _________________________________________________________________________
*   3. Proper Usage
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*       - Avoid the SyncSelections native. It may cause the
*         thread to hang or make some units un-able to move.
*
*       - Dummies must be select-able (no locust)
*
*       - Run the script in debug mode while testing
*   _________________________________________________________________________
*   4. Function API
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*       function SyncInteger takes integer playerId, integer number returns boolean
*
*       function GetSyncedInteger takes nothing returns integer
*       function GetSyncedPlayer takes nothing returns player
*       function GetSyncedPlayerId takes nothing returns integer
*       function IsPlayerSyncing takes player p returns boolean
*       function IsSyncEnabled takes nothing returns boolean
*       function SyncIntegerToggle takes boolean flag returns nothing
*       function SyncIntegerEnable takes nothing returns nothing
*       function SyncIntegerDisable takes nothing returns nothing
*
*       function OnSyncInteger takes code func returns triggercondition
*       function RemoveSyncEvent takes triggercondition action returns nothing
*       function TriggerRegisterSyncEvent takes trigger t, integer eventtype returns nothing
*
*       function SyncInitialize takes nothing returns nothing
*       function SyncTerminate takes boolean destroyEvent returns nothing
*
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   -http://www.hiveworkshop.com/forums/submissions-414/syncinteger-syncstring-278674/
*
*/
        globals
            // calls SyncInitialize automatically
            private constant boolean AUTO_INIT          = true

            // owner of the dummy units
            private constant player DUMMY_PLAYER        = Player(PLAYER_NEUTRAL_PASSIVE)

            // dummy can *not* have locust (must be selectabe)
            // basically anything should work (like 'hfoo')
            private constant integer DUMMY_ID           = 'hfoo' // XE_DUMMY_UNITID

            // dummy ghost ability
            private constant integer DUMMY_ABILITY      = 'Aeth'

            // debug mode
            private constant boolean ALLOW_DEBUGGING    = true

            // higher == more dummies but faster
            private constant integer BASE               = 10

            // don't need to change this
            private constant integer DUMMY_COUNT        = BASE+2

            // endconfig
            constant integer EVENT_SYNC_INTEGER = 1

            private trigger OnSelectTrigger = CreateTrigger()
            private trigger EventTrig       = CreateTrigger()
            private real FireEvent          = 0

            private group SelectionGroup

            private integer array SyncData
            private integer LastPlayer
            private integer LastSync
            private unit array SyncIntegerDummy
            private integer array Power
        endglobals

        function GetSyncedInteger takes nothing returns integer
            return LastSync
        endfunction

        function GetSyncedPlayer takes nothing returns player
            return Player(LastPlayer)
        endfunction

        function GetSyncedPlayerId takes nothing returns integer
            return LastPlayer
        endfunction

        function IsPlayerSyncing takes player p returns boolean
            return (SyncData[GetPlayerId(p)] != -1)
        endfunction

        function IsPlayerIdSyncing takes integer pid returns boolean
            return (SyncData[pid] != -1)
        endfunction

        function IsSyncEnabled takes nothing returns boolean
            return IsTriggerEnabled(OnSelectTrigger)
        endfunction

        function SyncIntegerEnable takes nothing returns nothing
            call EnableTrigger(OnSelectTrigger)
        endfunction

        function SyncIntegerDisable takes nothing returns nothing
            call DisableTrigger(OnSelectTrigger)
        endfunction

        function SyncIntegerToggle takes boolean flag returns nothing
            if (flag) then
                call EnableTrigger(OnSelectTrigger)
            else
                call DisableTrigger(OnSelectTrigger)
            endif
        endfunction

        function OnSyncInteger takes code func returns triggercondition
            return TriggerAddCondition(EventTrig, Filter(func))
        endfunction

        function RemoveSyncEvent takes triggercondition action returns nothing
           call TriggerRemoveCondition(EventTrig, action)
        endfunction

        function TriggerRegisterSyncEvent takes trigger t, integer eventtype returns nothing
            call TriggerRegisterVariableEvent(t, SCOPE_PREFIX + "FireEvent", EQUAL, eventtype)
        endfunction

        function SyncInteger takes integer playerId, integer number returns boolean
            local integer x = number
            local integer i = 0
            local integer d = BASE
            local integer n = 0
            local player p
            local unit u

            static if (ALLOW_DEBUGGING and DEBUG_MODE) then
                if (OnSelectTrigger == null) then
                    call BJDebugMsg(SCOPE_PREFIX + "SyncInteger: OnSelectTrigger is destroyed")
                endif

                if (not IsSyncEnabled()) then
                    call BJDebugMsg(SCOPE_PREFIX + "SyncInteger: OnSelectTrigger is disabled")
                endif
            endif

            if (not IsSyncEnabled()) then
                return false
            endif

            if (number < 0) then
                set d = DUMMY_COUNT-1
                set number = number * -1
            endif

            set p = Player(playerId)

            loop
                set x = x/(BASE)
                exitwhen x==0
                set i=i+1
            endloop

            // de-select one unit in case the players selection is full
            call GroupEnumUnitsSelected(SelectionGroup, p, null)
            set u = FirstOfGroup(SelectionGroup)

            if (GetLocalPlayer() == p) then
                call SelectUnit(u, false)
            endif

            loop
                set n = Power[i]
                set x = number/n

                if (GetLocalPlayer() == p) then
                    call SelectUnit(SyncIntegerDummy[x], true)
                    call SelectUnit(SyncIntegerDummy[x], false)
                endif

                set number = number-x*n

                exitwhen i == 0

                set i = i - 1
            endloop

            if (GetLocalPlayer() == p) then
                call SelectUnit(SyncIntegerDummy[d], true)
                call SelectUnit(SyncIntegerDummy[d], false)
                call SelectUnit(u, true)
            endif

            set u = null

            return true
        endfunction

        //this cleans up all dummies and triggers created by the system
        function SyncTerminate takes boolean destroyEvents returns nothing
            local integer i = 0

            if (destroyEvents) then
                call DestroyTrigger(OnSelectTrigger)
                call DestroyTrigger(EventTrig)
                static if (LIBRARY_SyncString) then
                    call DestroyTrigger(SyncString_EventTrig)
                endif
            else
                call SyncIntegerDisable()
            endif

            static if (LIBRARY_UnitDex) then
                set UnitDex.Enabled = false
            endif

            loop
                exitwhen i >= DUMMY_COUNT
                call RemoveUnit(SyncIntegerDummy[i])
                set SyncIntegerDummy[i] = null
                set i = i + 1
            endloop

            static if (LIBRARY_UnitDex) then
                set UnitDex.Enabled = true
            endif
        endfunction

        function SyncInitialize takes nothing returns nothing
            local integer i = 0

            static if (ALLOW_DEBUGGING and DEBUG_MODE) then
                if (OnSelectTrigger == null) then
                    call BJDebugMsg(SCOPE_PREFIX + "SyncInitialize: OnSelectTrigger is null and has no events attached to it")
                endif
            endif

            static if (LIBRARY_UnitDex) then
                set UnitDex.Enabled = false
            endif

            loop
                exitwhen i >= DUMMY_COUNT
                set SyncIntegerDummy[i]=CreateUnit(DUMMY_PLAYER, DUMMY_ID, 1000000, 1000000, i)

                static if (ALLOW_DEBUGGING and DEBUG_MODE) then
                    if (i == 0) then // display once
                        if (SyncIntegerDummy[i] == null) then
                            call BJDebugMsg(SCOPE_PREFIX + "SyncInitialize: Dummy unit is null (check DUMMY_ID)")
                        endif

                        if (GetUnitAbilityLevel(SyncIntegerDummy[i], 'Aloc') > 0) then
                            call BJDebugMsg(SCOPE_PREFIX + "SyncInitialize: Dummy units must be selectable (detected locust)")
                            call UnitRemoveAbility(SyncIntegerDummy[i], 'Aloc')
                        endif
                    endif
                endif

                call SetUnitUserData(SyncIntegerDummy[i], i)
                call UnitAddAbility(SyncIntegerDummy[i], DUMMY_ABILITY)
                call PauseUnit(SyncIntegerDummy[i], true)
                set i = i + 1
            endloop

            static if (LIBRARY_UnitDex) then
                set UnitDex.Enabled = true
            endif

            if (GetExpiredTimer() != null) then
                call DestroyTimer(GetExpiredTimer())
            endif
        endfunction

        private function OnSelect takes nothing returns boolean
            local unit u        = GetTriggerUnit()
            local player p      = GetTriggerPlayer()
            local integer id    = GetPlayerId(p)
            local integer index = GetUnitUserData(u)
            local boolean isNeg = (SyncIntegerDummy[DUMMY_COUNT-1] == u)

            if (SyncIntegerDummy[index] != u) then
                set u = null
                return false
            endif

            static if (ALLOW_DEBUGGING and DEBUG_MODE) then
                if (OnSelectTrigger == null) then
                    call BJDebugMsg(SCOPE_PREFIX + "SyncInteger: OnSelectTrigger is null")
                endif
            endif

            if (isNeg) then
                set SyncData[id] = SyncData[id]*-1
            endif

            if (isNeg or SyncIntegerDummy[DUMMY_COUNT-2] == u) then
                set LastPlayer   = id
                set LastSync     = SyncData[id]
                set SyncData[id] = -1

                // run "events"
                set FireEvent = EVENT_SYNC_INTEGER
                call TriggerEvaluate(EventTrig)
                set FireEvent = 0
            else
                if (SyncData[id]==-1)then
                    set SyncData[id]=0
                endif
                set SyncData[id] = SyncData[id] * BASE + index
            endif

            set u = null

            return false
        endfunction

        public function FireEvents takes real eventtype returns nothing
            set FireEvent = eventtype
            set FireEvent = 0
        endfunction

        //===========================================================================
        private function Init takes nothing returns nothing
            local integer i = 0
            local integer j

            loop
                call TriggerRegisterPlayerUnitEvent(OnSelectTrigger, Player(i), EVENT_PLAYER_UNIT_SELECTED, null)

                set SyncData[i] = -1

                set i = i + 1
                exitwhen i==bj_MAX_PLAYER_SLOTS
            endloop

            call TriggerAddCondition(OnSelectTrigger, Filter(function OnSelect))

            static if (AUTO_INIT) then
                call TimerStart(CreateTimer(), 0, false, function SyncInitialize)
            endif

            static if (LIBRARY_GroupUtils) then
                set SelectionGroup=ENUM_GROUP
            else
                set SelectionGroup=CreateGroup()
            endif

            // fix for innacuracy of real numbers
            set i=0
            set j=1

            loop
                exitwhen i==32

                set Power[i]=j
                set j = j * BASE

                set i=i+1
            endloop
        endfunction

        static if (ALLOW_DEBUGGING and DEBUG_MODE) then
            private function SyncSelectionsHook takes nothing returns nothing
                call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, SCOPE_PREFIX + "SyncSelectionsHook: Detected SyncSelections (can cause issues)")
            endfunction

            hook SyncSelections SyncSelectionsHook
        endif

endlibrary
