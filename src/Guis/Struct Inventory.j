/// @todo Finish this later.
/// Test system!
library StructGuisInventory requires Asl, StructGameCharacter, StructGuisMainWindow, StructMapMapMapData

	struct Inventory extends MainWindow
		private AImage m_backgroundImage
		private ViewWidget m_viewWidget
		private EquipmentWidget m_equipmentWidget
		private PropertiesWidget m_propertiesWidget

		/// Access from button functions.
		public method viewWidget takes nothing returns ViewWidget
			return this.m_viewWidget
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, gg_rct_main_window_inventory)
			call this.setTooltipX(1100.0)
			call this.setTooltipY(300.0)
			call this.setTooltipBackgroundImageFilePath("") /// @todo Set tooltip window
			set this.m_backgroundImage = AImage.createSimple(this, 0.0, 0.0, 2600.0, 1400.0)
			call this.m_backgroundImage.setFile("CharacterAdministration.tga")
			set this.m_viewWidget = ViewWidget.create.evaluate(this, 200.0, 200.0)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod

		public static method init0 takes nothing returns nothing
			//call ViewWidget.init0.evaluate()
		endmethod
	endstruct

	/**
	* Character 3d view for viewing equipped items, rotating and animating the character model.
	*/
	struct ViewWidget extends AWidget
		private static AStringVector m_animations
		private unit m_unit
		private integer m_animationIndex
		private AButton m_rotateLeftButton
		private AButton m_rotateRightButton
		private AButton m_previousAnimationButton
		private AButton m_nextAnimationButton
		private AText m_animationText
		private AImage m_topBorder
		private AImage m_bottomBorder
		private AImage m_leftBorder
		private AImage m_rightBorder

		public method rotateLeft takes nothing returns nothing
			call SetUnitFacing(this.m_unit, GetUnitFacing(this.m_unit) - 20.0)
		endmethod

		public method rotateRight takes nothing returns nothing
			call SetUnitFacing(this.m_unit, GetUnitFacing(this.m_unit) + 20.0)
		endmethod

		public method previousAnimation takes nothing returns nothing
			set this.m_animationIndex = this.m_animationIndex - 1
			if (this.m_animationIndex < 0) then
				set this.m_animationIndex = thistype.m_animations.backIndex()
			endif
			call QueueUnitAnimation(this.m_unit, thistype.m_animations[this.m_animationIndex])
		endmethod

		public method nextAnimation takes nothing returns nothing
			set this.m_animationIndex = this.m_animationIndex + 1
			if (this.m_animationIndex > thistype.m_animations.size()) then
				set this.m_animationIndex = 0
			endif
			call QueueUnitAnimation(this.m_unit, thistype.m_animations[this.m_animationIndex])
		endmethod

		public stub method show takes nothing returns nothing
			local integer i
			call super.show()
			set this.m_unit = ACharacter.playerCharacter(this.mainWindow().gui().player()).copy(bj_UNIT_STATE_METHOD_ABSOLUTE) /// @todo Rotate on X.
			call PauseUnit(this.m_unit, true)
			call SetUnitInvulnerable(this.m_unit, true)
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (i != GetPlayerId(this.mainWindow().gui().player())) then
					call UnitShareVision(this.m_unit, Player(i), false)
				endif
				set i = i + 1
			endloop
			call SetUnitPosition(this.m_unit, this.mainWindow().getX(this.x()), this.mainWindow().getY(this.y()))
			call SetUnitFacing(this.m_unit, 0.0)
			call QueueUnitAnimation(this.m_unit, thistype.m_animations[this.m_animationIndex])
		endmethod

		public stub method hide takes nothing returns nothing
			call super.hide()
			call RemoveUnit(this.m_unit)
			set this.m_unit = null
		endmethod

		private static method onHitActionRotateLeft takes AButton whichButton returns nothing
			call Character(ACharacter.playerCharacter(whichButton.mainWindow().gui().player())).guiInventory().viewWidget().rotateLeft()
		endmethod

		private static method onHitActionRotateRight takes AButton whichButton returns nothing
			call Character(ACharacter.playerCharacter(whichButton.mainWindow().gui().player())).guiInventory().viewWidget().rotateRight()
		endmethod

		private static method onHitActionPreviousAnimation takes AButton whichButton returns nothing
			call Character(ACharacter.playerCharacter(whichButton.mainWindow().gui().player())).guiInventory().viewWidget().previousAnimation()
		endmethod

		private static method onHitActionNextAnimation takes AButton whichButton returns nothing
			call Character(ACharacter.playerCharacter(whichButton.mainWindow().gui().player())).guiInventory().viewWidget().nextAnimation()
		endmethod

		public static method create takes AMainWindow mainWindow, real x, real y returns thistype
			local thistype this = thistype.createSimple(mainWindow, x, y, 500.0, 500.0)
			set this.m_unit = null
			set this.m_animationIndex = 0
			set this.m_rotateLeftButton = AButton.create(mainWindow, x, y + 200.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionRotateLeft, AWidget.onTrackActionShowTooltip)
			call this.m_rotateLeftButton.setFile("Icons\\Interface\\Buttons\\Left.blp")
			call this.m_rotateLeftButton.setTooltipSize(12.0)
			call this.m_rotateLeftButton.setTooltip(tr("Klicken Sie hier, um das angezeigte Charaktermodell nach links zu drehen."))
			set this.m_rotateRightButton = AButton.create(mainWindow, x + 500.0, y + 200.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionRotateRight, AWidget.onTrackActionShowTooltip)
			call this.m_rotateRightButton.setFile("UI\\Widgets\\Glues\\GlueScreen-CampaignButton-Arrow.blp")
			call this.m_rotateRightButton.setTooltipSize(12.0)
			call this.m_rotateRightButton.setTooltip(tr("Klicken Sie hier, um das angezeigte Charaktermodell nach rechts zu drehen."))
			set this.m_previousAnimationButton = AButton.create(mainWindow, x + 20.0, y + 400.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionPreviousAnimation, AWidget.onTrackActionShowTooltip)
			call this.m_previousAnimationButton.setFile("Icons\\Interface\\Buttons\\Left.blp")
			call this.m_previousAnimationButton.setTooltipSize(12.0)
			call this.m_previousAnimationButton.setTooltip(tr("Klicken Sie hier, um die vorherige Animation des angezeigten Charaktermodells abzuspielen."))
			set this.m_nextAnimationButton = AButton.create(mainWindow, x + 480, y + 400.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionNextAnimation, AWidget.onTrackActionShowTooltip)
			call this.m_nextAnimationButton.setFile("Icons\\Interface\\Buttons\\Right.blp")
			call this.m_nextAnimationButton.setTooltipSize(12.0)
			call this.m_nextAnimationButton.setTooltip(tr("Klicken Sie hier, um die nächste Animation des angezeigten Charaktermodells abzuspielen."))

			set this.m_animationText = AText.create(mainWindow, x + 205, y + 400, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", 0, AWidget.onTrackActionShowTooltip)
			call this.m_animationText.setTooltipSize(12.0)
			call this.m_animationText.setTooltip(tr("Der Name der abgespielten Animation des angezeigten Charaktermodells."))
			//private AImage m_topBorder
			//private AImage m_bottomBorder
			//private AImage m_leftBorder
			//private AImage m_rightBorder

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (this.m_unit != null) then
				call RemoveUnit(this.m_unit)
				set this.m_unit = null
			endif
		endmethod

		public static method init0 takes nothing returns nothing
			set thistype.m_animations = AStringVector.create()
		endmethod

		public static method addAnimation takes string animation returns nothing
			call thistype.m_animations.pushBack(animation)
		endmethod
	endstruct

	/// File path to autocast model for item selection UI/Feedback/Autocast/UI-ModalButtonOn.mdx
	struct EquipmentWidget extends AWidget
	endstruct

	struct RucksackWidget extends AWidget
	endstruct

	struct PropertiesWidget extends AWidget
		private AText m_headlineText
		private AText m_levelText

		public static method create takes AMainWindow mainWindow, real x, real y returns thistype
			local thistype this = thistype.allocate(mainWindow, x, y, 500.0, 500.0, "", 0, 0)
			set this.m_headlineText = AText.createSimple(mainWindow, x + 200, y + 20.0, 0.0, 0.0)
			call this.m_headlineText.setTextAndSize(tr("Eigenschaften"), 14.0)

			return this
		endmethod

	endstruct

endlibrary