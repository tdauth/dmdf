scope HttpExample initializer Init

     private function OnDownloadString takes nothing returns boolean
        local HttpRequest req = GetEventHttpRequest() // or HttpRequest.last()

        call BJDebugMsg(GetPlayerName(req.player) + " downloaded \"" + req.response + "\"")

        call req.destroy()

        return false
    endfunction


    private function OnMapStart takes nothing returns boolean
        local HttpRequest http = HttpRequest.create(FindPlayerWithSharpCraft(), "www.hiveworkshop.com/attachments/hello-txt.248392/")

        if (http.player == null) then
            call BJDebugMsg(SCOPE_PREFIX + "No players have SharpCraft installed.")
            return false
        endif

        set http.callback = Filter(function OnDownloadString)

        call BJDebugMsg("Downloading " + http.url)

        call http.start()

        return false
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        call OnSharpCraftInit(function OnMapStart)
    endfunction

endscope
