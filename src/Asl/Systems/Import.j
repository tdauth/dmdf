//! import "Systems/Character/Import.j"
//! import "Systems/BonusMod/Import.j"
static if (DEBUG_MODE) then
//! import "Systems/Debug/Import.j"
endif
//! import "Systems/Gui/Import.j"
//! import "Systems/Inventory/Import.j"
//! import "Systems/Melee/Import.j"
//! import "Systems/World/Import.j"

/**
 * Requests all sub systems of the ASL.
 * Each system covers a specific range like character treatment or graphical user interfaces.
 * \sa Asl, ACore
 */
library ASystems requires ASystemsCharacter, optional ASystemsDebug, ASystemsBonusMod, ASystemsGui, ASystemsInventory, ASystemsMelee, ASystemsWorld
endlibrary