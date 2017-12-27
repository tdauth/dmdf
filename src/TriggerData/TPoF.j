/**
 * This file contains vJass code to use the custom trigger data of the modification "The Power of Fire".
 * To use it, just open the trigger editor and select the custom map script and add the line:
 * //! import "TriggerData/TPoF.j"
 *
 * The file predefines all required globals and structs and provides simple JASS functions as wrapper for the actual systems of TPoF and the ASL.
 * Since the GUI trigger editor does not allow handling vJass code these adaptions are necessary.
 *
 * Event handling is realized by storing vectors of triggers which are registered for events using \ref ATriggerVector.
 * The events are triggered for example by the \ref MapData methods. The trigger parameters are stored as values in the hashtable \ref DmdfHashTable.global()
 * using the trigger's handle ID as parent key and a unique integer key as child key. They can be accessed in the trigger using the handle ID of \ref GetTriggeringTrigger()
 * as parent key and the unique integer key as child key.
 *
 * Using triggers instead of function pointers is a bit more complicated. Since the GUI trigger does not simply allow handling with function references it is much easier to simply use a whole trigger as a function pointer. To use a trigger as function pointer a unique hash table has to be used such as \ref TalkStartActionsHashTable and the trigger has to be stored using a passed function argument (passed to the function of the function pointer) as parent key. Then a predefined function which matches the function interface has to be set as function pointer. When the function of the pointer is called it uses the parameter which was used as parent key again to restore the stored trigger and calls the trigger instead of doing anything else. Thus a trigger is called in the end which has been specified by the user. Any trigger parameters have to be attached as well like it is done for event handling using \ref DmdfHashTable.global() and the called trigger.
 */

//! import "Import Dmdf.j"

/**
 * \brief All functions for the trigger data of The Power of Fire. Wrappers have to be used since the vJass syntax is not allowed for TriggerData.
 */
library TPoFTriggerData requires Asl, Dmdf

globals
	// Last X'd vars
	AQuest lastCreatedCharacterQuest = 0
	AQuestItem lastCreatedCharacterQuestItem = 0
	Talk lastCreatedTalk = 0
	AInfo lastCreatedInfo = 0
	Fellow lastCreatedFellow = 0
	SpawnPoint lastCreatedSpawnPoint = 0
	ItemSpawnPoint lastCreatedItemSpawnPoint = 0
	integer lastAddedSpawnPointMemberIndex = 0
	integer lastAddedSpawnPointMemberItemTypeIndex = 0
	NpcRoutineWithFacing lastCreatedRoutineWithFacing = 0
	NpcTalksRoutine lastCreatedRoutineTalks = 0
	AVideo lastCreatedVideo = 0
	integer lastSavedUnitActor = 0
endglobals

function EnglishGermanString takes string english, string german returns string
	return tre(german, english)
endfunction

globals
	force CharacterPlayers = CreateForce()
endglobals

function GetCharacterPlayers takes nothing returns force
	local integer i = 0
	call ForceClear(CharacterPlayers)
	loop
		exitwhen (i == bj_MAX_PLAYERS)
		if (Character.playerCharacter(Player(i)) != 0) then
			call ForceAddPlayer(CharacterPlayers, Player(i))
		endif
		set i = i + 1
	endloop

	return CharacterPlayers
endfunction

globals
	ATriggerVector mapInitSettingsTriggers = 0
	ATriggerVector mapInitTriggers = 0
	ATriggerVector mapCreateClassSelectionItemsTriggers = 0
	ATriggerVector mapCreateClassItemsTriggers = 0
	ATriggerVector mapStartTriggers = 0
	ATriggerVector mapSelectClassTriggers = 0
	ATriggerVector mapRepickCharacterTriggers = 0
	ATriggerVector mapRestoreCharacterTriggers = 0
	ATriggerVector mapRestoreCharactersTriggers = 0
	ATriggerVector mapInitVideoSettingsTriggers = 0
	ATriggerVector mapResetVideoSettingsTriggers = 0
	ATriggerVector characterOnEquipItemTriggers = 0
	ATriggerVector characterOnAddRucksackItemTriggers = 0

	constant integer TRIGGERDATA_KEY_INFO = 0
	constant integer TRIGGERDATA_KEY_CHARACTER = 1
	constant integer TRIGGERDATA_KEY_TALK = 2
	constant integer TRIGGERDATA_KEY_ZONENAME = 3
	constant integer TRIGGERDATA_KEY_INVENTORY = 4
	constant integer TRIGGERDATA_KEY_ITEMINDEX = 5
	constant integer TRIGGERDATA_KEY_ITEMFIRSTTIME = 6
	constant integer TRIGGERDATA_KEY_QUEST = 7
	constant integer TRIGGERDATA_KEY_STATE = 8
	constant integer TRIGGERDATA_KEY_CLASS = 9
	constant integer TRIGGERDATA_KEY_VIDEO = 10

	AGlobalHashTable QuestAreaHashTable = 0
	AGlobalHashTable QuestHashTable = 0
	AGlobalHashTable TalkInfoConditionHashTable = 0
	AGlobalHashTable TalkInfoActionHashTable = 0
	AGlobalHashTable TalkStartActionsHashTable = 0
	AGlobalHashTable VideoInitActionHashTable = 0
	AGlobalHashTable VideoPlayActionHashTable = 0
	AGlobalHashTable VideoStopActionHashTable = 0
	AGlobalHashTable VideoSkipActionHashTable = 0
