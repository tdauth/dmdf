/**
 * Predefinition simplifies usage.
 */
globals
	constant boolean A_SYSTEMS = true
	constant boolean A_DEBUG_HANDLES = false
	constant boolean A_DEBUG_NATIVES = false
	constant real A_MAX_COLLISION_SIZE = 300
	constant integer A_MAX_COLLISION_SIZE_ITERATIONS = 10
	constant integer A_SPELL_RESISTANCE_CREEP_LEVEL = 6
	constant boolean DMDF_INFO_LOG = false
	constant boolean DMDF_NPC_ROUTINES = true
	constant boolean DMDF_VIOLENCE = true
	constant boolean DMDF_CREDITS = true

	// used by function GetTimeString()
	constant string A_TEXT_TIME_VALUE = "0%1%" // GetLocalizedString(
	constant string A_TEXT_TIME_PAIR = "%1%:%2%" // GetLocalizedString(
	// used by ADialog
	constant string A_TEXT_DIALOG_BUTTON = "[%1%] %2%" // GetLocalizedString(
endglobals

//! import "Import Asl.j"
//! import "Import Dmdf.j"
//! import "Systems/Debug/Text en.j"

// All functions for the trigger data of The Power of Fire. Wrappers have to be used since the vJass syntax is not allowed for TriggerData.

library TPoFTriggerData requires Asl, Dmdf

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
	ATriggerVector mapStartTriggers = 0
	ATriggerVector mapRestoreCharactersTriggers = 0
	ATriggerVector mapInitVideoSettingsTriggers = 0
	ATriggerVector mapResetVideoSettingsTriggers = 0

	constant integer TRIGGERDATA_KEY_INFO = 0
	constant integer TRIGGERDATA_KEY_CHARACTER = 1
	constant integer TRIGGERDATA_KEY_TALK = 2
	constant integer TRIGGERDATA_KEY_ZONENAME = 3
endglobals

function TriggerRegisterMapInitSettingsEvent takes trigger whichTrigger returns nothing
	call mapInitSettingsTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapInitEvent takes trigger whichTrigger returns nothing
	call mapInitTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapStartEvent takes trigger whichTrigger returns nothing
	call mapStartTriggers.pushBack(whichTrigger)
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

function GetTriggerZoneName takes nothing returns string
	return DmdfHashTable.global().handleStr(GetTriggeringTrigger(), TRIGGERDATA_KEY_ZONENAME)
endfunction

function CreateZone takes string mapName, rect enterRect returns Zone
	return Zone.create(mapName, enterRect)
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

function AddInfo takes Talk talk, boolean permanent, boolean important, string text returns AInfo
	return talk.addInfo(permanent, important, 0, 0, text)
endfunction

function SetInfoCondition takes AInfo info, AInfoCondition infoCondition returns nothing
	call info.setCondition(infoCondition)
endfunction

function SetInfoAction takes AInfo info, AInfoAction infoAction returns nothing
	call info.setAction(infoAction)
endfunction

function CreateQuestArea takes rect whichRect, boolean withFogModifier returns QuestArea
	return QuestArea.create(whichRect, withFogModifier)
endfunction

function SetCharacterQuestReward takes AQuest whichQuest, integer rewardType, integer value returns nothing
	call whichQuest.setReward(rewardType, value)
endfunction

function SetQuestItemReward takes AQuestItem whichQuestItem, integer rewardType, integer value returns nothing
	call whichQuestItem.setReward(rewardType, value)
endfunction

function CreateCharacterQuest takes Character character, string title returns AQuest
	return AQuest.create(character, title)
endfunction

function CreateCharacterQuestItem takes AQuest whichQuest, string title returns AQuestItem
	return AQuestItem.create(whichQuest, title)
endfunction

function SetFellowRevivalTitle takes Fellow fellow, string revivalTitle returns nothing
	call fellow.setRevivalTitle(revivalTitle)
endfunction

function SetFellowTalk takes Fellow fellow, boolean active returns nothing
	call fellow.setTalk(active)
endfunction

function PlayerCharacter takes player whichPlayer returns Character
	return Character(Character.playerCharacter(whichPlayer))
endfunction

function CharacterClass takes Character character returns AClass
	return character.class()
endfunction

function CharacterInventory takes Character character returns AInventory
	return character.inventory()
endfunction

function InventoryHasItemType takes AInventory inventory, integer itemCode returns boolean
	return inventory.hasItemType(itemCode)
endfunction

function InventoryTotalItemTypeCharges takes AInventory inventory, integer itemCode returns integer
	return inventory.totalItemTypeCharges(itemCode)
endfunction

function MapZoneName takes nothing returns string
	return MapSettings.mapName()
endfunction

function ItemTypeByItem takes item whichItem returns ItemType
	return ItemType.itemTypeOfItem(whichItem)
endfunction

function CreateTalk takes unit whichUnit returns Talk
	return Talk.create(whichUnit, 0) // Set the talk action by trigger AFTER creation!
endfunction

function SetTalkStartAction takes Talk talk, ATalkStartAction startAction returns nothing
	call talk.setStartAction(startAction)
endfunction

