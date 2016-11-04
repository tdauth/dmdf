//! import "Dornheim/Quests/Struct Quest Mother.j"
//! import "Dornheim/Quests/Struct Quest Ralphs Garden.j"

library MapQuests requires StructMapQuestsQuestMother, StructMapQuestsQuestRalphsGarden

	function initMapPrimaryQuests takes nothing returns nothing
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
		call QuestMother.initQuest()
		call QuestRalphsGarden.initQuest()
	endfunction

endlibrary