endglobals

/**
 * This function has to be called before any other calls using these variables!
 */
function Init takes nothing returns nothing
	set QuestAreaHashTable = AGlobalHashTable.create()
	set QuestHashTable = AGlobalHashTable.create()
	set TalkInfoConditionHashTable = AGlobalHashTable.create()
	set TalkInfoActionHashTable = AGlobalHashTable.create()
	set TalkStartActionsHashTable = AGlobalHashTable.create()
	set VideoInitActionHashTable = AGlobalHashTable.create()
	set VideoPlayActionHashTable = AGlobalHashTable.create()
	set VideoStopActionHashTable = AGlobalHashTable.create()
	set VideoSkipActionHashTable = AGlobalHashTable.create()

	set mapInitSettingsTriggers = ATriggerVector.create()
	set mapInitTriggers = ATriggerVector.create()
	set mapCreateClassSelectionItemsTriggers = ATriggerVector.create()
	set mapCreateClassItemsTriggers = ATriggerVector.create()
	set mapStartTriggers = ATriggerVector.create()
	set mapSelectClassTriggers = ATriggerVector.create()
	set mapRepickCharacterTriggers = ATriggerVector.create()
	set mapRestoreCharacterTriggers = ATriggerVector.create()
	set mapRestoreCharactersTriggers = ATriggerVector.create()
	set mapInitVideoSettingsTriggers = ATriggerVector.create()
	set mapResetVideoSettingsTriggers = ATriggerVector.create()
	set characterOnEquipItemTriggers = ATriggerVector.create()
	set characterOnAddRucksackItemTriggers = ATriggerVector.create()
endfunction

function TriggerRegisterMapInitSettingsEvent takes trigger whichTrigger returns nothing
	call mapInitSettingsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapInitEvent takes trigger whichTrigger returns nothing
	call mapInitTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnCreateClassSelectionItemsEvent takes trigger whichTrigger returns nothing
	call mapCreateClassSelectionItemsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnCreateClassItemsEvent takes trigger whichTrigger returns nothing
	call mapCreateClassItemsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapStartEvent takes trigger whichTrigger returns nothing
	call mapStartTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnSelectClassEvent takes trigger whichTrigger returns nothing
	call mapSelectClassTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnRepickCharacterEvent takes trigger whichTrigger returns nothing
	call mapRepickCharacterTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnRestoreCharacterEvent takes trigger whichTrigger returns nothing
	call mapRestoreCharacterTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnRestoreCharactersEvent takes trigger whichTrigger returns nothing
	call mapRestoreCharactersTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnInitVideoSettingsEvent takes trigger whichTrigger returns nothing
	call mapInitVideoSettingsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapOnResetVideoSettingsEvent takes trigger whichTrigger returns nothing
	call mapResetVideoSettingsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterCharacterOnEquipItemEvent takes trigger whichTrigger returns nothing
	call characterOnEquipItemTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterCharacterOnAddItemToRucksackEvent takes trigger whichTrigger returns nothing
	call characterOnAddRucksackItemTriggers.pushBack(whichTrigger)
endfunction

function GetTriggerZoneName takes nothing returns string
	return DmdfHashTable.global().handleStr(GetTriggeringTrigger(), TRIGGERDATA_KEY_ZONENAME)
endfunction

function GetTriggerInventory takes nothing returns AUnitInventory
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_INVENTORY)
endfunction

function GetTriggerEquipmentType takes nothing returns integer
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_ITEMINDEX)
endfunction

function GetTriggerRucksackItemIndex takes nothing returns integer
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_ITEMINDEX)
endfunction

function GetTriggerAddedItemFirstTime takes nothing returns boolean
	return DmdfHashTable.global().handleBoolean(GetTriggeringTrigger(), TRIGGERDATA_KEY_ITEMFIRSTTIME)
endfunction

function CreateZone takes string mapName, rect enterRect returns Zone
	return Zone.create(mapName, enterRect)
endfunction

function GameAddDefaultDoodadsOcclusion takes nothing returns nothing
	call Game.addDefaultDoodadsOcclusion()
endfunction

function GameApplyHandicapToCreeps takes nothing returns nothing
	call Game.applyHandicapToCreeps()
endfunction

function SetMapSettingsMapName takes string mapName returns nothing
	call MapSettings.setMapName(mapName)
