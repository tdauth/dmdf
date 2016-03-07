//! import "Gardonar/Videos/Struct Video Intro.j"
//! import "Gardonar/Videos/Struct Video Palace.j"

library MapVideos requires StructMapVideosVideoIntro

	function initMapVideos takes nothing returns nothing
		call VideoIntro.initVideo()
		call VideoPalace.initVideo()
	endfunction

endlibrary