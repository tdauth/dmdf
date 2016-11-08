//! import "Dornheim/Quests/Struct Quest Mother.j"
//! import "Dornheim/Quests/Struct Quest Ralphs Garden.j"
//! import "Dornheim/Quests/Struct Quest Shit On The Throne.j"

library MapQuests requires StructMapQuestsQuestMother, StructMapQuestsQuestRalphsGarden, StructMapQuestsQuestShitOnTheThrone

	function initMapPrimaryQuests takes nothing returns nothing
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
		call QuestMother.initQuest()
		call QuestRalphsGarden.initQuest()
		call QuestShitOnTheThrone.initQuest()
	endfunction

endlibrary