endfunction

function SetMapSettingsAlliedPlayer takes player whichPlayer returns nothing
	call MapSettings.setAlliedPlayer(whichPlayer)
endfunction

function SetMapSettingsPlayerGivesXP takes player whichPlayer, boolean flag returns nothing
	call MapSettings.setPlayerGivesXP(whichPlayer, flag)
endfunction

function SetMapSettingsGoldmine takes unit goldmine returns nothing
	call MapSettings.setGoldmine(goldmine)
endfunction

function SetMapSettingsMusic takes string musicList returns nothing
	call MapSettings.setMapMusic(musicList)
endfunction

function SetMapSettingsStartLevel takes integer startLevel returns nothing
	call MapSettings.setStartLevel(startLevel)
endfunction

function AddMapSettingsZoneRestorePosition takes string zone, player whichPlayer, real x, real y, real facing returns nothing
	call MapSettings.addZoneRestorePosition(zone, whichPlayer, x, y, facing)
endfunction

function AddMapSettingsZoneRestorePositionForAllPlayers takes string zone, real x, real y, real facing returns nothing
	call MapSettings.addZoneRestorePositionForAllPlayers(zone, x, y, facing)
endfunction

function ChangeMap takes string mapName returns nothing
	 call MapChanger.changeMap(mapName)
endfunction

function SetZoneEnabled takes Zone zone, boolean flag returns nothing
	if (flag) then
		call zone.enable()
	else
		call zone.disable()
	endif
endfunction

function GetLastCreatedInfo takes nothing returns AInfo
	return lastCreatedInfo
endfunction

function AddInfo takes Talk talk, boolean permanent, boolean important, string text returns AInfo
	set lastCreatedInfo = talk.addInfo(permanent, important, 0, 0, text)
	return lastCreatedInfo
endfunction

function SetInfoCondition takes AInfo info, AInfoCondition infoCondition returns nothing
	call info.setCondition(infoCondition)
endfunction

function SetInfoAction takes AInfo info, AInfoAction infoAction returns nothing
	call info.setAction(infoAction)
endfunction

// Quest Area API

function CreateQuestArea takes rect whichRect, boolean withFogModifier returns QuestArea
	return QuestArea.create(whichRect, withFogModifier)
endfunction

function QuestAreaEnterConditionEvaluate takes AInfo info, Character character returns boolean
	local trigger whichTrigger = QuestAreaHashTable.trigger(info, 0)
	// TODO set entering unit?
	return TriggerEvaluate(whichTrigger)
endfunction

function QuestAreaEnterActionExecute takes AInfo info, Character character returns nothing
	local trigger whichTrigger = QuestAreaHashTable.trigger(info, 0)
	// TODO set entering unit?
	call TriggerExecute(whichTrigger)
endfunction

function SetQuestAreaConditionAndActionByTrigger takes QuestArea questArea, trigger whichTrigger returns nothing
	call QuestAreaHashTable.setTrigger(questArea, 0, whichTrigger)
	call questArea.setEnterCondition(QuestAreaEnterConditionEvaluate)
	call questArea.setEnterAction(QuestAreaEnterActionExecute)
endfunction

// Quest API

function SetCharacterQuestState takes AQuest whichQuest, integer state returns nothing
	call whichQuest.setState(state)
endfunction

function QuestStateEvent takes AQuest whichQuest, integer state, trigger eventTrigger returns nothing
	local trigger whichTrigger = QuestHashTable.trigger(whichQuest, state)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_QUEST, whichQuest)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_STATE, state)
	// TODO how to transfer the events of which Trigger to the actual state trigger
endfunction

function QuestStateConditionEvaluate takes AQuest whichQuest, integer state returns boolean
	local trigger whichTrigger = QuestHashTable.trigger(whichQuest, state)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_QUEST, whichQuest)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_STATE, state)
	return TriggerEvaluate(whichTrigger)
endfunction

function QuestStateActionExecute takes AQuest whichQuest, integer state returns nothing
	local trigger whichTrigger = QuestHashTable.trigger(whichQuest, state)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_QUEST, whichQuest)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_STATE, state)
	call TriggerExecute(whichTrigger)
endfunction

function SetCharacterQuestStateTrigger takes AQuest whichQuest, integer state, trigger whichTrigger returns nothing
	call QuestHashTable.setTrigger(whichQuest, state, whichTrigger)
	call whichQuest.setStateEvent(state, QuestStateEvent)
	call whichQuest.setStateCondition(state, QuestStateConditionEvaluate)
	call whichQuest.setStateAction(state, QuestStateActionExecute)
endfunction

function SetCharacterQuestDescription takes AQuest whichQuest, string description returns nothing
	call whichQuest.setDescription(description)
endfunction

function SetCharacterQuestIconPath takes AQuest whichQuest, string iconPath returns nothing
	call whichQuest.setIconPath(iconPath)
