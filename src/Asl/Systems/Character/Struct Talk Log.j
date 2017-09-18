library AStructSystemsCharacterTalkLog requires AStructCoreGeneralVector, AStructSystemsCharacterAbstractCharacterSystem

	private struct AInfoSpeech
		private AInfoData m_infoData
		private boolean m_toCharacter
		private string m_text
		private sound m_sound

		public method toCharacter takes nothing returns boolean
			return this.m_toCharacter
		endmethod

		public method text takes nothing returns string
			return this.m_text
		endmethod

		public method sound takes nothing returns sound
			return this.m_sound
		endmethod

		public static method create takes AInfoData infoData, boolean toCharacter, string text, sound whichSound returns thistype
			local thistype this = thistype.allocate()
			set this.m_infoData = infoData
			set this.m_toCharacter = toCharacter
			set this.m_text = text
			set this.m_sound = whichSound

			return this
		endmethod
	endstruct

	/// \todo Should be private, vJass bug.
	struct AInfoData
		public AInfo m_info
		public AIntegerVector m_speeches

		public method info takes nothing returns AInfo
			return this.m_info
		endmethod

		public method addSpeech takes boolean toCharacter, string text, sound whichSound returns integer
			call this.m_speeches.pushBack(AInfoSpeech.create(this, toCharacter, text, whichSound))
			return this.m_speeches.backIndex()
		endmethod

		public method speech takes integer index returns AInfoSpeech
			return AInfoSpeech(this.m_speeches[index])
		endmethod

		public method speeches takes nothing returns integer
			return this.m_speeches.size()
		endmethod

		public static method create takes AInfo info returns thistype
			local thistype this = thistype.allocate()
			set this.m_info = info
			set this.m_speeches = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			loop
				exitwhen (this.m_speeches.empty())
				call AInfoSpeech(this.m_speeches.back()).destroy()
				call this.m_speeches.popBack()
			endloop
			call this.m_speeches.destroy()
		endmethod
	endstruct

	struct ATalkLog extends AAbstractCharacterSystem
		private AIntegerVector m_infoData

		private method infoIndex takes AInfo info returns integer
			local integer i = 0
			loop
				exitwhen (i == this.m_infoData.size())
				if (AInfoData(this.m_infoData[i]).info() == info) then
					return i
				endif
				set i = i + 1
			endloop
			return -1
		endmethod

		public method info takes integer index returns AInfo
			return AInfoData(this.m_infoData[index]).info()
		endmethod

		public method infos takes nothing returns integer
			return this.m_infoData.size()
		endmethod

		public method addSpeech takes AInfo info, boolean toCharacter, string text, sound whichSound returns integer
			local integer index = this.infoIndex(info)
			if (index == -1) then
				call this.m_infoData.pushBack(AInfoData.create(info))
				set index = this.m_infoData.backIndex()
			endif
			call AInfoData(this.m_infoData[index]).addSpeech(toCharacter, text, whichSound)
			return AInfoData(this.m_infoData[index]).speeches() - 1
		endmethod

		public method speeches takes AInfo info returns integer
			local integer index = this.infoIndex(info)
			if (index == -1) then
				return 0
			endif
			return AInfoData(this.m_infoData[index]).speeches()
		endmethod

		public method speechToCharacter takes AInfo info, integer index returns boolean
			local integer infoIndex = this.infoIndex(info)
			if (infoIndex == -1) then
				return false
			endif
			if (index >= AInfoData(this.m_infoData[index]).speeches() or index < 0) then
				return false
			endif
			return AInfoData(this.m_infoData[index]).speech(index).toCharacter()
		endmethod

		public method speechText takes AInfo info, integer index returns string
			local integer infoIndex = this.infoIndex(info)
			if (infoIndex == -1) then
				return null
			endif
			if (index >= AInfoData(this.m_infoData[infoIndex]).speeches() or index < 0) then
				return null
			endif
			return AInfoData(this.m_infoData[infoIndex]).speech(index).text()
		endmethod

		public method speechSound takes AInfo info, integer index returns sound
			local integer infoIndex = this.infoIndex(info)
			if (infoIndex == -1) then
				return null
			endif
			if (index >= AInfoData(this.m_infoData[infoIndex]).speeches() or index < 0) then
				return null
			endif
			return AInfoData(this.m_infoData[infoIndex]).speech(index).sound()
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// members
			set this.m_infoData = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			loop
				exitwhen (this.m_infoData.empty())
				call AInfoData(this.m_infoData.back()).destroy()
				call this.m_infoData.popBack()
			endloop
			call this.m_infoData.destroy()
		endmethod
	endstruct

endlibrary