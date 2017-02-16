library StructGameMissions requires Asl, StructGameCharacter, StructGameOptions

	function PanToQuestForPlayer takes player whichPlayer, AQuest whichQuest returns nothing
		debug call Print("Pinging mission " + whichQuest.title())
		call SmartCameraPanWithZForPlayer(whichPlayer, whichQuest.latestPingX(), whichQuest.latestPingY(), 0.0, 0.0)
	endfunction

	/**
	 * \brief Every character gets an item with a spellbook ability which contains icons for all active missions. Clicking on an icon pans the camera to the mission's target location.
	 */
	struct Missions extends AMultipageSpellbook
		private Character m_character

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method addMission takes integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns integer
			return this.addEntry(MissionEntry.create.evaluate(this, abilityId, spellBookAbilityId, whichQuest))
		endmethod

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate(whichUnit, 'A1RH', 'A1RJ', 'A1RC', 'A1RI')
			set this.m_character = character
			call this.setShortcut(tre("A", "A"))
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod

		public static method addMissionToAll takes integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns nothing
			local Character character = 0
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set character = Character.playerCharacter(Player(i))
				if (character != 0) then
					call character.options().missions().addMission(abilityId, spellBookAbilityId, whichQuest)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

	/**
	 * \brief The entry for a single quest which can be clicked at and moves the player's camera to the curretn quest target location.
	 */
	struct MissionEntry extends AMultipageSpellbookAction
		private AQuest m_quest

		public method missions takes nothing returns Missions
			return Missions(this.multipageSpellbook())
		endmethod

		public method quest takes nothing returns AQuest
			return this.m_quest
		endmethod

		public stub method onCheck takes nothing returns boolean
			if (not this.quest().isNew()) then
				call this.missions().character().displayMessage(ACharacter.messageTypeError, tre("Auftrag wurde bereits abgeschlossen.", "Mission has already been completed."))

				return false
			endif

			return true
		endmethod

		public stub method onTrigger takes nothing returns nothing
			if (this.quest().hasLatestPing()) then
				call PanToQuestForPlayer(this.missions().character().player(), this.quest())
			else
				call this.missions().character().displayMessage(ACharacter.messageTypeError, tre("Auftrag hat kein Zielgebiet.", "Mission has no target location."))
			endif
		endmethod

		public static method create takes Missions missions, integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns thistype
			local thistype this = thistype.allocate(missions, abilityId, spellBookAbilityId)
			set this.m_quest = whichQuest

			return this
		endmethod
	endstruct

endlibrary