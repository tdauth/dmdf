//! import "Deranors Swamp/Quests/Struct Quest Hell.j"

library MapQuests requires StructMapQuestsQuestHell

	function initMapPrimaryQuests takes nothing returns nothing
		call QuestHell.initQuest()
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
	endfunction

endlibrary