endfunction

function SetCharacterQuestReward takes AQuest whichQuest, integer rewardType, integer value returns nothing
	call whichQuest.setReward(rewardType, value)
endfunction

function DisplayCharacterQuestState takes AQuest whichQuest returns nothing
	call whichQuest.displayState()
endfunction

function DisplayCharacterQuestUpdate takes AQuest whichQuest returns nothing
	call whichQuest.displayUpdate()
endfunction

function DisplayCharacterQuestUpdateMessage takes AQuest whichQuest, string message returns nothing
	call whichQuest.displayUpdateMessage(message)
endfunction

function SetQuestItemState takes AQuestItem whichQuestItem, integer state returns nothing
	call whichQuestItem.setState(state)
endfunction

function SetQuestItemReward takes AQuestItem whichQuestItem, integer rewardType, integer value returns nothing
	call whichQuestItem.setReward(rewardType, value)
endfunction

function EnableQuestUntil takes AQuest whichQuest, integer questItemIndex returns nothing
	call whichQuest.enableUntil(questItemIndex)
endfunction

function GetLastCreatedCharacterQuest takes nothing returns AQuest
	return lastCreatedCharacterQuest
endfunction

function CreateCharacterQuest takes Character character, string title returns AQuest
	set lastCreatedCharacterQuest = AQuest.create(character, title)
	return lastCreatedCharacterQuest
endfunction

function GetLastCreatedCharacterQuestItem takes nothing returns AQuestItem
	return lastCreatedCharacterQuestItem
endfunction

function CreateCharacterQuestItem takes AQuest whichQuest, string title returns AQuestItem
	set lastCreatedCharacterQuestItem = AQuestItem.create(whichQuest, title)
	return lastCreatedCharacterQuestItem
endfunction

function GetCharacterQuestState takes AQuest whichQuest returns integer
	return whichQuest.state()
endfunction

function GetQuestItemState takes AQuestItem questItem returns integer
	return questItem.state()
endfunction

// Fellow API

function SetFellowRevivalTitle takes Fellow fellow, string revivalTitle returns nothing
	call fellow.setRevivalTitle(revivalTitle)
endfunction

function SetFellowTalk takes Fellow fellow, boolean active returns nothing
	call fellow.setTalk(active)
endfunction

// Character API

function GetTriggerCharacter takes nothing returns Character
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_CHARACTER)
endfunction

function GetTriggerClass takes nothing returns AClass
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_CLASS)
endfunction

function PlayerCharacter takes player whichPlayer returns Character
	return Character(Character.playerCharacter(whichPlayer))
endfunction

function CharacterPlayer takes Character character returns player
	return character.player()
endfunction

function CharacterUnit takes Character character returns unit
	return character.unit()
endfunction

function CharacterClass takes Character character returns AClass
	return character.class()
endfunction

function CharacterInventory takes Character character returns AUnitInventory
	return character.inventory()
endfunction

function CharacterSetAllMovable takes boolean movable returns nothing
	call Character.setAllMovable(movable)
endfunction

function CharacterGiveItem takes Character character, integer itemTypeId returns nothing
	call character.giveItem(itemTypeId)
endfunction

// Inventory API

function InventoryEquipmentItemType takes AUnitInventory inventory, integer equipmentType returns integer
	local AUnitInventoryItemData itemData = inventory.equipmentItemData(equipmentType)
	if (itemData != 0) then
		return itemData.itemTypeId()
	endif
	return 0
endfunction

function InventoryRucksackItemType takes AUnitInventory inventory, integer index returns integer
	local AUnitInventoryItemData itemData = inventory.backpackItemData(index)
	if (itemData != 0) then
		return itemData.itemTypeId()
	endif
	return 0
endfunction

function InventoryRucksackItemCharges takes AUnitInventory inventory, integer index returns integer
	local AUnitInventoryItemData itemData = inventory.backpackItemData(index)
	if (itemData != 0) then
		return itemData.charges()
	endif
	return 0
endfunction

function InventoryHasItemType takes AUnitInventory inventory, integer itemCode returns boolean
	return inventory.hasItemType(itemCode)
endfunction

function InventoryTotalItemTypeCharges takes AUnitInventory inventory, integer itemCode returns integer
	return inventory.totalItemTypeCharges(itemCode)
endfunction

function PlayerBuilding takes integer playerIndex returns unit
	return Buildings.playerBuilding(playerIndex - 1)
endfunction

function MapZoneName takes nothing returns string
	return MapSettings.mapName()
endfunction

function ItemTypeByItem takes item whichItem returns ItemType
	return ItemType.itemTypeOfItem(whichItem)
endfunction

function ItemTypeRequiresTwoSlots takes integer itemTypeId returns boolean
	return ItemType.itemTypeIdRequiresTwoSlots(itemTypeId)
endfunction

// Talk API

