library SharpCraftChecker initializer Init requires SharpCraftExtensions, Sync, PlayerUtils

    globals
        private boolean array HasSC
        private integer C=0
        private integer D=0
        private boolean B=false
        private trigger E=CreateTrigger()
    endglobals

    public function Initialized takes nothing returns boolean
        return B
    endfunction

    function PlayerHasSharpCraft takes player p returns boolean
        return HasSC[GetPlayerId(p)]
    endfunction

    function PlayersWithSharpCraft takes nothing returns integer
        return D
    endfunction

    function OnSharpCraftInit takes code callback returns nothing
        call TriggerAddCondition(E, Filter(callback))
    endfunction

    function FindPlayerWithSharpCraft takes nothing returns player
        local integer i = 0
        local player p
        loop
            exitwhen i == User.AmountPlaying
            set p = User.fromPlaying(i).handle

            if (PlayerHasSharpCraft(p)) then
                return p
            endif

            set i = i + 1
        endloop
        return null
    endfunction

    private function OnReceiveData takes nothing returns nothing
        local SyncData data = GetSyncedData()
        local boolean b = data.readBool(0)
        set HasSC[GetPlayerId(data.from)] = b

        call data.destroy()

        if (b) then
            debug call BJDebugMsg(User[data.from].nameColored + " has SharpCraft")
            set D=D+1
        endif

        set C=C+1

        if (C>=User.AmountPlaying) then
            call TriggerEvaluate(E)
            set B=true
            set C=-100
        endif
    endfunction

    private function OnGameStart takes nothing returns nothing
        local integer i = 0
        local User u
        local SyncData data

        loop
            exitwhen i == User.AmountPlaying

            set u = User.fromPlaying(i)

            set HasSC[u.id] = false

            if (u.isPlaying) then
                set data = SyncData.create(u.handle)
                call data.addBool(HasSharpCraft())
                call data.addEventListener(function OnReceiveData)
                call data.start()
            endif

            set i = i + 1
        endloop
    endfunction

    private function Init takes nothing returns nothing
        call TimerStart(CreateTimer(), 0, false, function OnGameStart)
    endfunction

endlibrary
