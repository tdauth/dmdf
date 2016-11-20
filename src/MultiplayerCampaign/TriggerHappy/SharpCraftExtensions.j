library SharpCraftExtensions initializer Init

    globals
        gamecache SharpCraftCache = null
    endglobals

    function HasSharpCraft takes nothing returns boolean // async
        return GetStoredBoolean(SharpCraftCache, "SC", "0")
    endfunction

    private function Init takes nothing returns nothing
        set SharpCraftCache = InitGameCache("sc.w3v")

        call Cheat("SharpCraftInit")

        if (not HasSharpCraft()) then
            call InitGameCache("sc.w3v")
        endif
    endfunction


endlibrary
