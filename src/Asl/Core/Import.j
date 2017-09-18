//! import "Core/Ai/Import.j"
static if (DEBUG_MODE) then
//! import "Core/Debug/Import.j"
endif
//! import "Core/Environment/Import.j"
//! import "Core/General/Import.j"
//! import "Core/Interface/Import.j"
//! import "Core/Maths/Import.j"
//! import "Core/String/Import.j"

/**
 * ASL core covers all core functions, structures and interfaces such as \ref containers, player-only functions, maths stuff, string treatment and debugging functions and structures and \ref wrappers, for instance.
 * \sa Asl
 * \if A_SYSTEMS
 * \sa ASystems
 * \endif
 */
library ACore requires ACoreAi, optional ACoreDebug, ACoreEnvironment, ACoreGeneral, ACoreInterface, ACoreMaths, ACoreString
endlibrary