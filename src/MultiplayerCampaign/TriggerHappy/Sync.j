
library Sync requires SyncInteger, PlayerUtils
/***************************************************************
*
*   v1.1.0, by TriggerHappy
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
*   This library allows you to quickly synchronize async data such as,
*   camera position, or a the contents of a local file, to all players
*   in the map by using the game cache.
*
*   Full Documentation: -http://www.hiveworkshop.com/forums/pastebin.php?id=p4f84s
*
*   _________________________________________________________________________
*   1. Installation
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   Copy the script to your map and save it (requires JassHelper *or* JNGP)
*   _________________________________________________________________________
*   2. API
*   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*       struct SyncData
*
*           method create takes player from returns SyncData
*           method start takes nothing returns nothing
*           method refresh takes nothing returns nothing
*           method destroy takes nothing returns nothing
*
*           method addInt takes integer i returns nothing
*           method addReal takes integer i returns nothing
*           method addString takes string s, integer len returns nothing
*           method addBool takes booleanflag returns nothing
*
*           method readInt takes integer index returns integer
*           method readReal takes integer index returns integer
*           method readString takes integer index returns string
*           method readBool takes integer index returns boolean
*
*           method hasInt takes nothing returns boolean
*           method hasReal takes nothing returns boolean
*           method hasString takes nothing returns boolean
*           method hasBool takes nothing returns boolean
*
*           method addEventListener takes code func returns nothing
*
*           ---------
*
*           readonly player from
*
*           readonly real timeStarted
*           readonly real timeFinished
*           readonly real timeElapsed
*
*           readonly integer intCount
*           readonly integer boolCount
*           readonly integer strCount
*           readonly integer realCount
*           readonly integer playersDone
*
*           readonly boolean buffering
*
*           readonly static integer last
*           readonly static player LocalPlayer
*           readonly static boolean Initialized
*
*       function GetSyncedData takes nothing returns SyncData
*
***************************************************************/

    globals
        // characters that can be synced (ascii)
        private constant string ALPHABET                = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~`"

        // safe characters for use in game cache keys
        // (case sensitive)
        private constant string SAFE_KEYS               = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`{|}~`"

        // how fast the buffer updates
        private constant real UPDATE_PERIOD             = 0.03125

        // automatically recycle indices when the syncing player leaves
        private constant boolean AUTO_DESTROY_ON_LEAVE  = true

        // preload game cache key strings on init
        private constant boolean PRELOAD_STR_CACHE      = true

        // size of the alphabet
        private constant integer ALPHABET_BASE          = StringLength(ALPHABET)

        // stop reading the buffer when reaching this char
        private constant string TERM_CHAR               = "`"

        // maximum number of strings *per instance*
        private constant integer MAX_STRINGS            = 8192

        // filenames for gc
        private constant string CACHE_FILE              = "i.w3v"
        private constant string CACHE_FILE_STR          = "s.w3v"

        // event id for JASS API
        constant integer EVENT_SYNC_CACHE = 3
    endglobals

    //**************************************************************

    function GetSyncedData takes nothing returns SyncData
        return SyncData(SyncData.Last)
    endfunction

    public function I2Char takes string alphabet, integer i returns string
        return SubString(alphabet, i, i + 1)
    endfunction

    public function Char2I takes string alphabet, string c returns integer
        local integer i = 0
        local string s
        local integer l = StringLength(alphabet)
        loop
            set s = I2Char(alphabet, i)
            exitwhen i == l
            if (s == c) then
                return i
            endif
            set i = i + 1
        endloop
        return 0
    endfunction

    public function ConvertBase takes string alphabet, integer i returns string
        local integer b
        local string s = ""
        local integer l = StringLength(alphabet)
        if i < l then
            return I2Char(alphabet, i)
        endif
        loop
            exitwhen i <= 0
            set b = i - ( i / l ) * l
            set s = I2Char(alphabet, b) + s
            set i = i / l
        endloop
        return s
    endfunction

    public function PopulateString takes string s, integer makeLen returns string
        local integer i = 0
        local integer l = StringLength(s)
        if (l == makeLen) then
            return s
        endif
        set l = makeLen-l
        loop
            exitwhen i > l
            set s = s + TERM_CHAR
            set i = i + 1
        endloop
        return s
    endfunction

    //**************************************************************

    globals
        // string table keys
        private constant integer KEY_STR_POS = (0*MAX_STRINGS)
        private constant integer KEY_STR_LEN = (1*MAX_STRINGS)

        // pending data storage space
        private constant integer KEY_STR_CACHE = (2*MAX_STRINGS)
    endglobals

    struct SyncData

        readonly player from

        readonly real timeStarted
        readonly real timeFinished
        readonly real timeElapsed

        readonly integer intCount
        readonly integer boolCount
        readonly integer strCount
        readonly integer realCount
        readonly integer playersDone

        readonly boolean buffering

        readonly static boolean Initialized = false
        readonly static integer Last = 0
        readonly static player LocalPlayer

        private integer strBufferLen
        private trigger eventTrig
        private string mkey

        private static hashtable Table
        private static gamecache array Cache
        private static integer array PendingCount
        private static timer Elapsed
        private static timer BufferTimer
        private static integer Running = 0

        private thistype next
        private thistype prev

        private method resetVars takes nothing returns nothing
            set this.intCount       = 0
            set this.strCount       = 0
            set this.boolCount      = 0
            set this.realCount      = 0
            set this.playersDone    = 0
            set this.strBufferLen   = 0
            set this.timeStarted    = 0
            set this.timeFinished   = 0
            set this.buffering      = false
        endmethod

        private static method getKey takes integer pos returns string
            local string position=""

            if (HaveSavedString(Table, KEY_STR_CACHE, pos)) then
                return LoadStr(Table, KEY_STR_CACHE, pos)
            endif

            set position = ConvertBase(SAFE_KEYS, pos)
            call SaveStr(Table, KEY_STR_CACHE, pos, position)

            return position
        endmethod

        static method create takes player from returns thistype
            local thistype this

            // Player has to be playing because of GetLocalPlayer use.
            if (GetPlayerController(from) != MAP_CONTROL_USER or GetPlayerSlotState(from) != PLAYER_SLOT_STATE_PLAYING) then
                return 0
            endif

            set this = thistype.allocate()

            set this.from   = from
            set this.mkey   = getKey(this-1)

            call this.resetVars()

            set thistype(0).next.prev = this
            set this.next = thistype(0).next
            set thistype(0).next = this

            set this.prev = 0

            return this
        endmethod

        method refresh takes nothing returns nothing
            local integer i = 0
            local integer p = 0

            loop
                static if (LIBRARY_PlayerUtils) then
                    exitwhen i == User.AmountPlaying
                    set p = User.fromPlaying(i).id
                else
                    exitwhen i == bj_MAX_PLAYER_SLOTS
                    set p = i
                endif

                call SaveInteger(Table, this, KEY_STR_POS + p, 0)
                call SaveInteger(Table, this, KEY_STR_LEN + p, 0)
                call SaveBoolean(Table, p, this, false) // waiting
                call SaveBoolean(Table, 16+p, this, false) // playerdone

                set i = i + 1
            endloop

            call FlushStoredMission(Cache[0], this.mkey)
            call FlushStoredMission(Cache[1], this.mkey)

            call this.resetVars()
        endmethod

        method destroy takes nothing returns nothing
            if (this.eventTrig != null) then
                call DestroyTrigger(this.eventTrig)
                set this.eventTrig=null
            endif

            call this.refresh()

            set this.next.prev = this.prev
            set this.prev.next = this.next

            call this.deallocate()
        endmethod

        method start takes nothing returns nothing
            call this.t_start.execute()
        endmethod

        method hasInt takes integer index returns boolean
            return HaveStoredInteger(Cache[0], this.mkey, getKey(index))
        endmethod

        method hasReal takes integer index returns boolean
            return HaveStoredReal(Cache[0], this.mkey, getKey(index))
        endmethod

        method hasBool takes integer index returns boolean
            return HaveStoredBoolean(Cache[0], this.mkey, getKey(index))
        endmethod

        method hasString takes integer index returns boolean
            local integer i = LoadInteger(Table, this, KEY_STR_POS+index)
            if (index > 0 and i == 0) then
                return false
            endif
            return HaveStoredInteger(Cache[1], this.mkey, getKey(i + LoadInteger(Table, this, KEY_STR_LEN+index)))
        endmethod

        method addInt takes integer i returns nothing
            local string position=getKey(intCount)

            if (LocalPlayer == this.from) then
                call StoreInteger(Cache[0], this.mkey, position, i)
            endif

            set intCount=intCount+1
        endmethod

        method addReal takes real i returns nothing
            local string position=getKey(realCount)

            if (LocalPlayer == this.from) then
                call StoreReal(Cache[0], this.mkey, position, i)
            endif

            set realCount=realCount+1
        endmethod

        method addBool takes boolean flag returns nothing
            local string position=getKey(boolCount)

            if (LocalPlayer == this.from) then
                call StoreBoolean(Cache[0], this.mkey, position, flag)
            endif

            set boolCount=boolCount+1
        endmethod

        // SyncStoredString doesn't work
        method addString takes string s, integer l returns nothing
            local string position
            local integer i = 0
            local integer strPos = 0
            local integer strLen = 0

            if (StringLength(s) < l) then
                set s = PopulateString(s, l)
            endif

            // store the string position in the table
            if (strCount == 0) then
                call SaveInteger(Table, this, KEY_STR_POS, 0)
            else
                set strLen = LoadInteger(Table, this, KEY_STR_LEN + (strCount-1)) + 1
                set strPos = LoadInteger(Table, this, KEY_STR_POS + (strCount-1)) + strLen

                call SaveInteger(Table, this, KEY_STR_POS + strCount, strPos)
            endif

            // convert each character in the string to an integer
            loop
                exitwhen i > l

                set position = getKey(strPos + i)

                if (LocalPlayer == this.from) then
                    call StoreInteger(Cache[1], this.mkey, position, Char2I(ALPHABET, SubString(s, i, i + 1)))
                endif

                set i = i + 1
            endloop

            set strBufferLen = strBufferLen + l
            call SaveInteger(Table, this, KEY_STR_LEN+strCount, l) // store the length as well
            set strCount=strCount+1
        endmethod

        method readInt takes integer index returns integer
            return GetStoredInteger(Cache[0], this.mkey, ConvertBase(SAFE_KEYS, index))
        endmethod

        method readReal takes integer index returns real
            return GetStoredReal(Cache[0], this.mkey, ConvertBase(SAFE_KEYS, index))
        endmethod

        method readBool takes integer index returns boolean
            return GetStoredBoolean(Cache[0], this.mkey, ConvertBase(SAFE_KEYS, index))
        endmethod

        method readString takes integer index returns string
            local string s = ""
            local string c
            local integer i = 0
            local integer strLen = LoadInteger(Table, this, KEY_STR_LEN+index)
            local integer strPos

            if (not hasString(index)) then
                return null
            endif

            set strLen = LoadInteger(Table, this, KEY_STR_LEN+index)
            set strPos = LoadInteger(Table, this, KEY_STR_POS+index)

            loop
                exitwhen i > strLen

                set c = I2Char(ALPHABET, GetStoredInteger(Cache[1], this.mkey, ConvertBase(SAFE_KEYS, strPos + i)))

                if (c == TERM_CHAR) then
                    return s
                endif

                set s = s + c
                set i = i + 1
            endloop

            return s
        endmethod

        method addEventListener takes code func returns nothing
            if (this.eventTrig == null) then
                set this.eventTrig = CreateTrigger()
            endif
            call TriggerAddCondition(this.eventTrig, Filter(func))
        endmethod

        method t_start takes nothing returns nothing
            local integer i = 0
            local integer n = 0
            local integer j = 0
            local integer p = 0
            local integer l = intCount
            local string position

            // Find the highest count
            if (l < realCount) then
                set l = realCount
            endif
            if (l < strCount) then
                set l = strCount
            endif
            if (l < boolCount) then
                set l = boolCount
            endif

            // Begin syncing
            loop
                exitwhen i > l

                set position = LoadStr(Table, KEY_STR_CACHE, i)

                if (i < intCount and LocalPlayer == this.from) then
                    call SyncStoredInteger(Cache[0], this.mkey, position)
                endif
                if (i < realCount and LocalPlayer == this.from) then
                    call SyncStoredReal(Cache[0], this.mkey, position)
                endif
                if (i < boolCount and LocalPlayer == this.from) then
                    call SyncStoredBoolean(Cache[0], this.mkey, position)
                endif

                if (i < strCount and LocalPlayer == this.from) then
                    set n = LoadInteger(Table, this, KEY_STR_LEN + i)
                    set p = LoadInteger(Table, this, KEY_STR_POS + i)

                    set j = 0

                    loop
                        exitwhen j > n

                        set position = LoadStr(Table, KEY_STR_CACHE, p + j)

                        if (LocalPlayer == this.from) then
                            call SyncStoredInteger(Cache[1], this.mkey, position)
                        endif

                        set j = j + 1
                    endloop
                endif

                set i = i + 1
            endloop

            set this.timeStarted = TimerGetElapsed(Elapsed)
            set this.playersDone = 0
            set this.buffering   = true

            if (Running==0) then
                call TimerStart(BufferTimer, UPDATE_PERIOD, true, function thistype.readBuffer)
            endif

            set Running=Running+1
        endmethod

        static method readBuffer takes nothing returns nothing
            local boolean b = true
            local integer i = 0
            local integer p = GetPlayerId(GetLocalPlayer())
            local thistype data = thistype(0).next

            loop
                exitwhen data == 0

                // find the nearest instance that is still buffering
                loop
                    exitwhen data.buffering or data == 0
                    set data=data.next
                endloop

                // if none are found, exit
                if (not data.buffering) then
                    return
                endif

                // if the player has left, destroy the instance
                static if (AUTO_DESTROY_ON_LEAVE) then
                    if (GetPlayerSlotState(data.from) != PLAYER_SLOT_STATE_PLAYING) then
                        call data.destroy()
                    endif
                endif

                set b = true

                // make sure all integers have been synced
                if (data.intCount > 0 and  not data.hasInt(data.intCount-1)) then
                    set b = false
                endif

                // make sure all reals have been synced
                if (data.realCount > 0 and not data.hasReal(data.realCount-1)) then
                    set b = false
                endif

                // check strings too
                if (data.strCount > 0 and not data.hasString(data.strCount-1)) then
                    set b = false
                endif

                // and booleans
                if (data.boolCount > 0 and not data.hasBool(data.boolCount-1)) then
                    set b = false
                endif

                // if everything has been synced
                if (b) then

                    if (not LoadBoolean(Table, p, data)) then // async
                        call SaveBoolean(Table, p, data, true)

                        // notify everyone that the local player has recieved all of the data
                        call SyncInteger(p, data)
                    endif

                endif

                set data = data.next
            endloop
        endmethod

        static method updateStatus takes nothing returns boolean
            local integer i = 0
            local integer p = GetSyncedPlayerId()
            local boolean b = true
            local boolean c = true
            local thistype data = GetSyncedInteger()

            if (not data.buffering) then
                return false
            endif

            set data.playersDone = data.playersDone + 1

            call SaveBoolean(Table, p, data, true)
            call SaveBoolean(Table, 16+p, data, true)

            // check if everyone has received the data
            loop
                static if (LIBRARY_PlayerUtils) then
                    exitwhen i == User.AmountPlaying
                    set p = User.fromPlaying(i).id
                    set c = User.fromPlaying(i).isPlaying
                else
                    exitwhen i == bj_MAX_PLAYER_SLOTS
                    set p = i
                    set c = (GetPlayerController(Player(p)) == MAP_CONTROL_USER and GetPlayerSlotState(Player(p)) == PLAYER_SLOT_STATE_PLAYING)
                endif

                if (c and not LoadBoolean(Table, 16+p, data)) then
                    set b = false // someone hasn't
                endif

                set i = i + 1
            endloop

            // if everyone has recieved the data
            if (b) then
                set Running = Running-1

                if (Running == 0) then
                    call PauseTimer(BufferTimer)
                endif

                set data.buffering    = false
                set data.timeFinished = TimerGetElapsed(Elapsed)
                set data.timeElapsed  = data.timeFinished - data.timeStarted

                call SaveBoolean(Table, GetPlayerId(GetLocalPlayer()), data, false)

                // fire events
                if (data.eventTrig != null) then
                    set Last = data
                    call TriggerEvaluate(data.eventTrig)
                endif

                call SyncInteger_FireEvents(EVENT_SYNC_CACHE)
            endif

            return false
        endmethod

        static method onInit takes nothing returns nothing
            set Table=InitHashtable()

            set Cache[0]=InitGameCache(CACHE_FILE)
            set Cache[1]=InitGameCache(CACHE_FILE_STR)

            set Elapsed=CreateTimer()
            set BufferTimer=CreateTimer()

            static if (LIBRARY_PlayerUtils) then
                set LocalPlayer=User.Local
            else
                set LocalPlayer=GetLocalPlayer()
            endif

            call OnSyncInteger(function thistype.updateStatus)
            call TimerStart(Elapsed, 604800, false, null)

            static if (PRELOAD_STR_CACHE) then
                loop
                    exitwhen Last == ALPHABET_BASE
                    call getKey(Last)
                    set Last = Last + 1
                endloop
                set Last = 0
            endif

            set Initialized = true
        endmethod

    endstruct

endlibrary