function GetLastCreatedTalk takes nothing returns Talk
	return lastCreatedTalk
endfunction

function CreateTalk takes unit whichUnit returns Talk
	set lastCreatedTalk = Talk.create(whichUnit, 0) // Set the talk action by trigger AFTER creation!
	return lastCreatedTalk
endfunction

function SetTalkStartAction takes Talk talk, ATalkStartAction startAction returns nothing
	call talk.setStartAction(startAction)
endfunction

function Speech takes AInfo info, Character character, boolean toCharacter, string text, sound whichSound returns nothing
	call speech(info, character, toCharacter, text, whichSound)
endfunction

function GetTriggerInfo takes nothing returns AInfo
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_INFO)
endfunction

function GetTriggerTalk takes nothing returns Talk
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_TALK)
endfunction

function GetInfoTalk takes AInfo info returns Talk
	return info.talk()
endfunction

function GetInfoIndex takes AInfo info returns integer
	return info.index()
endfunction

function InfoHasBeenShownToCharacter takes Talk talk, integer index, Character character returns boolean
	return talk.infoHasBeenShownToCharacter(index, character)
endfunction

function InfoConditionEvaluate takes AInfo info, Character character returns boolean
	local trigger whichTrigger = TalkInfoConditionHashTable.trigger(info, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_INFO, info)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_CHARACTER, character)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_TALK, info.talk())
	return TriggerEvaluate(whichTrigger)
endfunction

function InfoConditionByTrigger takes trigger whichTrigger, AInfo info returns AInfoCondition
	call TalkInfoConditionHashTable.setTrigger(info, 0, whichTrigger)
	return InfoConditionEvaluate
endfunction

function InfoActionExecute takes AInfo info, Character character returns nothing
	local trigger whichTrigger = TalkInfoActionHashTable.trigger(info, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_INFO, info)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_CHARACTER, character)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_TALK, info.talk())
	call TriggerExecute(whichTrigger)
endfunction

function InfoActionByTrigger takes trigger whichTrigger, AInfo info returns AInfoAction
	call TalkInfoActionHashTable.setTrigger(info, 0, whichTrigger)
	return InfoActionExecute
endfunction

function SetInfoConditionAndActionByTrigger takes AInfo info, trigger whichTrigger returns nothing
	call info.setCondition(InfoConditionByTrigger(whichTrigger, info))
	call info.setAction(InfoActionByTrigger(whichTrigger, info))
endfunction

function ShowTalkStartPage takes Talk talk, Character character returns nothing
	call talk.showStartPage(character)
endfunction

function ShowTalkRange takes Talk talk, integer index0, integer index1, Character character returns nothing
	call talk.showRange(index0, index1, character)
endfunction

function ShowTalkUntil takes Talk talk, integer index, Character character returns nothing
	call talk.showUntil(index, character)
endfunction

function CloseTalk takes Talk talk, Character character returns nothing
	call talk.close(character)
endfunction

function AddExitButton takes Talk talk returns AInfo
	set lastCreatedInfo = talk.addExitButton()
	return lastCreatedInfo
endfunction

function TalkStartActionExecute takes Talk talk, Character character returns nothing
	local trigger whichTrigger = TalkStartActionsHashTable.trigger(talk, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_CHARACTER, character)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_TALK, talk)

	call TriggerExecute(whichTrigger)
endfunction

function TalkStartActionByTrigger takes trigger whichTrigger, Talk talk returns ATalkStartAction
	call TalkStartActionsHashTable.setTrigger(talk, 0, whichTrigger)
	return TalkStartActionExecute
endfunction

// Fellow API

function GetLastCreatedFellow takes nothing returns Fellow
	return lastCreatedFellow
endfunction

function CreateFellow takes unit whichUnit, Talk talk returns Fellow
	set lastCreatedFellow = Fellow.create(whichUnit, talk)
	return lastCreatedFellow
endfunction

function CreateShrine takes unit shrineUnit, destructable whichDestructable, rect discoverRect, rect revivalRect, real revivalFacing returns Shrine
	return Shrine.create(shrineUnit, whichDestructable, discoverRect, revivalRect, revivalFacing)
endfunction

function GetLastCreatedSpawnPoint takes nothing returns SpawnPoint
	return lastCreatedSpawnPoint
endfunction

function GetLastAddedSpawnPointMemberIndex takes nothing returns integer
	return lastAddedSpawnPointMemberIndex
endfunction

function GetLastAddedSpawnPointMemberItemTypeIndexHint takes nothing returns integer
	return lastAddedSpawnPointMemberItemTypeIndex
endfunction

function GetLastCreatedItemSpawnPoint takes nothing returns ItemSpawnPoint
	return lastCreatedItemSpawnPoint
endfunction

function CreateSpawnPoint takes nothing returns SpawnPoint
	set lastCreatedSpawnPoint = SpawnPoint.create()
	return lastCreatedSpawnPoint
