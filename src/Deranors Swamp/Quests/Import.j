//! import "Deranors Swamp/Quests/Struct Quest Gate.j"

library MapQuests requires StructMapQuestsQuestGate

	function initMapPrimaryQuests takes nothing returns nothing
		call QuestGate.initQuest()
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
	endfunction

endlibrary