//! import "Gardonar/Videos/Struct Video Intro.j"
//! import "Gardonar/Videos/Struct Video Palace.j"
//! import "Gardonar/Videos/Struct Video Welcome.j"

library MapVideos requires StructMapVideosVideoIntro, StructMapVideosVideoPalace, StructMapVideosVideoWelcome

	function initMapVideos takes nothing returns nothing
		call VideoIntro.initVideo()
		call VideoPalace.initVideo()
		call VideoWelcome.initVideo()
	endfunction

endlibrary