endfunction

// Fellow API

function ShareFellowWithAll takes Fellow fellow returns nothing
	call fellow.shareWithAll()
endfunction

function ShareFellowWithCharacter takes Fellow fellow, Character character returns nothing
	call fellow.shareWith(character)
endfunction

function ResetFellow takes Fellow fellow returns nothing
	call fellow.reset()
endfunction

function SetFellowRevival takes Fellow fellow, boolean enabled returns nothing
	call fellow.setRevival(enabled)
endfunction

function SetFellowDescription takes Fellow fellow, string description returns nothing
	call fellow.setDescription(description)
endfunction

function FellowAddAbility takes Fellow fellow, integer abilityId returns nothing
	call fellow.addAbility(abilityId)
endfunction

function SpawnPointAddUnitWithType takes SpawnPoint spawnPoint, unit whichUnit, real chance returns integer
	set lastAddedSpawnPointMemberIndex = spawnPoint.addUnitWithType(whichUnit, chance)
	return lastAddedSpawnPointMemberIndex
endfunction

function SpawnPointAddNewItemType takes SpawnPoint spawnPoint, integer unitIndex, integer itemCode, real chance returns integer
	set lastAddedSpawnPointMemberItemTypeIndex = spawnPoint.addNewItemType(unitIndex, itemCode, chance)
	return lastAddedSpawnPointMemberItemTypeIndex
endfunction

function CreateItemSpawnPointAtItemPos takes item whichItem returns ItemSpawnPoint
	set lastCreatedItemSpawnPoint = ItemSpawnPoint.create(GetItemX(whichItem), GetItemY(whichItem), whichItem)
	return lastCreatedItemSpawnPoint
endfunction

function CreateItemSpawnPoint takes real x, real y, item whichItem returns ItemSpawnPoint
	set lastCreatedItemSpawnPoint = ItemSpawnPoint.create(x, y, whichItem)
	return lastCreatedItemSpawnPoint
endfunction

function CreateDungeon takes string name, rect cameraBounds, rect viewRect returns Dungeon
	return Dungeon.create(name, cameraBounds, viewRect)
endfunction

// Routine API

function GetLastCreatedRoutineWithFacing takes nothing returns NpcRoutineWithFacing
	return lastCreatedRoutineWithFacing
endfunction

function CreateRoutineWithFacing takes ARoutine routine, unit npc, real startTimeOfDay, real endTimeOfDay, rect targetRect returns NpcRoutineWithFacing
	set lastCreatedRoutineWithFacing = NpcRoutineWithFacing.create(routine, npc, startTimeOfDay, endTimeOfDay, targetRect)
	return lastCreatedRoutineWithFacing
endfunction

function RoutineSetFacing takes NpcRoutineWithFacing routine, real facing returns nothing
	call routine.setFacing(facing)
endfunction

function GetLastCreatedRoutineTalks takes nothing returns NpcTalksRoutine
	return lastCreatedRoutineTalks
endfunction

function CreateRoutineTalks takes ARoutine routine, unit npc, real startTimeOfDay, real endTimeOfDay, rect targetRect returns NpcTalksRoutine
	set lastCreatedRoutineTalks = NpcTalksRoutine.create(routine, npc, startTimeOfDay, endTimeOfDay, targetRect)
	return lastCreatedRoutineTalks
endfunction

function RoutineTalksToRoutineWithFacing takes NpcTalksRoutine routine returns NpcRoutineWithFacing
	return routine
endfunction

function RoutineSetPartner takes NpcTalksRoutine routine, unit partner returns nothing
	call routine.setPartner(partner)
endfunction

function RoutineAddSound takes NpcTalksRoutine routine, string text, sound whichSound returns nothing
	call routine.addSound(text, whichSound)
endfunction

function RoutineAddSoundAnswer takes NpcTalksRoutine routine, string text, sound whichSound returns nothing
	call routine.addSoundAnswer(text, whichSound)
endfunction

function RoutineManualStart takes unit whichUnit returns nothing
	call AUnitRoutine.manualStart(whichUnit)
endfunction

function RoutineManualStartAll takes nothing returns nothing
	call AUnitRoutine.manualStartAll()
endfunction

function ShrineEnableForAll takes Shrine shrine, boolean showEffect returns nothing
	call ACharacter.enableShrineForAll(shrine, showEffect)
endfunction

// Video API

function GetTriggerVideo takes nothing returns Character
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_VIDEO)
endfunction

function CreateVideo takes boolean hasCharacterActor returns AVideo
	set lastCreatedVideo = AVideo.create(hasCharacterActor)
	return lastCreatedVideo
endfunction

function GetLastCreatedVideo takes nothing returns AVideo
	return lastCreatedVideo
endfunction

function VideoInitActionEvaluate takes AVideo video returns nothing
	local trigger whichTrigger = VideoInitActionHashTable.trigger(video, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_VIDEO, video)
	call TriggerEvaluate(whichTrigger)
