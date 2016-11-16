// All functions for the trigger data of The Power of Fire. Wrappers have to be used since the vJass syntax is not allowed for TriggerData.

function AddInfo takes Talk talk, boolean permanent, boolean important, AInfoCondition whichCondition, AInfoAction whichAction, string text returns nothing
	call talk.addInfo(permanent, important, whichCondition, whichAction, text)
endfunction

function CreateQuestArea takes rect whichRect, boolean withFogModifier returns QuestArea
	return QuestArea.create(whichRect, withFogModifier)
endfunction

function PlayerCharacter takes player whichPlayer returns Character
	return Character(Character.playerCharacter(whichPlayer))
endfunction

function MapZoneName takes nothing returns string
	return MapData.mapName
endfunction

function ItemTypeByItem takes item whichItem returns ItemType
	return ItemType.itemTypeOfItem(whichItem)
endfunction

function CreateTalk takes unit whichUnit, ATalkStartAction startAction returns Talk
	return Talk.create(whichUnit, startAction)
endfunction

globals
	trigger InfoConditionTrigger
	trigger InfoActionTrigger
endglobals

function GetTriggerInfo takes trigger whichTrigger returns AInfo
	return DmdfHashTable.global().handleInteger(whichTrigger, 0)
endfunction

function GetTriggerCharacter takes trigger whichTrigger returns Character
	return DmdfHashTable.global().handleInteger(whichTrigger, 1)
endfunction

function InfoConditionEvaluate takes AInfo info, Character character returns boolean
	call DmdfHashTable.global().setHandleInteger(InfoConditionTrigger, 0, info)
	call DmdfHashTable.global().setHandleInteger(InfoConditionTrigger, 1, character)
	return TriggerEvaluate(InfoConditionTrigger)
endfunction

function InfoConditionByTrigger takes trigger whichTrigger returns AInfoCondition
	return InfoConditionEvaluate
endfunction

function InfoActionExecute takes AInfo info, Character character returns boolean
	call DmdfHashTable.global().setHandleInteger(InfoConditionTrigger, 0, info)
	call DmdfHashTable.global().setHandleInteger(InfoConditionTrigger, 1, character)
	return TriggerExecute(InfoActionTrigger)
endfunction

function InfoActionByTrigger takes trigger whichTrigger returns AInfoAction
	return InfoActionExecute
endfunction

function CreateFellow takes unit whichUnit, Talk talk returns Fellow
	return Fellow.create(whichUnit, talk)
endfunction

function CreateShrine takes unit shrineUnit, destructable whichDestructable, rect discoverRect, rect revivalRect, real revivalFacing return Shrine
	return Shrine.create(shrineUnit, whichDestructable, discoverRect, revivalRect, revivalFacing)
endfunction

function CreateSpawnPoint takes nothing returns SpawnPoint
	return SpawnPoint.create()
endfunction

function ShareFellowWithAll takes Fellow fellow returns nothing
	call fellow.shareWithAll()
endfunction

function ShareFellowWithCharacter takes Fellow fellow, Character character returns nothing
	call fellow.shareWith(character)
endfunction

function ResetFellow takes Fellow fellow returns nothing
	call fellow.reset()
endfunction

function SetFellowDescription takes Fellow fellow, string description returns nothing
	call fellow.setDescription(description)
endfunction

function SpawnPointAddUnitWithType takes SpawnPoint spawnPoint, unit whichUnit, real chance returns integer
	return spawnPoint.addUnitWithType(whichUnit, chance)
endfunction

function SpawnPointAddNewItemType takes SpawnPoint spawnPoint, integer unitIndex, integer itemCode, real chance returns integer
	return spawnPoint.addNewItemType(unitIndex, itemCode, chance)
endfunction

function CreateItemSpawnPoint takes nothing returns ItemSpawnPoint
	return ItemSpawnPoint.create()
endfunction