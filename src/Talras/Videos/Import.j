//! import "Talras/Videos/Struct Video A New Alliance.j"
//! import "Talras/Videos/Struct Video Bjoern.j"
//! import "Talras/Videos/Struct Video Bloodthirstiness.j"
//! import "Talras/Videos/Struct Video Death Vault.j"
//! import "Talras/Videos/Struct Video Deranor.j"
//! import "Talras/Videos/Struct Video Deranors Death.j"
//! import "Talras/Videos/Struct Video Dragon Hunt.j"
//! import "Talras/Videos/Struct Video Holzbruck.j"
//! import "Talras/Videos/Struct Video Intro.j"
//! import "Talras/Videos/Struct Video Iron From The Drum Cave.j"
//! import "Talras/Videos/Struct Video Kuno.j"
//! import "Talras/Videos/Struct Video Manfred.j"
//! import "Talras/Videos/Struct Video Prepare For The Defense.j"
//! import "Talras/Videos/Struct Video Recruit.j"
//! import "Talras/Videos/Struct Video Recruit The High Elf.j"
//! import "Talras/Videos/Struct Video Report Kuno.j"
//! import "Talras/Videos/Struct Video Report Manfred.j"
//! import "Talras/Videos/Struct Video Rescue Dago 0.j"
//! import "Talras/Videos/Struct Video Rescue Dago 1.j"
//! import "Talras/Videos/Struct Video The Castle.j"
//! import "Talras/Videos/Struct Video The Chief.j"
//! import "Talras/Videos/Struct Video The Duke Of Talras.j"
//! import "Talras/Videos/Struct Video The First Combat.j"
//! import "Talras/Videos/Struct Video Upstream.j"
//! import "Talras/Videos/Struct Video Weapons From Wieland.j"
//! import "Talras/Videos/Struct Video Wieland.j"
//! import "Talras/Videos/Struct Video Wigberht.j"

library MapVideos requires StructMapVideosVideoANewAlliance, StructMapVideosVideoBjoern, StructMapVideosVideoBloodthirstiness, StructMapVideosVideoDeathVault, StructMapVideosVideoDeranor, StructMapVideosVideoDeranorsDeath, StructMapVideosVideoDragonHunt, StructMapVideosVideoHolzbruck, StructMapVideosVideoIntro, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoKuno, StructMapVideosVideoManfred, StructMapVideosVideoPrepareForTheDefense, StructMapVideosVideoRecruit, StructMapVideosVideoRecruitTheHighElf, StructMapVideosVideoReportKuno, StructMapVideosVideoReportManfred, StructMapVideosVideoRescueDago0, StructMapVideosVideoRescueDago1, StructMapVideosVideoTheCastle, StructMapVideosVideoTheChief, StructMapVideosVideoTheDukeOfTalras, StructMapVideosVideoTheFirstCombat, StructMapVideosVideoUpstream, StructMapVideosVideoWeaponsFromWieland, StructMapVideosVideoWieland, StructMapVideosVideoWigberht

	function initMapVideos takes nothing returns nothing
		call VideoANewAlliance.initVideo()
		call VideoBjoern.initVideo()
		call VideoBloodthirstiness.initVideo()
		call VideoDeathVault.initVideo()
		call VideoDeranor.initVideo()
		call VideoDeranorsDeath.initVideo()
		call VideoDragonHunt.initVideo()
		call VideoHolzbruck.initVideo()
		call VideoIntro.initVideo()
		call VideoIronFromTheDrumCave.initVideo()
		call VideoKuno.initVideo()
		call VideoManfred.initVideo()
		call VideoPrepareForTheDefense.initVideo()
		call VideoRecruit.initVideo()
		call VideoRecruitTheHighElf.initVideo()
		call VideoReportKuno.initVideo()
		call VideoReportManfred.initVideo()
		call VideoRescueDago0.initVideo()
		call VideoRescueDago1.initVideo()
		call VideoTheCastle.initVideo()
		call VideoTheChief.initVideo()
		call VideoTheDukeOfTalras.initVideo()
		call VideoTheFirstCombat.initVideo()
		call VideoUpstream.initVideo()
		call VideoWeaponsFromWieland.initVideo()
		call VideoWieland.initVideo()
		call VideoWigberht.initVideo()
	endfunction

endlibrary