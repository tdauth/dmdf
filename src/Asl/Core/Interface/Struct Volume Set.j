library AStructCoreInterfaceVolumeSet

	/**
	 * \brief Stores the any volumeset and can be applied to players or forces.
	 * \sa VolumeGroupSetVolume, VolumeGroupReset, VolumeGroupSetVolumeForPlayerBJ, SetCineModeVolumeGroupsImmediateBJ, SetSpeechVolumeGroupsImmediateBJ
	 */
	struct AVolumeSet
		public static constant integer volumeGroups = 8 /// \todo vJass bug, SOUND_VOLUMEGROUP_FIRE + 1
		private real array m_scale[8] /// \todo vJass bug, thistype.volumeGroups

		public method apply takes nothing returns nothing
			local integer i = 0
			loop
				call VolumeGroupSetVolume(ConvertVolumeGroup(i), this.m_scale[i])
				set i = i + 1
				exitwhen (i == thistype.volumeGroups)
			endloop
		endmethod

		public method applyForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.apply()
			endif
		endmethod

		public method applyForForce takes force whichForce returns nothing
			if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
				call this.apply()
			endif
		endmethod

		public method setVolume takes volumegroup volumeGroup, real scale returns nothing
			set this.m_scale[GetHandleId(volumeGroup)] = scale
		endmethod

		public method volume takes volumegroup volumeGroup returns real
			return this.m_scale[GetHandleId(volumeGroup)]
		endmethod

		public method setVolumes takes real scale returns nothing
			local integer i = 0
			loop
				set this.m_scale[i] = scale
				set i = i + 1
				exitwhen (i == thistype.volumeGroups)
			endloop
		endmethod

		public method setCineModeVolume takes nothing returns nothing
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UNITMOVEMENT)] = bj_CINEMODE_VOLUME_UNITMOVEMENT
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UNITSOUNDS)] = bj_CINEMODE_VOLUME_UNITSOUNDS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_COMBAT)] = bj_CINEMODE_VOLUME_COMBAT
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_SPELLS)] = bj_CINEMODE_VOLUME_SPELLS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UI)] = bj_CINEMODE_VOLUME_UI
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_MUSIC)] = bj_CINEMODE_VOLUME_MUSIC
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_AMBIENTSOUNDS)] = bj_CINEMODE_VOLUME_AMBIENTSOUNDS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_FIRE)] = bj_CINEMODE_VOLUME_FIRE
		endmethod

		public method setSpeechVolume takes nothing returns nothing
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UNITMOVEMENT)] =  bj_SPEECH_VOLUME_UNITMOVEMENT
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UNITSOUNDS)] = bj_SPEECH_VOLUME_UNITSOUNDS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_COMBAT)] = bj_SPEECH_VOLUME_COMBAT
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_SPELLS)] = bj_SPEECH_VOLUME_SPELLS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_UI)] = bj_SPEECH_VOLUME_UI
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_MUSIC)] = bj_SPEECH_VOLUME_MUSIC
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_AMBIENTSOUNDS)] = bj_SPEECH_VOLUME_AMBIENTSOUNDS
			set this.m_scale[GetHandleId(SOUND_VOLUMEGROUP_FIRE)] = bj_SPEECH_VOLUME_FIRE
		endmethod

		public method setDefaultVolume takes nothing returns nothing
			/// @todo Get default volumes from UI file
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setDefaultVolume()
			return this
		endmethod

		public static method createCineMode takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setCineModeVolume()
			return this
		endmethod

		public static method createSpeech takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setSpeechVolume()
			return this
		endmethod
	endstruct

endlibrary