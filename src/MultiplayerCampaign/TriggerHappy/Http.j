 library Http requires SharpCraftExtensions, Sync

    globals
        private constant integer MAX_RESPONSE_LEN   = 48
        private constant real CHECK_PERIOD          = 1
    endglobals

    function GetEventHttpRequest takes nothing returns HttpRequest
        return HttpRequest.last()
    endfunction

    struct HttpRequest

        private static timer callbackTimer = CreateTimer()
        private static integer activeRequests = 0
        private static trigger EventTrig = CreateTrigger()
        private static integer LastRequest = 0
        private static integer array RequestId

        string url
        string method
        string data
        string response
        boolexpr callback

        readonly player player

        private SyncData sync
        private boolean running
        private thistype next
        private thistype prev

        private method fireEvent takes nothing returns nothing
            if (this.callback == null) then
                return
            endif
            call TriggerAddCondition(EventTrig, this.callback)
            call TriggerEvaluate(EventTrig)
            call TriggerClearConditions(EventTrig)
        endmethod

        private static method gotResponseSync takes nothing returns nothing
            local SyncData sync = GetSyncedData()
            local string response = sync.readString(0)
            local HttpRequest request = RequestId[sync]

            set LastRequest = request
            set request.response = response
            call request.fireEvent()

            call sync.destroy()
        endmethod

        private static method gotResponse takes nothing returns nothing
            local SyncData sync = GetSyncedData()
            local HttpRequest request = sync.readInt(0)-1
            local string response = ""

            if (request <= 0) then
                call sync.refresh()

                return
            endif

            set RequestId[sync] = request
            set response = GetStoredString(SharpCraftCache, "HTTP", I2S(request))

            call sync.destroy()

            set sync = SyncData.create(request.player)

            call sync.addString(response, MAX_RESPONSE_LEN)
            call sync.addEventListener(function thistype.gotResponseSync)
            call sync.start()

            call FlushStoredString(SharpCraftCache, "HTTP", I2S(request))

            set activeRequests = activeRequests - 1

            if (activeRequests == 0) then
                call PauseTimer(callbackTimer)
            endif
        endmethod

        static method create takes player downloader, string url returns thistype
            local thistype this

            set this = thistype.allocate()
            set this.url = url
            set this.player = downloader
            set this.sync = SyncData.create(downloader)

            set thistype(0).next.prev = this
            set this.next = thistype(0).next
            set thistype(0).next = this

            set this.prev = 0

            call this.sync.addEventListener(function thistype.gotResponse)

            return this
        endmethod

        static method last takes nothing returns thistype
            return thistype.LastRequest
        endmethod

        method destroy takes nothing returns nothing
            set this.next.prev = this.prev
            set this.prev.next = this.next

            set this.method = "GET"
            set this.data = ""
            set this.running = false
            set this.response = ""
            set this.callback = null

            call this.deallocate()
        endmethod

        method start takes nothing returns nothing
            if (this.running) then
                return
            endif

            call StoreString(SharpCraftCache, "ARG", "0", "HTTP")
            call StoreString(SharpCraftCache, "ARG", "1", "ID       = " + I2S(this))
            call StoreString(SharpCraftCache, "ARG", "2", "URL      = " + this.url)
            call StoreString(SharpCraftCache, "ARG", "3", "DATA     = " + this.data)
            call StoreString(SharpCraftCache, "ARG", "4", "METHOD   = " + this.method)
            call StoreString(SharpCraftCache, "ARG", "5", "PLAYER   = " + I2S(GetPlayerId(this.player)))
            call StoreString(SharpCraftCache, "ARG", "6", "END")

            call Cheat("RunSharpCraftCommand")

            set activeRequests = activeRequests + 1

            if (activeRequests == 1) then
                call TimerStart(callbackTimer, CHECK_PERIOD, true, function thistype.check)
            endif

            set this.running = true
        endmethod

        private static method check takes nothing returns nothing
            local integer reqId = 0
            local thistype request = thistype(0).next

            call Cheat("StoreLastResults HTTP")

            loop
                exitwhen request == 0

                if (HaveStoredString(SharpCraftCache, "HTTP", I2S(request))) then
                    set reqId = request
                endif

                if (request.sync.intCount == 0) then
                    call request.sync.addInt(reqId + 1)
                    call request.sync.start()
                endif

                set reqId = 0

                set request = request.next
            endloop

        endmethod

    endstruct

endlibrary
