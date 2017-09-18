library ALibraryTestContainersList requires ALibraryCoreDebugMisc, AStructCoreDebugBenchmark, AStructCoreGeneralList, AStructCoreGeneralMap, AStructCoreGeneralVector

	globals
		private constant integer insertions = 1000
	endglobals
static if (DEBUG_MODE) then
	private function generateValue takes nothing returns integer
		return GetRandomInt(0, 10000)
	endfunction

	private function listFindSpeedTest takes AIntegerList list, integer value returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("List find speed test")
		call benchmark.start()
		call list.find(value)
		call benchmark.stop()
		return benchmark
	endfunction

	private function listInsertionsSpeedTest takes AIntegerList list returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("List insertions speed test")
		call benchmark.start()
		loop
			exitwhen (list.size() == insertions)
			call list.pushBack(generateValue())
		endloop
		call benchmark.stop()
		return benchmark
	endfunction

	private function mapFindSpeedTest takes AIntegerMap map, integer value returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Map find speed test (key)")
		call benchmark.start()
		call map.find(value)
		call benchmark.stop()
		return benchmark
	endfunction

	private function mapFindValueSpeedTest takes AIntegerMap map, integer value returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Map find speed test (value)")
		call benchmark.start()
		call map.contains(value) // value is key
		call benchmark.stop()
		return benchmark
	endfunction

	private function mapInsertionsSpeedTest takes AIntegerMap map returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Map insertions speed test")
		local integer i = 0
		local integer value
		call benchmark.start()
		loop
			exitwhen (map.size() == insertions)
			set value = generateValue()
			call map.insert(value, value)
		endloop
		call benchmark.stop()
		return benchmark
	endfunction

	private function vectorFindSpeedTest takes AIntegerVector vector, integer value returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Vector find speed test (index)")
		call benchmark.start()
		call vector.at(value) // value is index
		call benchmark.stop()
		return benchmark
	endfunction

	private function vectorFindValueSpeedTest takes AIntegerVector vector, integer value returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Vector find speed test (value)")
		call benchmark.start()
		call vector.find(value)
		call benchmark.stop()
		return benchmark
	endfunction

	private function vectorInsertionsSpeedTest takes AIntegerVector vector returns ABenchmark
		local ABenchmark benchmark = ABenchmark.create("Vector insertions speed test")
		call benchmark.start()
		loop
			exitwhen (vector.size() == insertions)
			call vector.pushBack(10)
		endloop
		call benchmark.stop()
		return benchmark
	endfunction
endif

	/**
	 * Generic container speed comparison and \ref A_FOREACH test.
	 */
	function AListDebug takes nothing returns nothing
static if (DEBUG_MODE) then
		local AIntegerList list = AIntegerList.create()
		local AIntegerMap map = AIntegerMap.create()
		local AIntegerVector vector = AIntegerVector.create()

		call listInsertionsSpeedTest(list)
		call mapInsertionsSpeedTest(map)
		call vectorInsertionsSpeedTest(vector)

		call listFindSpeedTest(list, 10)
		call mapFindSpeedTest(map, 10)
		call mapFindValueSpeedTest(map, 10)
		call vectorFindSpeedTest(vector, 10)
		call vectorFindValueSpeedTest(vector, 10)


		debug call Print("A_FOREACH test for list:")
		//! runtextmacro A_FOREACH("list")
			// no trigger sleep here since iterator could be changed
			debug call Print("Data: " + I2S(AIntegerListIterator(aIterator).data()))
		//! runtextmacro A_FOREACH_END()
		debug call Print("A_REVERSE_FOREACH test for test:")
		//! runtextmacro A_REVERSE_FOREACH("list")
			// no trigger sleep here since iterator could be changed
			debug call Print("Data: " + I2S(AIntegerListIterator(aIterator).data()))
		//! runtextmacro A_REVERSE_FOREACH_END()

		call list.destroy()
		call map.destroy()
		call vector.destroy()
endif
	endfunction

endlibrary