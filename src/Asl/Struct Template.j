This file is deprecated since we should optimize declaration positions (using JassHelper option [forcemethodevaluate])

library A<Struct/Library><Module Identifier: Core/Objects/Systems><Sub Module Identifier><Identifier>

	// text macro calls

	// keywords

	globals
		// public constant globals
		// public globals
		// private constant globals
		// private globals
	endglobals

	// type definitions

	// function interfaces of interface

	// interfaces
	interface AInterfaceIdentifier
		// same as in struct definition
	endinterface

	// function interfaces of struct, should be in struct declaration -> vJass bug

	//structs
	struct AStructIdentifier
		// public static constant members
		// private static constant members
		// private static dynamic members
		// private static construction members
		// private static construction text members with the text prefix
		// private static members
		// private dynamic members
		// private construction members
		// private members

		// module implementations

		// text macro calls

		// dynamic member methods

		// construction member methods

		// member methods

		// convenience methods

		// public methods

		// private methods

		// create
		// You have to call the constructor with all construction members
		// Dynamic members can be changed later (after construction) by using the set methods
		// If all members are dynamic, the constructor can take them instead of construction members

		// additional create methods

		// private methods called from onDestroy

		// onDestroy

		// private methods called from onInit

		// onInit (usually private)

		// private methods called from init

		// public init method (init all static construction members)
		// Use this instead of onInit if nothing should be initialized if the system is not be used

		// private methods called from cleanUp

		// public cleanUp method (uninit all static members)

		// public static set and get methods

		// public static methods

		// private static methods
	endstruct

	// functions

	// public functions

	// private functions

	// library initializer (usually private)

	// hooks

endlibrary