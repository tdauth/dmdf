library ModuleVideosVideo

	/**
	 * Fixes the camera fields and resets the camera and then applies a camera setup.
	 * This is necessary since \ref Character and \ref CameraHeight have systems which set camera fields.
	 * This cannot be done in \ref onInitAction() since it is evaluated and not executed.
	 */
	function FixVideoCamera takes camerasetup cameraSetup returns nothing
		// reset z offset for safety, reset immediately, otherwise it might move in video sequences!
		call SetCameraField(CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
		call TriggerSleepAction(CameraHeight.period) // wait the field time for safety, otherwise the field is set the whole time during videos
		// make sure the field is not applied anymore
		call TriggerSleepAction(Character.cameraTimerInterval)
		call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, Character.defaultCameraDistance, 0.0)
		call SetCameraField(CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
		call StopCamera() // for safety
		call ResetToGameCamera(0.0) // for safety

		if (cameraSetup != null) then
			call CameraSetupApplyForceDuration(cameraSetup, true, 0.0)
		endif
	endfunction

	/**
	 * \brief Every video should implement this module to provide a global instance.
	 */
	module Video
		private static thistype m_video

		/**
		 * Initializes the video object as singleton. After calling this method you can use \ref video() to access the global instance.
		 * This method should be called for every video in the map initialization process.
		 */
		public static method initVideo takes nothing returns nothing
			set thistype.m_video = thistype.create()
		endmethod

		/**
		 * \return Returns the global instance of the video.
		 */
		public static method video takes nothing returns thistype
			return thistype.m_video
		endmethod
	endmodule

endlibrary