//! import "Core/Import.j"
//! import "Systems/Import.j"
static if (DEBUG_MODE) then
//! import "Test/Import.j"
endif

/**
 * \mainpage Advanced Script Libray library
 * \author Tamino Dauth <tamino@cdauth.eu>
 * \library Asl
 * Request this library if you want to use any system of the ASL.
 * The ASL is separated into its core and additonal systems.
 * Its core provides more abstract types and functions for general use in Warcraft III whereas the systems provide more specific usage, mainly RPG systems.
 * \note Since vJass has no real support for static ifs on import and require statements you cannot choose exactely which libraries you're going to use. Therefore, your map script might become very big. We recommend to use <a href="http://www.wc3c.net/showthread.php?t=79326">Wc3mapoptimizer</a> to decrease the map's size and increase code performance.
 * \sa ACore
 * \sa ASystems
 *
 * \defgroup war3err war3err
 * If game is started with <a href="http://www.wc3c.net/showthread.php?t=86652">war3err</a> debugging support, you can use some more functions for better debugging.
 *
 * \defgroup nativedebug Native debugging
 * If global constant \ref A_DEBUG_NATIVES is set to true and script has been compiled in debug mode, some JASS natives will be debugged due to usual issues
 * of Warcraft III's interpreter.
 * Debugging is realized by using function hooks.
 * \note You can check out all known native bugs on <a href="http://www.wc3c.net/showthread.php?t=80693">Wc3C.net<a> or <a href="http://mappedia.de/Liste_bekannter_Fehler">Mappedia (German)</a>.
 */
library Asl requires ACore, optional ASystems, optional ATest
endlibrary