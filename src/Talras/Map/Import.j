//! import "Talras/Map/Struct Aos.j"
//! import "Talras/Map/Struct Arena.j"
//! import "Talras/Map/Struct Buildings.j"
//! import "Talras/Map/Struct Dungeons.j"
//! import "Talras/Map/Struct Fellows.j"
static if (DEBUG_MODE) then
//! import "Talras/Map/Struct Map Cheats.j"
endif
//! import "Talras/Map/Struct Map Data.j"
static if (DMDF_NPC_ROUTINES) then
//! import "Talras/Map/Struct Npc Routines.j"
endif
//! import "Talras/Map/Struct Npcs.j"
//! import "Talras/Map/Struct Shrines.j"
//! import "Talras/Map/Struct Spawn Points.j"
//! import "Talras/Map/Struct Tavern.j"
//! import "Talras/Map/Struct Tomb.j"
//! import "Talras/Map/Struct Weather.j"

library MapMap requires StructMapMapAos, StructMapMapArena, StructMapMapBuildings, StructMapMapDungeons, StructMapMapFellows, optional StructMapMapMapCheats, StructMapMapMapData, optional StructMapMapNpcRoutines, StructMapMapNpcs, StructMapMapShrines, StructMapMapSpawnPoints, StructMapMapTavern, StructMapMapTomb, StructMapMapWeather
endlibrary