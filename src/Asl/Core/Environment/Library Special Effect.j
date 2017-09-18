library ALibraryCoreEnvironmentSpecialEffect

	/// Creates a single special effect which only can be seen by player \p user.
	/// \author Tamino Dauth
	function CreateSpecialEffectForPlayer takes player user, string modelPath, real x, real y returns effect
		local player localPlayer = GetLocalPlayer()
		local string localPath = ""
		if (user == localPlayer) then
			set localPath = modelPath 
		endif
		set localPlayer = null
		return AddSpecialEffect(localPath, x, y) 
	endfunction

	/// Creates a single special effect on widget's \p target attachement point \p attachPoint with model file \p model path.
	/// The created special effect is only visible to player \p user.
	function CreateSpecialEffectOnTargetForPlayer takes player user, string modelPath, widget target, string attachPoint returns effect
		local player localPlayer = GetLocalPlayer()
		local string localPath = ""
		if (user == localPlayer) then
			set localPath = modelPath
		endif
		set localPlayer = null
		return AddSpecialEffectTarget(localPath, target, attachPoint) 
	endfunction
	
	function AddSpellEffectForPlayer takes player whichPlayer, string abilityString, effecttype t, real x, real y returns effect
		local string localAbilityString = ""
		if (whichPlayer == GetLocalPlayer()) then
			set localAbilityString = abilityString
		endif
		return AddSpellEffect(localAbilityString, t, x, y)
	endfunction
	
	function AddSpellEffectLocForPlayer takes player whichPlayer, string abilityString, effecttype t, location where returns effect
		local string localAbilityString = ""
		if (whichPlayer == GetLocalPlayer()) then
			set localAbilityString = abilityString
		endif
		return AddSpellEffectLoc(localAbilityString, t, where)
	endfunction
	
	function AddSpellEffectByIdForPlayer takes player whichPlayer, integer abilityId, effecttype t, real x, real y returns effect
		local integer localAbilityId = 0
		if (whichPlayer == GetLocalPlayer()) then
			set localAbilityId = abilityId
		endif
		return AddSpellEffectById(localAbilityId, t, x, y)
	endfunction
	
	function AddSpellEffectByIdLocForPlayer takes player whichPlayer, integer abilityId, effecttype t, location where returns effect
		local integer localAbilityId = 0
		if (whichPlayer == GetLocalPlayer()) then
			set localAbilityId = abilityId
		endif
		return AddSpellEffectByIdLoc(localAbilityId, t, where)
	endfunction
	
	function AddSpellEffectTargetForPlayer takes player whichPlayer, string modelName, effecttype t, widget targetWidget, string attachPoint returns effect
		local string localModelName = ""
		if (whichPlayer == GetLocalPlayer()) then
			set localModelName = modelName
		endif
		return AddSpellEffectTarget(modelName, t, targetWidget, attachPoint)
	endfunction
	
	function AddSpellEffectTargetByIdForPlayer takes player whichPlayer, integer abilityId, effecttype t, widget targetWidget, string attachPoint returns effect
		local integer localAbilityId = 0
		if (whichPlayer == GetLocalPlayer()) then
			set localAbilityId = abilityId
		endif
		return AddSpellEffectTargetById(abilityId, t, targetWidget, attachPoint)
	endfunction

endlibrary