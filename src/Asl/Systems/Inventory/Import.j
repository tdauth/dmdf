//! import "Systems/Inventory/Struct Item Type.j"
//! import "Systems/Inventory/Struct Unit Inventory.j"

/**
 * \brief The inventory system allows units with the inventory ability to use one page for equipment items and other pages for carrying items in the backpack.
 * A unit can get such an inventory by creating an instance of \ref AUnitInventory.
 * Custom equipment types can be created using \ref AItemType.
 */
library ASystemsInventory requires AStructSystemsInventoryItemType, AStructSystemsInventoryUnitInventory
endlibrary