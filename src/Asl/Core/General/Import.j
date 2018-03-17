//! import "Core/General/Interface Container.j"
//! import "Core/General/Struct Asl.j"
//! import "Core/General/Struct Force.j"
//! import "Core/General/Struct Group.j"
//! import "Core/General/Struct Hash Table.j"
//! import "Core/General/Struct List.j"
//! import "Core/General/Struct Vector.j"
//! import "Core/General/Library Code.j"
//! import "Core/General/Library Conversion.j"
//! import "Core/General/Library Game.j"
//! import "Core/General/Library Item.j"
//! import "Core/General/Library Player.j"
//! import "Core/General/Library Timer.j"
//! import "Core/General/Library Unit.j"

/**
 * \fn StartStockUpdates
 * Perform the first update, and then arrange future updates.
 * \author Blizzard Entertainment
 *
 * \fn UnitDropItem
 * Makes the given unit drop the given item
 * Note: This could potentially cause problems if the unit is standing
 * right on the edge of an unpathable area and happens to drop the
 * item into the unpathable area where nobody can get it...
 * \author Blizzard Entertainment
 * \sa WidgetDropItem
 *
 * \fn WidgetDropItem
 * Makes widget \p inWidget dropping an item of type \p inItemID which does acutally mean that it's created at a random location within a maximum range of 32.
 * \return Returns dropped item handle.
 * \sa UnitDropItem

 * \defgroup wrappers Wrappers
 * There are various wrapper structures which provide nearly the same functionality of a default native JASS type but some extras, as well.
 * \ref AForce can be used to get the same functions as there are for native type \ref force but you get random access to force members, too.
 * \ref AGroup does the same for native type \ref group.
 * Finally, \ref AHashTable provides access to one single \ref hashtable but in a way like for \ref gamecache (which had been used before), too.

 * \defgroup containers Containers
 * ASL provides some different container types based on <a href="http://www.cplusplus.com/reference/stl">C++ STL</a> and provided through vJass's text macro feature.
 * For simple containers which do usually only grow at their end you can use \ref A_VECTOR.
 * There is a more specialized version for numeric operations, as well called \ref A_NUMERIC_VECTOR.
 * If you need a more flexible container without random access functionality which can grow easily by pushing elements to its front or inserting elements somewhere you should use \ref A_LIST which provides you a double-linked list container.
 * The last structure isn't any real custom container macro but can be used to store elements, too.
 * It's simply a wrapper for JASS data type \ref hashtable called \ref AHashTable.
 * Therefore it doesn't need any text macro call to be generated.
 *
 * All container text macros do provide some default structures mostly for default types in JASS:
 * <ul>
 * <li>AIntegerVector</li>
 * <li>AStringVector</li>
 * <li>ABooleanVector</li>
 * <li>ARealVector</li>
 * <li>AHandleVector</li>
 * <li>AEffectVector</li>
 * <li>AUnitVector</li>
 * <li>AItemVector</li>
 * <li>ADestructableVector</li>
 * <li>ARectVector</li>
 * <li>AWeatherEffectVector</li>
 * <li>APlayerVector</li>
 * <li>AIntegerNumericVector</li>
 * <li>ARealNumericVector</li>
 * <li>AIntegerList</li>
 * <li>AStringList</li>
 * <li>ABooleanList</li>
 * <li>ARealList</li>
 * <li>AHandleList</li>
 * <li>APlayerList</li>
 * <li>ARegionList</li>
 * </ul>
 * \note If you're going to use any container structure for storing pointers you should rather use an existing integer based container than creating a new text macro instance which generates a lot of code although it could be more type safe (actually type safety isn't implemented in vJass that strong at all).
 * \note As you can see there are many default containers for native handle-based types. Unfortunately, we cannot do downcasts anymore (since return bug has been fixed) so we need to generate a container structure for each type seperately instead of using the handle-based container for all derived types.

 * \defgroup foreach foreach loops
 * foreach loops can be used to iterate through container types (\ref containers).
 * They are implemented via text macros and you do not have to consider any bounds in code anymore.
 * All container types which do offer iterators can be used in foreach loops.
 * At the moment these are:
 * <ul>
 * <li>\ref A_VECTOR </li>
 * <li>\ref A_LIST </li>
 * </ul>
 * There are two different types of foreach loops.
 * The first one is much easier to use since you do not have declare any other variable than your iterated container.
 * On the other hand you have to use an iterator called \ref aIterator instead of a simple value.
 * The second version requires a local variable of value type of the used container.
 * It's easier for people who don't any iterator and you only have to declare another local variable and the name of the container's iterator type (which is required since the text macro can't detect it automatically).
 *
 * \warning The foreach statements use the global variable \ref aIterator which can be overwritten by simultaneous foreach statements, so please only use any foreach statement if you're really, really sure that there won't be such a statement at the same time (don't use functions like \ref TriggerSleepAction()). It can be compared to "For Integer A" and "For Integer B" trigger actions which do use a global variable, as well.
 *
 * Here is an example of how foreach loops can be used:
 * \code
	function TestFunction takes nothing returns nothing
		local AIntegerList list = AIntegerList.createWithSize(10, 0)
		local integer value
		//! runtextmacro A_FOREACH("list")
			debug call Print("Data: " + I2S(AIntegerListIterator(aIterator.data()))) // alternativer Iteratorzugriff
		//! runtextmacro A_FOREACH_END()
		//! runtextmacro A_FOREACH_2("value", "list", "AIntegerListIterator")
			debug call Print("Data: " + I2S(value))
		//! runtextmacro A_FOREACH_END()
		//! runtextmacro A_REVERSE_FOREACH_2("value", "list", "AIntegerListIterator")
			debug call Print("Data: " + I2S(value))
		//! runtextmacro A_REVERSE_FOREACH_END()
	endfunction
 * \endcode
 * As you can see there exist reverse versions of both foreach loops to iterate
 * containers in reverse order.
 * \note Don't forget to conclude your scope with the ending statement
 *
 * By now, there's another foreach-like statement called \ref A_DESTROY .
 * It helps you to clean up your container if it contains struct based instances since calls the destructor of each element automatically.
 * Here is an example of how to use it:
 * \code
	function TestFunction2 takes nothing returns nothing
		local AIntegerList list = AIntegerList.create()
		loop
			exitwhen (list.size() == 10)
			call list.pushBack(AIntegerList.create()) // add instance
		endloop
		// cleans up all instances
		loop
			exitwhen (list.empty())
			call AIntegerList(list.back()).destroy()
			call list.popBack()
		endloop
		call list.destroy()
	endfunction

	// can be replaced by

	function TestFunction2 takes nothing returns nothing
		local AIntegerList list = AIntegerList.create()
		loop
			exitwhen (list.size() == 10)
			call list.pushBack(AIntegerList.create()) // add instance
		endloop
		// cleans up all instances
		//! runtextmacro A_DESTROY("list", "AIntegerList")
	endfunction
 * \endcode
 */
library ACoreGeneral requires AInterfaceCoreGeneralContainer, AStructCoreGeneralAsl, AStructCoreGeneralForce, AStructCoreGeneralGroup, AStructCoreGeneralHashTable, AStructCoreGeneralList, AStructCoreGeneralVector, ALibraryCoreCode, ALibraryCoreGeneralConversion, ALibraryCoreGeneralGame, ALibraryCoreGeneralItem, ALibraryCoreGeneralPlayer, ALibraryCoreGeneralTimer, ALibraryCoreGeneralUnit
endlibrary