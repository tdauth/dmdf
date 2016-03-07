//! import "Gardonar/Quests/Struct Quest Palace.j"

library MapQuests requires StructMapQuestsQuestPalace

	function initMapPrimaryQuests takes nothing returns nothing
		call QuestPalace.initQuest()
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
	endfunction

endlibrary