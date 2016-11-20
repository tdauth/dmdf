library MultiplayerCampaign

     private function OnGetResponse takes nothing returns boolean
        local HttpRequest req = GetEventHttpRequest() // or HttpRequest.last()

        call BJDebugMsg(GetPlayerName(req.player) + " downloaded \"" + req.response + "\"")

        call req.destroy()

        return false
    endfunction


    function RehostMap takes string mapName returns boolean
        local HttpRequest http = HttpRequest.create(FindPlayerWithSharpCraft(), "wc3lib.org/rehost/" + mapName)

        if (http.player == null) then
            call BJDebugMsg("No players have SharpCraft installed.")
            return false
        endif

        set http.callback = Filter(function OnGetResponse)

        call BJDebugMsg("Downloading " + http.url)

        call http.start()

        return false
    endfunction

endlibrary
