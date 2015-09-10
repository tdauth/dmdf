//! import "Talras/Talks/Struct Talk Agihard.j"
//! import "Talras/Talks/Struct Talk Baldar.j"
//! import "Talras/Talks/Struct Talk Bjoern.j"
//! import "Talras/Talks/Struct Talk Brogo.j"
//! import "Talras/Talks/Struct Talk Carsten.j"
//! import "Talras/Talks/Struct Talk Dago.j"
//! import "Talras/Talks/Struct Talk Dragon Slayer.j"
//! import "Talras/Talks/Struct Talk Einar.j"
//! import "Talras/Talks/Struct Talk Ferdinand.j"
//! import "Talras/Talks/Struct Talk Fulco.j"
//! import "Talras/Talks/Struct Talk Guntrich.j"
//! import "Talras/Talks/Struct Talk Haid.j"
//! import "Talras/Talks/Struct Talk Haldar.j"
//! import "Talras/Talks/Struct Talk Heimrich.j"
//! import "Talras/Talks/Struct Talk Irmina.j"
//! import "Talras/Talks/Struct Talk Kuno.j"
//! import "Talras/Talks/Struct Talk Lothar.j"
//! import "Talras/Talks/Struct Talk Manfred.j"
//! import "Talras/Talks/Struct Talk Markward.j"
//! import "Talras/Talks/Struct Talk Mathilda.j"
//! import "Talras/Talks/Struct Talk Osman.j"
//! import "Talras/Talks/Struct Talk Ricman.j"
//! import "Talras/Talks/Struct Talk Sheep Boy.j"
//! import "Talras/Talks/Struct Talk Sisgard.j"
//! import "Talras/Talks/Struct Talk Talras Guardian.j"
//! import "Talras/Talks/Struct Talk Tanka.j"
//! import "Talras/Talks/Struct Talk Tellborn.j"
//! import "Talras/Talks/Struct Talk Trommon.j"
//! import "Talras/Talks/Struct Talk Tobias.j"
//! import "Talras/Talks/Struct Talk Ursula.j"
//! import "Talras/Talks/Struct Talk Wieland.j"
//! import "Talras/Talks/Struct Talk Wigberht.j"

library MapTalks requires StructMapTalksTalkAgihard, StructMapTalksTalkBaldar, StructMapTalksTalkBjoern, StructMapTalksTalkBrogo, StructMapTalksTalkCarsten, StructMapTalksTalkDago, StructMapTalksTalkDragonSlayer, StructMapTalksTalkEinar, StructMapTalksTalkFerdinand, StructMapTalksTalkFulco, StructMapTalksTalkGuntrich, StructMapTalksTalkHaid, StructMapTalksTalkHaldar, StructMapTalksTalkHeimrich, StructMapTalksTalkIrmina, StructMapTalksTalkKuno, StructMapTalksTalkLothar, StructMapTalksTalkManfred, StructMapTalksTalkMarkward, StructMapTalksTalkMathilda, StructMapTalksTalkOsman, StructMapTalksTalkRicman, StructMapTalksTalkSheepBoy, StructMapTalksTalkSisgard, StructMapTalksTalkTalrasGuardian, StructMapTalksTalkTanka, StructMapTalksTalkTellborn, StructMapTalksTalkTrommon, StructMapTalksTalkTobias, StructMapTalksTalkUrsula, StructMapTalksTalkWieland, StructMapTalksTalkWigberht

	function initMapTalks takes nothing returns nothing
		local ATalk talk
		call TalkAgihard.initTalk()
		call TalkBaldar.initTalk()
		call TalkBjoern.initTalk()
		call TalkBrogo.initTalk()
		call TalkCarsten.initTalk()
		// dagos talk is created after quest "Rescue Dago"
		// dragon slayer talk is created after quest "Slaughter"
		call TalkEinar.initTalk()
		call TalkFerdinand.initTalk()
		call TalkFulco.initTalk()
		call TalkGuntrich.initTalk()
		call TalkHaid.initTalk()
		call TalkHaldar.initTalk()
		call TalkHeimrich.initTalk()
		call TalkIrmina.initTalk()
		call TalkKuno.initTalk()
		call TalkLothar.initTalk()
		call TalkManfred.initTalk()
		call TalkMarkward.initTalk()
		call TalkMathilda.initTalk()
		call TalkOsman.initTalk()
		call TalkRicman.initTalk()
		call TalkSheepBoy.initTalk()
		call TalkSisgard.initTalk()
		call TalkTanka.initTalk()
		call TalkTellborn.initTalk()
		call TalkTrommon.initTalk()
		call TalkTobias.initTalk()
		call TalkUrsula.initTalk()
		call TalkWieland.initTalk()
		call TalkWigberht.initTalk()
		// guardians
		set talk = TalkTalrasGuardian.create(gg_unit_n015_0149)
		call talk.setEffectPath(null)
		set talk = TalkTalrasGuardian.create(gg_unit_n005_0119)
		call talk.setEffectPath(null)
		set talk = TalkTalrasGuardian.create(gg_unit_n015_0118)
		call talk.setEffectPath(null)
		set talk = TalkTalrasGuardian.create(gg_unit_n015_0456)
		call talk.setEffectPath(null)
	endfunction

endlibrary
