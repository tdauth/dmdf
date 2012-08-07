library StructGameMarker requires Asl

	/**
	 * Static hint based on a single \ref trackable which shows a message when cursor is moved over it.
	 */
	struct Marker
		private string m_message
		private trackable m_trackable
		private trigger m_trackTrigger

		public method setMessage takes string message returns nothing
			set this.m_message = message
		endmethod

		public method message takes nothing returns string
			return this.m_message
		endmethod

		public method enable takes nothing returns nothing
			call EnableTrigger(this.m_trackTrigger)
		endmethod

		public method disable takes nothing returns nothing
			call DisableTrigger(this.m_trackTrigger)
		endmethod

		public method isEnabled takes nothing returns boolean
			return IsTriggerEnabled(this.m_trackTrigger)
		endmethod

		private static method triggerActionTrack takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, "this")
			local player triggerPlayer = GetTriggerPlayer()

			if (ACharacter.playerCharacter(triggerPlayer) != 0) then
				call ACharacter.playerCharacter(triggerPlayer).displayMessage(ACharacter.messageTypeInfo, Format(tr("Wegweiser: „%1%”")).s(this.m_message).result())
			endif

			set triggeringTrigger = null
			set triggerPlayer = null
		endmethod

		private method createTrackTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_trackTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterTrackableTrackEvent(this.m_trackTrigger, this.m_trackable)
			set triggerAction = TriggerAddAction(this.m_trackTrigger, function thistype.triggerActionTrack)
			call DmdfHashTable.global().setHandleInteger(this.m_trackTrigger, "this", this)
			set triggerEvent = null
			set triggerAction = null
		endmethod

		public static method create takes string modelPath, real x, real y, real facing, string message returns thistype
			local thistype this = thistype.allocate()
			set this.m_message = message
			set this.m_trackable = CreateTrackable(modelPath, x, y, facing)
			call this.createTrackTrigger()

			return this
		endmethod

		/// Markers are undestructable (trackables).
		private method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary