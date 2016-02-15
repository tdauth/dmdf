//! import "Talras/Quests/Struct Quest A Big Present.j"
//! import "Talras/Quests/Struct Quest A Little Present.j"
//! import "Talras/Quests/Struct Quest A New Alliance.j"
//! import "Talras/Quests/Struct Quest Among The Weapons Peasants.j"
//! import "Talras/Quests/Struct Quest Arena Champion.j"
//! import "Talras/Quests/Struct Quest Burn The Bears Down.j"
//! import "Talras/Quests/Struct Quest Cats For Brogo.j"
//! import "Talras/Quests/Struct Quest Coats For The Peasants.j"
//! import "Talras/Quests/Struct Quest Death To Black Legion.j"
//! import "Talras/Quests/Struct Quest Death To White Legion.j"
//! import "Talras/Quests/Struct Quest Deranor.j"
//! import "Talras/Quests/Struct Quest Gold For The Trading Permission.j"
//! import "Talras/Quests/Struct Quest Kunos Daughter.j"
//! import "Talras/Quests/Struct Quest Mushroom Search.j"
//! import "Talras/Quests/Struct Quest My Friend The Bear.j"
//! import "Talras/Quests/Struct Quest Perdix Hunt.j"
//! import "Talras/Quests/Struct Quest Protect The People.j"
//! import "Talras/Quests/Struct Quest Seeds For The Garden.j"
//! import "Talras/Quests/Struct Quest Reinforcement For Talras.j"
//! import "Talras/Quests/Struct Quest Rescue Dago.j"
//! import "Talras/Quests/Struct Quest Shamans In Talras.j"
//! import "Talras/Quests/Struct Quest Slaughter.j"
//! import "Talras/Quests/Struct Quest Storming The Mill.j"
//! import "Talras/Quests/Struct Quest Supplies For Einar.j"
//! import "Talras/Quests/Struct Quest Supply For Talras.j"
//! import "Talras/Quests/Struct Quest Talras.j"
//! import "Talras/Quests/Struct Quest The Author.j"
//! import "Talras/Quests/Struct Quest The Beast.j"
//! import "Talras/Quests/Struct Quest The Brave Armourer Of Talras.j"
//! import "Talras/Quests/Struct Quest The Dark Cult.j"
//! import "Talras/Quests/Struct Quest The Defense Of Talras.j"
//! import "Talras/Quests/Struct Quest The Dragon.j"
//! import "Talras/Quests/Struct Quest The Ghost Of The Master.j"
//! import "Talras/Quests/Struct Quest The Holy Potato.j"
//! import "Talras/Quests/Struct Quest The Kings Crown.j"
//! import "Talras/Quests/Struct Quest The Magic.j"
//! import "Talras/Quests/Struct Quest The Magical Shield.j"
//! import "Talras/Quests/Struct Quest The Norsemen.j"
//! import "Talras/Quests/Struct Quest The Oaks Power.j"
//! import "Talras/Quests/Struct Quest The Paedophilliac Cleric.j"
//! import "Talras/Quests/Struct Quest The Way To Holzbruck.j"
//! import "Talras/Quests/Struct Quest War Lumber From Kuno.j"
//! import "Talras/Quests/Struct Quest War Recruit.j"
//! import "Talras/Quests/Struct Quest War Sub Quest.j"
//! import "Talras/Quests/Struct Quest War Supply From Manfred.j"
//! import "Talras/Quests/Struct Quest War Traps From Bjoern.j"
//! import "Talras/Quests/Struct Quest War Weapons From Wieland.j"
//! import "Talras/Quests/Struct Quest War.j"
//! import "Talras/Quests/Struct Quest Wielands Sword.j"
//! import "Talras/Quests/Struct Quest Witching Hour.j"
//! import "Talras/Quests/Struct Quest Wolves Hunt.j"
//! import "Talras/Quests/Struct Quest Wood For The Hut.j"

