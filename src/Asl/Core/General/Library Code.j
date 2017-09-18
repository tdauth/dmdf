library ALibraryCoreCode

	/**
	 * Runs \p callback using a new OpLimit.
	 * This might be useful for functions which have many operations and would break the OpLimit.
	 * \param callback The function which is called with a new OpLimit.
	 */
	function NewOpLimit takes code callback returns nothing
		call ForForce(bj_FORCE_PLAYER[0], callback)
	endfunction

endlibrary