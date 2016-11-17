//! import "Dornheim/Quests/Struct Quest Mother.j"
//! import "Dornheim/Quests/Struct Quest Ralphs Garden.j"
//! import "Dornheim/Quests/Struct Quest Shit On The Throne.j"
//! import "Dornheim/Quests/Struct Quest The Children.j"

library MapQuests requires StructMapQuestsQuestMother, StructMapQuestsQuestRalphsGarden, StructMapQuestsQuestShitOnTheThrone, StructMapQuestsQuestTheChildren

	function initMapPrimaryQuests takes nothing returns nothing
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
		call QuestMother.initQuest()
		call QuestRalphsGarden.initQuest()
		call QuestShitOnTheThrone.initQuest()
		call QuestTheChildren.initQuest()
	endfunction

endlibrary