library MapQuests requires StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent, StructMapQuestsQuestANewAlliance, StructMapQuestsQuestAmongTheWeaponsPeasants, StructMapQuestsQuestArenaChampion, StructMapQuestsQuestBurnTheBearsDown, StructMapQuestsQuestCatsForBrogo, StructMapQuestsQuestCoatsForThePeasants, StructMapQuestsQuestDeathToBlackLegion, StructMapQuestsQuestDeathToWhiteLegion, StructMapQuestsQuestDeranor, StructMapQuestsQuestGoldForTheTradingPermission, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestMushroomSearch, StructMapQuestsQuestMyFriendTheBear, StructMapQuestsQuestPerdixHunt, StructMapQuestsQuestProtectThePeople, StructMapQuestsQuestSeedsForTheGarden, StructMapQuestsQuestReinforcementForTalras, StructMapQuestsQuestTheAuthor, StructMapQuestsQuestRescueDago, StructMapQuestsQuestShamansInTalras, StructMapQuestsQuestSlaughter, StructMapQuestsQuestStormingTheMill, StructMapQuestsQuestSuppliesForEinar, StructMapQuestsQuestSupplyForTalras, StructMapQuestsQuestTalras, StructMapQuestsQuestTheBeast, StructMapQuestsQuestTheBraveArmourerOfTalras, StructMapQuestsQuestTheDarkCult, StructMapQuestsQuestTheDefenseOfTalras, StructMapQuestsQuestTheDragon, StructMapQuestsQuestTheGhostOfTheMaster, StructMapQuestsQuestTheHolyPotato, StructMapQuestsQuestTheKingsCrown, StructMapQuestsQuestTheMagic, StructMapQuestsQuestTheMagicalShield, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestTheOaksPower, StructMapQuestsQuestThePaedophilliacCleric, StructMapQuestsQuestTheWayToHolzbruck,  StructMapQuestsQuestWarLumberFromKuno, StructMapQuestsQuestWarRecruit, StructMapQuestsQuestWarSubQuest, StructMapQuestsQuestWarSupplyFromManfred, StructMapQuestsQuestWarTrapsFromBjoern, StructMapQuestsQuestWarWeaponsFromWieland, StructMapQuestsQuestWar, StructMapQuestsQuestWielandsSword, StructMapQuestsQuestWitchingHour, StructMapQuestsQuestWolvesHunt, StructMapQuestsQuestWoodForTheHut

	function initMapPrimaryQuests takes nothing returns nothing
		call QuestANewAlliance.initQuest()
		call QuestTalras.initQuest()
		call QuestRescueDago.initQuest()
		call QuestSlaughter.initQuest()
		call QuestDeranor.initQuest()
		call QuestTheDefenseOfTalras.initQuest()
		call QuestTheNorsemen.initQuest()
		call QuestTheWayToHolzbruck.initQuest()
		call QuestWarLumberFromKuno.initQuest()
		call QuestWarRecruit.initQuest()
		call QuestWarSupplyFromManfred.initQuest()
		call QuestWarTrapsFromBjoern.initQuest()
		call QuestWarWeaponsFromWieland.initQuest()
		call QuestWar.initQuest()
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
		call QuestPerdixHunt.initQuest()
		call QuestProtectThePeople.initQuest()
		call QuestReinforcementForTalras.initQuest()
		call QuestSeedsForTheGarden.initQuest()
		call QuestShamansInTalras.initQuest()
		call QuestStormingTheMill.initQuest()
		call QuestSuppliesForEinar.initQuest()
		call QuestSupplyForTalras.initQuest()
		call QuestTheAuthor.initQuest()
		call QuestTheBeast.initQuest()
		call QuestTheBraveArmourerOfTalras.initQuest()
		call QuestTheDarkCult.initQuest()
		call QuestTheDragon.initQuest()
		call QuestTheGhostOfTheMaster.initQuest()
		call QuestTheHolyPotato.initQuest()
		call QuestTheKingsCrown.initQuest()
		call QuestTheMagic.initQuest()
		call QuestTheMagicalShield.initQuest()
		call QuestTheOaksPower.initQuest()
		call QuestThePaedophilliacCleric.initQuest()
		call QuestWielandsSword.initQuest()
		call QuestWitchingHour.initQuest()
		call QuestWolvesHunt.initQuest()
		call QuestWoodForTheHut.initQuest()
	endfunction

endlibrary