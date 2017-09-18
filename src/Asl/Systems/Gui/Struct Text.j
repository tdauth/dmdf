library AStructSystemsGuiText requires ALibraryCoreInterfaceTextTag, AStructSystemsGuiWidget

	struct AText extends AWidget
		//dynamic members
		private real m_heightOffset
		private string m_text
		private real m_size
		private integer m_red
		private integer m_green
		private integer m_blue
		private integer m_alpha
		private real m_speed
		private real m_angle
		private real m_fadepoint
		private boolean m_suspended //Unterbrochen
		//private boolean permanent //Textes are always permanent
		//private real lifespan //Textes are always permanent
		//private real age
		//Don't change permanent
		//members
		private texttag m_textTag

		//dynamic members

		//Do not change x and y
		//These values are always static!
		public method setHeightOffset takes real heightOffset returns nothing
			set this.m_heightOffset = heightOffset
			call SetTextTagPos(this.m_textTag, this.mainWindow().getX(this.x()), this.mainWindow().getY(this.y()), heightOffset)
		endmethod

		public method heightOffset takes nothing returns real
			return this.m_heightOffset
		endmethod

		//We don't need SetTextTagPosUnit.
		//It's a GUI...

		public method setTextAndSize takes string text, real size returns nothing
			set this.m_text = text
			set this.m_size = size
			call SetTextTagTextBJ(this.m_textTag, text, size)
		endmethod

		public method text takes nothing returns string
			return this.m_text
		endmethod

		public method size takes nothing returns real
			return this.m_size
		endmethod

		public method setColour takes integer red, integer green, integer blue, integer alpha returns nothing
			set this.m_red = red
			set this.m_green = green
			set this.m_blue = blue
			set this.m_alpha = alpha
			call SetTextTagColor(this.m_textTag, red, green, blue, alpha)
		endmethod

		public method red takes nothing returns integer
			return this.m_red
		endmethod

		public method green takes nothing returns integer
			return this.m_green
		endmethod

		public method blue takes nothing returns integer
			return this.m_blue
		endmethod

		public method alpha takes nothing returns integer
			return this.m_alpha
		endmethod

		public method setSpeedAndAngle takes real speed, real angle returns nothing
			set this.m_speed = speed
			set this.m_angle = angle
			call SetTextTagVelocityBJ(this.m_textTag, speed, angle)
		endmethod

		public method speed takes nothing returns real
			return this.m_speed
		endmethod

		public method angle takes nothing returns real
			return this.m_angle
		endmethod

		public method setFadepoint takes real fadepoint returns nothing
			set this.m_fadepoint = fadepoint
			call SetTextTagFadepoint(this.m_textTag, fadepoint)
		endmethod

		public method fadepoint takes nothing returns real
			return this.m_fadepoint
		endmethod

		//Unterbricht die Bewegung.
		public method setSuspended takes boolean suspended returns nothing
			set this.m_suspended = suspended
			call SetTextTagSuspended(this.m_textTag, suspended)
		endmethod

		public method suspended takes nothing returns boolean
			return this.m_suspended
		endmethod

		//methods

		public stub method show takes nothing returns nothing
			call super.show()
			call ShowTextTagForPlayer(this.mainWindow().gui().player(), this.m_textTag, true)
		endmethod

		public stub method hide takes nothing returns nothing
			call super.hide()
			call ShowTextTagForPlayer(this.mainWindow().gui().player(), this.m_textTag, false)
		endmethod

		public static method create takes AMainWindow mainWindow, real x, real y, real sizeX, real sizeY, string modelFilePath, AWidgetOnHitAction onHitAction, AWidgetOnTrackAction onTrackAction returns AText
			local AText this = AText.allocate(mainWindow, x, y, sizeX, sizeY, modelFilePath, onHitAction, onTrackAction)
			//dynamic members
			set this.m_heightOffset = 0.0
			//members
			set this.m_textTag = CreateTextTag()
			call SetTextTagPos(this.m_textTag, mainWindow.getX(x), mainWindow.getY(y), this.m_heightOffset) //Members x and y were set in the allocate method.
			call SetTextTagVisibility(this.m_textTag, false)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			//members
			call DestroyTextTag(this.m_textTag)
			set this.m_textTag = null
		endmethod
	endstruct

endlibrary