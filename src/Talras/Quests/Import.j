//! import "Talras/Quests/Struct Quest A Big Present.j"
//! import "Talras/Quests/Struct Quest A Little Present.j"
//! import "Talras/Quests/Struct Quest Among The Weapons Peasants.j"
//! import "Talras/Quests/Struct Quest Arena Champion.j"
//! import "Talras/Quests/Struct Quest Burn The Bears Down.j"
//! import "Talras/Quests/Struct Quest Cats For Brogo.j"
//! import "Talras/Quests/Struct Quest Coats For The Peasants.j"
//! import "Talras/Quests/Struct Quest Death To Black Legion.j"
//! import "Talras/Quests/Struct Quest Death To White Legion.j"
//! import "Talras/Quests/Struct Quest Gold For The Trading Permission.j"
//! import "Talras/Quests/Struct Quest Kunos Daughter.j"
//! import "Talras/Quests/Struct Quest Mushroom Search.j"
//! import "Talras/Quests/Struct Quest My Friend The Bear.j"
//! import "Talras/Quests/Struct Quest Protect The People.j"
//! import "Talras/Quests/Struct Quest Rescue Dago.j"
//! import "Talras/Quests/Struct Quest Shamans In Talras.j"
//! import "Talras/Quests/Struct Quest Slaughter.j"
//! import "Talras/Quests/Struct Quest Talras.j"
//! import "Talras/Quests/Struct Quest The Beast.j"
//! import "Talras/Quests/Struct Quest The Brave Armourer Of Talras.j"
//! import "Talras/Quests/Struct Quest The Dark Cult.j"
//! import "Talras/Quests/Struct Quest The Holy Potato.j"
//! import "Talras/Quests/Struct Quest The Kings Crown.j"
//! import "Talras/Quests/Struct Quest The Magic.j"
//! import "Talras/Quests/Struct Quest The Norsemen.j"
//! import "Talras/Quests/Struct Quest The Oaks Power.j"
//! import "Talras/Quests/Struct Quest The Paedophilliac Cleric.j"
//! import "Talras/Quests/Struct Quest The Way To Holzbruck.j"
//! import "Talras/Quests/Struct Quest Wielands Sword.j"
//! import "Talras/Quests/Struct Quest Witching Hour.j"
//! import "Talras/Quests/Struct Quest Wood For The Hut.j"

library MapQuests requires StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent, StructMapQuestsQuestAmongTheWeaponsPeasants, StructMapQuestsQuestArenaChampion, StructMapQuestsQuestBurnTheBearsDown, StructMapQuestsQuestCatsForBrogo, StructMapQuestsQuestCoatsForThePeasants, StructMapQuestsQuestDeathToBlackLegion, StructMapQuestsQuestDeathToWhiteLegion, StructMapQuestsQuestGoldForTheTradingPermission, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestMushroomSearch, StructMapQuestsQuestMyFriendTheBear, StructMapQuestsQuestProtectThePeople, StructMapQuestsQuestRescueDago, StructMapQuestsQuestShamansInTalras, StructMapQuestsQuestSlaughter, StructMapQuestsQuestTalras, StructMapQuestsQuestTheBeast, StructMapQuestsQuestTheBraveArmourerOfTalras, StructMapQuestsQuestTheDarkCult, StructMapQuestsQuestTheHolyPotato, StructMapQuestsQuestTheKingsCrown, StructMapQuestsQuestTheMagic, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestTheOaksPower, StructMapQuestsQuestThePaedophilliacCleric, StructMapQuestsQuestTheWayToHolzbruck, StructMapQuestsQuestWielandsSword, StructMapQuestsQuestWitchingHour, StructMapQuestsQuestWoodForTheHut

	function initMapPrimaryQuests takes nothing returns nothing
		call QuestTalras.initQuest()
		call QuestRescueDago.initQuest()
		call QuestSlaughter.initQuest()
		call QuestTheNorsemen.initQuest()
		call QuestTheWayToHolzbruck.initQuest()
	endfunction

	function initMapSecundaryQuests takes nothing returns nothing
		call QuestABigPresent.initQuest()
		call QuestALittlePresent.initQuest()
		call QuestAmongTheWeaponsPeasants.initQuest()
		call QuestArenaChampion.initQuest()
		call QuestBurnTheBearsDown.initQuest()
		call QuestCatsForBrogo.initQuest()
		call QuestCoatsForThePeasants.initQuest()
		call QuestDeathToBlackLegion.initQuest()
		call QuestDeathToWhiteLegion.initQuest()
		call QuestGoldForTheTradingPermission.initQuest()
		call QuestKunosDaughter.initQuest()
		call QuestMushroomSearch.initQuest()
		call QuestMyFriendTheBear.initQuest()
		call QuestProtectThePeople.initQuest()
		call QuestShamansInTalras.initQuest()
		call QuestTheBeast.initQuest()
		call QuestTheBraveArmourerOfTalras.initQuest()
		call QuestTheDarkCult.initQuest()
		call QuestTheHolyPotato.initQuest()
		call QuestTheKingsCrown.initQuest()
		call QuestTheMagic.initQuest()
		call QuestTheOaksPower.initQuest()
		call QuestThePaedophilliacCleric.initQuest()
		call QuestWielandsSword.initQuest()
		call QuestWitchingHour.initQuest()
		call QuestWoodForTheHut.initQuest()
	endfunction

endlibrary