endfunction

function VideoSetInitActionByTrigger takes AVideo video, trigger whichTrigger returns nothing
	call VideoInitActionHashTable.setTrigger(video, 0, whichTrigger)
	call video.setInitAction(VideoInitActionEvaluate)
endfunction

function VideoPlayActionExecute takes AVideo video returns nothing
	local trigger whichTrigger = VideoPlayActionHashTable.trigger(video, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_VIDEO, video)
	call TriggerExecute(whichTrigger)
endfunction

function VideoSetPlayActionByTrigger takes AVideo video, trigger whichTrigger returns nothing
	call VideoPlayActionHashTable.setTrigger(video, 0, whichTrigger)
	call video.setPlayAction(VideoPlayActionExecute)
endfunction

function VideoStopActionEvaluate takes AVideo video returns nothing
	local trigger whichTrigger = VideoStopActionHashTable.trigger(video, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_VIDEO, video)
	call TriggerEvaluate(whichTrigger)
endfunction

function VideoSetStopActionByTrigger takes AVideo video, trigger whichTrigger returns nothing
	call VideoStopActionHashTable.setTrigger(video, 0, whichTrigger)
	call video.setStopAction(VideoStopActionEvaluate)
endfunction

function VideoSkipActionEvaluate takes AVideo video returns nothing
	local trigger whichTrigger = VideoSkipActionHashTable.trigger(video, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, TRIGGERDATA_KEY_VIDEO, video)
	call TriggerEvaluate(whichTrigger)
endfunction

function VideoSetSkipActionByTrigger takes AVideo video, trigger whichTrigger returns nothing
	call VideoSkipActionHashTable.setTrigger(video, 0, whichTrigger)
	call video.setSkipAction(VideoSkipActionEvaluate)
endfunction

function VideoInitVideoSettings takes AVideo video returns nothing
	call Game.initVideoSettings(video)
endfunction

function VideoResetVideoSettings takes nothing returns nothing
	call Game.resetVideoSettings()
endfunction

function VideoWait takes real seconds returns boolean
	return wait(seconds)
endfunction

function GetLastSavedUnitActor takes nothing returns integer
	return lastSavedUnitActor
endfunction

function VideoSaveUnitActor takes AVideo video, unit whichUnit returns integer
	set lastSavedUnitActor = video.saveUnitActor(whichUnit)
	return lastSavedUnitActor
endfunction

function VideoUnitActor takes AVideo video, integer index returns unit
	return video.unitActor(index)
endfunction

function VideoCharacterActor takes AVideo video returns unit
	return video.actor()
endfunction

function VideoPlay takes AVideo video returns nothing
	call video.play()
endfunction

function VideoStop takes AVideo video returns nothing
	call video.stop()
endfunction

function VideoFadeOutWithWait takes nothing returns nothing
	call Game.fadeOutWithWait()
endfunction

function VideoFadeInWithWait takes nothing returns nothing
	call Game.fadeInWithWait()
endfunction

// Shop API

function CreateShop takes unit npc, unit shop returns Shop
	return Shop.create(npc, shop)
endfunction

