//! import "Guis/Struct Credits.j"
//! import "Guis/Struct Document.j"
///! import "Guis/Struct Grimoire.j"
static if (DMDF_INFO_LOG) then
//! import "Guis/Struct Info Log.j"
endif
static if (DMDF_INVENTORY) then
//! import "Guis/Struct Inventory.j"
endif
//! import "Guis/Struct Main Menu.j"
//! import "Guis/Struct Main Window.j"
static if (DMDF_TRADE) then
//! import "Guis/Struct Trade.j"
endif

library Guis requires StructGuisCredits, StructGuisDocument, optional StructGuisInfoLog, optional StructGuisInventory, StructGuisMainMenu, StructGuisMainWindow, optional StructGuisTrade
endlibrary