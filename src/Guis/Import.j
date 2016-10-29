//! import "Guis/Struct Command Buttons.j"
static if (DMDF_CREDITS) then
//! import "Guis/Struct Credits.j"
endif
static if (DMDF_INFO_LOG) then
//! import "Guis/Struct Info Log.j"
endif
//! import "Guis/Struct Main Window.j"

library Guis requires StructGuisCommandButtons, optional StructGuisCredits, optional StructGuisInfoLog, StructGuisMainWindow
endlibrary