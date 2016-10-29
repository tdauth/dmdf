library StructMapQuestsQuestPalace requires Asl, StructMapMapFellows, StructMapVideosVideoPalace, StructMapVideosVideoWelcome

	struct QuestAreaPalace extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoPalace.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call ACharacter.panCameraSmartToAll()
			call QuestPalace.quest.evaluate().completeReachPalace.evaluate()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaPalaceInside extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoWelcome.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call ACharacter.panCameraSmartToAll()
			call QuestPalace.quest.evaluate().completeReachPalaceInside.evaluate()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestPalace extends SharedQuest
		public static constant integer questItemReachPalace = 0
		public static constant integer questItemReachPalaceInside = 1
		public static constant integer questItemFightThroughHell = 2
		private QuestAreaPalace m_questAreaPalace
		private QuestAreaPalace m_questAreaPalaceInside

		implement Quest

		public stub method enable takes nothing returns boolean
			set this.m_questAreaPalace = QuestAreaPalace.create(gg_rct_quest_palace_gather)
			return this.enableUntil(thistype.questItemReachPalace)
		endmethod

		public method completeReachPalace takes nothing returns nothing
			call this.questItem(thistype.questItemReachPalace).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemReachPalaceInside).setState(thistype.stateNew)
			call this.displayUpdate()

			call ModifyGateBJ(bj_GATEOPERATION_OPEN, gg_dest_DTg5_0000)

			call SetUnitX(gg_unit_n06Y_0023, GetRectCenterX(gg_rct_quest_palace_guard_position_0))
			call SetUnitY(gg_unit_n06Y_0023, GetRectCenterY(gg_rct_quest_palace_guard_position_0))

			call SetUnitX(gg_unit_n06Y_0024, GetRectCenterX(gg_rct_quest_palace_guard_position_1))
			call SetUnitY(gg_unit_n06Y_0024, GetRectCenterY(gg_rct_quest_palace_guard_position_1))

			call SetUnitX(gg_unit_n06X_0016, GetRectCenterX(gg_rct_quest_palace_guard_position_2))
			call SetUnitY(gg_unit_n06X_0016, GetRectCenterY(gg_rct_quest_palace_guard_position_2))

			call SetUnitX(gg_unit_n06X_0017, GetRectCenterX(gg_rct_quest_palace_guard_position_3))
			call SetUnitY(gg_unit_n06X_0017, GetRectCenterY(gg_rct_quest_palace_guard_position_3))

			set this.m_questAreaPalaceInside = QuestAreaPalaceInside.create(gg_rct_quest_palace_gather_inside)
		endmethod

		public method completeReachPalaceInside takes nothing returns nothing
			call this.questItem(thistype.questItemReachPalaceInside).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemFightThroughHell).setState(thistype.stateNew)
			call this.displayUpdate()

			// TODO make the way free through hell!
			call SetUnitX(gg_unit_n070_0035, GetRectCenterX(gg_rct_quest_palace_guard_position_4))
			call SetUnitY(gg_unit_n070_0035, GetRectCenterY(gg_rct_quest_palace_guard_position_4))
			call SetUnitFacing(gg_unit_n070_0035, 270.0)

			call SetUnitX(gg_unit_n070_0034, GetRectCenterX(gg_rct_quest_palace_guard_position_5))
			call SetUnitY(gg_unit_n070_0034, GetRectCenterY(gg_rct_quest_palace_guard_position_5))
			call SetUnitFacing(gg_unit_n070_0034, 90.0)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Der Palast", "The Palace"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDemonGate.blp")
			call this.setDescription(tre("In der Nähe befindet sich ein Palast. Sammelt euch dort.", "Nearby there is a palace. Gather there."))
			// item questItemReachPalace
			set questItem = AQuestItem.create(this, tre("Sammelt euch beim Palast.", "Gather at the palace."))
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_palace_gather)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// item questItemReachPalaceInside
			set questItem = AQuestItem.create(this, tre("Sammelt euch im Palast.", "Gather in the palace."))
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_palace_gather_inside)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// item questItemFightThroughHell
			set questItem = AQuestItem.create(this, tre("Kämpft euch durch Gardonars Hölle.", "Fight through Gardonar's hell."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_palace_fight_through_hell)
			call questItem.setReward(thistype.rewardExperience, 100)

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			call SetDestructableInvulnerable(gg_dest_DTg5_0000, true)
		endmethod
	endstruct

endlibrary