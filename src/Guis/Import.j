static if (DMDF_CREDITS) then
//! import "Guis/Struct Credits.j"
endif
///! import "Guis/Struct Grimoire.j"
static if (DMDF_INFO_LOG) then
//! import "Guis/Struct Info Log.j"
endif
//! import "Guis/Struct Main Menu.j"
//! import "Guis/Struct Main Window.j"

library Guis requires optional StructGuisCredits, optional StructGuisInfoLog, StructGuisMainMenu, StructGuisMainWindow
endlibrary