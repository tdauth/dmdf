library StructMapMapWeather requires Asl, StructGameMapSettings

	/**
	 * \brief The map Talras has as only weather rain which appears from time to time.
	 */
	struct Weather
		private static timer m_rainTimer
		private static timer m_resetRainTimer
		private static timer m_thunderTimer
		private static weathereffect m_rainWeatherEffect

		public static method pauseWeather takes nothing returns nothing
			if (thistype.m_rainWeatherEffect != null) then
				call EnableWeatherEffect(thistype.m_rainWeatherEffect, false)
				call PauseTimer(thistype.m_thunderTimer)
			else
				call PauseTimer(thistype.m_rainTimer)
			endif
		endmethod

		public static method resumeWeather takes nothing returns nothing
			if (thistype.m_rainWeatherEffect != null) then
				call EnableWeatherEffect(thistype.m_rainWeatherEffect, true)
				call ResumeTimer(thistype.m_thunderTimer)
			else
				call ResumeTimer(thistype.m_rainTimer)
			endif
		endmethod

		private static method timerFunctionThunder takes nothing returns nothing
			local integer i
			// don't create thunder effect if it is not raining anymore or the rain stops in a few seconds
			if (thistype.m_rainWeatherEffect != null and TimerGetRemaining(thistype.m_resetRainTimer) > 5.0) then
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (GetLocalPlayer() == Player(i)) then
						// only play thunder if view is in playable area where it rains
						if (GetCameraTargetPositionX() <= GetRectMaxX(gg_rct_area_playable) and GetCameraTargetPositionX() >= GetRectMinX(gg_rct_area_playable) and GetCameraTargetPositionY() <= GetRectMaxY(gg_rct_area_playable) and GetCameraTargetPositionY() >= GetRectMinY(gg_rct_area_playable)) then
							call SetSoundVolumeBJ(gg_snd_RollingThunder1, 50.0)
							call StartSound(gg_snd_RollingThunder1)
							call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN, 0.10, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.0, 100.0, 100.0, 0)
						endif
					endif
					set i = i + 1
				endloop

				call thistype.startThunderCountdown.evaluate()
			endif
		endmethod

		private static method timerFunctionRestartRain takes nothing returns nothing
			call RemoveWeatherEffect(thistype.m_rainWeatherEffect)
			set thistype.m_rainWeatherEffect = null

			call thistype.startRainCountdown.evaluate()
		endmethod

		private static method timerFunctionRain takes nothing returns nothing
			local integer random = GetRandomInt(0, 1)
			if (random == 0) then
				set thistype.m_rainWeatherEffect = AddWeatherEffect(gg_rct_area_playable, 'RLlr')
			else
				set thistype.m_rainWeatherEffect = AddWeatherEffect(gg_rct_area_playable, 'RLhr')
			endif
			call EnableWeatherEffect(thistype.m_rainWeatherEffect, true)

			call thistype.startThunderCountdown.evaluate()
			call TimerStart(thistype.m_resetRainTimer, GetRandomReal(45.0, 60.0), false, function thistype.timerFunctionRestartRain)
		endmethod

		private static method startThunderCountdown takes nothing returns nothing
			call TimerStart(thistype.m_thunderTimer, GetRandomReal(15.0, 20.0), false, function thistype.timerFunctionThunder)
		endmethod

		public static method startRainCountdown takes nothing returns nothing
			call TimerStart(thistype.m_rainTimer, GetRandomReal(120.0, 180.0), false, function thistype.timerFunctionRain)
		endmethod

		private static method onInit takes nothing returns nothing
			// weather
			set thistype.m_rainTimer = CreateTimer()
			set thistype.m_resetRainTimer = CreateTimer()
			set thistype.m_thunderTimer = CreateTimer()
		endmethod
	endstruct

endlibrary