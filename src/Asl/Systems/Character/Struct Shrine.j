library AStructSystemsCharacterShrine requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreEnvironmentSound, ALibraryCoreEnvironmentSpecialEffect, AStructSystemsCharacterCharacter, AStructSystemsCharacterRevival

	/**
	 * \brief Shrines are region based entities which can be used to change a characters revival (\ref ARevival).
	 * Each shrine has its own region which activates it when the character's unit enters it.
	 * \note All shrines are usable by all characters!
	 * \todo When enabled it sets a fixed facing and coordinates. It should assign a custom revival action to the character's \ref ARevival instead!
	 */
	struct AShrine
		// static constant members
		public static constant string defaultEffectPath = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
		public static constant string defaultSoundPath = "Abilities\\Spells\\Demon\\SoulPerservation\\SoulPerservation.wav"
		public static constant string defaultMessage = null
		// dynamic members
		private destructable m_destructable
		private region m_discoverRegion
		private rect m_revivalRect
		private real m_facing
		private string m_effectPath
		private string m_soundPath
		private string m_message
		// members
		private trigger m_shrineTrigger
		private effect m_discoverEffect

		//! runtextmacro optional A_STRUCT_DEBUG("\"AShrine\"")

		// dynamic members

		public method setDestructable takes destructable whichDestructable returns nothing
			set this.m_destructable = whichDestructable
		endmethod

		public method destructable takes nothing returns destructable
			return this.m_destructable
		endmethod

		public method hasDestructable takes nothing returns boolean
			return this.destructable() != null
		endmethod

		public method discoverRegion takes nothing returns region
			return this.m_discoverRegion
		endmethod

		private static method triggerConditionEnable takes nothing returns boolean
			local thistype this = 0
			if (GetTriggerUnit() == ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit())).unit()) then
				set this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
				return ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit())).shrine() != this
			endif
			return false
		endmethod

		private static method triggerActionEnable takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.onEnter.evaluate(ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit())))
		endmethod

		private method updateShrineTrigger takes nothing returns nothing
			if (this.m_shrineTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_shrineTrigger)
				set this.m_shrineTrigger = null
			endif
			set this.m_shrineTrigger = CreateTrigger()
			call TriggerRegisterEnterRegion(this.m_shrineTrigger, this.discoverRegion(), null)
			call TriggerAddCondition(this.m_shrineTrigger, Condition(function thistype.triggerConditionEnable))
			call TriggerAddAction(this.m_shrineTrigger, function thistype.triggerActionEnable)
			call AHashTable.global().setHandleInteger(this.m_shrineTrigger, 0, this)
		endmethod

		/**
		 * \param whichRegion Whenever a character enters this region the shrine will be enabled for him, except it is already activated.
		 * \sa discoverRegion()
		 */
		public method setDiscoverRegion takes region whichRegion returns nothing
			set this.m_discoverRegion = whichRegion
			call this.updateShrineTrigger()
		endmethod

		public method setRevivalRect takes rect whichRect returns nothing
			set this.m_revivalRect = whichRect
		endmethod

		public method revivalRect takes nothing returns rect
			return this.m_revivalRect
		endmethod

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod

		/**
		 * Sets the shrine's effect path of its effect which is created whenever the shrine is enabled by any character.
		 * \sa defaultEffectPath
		 * \sa effectPath()
		 * \sa hasEffect()
		 */
		public method setEffectPath takes string effectPath returns nothing
			set this.m_effectPath = effectPath
			if (effectPath == null and this.m_discoverEffect != null) then
				call DestroyEffect(this.m_discoverEffect)
				set this.m_discoverEffect = null
			endif
		endmethod

		/**
		 * \sa defaultEffectPath
		 * \sa setEffectPath()
		 * \sa hasEffect()
		 */
		public method effectPath takes nothing returns string
			return this.m_effectPath
		endmethod

		/**
		 * \sa defaultEffectPath
		 * \sa setEffectPath()
		 * \sa effectPath()
		 */
		public method hasEffect takes nothing returns boolean
			return this.effectPath() != null
		endmethod

		/**
		 * Sets the shrine's sound path of its sound which is played whenever the shrine is enabled by any character.
		 * \sa defaultSoundPath
		 * \sa soundPath()
		 * \sa hasSound()
		 */
		public method setSoundPath takes string soundPath returns nothing
			set this.m_soundPath = soundPath
		endmethod

		/**
		 * \sa defaultSoundPath
		 * \sa setSoundPath()
		 * \sa hasSound()
		 */
		public method soundPath takes nothing returns string
			return this.m_soundPath
		endmethod

		/**
		 * \sa defaultSoundPath
		 * \sa setSoundPath()
		 * \sa soundPath()
		 */
		public method hasSound takes nothing returns boolean
			return this.soundPath() != null
		endmethod

		/**
		 * Sets the shrine's message which is displayed to a character's owner whenever the shrine is enabled by the character.
		 * It's displayed of type \ref ACharacter.messageTypeInfo.
		 * \sa defaultMessage
		 * \sa message()
		 * \sa hasMessage()
		 */
		public method setMessage takes string message returns nothing
			set this.m_message = message
		endmethod

		/**
		 * \sa defaultMessage
		 * \sa setMessage()
		 * \sa hasMessage()
		 */
		public method message takes nothing returns string
			return this.m_message
		endmethod

		/**
		 * \sa defaultMessage
		 * \sa setMessage()
		 * \sa message()
		 */
		public method hasMessage takes nothing returns boolean
			return this.message() != null
		endmethod

		// methods

		private method disableForCharacter takes ACharacter character returns nothing
			debug if (character.shrine() == this) then
				call character.setShrine(0)
				if (this.m_discoverEffect != null) then
					call DestroyEffect(this.m_discoverEffect)
					set this.m_discoverEffect = null
				endif
			debug else
				debug call this.print("Is not the shrine of character " + I2S(character) + ".")
			debug endif
		endmethod

		public method enableForCharacter takes ACharacter character, boolean showMessage returns nothing
			local player user = character.player()
			local Shrine oldShrine = character.shrine()
			if (ACharacter.playerCharacter(user).shrine() != 0) then
				call ACharacter.playerCharacter(user).shrine().disableForCharacter(ACharacter.playerCharacter(user)) // disable old
			endif
			call character.setShrine(this)
			call character.revival().setX(GetRandomReal(GetRectMinX(this.revivalRect()), GetRectMaxX(this.revivalRect())))
			call character.revival().setY(GetRandomReal(GetRectMinY(this.revivalRect()), GetRectMaxY(this.revivalRect())))
			call character.revival().setFacing(this.facing())
			if (this.hasEffect()) then
				set this.m_discoverEffect = CreateSpecialEffectForPlayer(user, this.effectPath(), GetDestructableX(this.destructable()), GetDestructableY(this.destructable()))
			endif
			if (this.hasSound()) then
				call PlaySoundFileForPlayer(user, this.soundPath())
			endif
			if (showMessage and this.hasMessage()) then
				call character.displayMessage(ACharacter.messageTypeInfo, this.message())
			endif
			set user = null
			call this.onEnable.evaluate(character, oldShrine)
		endmethod

		/**
		 * Called by .evaluate().
		 * Is triggered whenever \ref enableForCharacter() is called.
		 */
		public stub method onEnable takes ACharacter character, AShrine oldShrine returns nothing
		endmethod

		/**
		 * Called by .evaluate().
		 * Usually calls \ref enableForCharacter() with the corresponding character and shows the message if it has one.
		 */
		public stub method onEnter takes ACharacter character returns nothing
			call this.enableForCharacter(character, true)
		endmethod

		public static method create takes destructable whichDestructable, region discoverRegion, rect revivalRect, real facing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_destructable = whichDestructable
			set this.m_discoverRegion = discoverRegion
			set this.m_revivalRect = revivalRect
			set this.m_facing = facing
			set this.m_effectPath = thistype.defaultEffectPath
			set this.m_soundPath = thistype.defaultSoundPath
			set this.m_message = thistype.defaultMessage

			call this.updateShrineTrigger()
			return this
		endmethod

		private method destroyShrineTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_shrineTrigger)
			set this.m_shrineTrigger = null
		endmethod

		private method destroyDiscoverEffect takes nothing returns nothing
			if (this.m_discoverEffect != null) then
				call DestroyEffect(this.m_discoverEffect)
				set this.m_discoverEffect = null
			endif
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_destructable = null

			call this.destroyShrineTrigger()
			call this.destroyDiscoverEffect()
		endmethod
	endstruct

endlibrary