//! import "Dornheim/Quests/Struct Quest Mother.j"

library MapQuests requires StructMapQuestsQuestMother

	function initMapPrimaryQuests takes nothing returns nothing
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
		call QuestMother.initQuest()
	endfunction

endlibrary