library StructMapQuestsQuestSuppliesForEinar requires Asl, StructGameCharacter

	struct QuestSuppliesForEinar extends AQuest
		public static constant integer maxSwords = 5
		private integer m_counter

		implement CharacterQuest
		
		private static method onCraftItemFunction takes Character character, integer itemTypeId returns nothing
			debug call Print(GetUnitName(character.unit()) + " crafts " + GetObjectName(itemTypeId))
			if (itemTypeId == 'I01Y') then
				call character.inventory().removeItemType('I01Y')
				call character.giveQuestItem('I060')
				
				set QuestSuppliesForEinar.characterQuest(character).m_counter = QuestSuppliesForEinar.characterQuest(character).m_counter + 1
				call QuestSuppliesForEinar.characterQuest(character).displayUpdateMessage(Format(tr("%1%/%2% Kurzschwerter hergestellt.")).i(QuestSuppliesForEinar.characterQuest(character).m_counter).i(thistype.maxSwords).result())
				
				if (QuestSuppliesForEinar.characterQuest(character).m_counter == thistype.maxSwords) then
					call character.removeOnCraftItemFunction(thistype.onCraftItemFunction)
					call QuestSuppliesForEinar.characterQuest(character).questItem(0).complete()
				endif
			endif
		endmethod

		public stub method enable takes nothing returns boolean
			call Character(this.character()).addOnCraftItemFunction(thistype.onCraftItemFunction)
			return super.enable()
		endmethod
		
		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			local thistype this = thistype(whichQuest)
			local integer i = 0
			loop
				exitwhen (i == thistype.maxSwords)
				debug call Print("Remove item type " + GetObjectName('I060'))
				call this.character().inventory().removeItemType('I060')
				set i = i + 1
			endloop
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Nachschub für Einar"))
			local AQuestItem questItem
			set this.m_counter = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNLongsword.blp")
			call this.setDescription(tr("Der Waffenhändler Einar aus Talras benötigt fünf geschmiedete Kurzschwerter, die er verkaufen kann. Die Schwerter müsse neu geschmiedet werden. Er möchte keine weiterverkaufte Ware."))
			call this.setReward(thistype.rewardExperience, 300)
			call this.setReward(thistype.rewardGold, 1000) // 5 * 150 + 250 reward
			call this.setStateAction(thistype.stateActionCompleted, thistype.stateActionCompleted)
			
			// item 0
			set questItem = AQuestItem.create(this, tr("Schmiede fünf Kurzschwerter für Einar."))
			
			// item 0
			set questItem = AQuestItem.create(this, tr("Bringe Einar die geschmiedeten Kurzschwerter."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.einar())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			return this
		endmethod
	endstruct

endlibrary
