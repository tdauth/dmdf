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
	constant boolean DMDF_INFO_LOG = true
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

// All functions for the trigger data of The Power of Fire. Wrappers have to be used since the vJass syntax is not allowed for TriggerData.

library TPoFTriggerData initializer Init requires Asl, Dmdf

function EnglishGermanString takes string english, string german returns string
	return tre(german, english)
endfunction

globals
	ATriggerVector mapInitTriggers
	ATriggerVector mapStartTriggers
endglobals

function TriggerRegisterMapInitEvent takes trigger whichTrigger returns nothing
	call mapInitTriggers.pushBack(whichTrigger)
endfunction

function TriggerRegisterMapStartEvent takes trigger whichTrigger returns nothing
	call mapStartTriggers.pushBack(whichTrigger)
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

function SetFellowRevivalTitle takes Fellow fellow, string revivalTitle returns nothing
	call fellow.setRevivalTitle(revivalTitle)
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

function Init takes nothing returns nothing
	set TalkInfoConditionHashTable = AGlobalHashTable.create()
	set TalkInfoActionHashTable = AGlobalHashTable.create()
	set TalkStartActionsHashTable = AGlobalHashTable.create()

	set mapInitTriggers = ATriggerVector.create()
	set mapStartTriggers = ATriggerVector.create()
endfunction

function GetTriggerInfo takes trigger whichTrigger returns AInfo
	return DmdfHashTable.global().handleInteger(whichTrigger, 0)
endfunction

function GetTriggerCharacter takes trigger whichTrigger returns Character
	return DmdfHashTable.global().handleInteger(whichTrigger, 1)
endfunction

function InfoConditionEvaluate takes AInfo info, Character character returns boolean
	local trigger whichTrigger = TalkInfoConditionHashTable.trigger(info, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 0, info)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 1, character)
	return TriggerEvaluate(whichTrigger)
endfunction

function InfoConditionByTrigger takes trigger whichTrigger, AInfo info returns AInfoCondition
	call TalkInfoConditionHashTable.setTrigger(info, 0, whichTrigger)
	return InfoConditionEvaluate
endfunction

function InfoActionExecute takes AInfo info, Character character returns nothing
	local trigger whichTrigger = TalkInfoActionHashTable.trigger(info, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 0, info)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 1, character)
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

function TalkStartActionExecute takes Talk talk, Character character returns nothing
	local trigger whichTrigger = TalkStartActionsHashTable.trigger(talk, 0)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 0, talk)
	call DmdfHashTable.global().setHandleInteger(whichTrigger, 1, character)

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

struct MapData extends MapDataInterface
	public static constant string mapName = "DH"
	public static constant string mapMusic = "Sound\\Music\\mp3Music\\Pippin the Hunchback.mp3;Sound\\Music\\mp3Music\\Minstrel Guild.mp3"
	public static constant integer maxPlayers = 6
	public static constant player alliedPlayer = Player(6)
	public static constant player neutralPassivePlayer = Player(7)
	public static constant real morning = 5.0
	public static constant real midday = 12.0
	public static constant real afternoon = 16.0
	public static constant real evening = 18.0
	public static constant real revivalTime = 35.0
	public static constant real revivalLifePercentage = 100.0
	public static constant real revivalManaPercentage = 100.0
	public static constant integer startLevel = 1
	public static constant integer startSkillPoints = 1 /// Includes the skill point for the default spell.
	public static constant integer levelSpellPoints = 2
	public static constant integer maxLevel = 10000
	public static constant integer workerUnitTypeId = 'h00E'
	public static constant boolean isSeparateChapter = true
	public static sound cowSound = null

	//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

	private static method create takes nothing returns thistype
		return 0
	endmethod

	private method onDestroy takes nothing returns nothing
	endmethod

	/// Required by \ref Game.
	// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
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
		call SuspendTimeOfDay(false)
		call SetTimeOfDay(12.0)
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
		loop
			exitwhen (i == mapStartTriggers.size())
			call TriggerExecute(mapStartTriggers[i])
			set i = i + 1
		endloop
	endmethod

	/// Required by \ref Classes.
	public static method startX takes integer index returns real
		return GetRectCenterX(gg_rct_start)
	endmethod

	/// Required by \ref Classes.
	public static method startY takes integer index returns real
		return GetRectCenterY(gg_rct_start)
	endmethod

	/// Required by \ref Classes.
	public static method startFacing takes integer index returns real
		return 90.0
	endmethod

	/// Required by \ref MapChanger.
	public static method restoreStartX takes integer index, string zone returns real
		return GetRectCenterX(gg_rct_start)
	endmethod

	/// Required by \ref MapChanger.
	public static method restoreStartY takes integer index, string zone returns real
		return GetRectCenterY(gg_rct_start)
	endmethod

	/// Required by \ref MapChanger.
	public static method restoreStartFacing takes integer index, string zone returns real
		return 180.0
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacters takes string zone returns nothing
	endmethod

	/**
	 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
	 */
	public static method playerGivesXP takes player whichPlayer returns boolean
		return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE)
	endmethod

	public static method initVideoSettings takes nothing returns nothing
	endmethod

	public static method resetVideoSettings takes nothing returns nothing
	endmethod

	/// Required by \ref Buildings.
	public static method goldmine takes nothing returns unit
		return null
	endmethod

	/// Required by teleport spells.
	public static method excludeUnitTypeFromTeleport takes integer unitTypeId returns boolean
		return false
	endmethod
endstruct

endlibrary