/**
 * The mission spells are spell book abilities which allow the player to pan the camera to the active quest locations.
 * Otherwise he would only see the quest pings on the map.
 */
library StructMapSpellsSpellMissions requires Asl, StructGameCharacter, MapQuests

	function PanToQuestForPlayer takes player whichPlayer, AQuest whichQuest returns nothing
		if (whichQuest.pingWidget() != null) then
			call SmartCameraPanWithZForPlayer(whichPlayer, GetWidgetX(whichQuest.latestPingWidget()), GetWidgetY(whichQuest.latestPingWidget()), 0.0, 0.0)
		else
			call SmartCameraPanWithZForPlayer(whichPlayer, whichQuest.latestPingX(), whichQuest.latestPingY(), 0.0, 0.0)
		endif
	endfunction

	struct SpellMissionTalras extends ASpell
		public static constant integer abilityId = 'A1BZ'
		
		private method condition takes nothing returns boolean
			if (not QuestTalras.quest().isNew()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Auftrag wurde bereits abgeschlossen."))
				
				return false
			endif
			
			return true
		endmethod
		
		private method action takes nothing returns nothing
			call PanToQuestForPlayer(this.character().player(), QuestTalras.quest())
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellMissionTheNorsemen extends ASpell
		public static constant integer abilityId = 'A1C0'
		
		private method condition takes nothing returns boolean
			if (not QuestTheNorsemen.quest().isNew()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Auftrag wurde bereits abgeschlossen."))
				
				return false
			endif
			
			return true
		endmethod
		
		private method action takes nothing returns nothing
			call PanToQuestForPlayer(this.character().player(), QuestTheNorsemen.quest())
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
		
		private static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SetPlayerAbilityAvailable(Player(i), thistype.abilityId, false)
				set i = i + 1
			endloop
		endmethod
	endstruct
	
	struct SpellMissionSlaughter extends ASpell
		public static constant integer abilityId = 'A1C1'
		
		private method condition takes nothing returns boolean
			if (not QuestSlaughter.quest().isNew()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Auftrag wurde bereits abgeschlossen."))
				
				return false
			endif
			
			return true
		endmethod
		
		private method action takes nothing returns nothing
			call PanToQuestForPlayer(this.character().player(), QuestSlaughter.quest())
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
		
		private static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SetPlayerAbilityAvailable(Player(i), thistype.abilityId, false)
				set i = i + 1
			endloop
		endmethod
	endstruct
	
endlibrary