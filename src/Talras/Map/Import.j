//! import "Talras/Map/Struct Aos.j"
//! import "Talras/Map/Struct Arena.j"
//! import "Talras/Map/Struct Buildings.j"
//! import "Talras/Map/Struct Dungeons.j"
//! import "Talras/Map/Struct Fellows.j"
//! import "Talras/Map/Struct Map Cheats.j"
//! import "Talras/Map/Struct Map Data.j"
static if (DMDF_NPC_ROUTINES) then // FIXME static ifs on imports dont have any effect?
//! import "Talras/Map/Struct Npc Routines.j"
endif
//! import "Talras/Map/Struct Npcs.j"
//! import "Talras/Map/Struct Shrines.j"
//! import "Talras/Map/Struct Spawn Points.j"
//! import "Talras/Map/Struct Tomb.j"
//! import "Talras/Map/Struct Weather.j"

library MapMap requires StructMapMapAos, StructMapMapArena, StructMapMapBuildings, StructMapMapDungeons, StructMapMapFellows, StructMapMapMapCheats, StructMapMapMapData, optional StructMapMapNpcRoutines, StructMapMapNpcs, StructMapMapShrines, StructMapMapSpawnPoints, StructMapMapTomb, StructMapMapWeather
endlibrary