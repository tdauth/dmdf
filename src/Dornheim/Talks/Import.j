//! import "Dornheim/Talks/Struct Talk Gotlinde.j"
//! import "Dornheim/Talks/Struct Talk Mother.j"
//! import "Dornheim/Talks/Struct Talk Ralph.j"
//! import "Dornheim/Talks/Struct Talk Wotan.j"

library MapTalks requires StructMapTalksTalkGotlinde, StructMapTalksTalkMother, StructMapTalksTalkRalph, StructMapTalksTalkWotan

	function initMapTalks takes nothing returns nothing
		call TalkGotlinde.initTalk()
		call TalkMother.initTalk()
		call TalkRalph.initTalk()
		call TalkWotan.initTalk()
	endfunction

endlibrary