struct MapData
	//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

	private static method create takes nothing returns thistype
		return 0
	endmethod

	private method onDestroy takes nothing returns nothing
	endmethod

	/// Required by \ref Game and called via. evaluate().
	public static method initSettings takes nothing returns nothing
		local integer i = 0
		/**
		 * Called before library initialization but must be called before Game.onInit and before InitCustomTriggers because of the trigger register calls.
		 *
		 * InitCustomTriggers() is called in main AFTER the struct and the library initializers, so this should work.
		 *
		 * Is called as first method in Game.onInit(), too.
		 */
		call Init()
		loop
			exitwhen (i == mapInitSettingsTriggers.size())
			debug call Print("Init Settings trigger " + I2S(GetHandleId(mapInitSettingsTriggers[i])))
			call ConditionalTriggerExecute(mapInitSettingsTriggers[i]) // trigger actions should be evaluated only
			set i = i + 1
		endloop
		// TODO wait for the execution of the triggers!
	endmethod

	/// Required by \ref Game.
	public static method init takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapInitTriggers.size())
			call ConditionalTriggerExecute(mapInitTriggers[i])
			set i = i + 1
		endloop
		// TODO wait for the execution of the triggers!
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 */
	public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapCreateClassSelectionItemsTriggers.size())
			call ConditionalTriggerExecute(mapCreateClassSelectionItemsTriggers[i])
			set i = i + 1
		endloop
		// TODO wait for the execution of the triggers!
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 * This is not done on repicks or when restoring a character instead.
	 */
	public static method onCreateClassItems takes Character character returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapCreateClassItemsTriggers.size())
			call ConditionalTriggerExecute(mapCreateClassItemsTriggers[i])
			set i = i + 1
		endloop
		// TODO wait for the execution of the triggers!
	endmethod

	/// Required by \ref Game.
	public static method onInitMapSpells takes ACharacter character returns nothing
	endmethod

	/// Required by \ref Game.
	public static method onStart takes nothing returns nothing
	endmethod

	private static method onEquipItem takes ACharacterInventory inventory, integer index, boolean firstTime returns nothing
		local integer i = 0
		loop
			exitwhen (i == characterOnEquipItemTriggers.size())
			call DmdfHashTable.global().setHandleInteger(characterOnEquipItemTriggers[i], TRIGGERDATA_KEY_CHARACTER, inventory.character())
			call DmdfHashTable.global().setHandleInteger(characterOnEquipItemTriggers[i], TRIGGERDATA_KEY_INVENTORY, inventory.unitInventory())
			call DmdfHashTable.global().setHandleInteger(characterOnEquipItemTriggers[i], TRIGGERDATA_KEY_ITEMINDEX, index)
			call DmdfHashTable.global().setHandleBoolean(characterOnEquipItemTriggers[i], TRIGGERDATA_KEY_ITEMFIRSTTIME, firstTime)
			call ConditionalTriggerExecute(characterOnEquipItemTriggers[i])
			set i = i + 1
		endloop
	endmethod

	private static method onAddItemToRucksack takes ACharacterInventory inventory, integer index, boolean firstTime returns nothing
		local integer i = 0
		loop
			exitwhen (i == characterOnAddRucksackItemTriggers.size())
			call DmdfHashTable.global().setHandleInteger(characterOnAddRucksackItemTriggers[i], TRIGGERDATA_KEY_CHARACTER, inventory.character())
			call DmdfHashTable.global().setHandleInteger(characterOnAddRucksackItemTriggers[i], TRIGGERDATA_KEY_INVENTORY, inventory.unitInventory())
			call DmdfHashTable.global().setHandleInteger(characterOnAddRucksackItemTriggers[i], TRIGGERDATA_KEY_ITEMINDEX, index)
			call DmdfHashTable.global().setHandleBoolean(characterOnAddRucksackItemTriggers[i], TRIGGERDATA_KEY_ITEMFIRSTTIME, firstTime)
			call ConditionalTriggerExecute(characterOnAddRucksackItemTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref ClassSelection.
	public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
		local integer i = 0
		// Do this on the character creation ONCE!
		call character.inventory().addOnEquipFunction(thistype.onEquipItem)
		call character.inventory().addOnAddToBackpackFunction(thistype.onAddItemToRucksack)
		loop
			exitwhen (i == mapSelectClassTriggers.size())
			call DmdfHashTable.global().setHandleInteger(mapSelectClassTriggers[i], TRIGGERDATA_KEY_CHARACTER, character)
			call DmdfHashTable.global().setHandleInteger(mapSelectClassTriggers[i], TRIGGERDATA_KEY_CLASS, class)
			call ConditionalTriggerExecute(mapSelectClassTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref ClassSelection.
	public static method onRepick takes Character character returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapRepickCharacterTriggers.size())
			call DmdfHashTable.global().setHandleInteger(mapRepickCharacterTriggers[i], TRIGGERDATA_KEY_CHARACTER, character)
			call ConditionalTriggerExecute(mapRepickCharacterTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref Game.
	public static method start takes nothing returns nothing
		local integer i = 0
		call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection
		call ACharacter.panCameraSmartToAll()
		call Game.applyHandicapToCreeps()
		loop
			exitwhen (i == mapStartTriggers.size())
			call ConditionalTriggerExecute(mapStartTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacter takes string zone, Character character returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapRestoreCharacterTriggers.size())
			call DmdfHashTable.global().setHandleStr(mapRestoreCharacterTriggers[i], TRIGGERDATA_KEY_ZONENAME, zone)
			call DmdfHashTable.global().setHandleInteger(mapRestoreCharacterTriggers[i], TRIGGERDATA_KEY_CHARACTER, character)
			call ConditionalTriggerExecute(mapRestoreCharacterTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacters takes string zone returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapRestoreCharactersTriggers.size())
			call DmdfHashTable.global().setHandleStr(mapRestoreCharactersTriggers[i], TRIGGERDATA_KEY_ZONENAME, zone)
			call ConditionalTriggerExecute(mapRestoreCharactersTriggers[i])
			set i = i + 1
		endloop
	endmethod

	public static method onInitVideoSettings takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapInitVideoSettingsTriggers.size())
			call ConditionalTriggerExecute(mapInitVideoSettingsTriggers[i])
			set i = i + 1
		endloop
	endmethod

	public static method onResetVideoSettings takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapResetVideoSettingsTriggers.size())
			call ConditionalTriggerExecute(mapResetVideoSettingsTriggers[i])
			set i = i + 1
		endloop
	endmethod
endstruct

endlibrary