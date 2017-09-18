//! import "Systems/Melee/Struct Abstract Id Generator.j"
//! import "Systems/Melee/Struct Abstract Id Item.j"
//! import "Systems/Melee/Struct Abstract Id Level Generator.j"
//! import "Systems/Melee/Struct Creep Id Item.j"
//! import "Systems/Melee/Struct Id Set.j"
//! import "Systems/Melee/Struct Id Table.j"
//! import "Systems/Melee/Struct Item Drop.j"
//! import "Systems/Melee/Struct Item Type Id Item.j"
//! import "Systems/Melee/Struct NP Id Item.j"
//! import "Systems/Melee/Struct Random Creep Id Generator.j"
//! import "Systems/Melee/Struct Random Item Type Id Generator.j"
//! import "Systems/Melee/Struct Random NP Id Generator.j"
//! import "Systems/Melee/Struct Unit Spawn.j"

/**
 * \brief A basic system which allows to create creep spots, units, destructable and item spawns on the map which use fixed or random IDs and have items dropped on their death.
 * The system takes use of \ref itempool and \ref unitpool which are also used by the Warcraft III World Editor itself when creating random creeps or drop tables.
 */
library ASystemsMelee requires AStructSystemsMeleeAbstractIdGenerator, AStructSystemsMeleeAbstractIdItem, AStructSystemsMeleeAbstractIdLevelGenerator, AStructSystemsMeleeCreepIdItem, AStructSystemsMeleeIdSet, AStructSystemsMeleeIdTable, AStructSystemsMeleeItemDrop, AStructSystemsMeleeItemTypeIdItem, AStructSystemsMeleeNPIdItem, AStructSystemsMeleeRandomCreepIdGenerator, AStructSystemsMeleeRandomItemTypeIdGenerator, AStructSystemsMeleeRandomNPIdGenerator, AStructSystemsMeleeUnitSpawn
endlibrary