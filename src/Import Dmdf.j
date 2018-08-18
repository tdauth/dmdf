//! import "Asl/Import Asl.j"
//! import "Asl/Systems/Debug/Text en.j"
//! import "Game/Import.j"
//! import "Guis/Import.j"
//! import "Quests/Import.j"
//! import "Spells/Import.j"
//! import "Talks/Import.j"
//! import "Videos/Import.j"

/**
 * Predefinition simplifies the usage of the systems.
 * These are the default values for the ASL and the modification TPoF.
 */
globals
	constant boolean A_DEBUG_HANDLES = false
	constant boolean A_DEBUG_NATIVES = false
	constant real A_MAX_COLLISION_SIZE = 300
	constant integer A_MAX_COLLISION_SIZE_ITERATIONS = 10
	constant integer A_SPELL_RESISTANCE_CREEP_LEVEL = 6
	/**
	 * The update interval in seconds in which the characters schema is refreshed.
	 * Note that it decreases the performance if this interval becomes smaller.
	 */
	constant real DMDF_CHARACTERS_SCHEMA_REFRESH_RATE = 2.0

	// used by function GetTimeString()
	constant string A_TEXT_TIME_VALUE = "0%1%" // GetLocalizedString(
	constant string A_TEXT_TIME_PAIR = "%1%:%2%" // GetLocalizedString(
	// used by ADialog
	constant string A_TEXT_DIALOG_BUTTON = "[%1%] %2%" // GetLocalizedString(
endglobals

/**
 * \brief All systems of the modification "The Power of Fire".
 * Require this library to use the API of this modification.
 */
library Dmdf requires Game, Guis, Quests, Spells, Talks, Videos
endlibrary