function Speech takes AInfo info, Character character, boolean toCharacter, string text, sound whichSound returns nothing
	call speech(info, character, toCharacter, text, whichSound)
endfunction

globals
	AGlobalHashTable TalkInfoConditionHashTable = 0
	AGlobalHashTable TalkInfoActionHashTable = 0
	AGlobalHashTable TalkStartActionsHashTable = 0
endglobals


/**
 * This function has to be called before any other calls using these variables!
 */
function Init takes nothing returns nothing
	set TalkInfoConditionHashTable = AGlobalHashTable.create()
	set TalkInfoActionHashTable = AGlobalHashTable.create()
	set TalkStartActionsHashTable = AGlobalHashTable.create()

	set mapInitSettingsTriggers = ATriggerVector.create()
	set mapInitTriggers = ATriggerVector.create()
	set mapStartTriggers = ATriggerVector.create()
	set mapRestoreCharactersTriggers = ATriggerVector.create()
	set mapInitVideoSettingsTriggers = ATriggerVector.create()
	set mapResetVideoSettingsTriggers = ATriggerVector.create()
endfunction

function GetTriggerInfo takes nothing returns AInfo
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_INFO)
endfunction

function GetTriggerTalk takes nothing returns Talk
	return DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), TRIGGERDATA_KEY_TALK)
endfunction

function GetTriggerCharacter takes trigger whichTrigger returns Character
	return DmdfHashTable.global().handleInteger(whichTrigger, TRIGGERDATA_KEY_CHARACTER)
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
	return talk.addExitButton()
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

function CreateFellow takes unit whichUnit, Talk talk returns Fellow
	return Fellow.create(whichUnit, talk)
endfunction

function CreateShrine takes unit shrineUnit, destructable whichDestructable, rect discoverRect, rect revivalRect, real revivalFacing returns Shrine
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

function CreateItemSpawnPoint takes real x, real y, item whichItem returns ItemSpawnPoint
	return ItemSpawnPoint.create(x, y, whichItem)
endfunction

function CreateDungeon takes string name, rect cameraBounds, rect viewRect returns Dungeon
	return Dungeon.create(name, cameraBounds, viewRect)
endfunction

function CreateRoutineWithFacing takes ARoutine routine, unit npc, real startTimeOfDay, real endTimeOfDay, rect targetRect returns NpcRoutineWithFacing
	return NpcRoutineWithFacing.create(routine, npc, startTimeOfDay, endTimeOfDay, targetRect)
endfunction

function RoutineSetFacing takes NpcRoutineWithFacing routine, real facing returns nothing
	call routine.setFacing(facing)
endfunction

function CreateRoutineTalks takes ARoutine routine, unit npc, real startTimeOfDay, real endTimeOfDay, rect targetRect returns NpcTalksRoutine
	return NpcTalksRoutine.create(routine, npc, startTimeOfDay, endTimeOfDay, targetRect)
endfunction

function RoutineTalksToRoutineWithFacing takes NpcTalksRoutine routine returns NpcRoutineWithFacing
	return routine
endfunction

function RoutineSetPartner takes NpcTalksRoutine routine, unit partner returns nothing
	call routine.setPartner(partner)
endfunction

function ShrineEnableForAll takes Shrine shrine, boolean showEffect returns nothing
	call ACharacter.enableShrineForAll(shrine, showEffect)
endfunction

struct MapData
	//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

	private static method create takes nothing returns thistype
		return 0
	endmethod

	private method onDestroy takes nothing returns nothing
	endmethod

	/// Required by \ref Game.
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
			call TriggerEvaluate(mapInitSettingsTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref Game.
	public static method init takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapInitTriggers.size())
			call TriggerEvaluate(mapInitTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 */
	public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 */
	public static method createClassItems takes Character character returns nothing
	endmethod

	/// Required by \ref Game.
	public static method initMapSpells takes ACharacter character returns nothing
	endmethod

	/// Required by \ref Game.
	public static method onStart takes nothing returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onRepick takes Character character returns nothing
	endmethod

	/// Required by \ref Game.
	public static method start takes nothing returns nothing
		local integer i = 0
		call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection
		call ACharacter.panCameraSmartToAll()
		call Game.applyHandicapToCreeps()
		loop
			exitwhen (i == mapStartTriggers.size())
			call TriggerExecute(mapStartTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacter takes string zone, Character character returns nothing
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacters takes string zone returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapRestoreCharactersTriggers.size())
			call DmdfHashTable.global().setHandleStr(mapRestoreCharactersTriggers[i], TRIGGERDATA_KEY_ZONENAME, zone)
			call TriggerEvaluate(mapRestoreCharactersTriggers[i])
			set i = i + 1
		endloop
	endmethod

	public static method initVideoSettings takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapInitVideoSettingsTriggers.size())
			call TriggerEvaluate(mapInitVideoSettingsTriggers[i])
			set i = i + 1
		endloop
	endmethod

	public static method resetVideoSettings takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen (i == mapResetVideoSettingsTriggers.size())
			call TriggerEvaluate(mapResetVideoSettingsTriggers[i])
			set i = i + 1
		endloop
	endmethod
endstruct

endlibrary