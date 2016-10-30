//! import "Dornheim/Talks/Struct Talk Gotlinde.j"
//! import "Dornheim/Talks/Struct Talk Mother.j"
//! import "Dornheim/Talks/Struct Talk Ralph.j"

library MapTalks requires StructMapTalksTalkGotlinde, StructMapTalksTalkMother, StructMapTalksTalkRalph

	function initMapTalks takes nothing returns nothing
		call TalkGotlinde.initTalk()
		call TalkMother.initTalk()
		call TalkRalph.initTalk()
	endfunction

endlibrary
