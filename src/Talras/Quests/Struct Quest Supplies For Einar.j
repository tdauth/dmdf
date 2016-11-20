library StructMapQuestsQuestSuppliesForEinar requires Asl, StructGameCharacter

	struct QuestSuppliesForEinar extends AQuest
		public static constant integer maxSwords = 5
		private integer m_counter

		/// Called with .evaluate().
		private static method onCraftItemFunction takes Character character, integer itemTypeId returns nothing
			local thistype this = thistype.characterQuest.evaluate(character)
			debug call Print(GetUnitName(character.unit()) + " crafts " + GetObjectName(itemTypeId))
			if (itemTypeId == 'I060') then
				set this.m_counter = this.m_counter + 1
				call this.displayUpdateMessage(Format(tre("%1%/%2% Kurzschwerter hergestellt.", "Crafted %1%/%2% Shortswords.")).i(this.m_counter).i(thistype.maxSwords).result())

				if (this.m_counter == thistype.maxSwords) then
					// do not allow forging any more swords
					call SetPlayerAbilityAvailable(this.character().player(), SpellBookOfSmithCraftEinarsSword.abilityId, false)
					call this.questItem(0).complete()
				endif
			endif
		endmethod

		public stub method enable takes nothing returns boolean
			call Character(this.character()).addOnCraftItemFunction(thistype.onCraftItemFunction)
			call SetPlayerAbilityAvailable(this.character().player(), SpellBookOfSmithCraftEinarsSword.abilityId, true)
			return super.enable()
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			local thistype this = thistype(whichQuest)
			local Character character = Character(this.character())
			local integer i = 0
			loop
				exitwhen (i == thistype.maxSwords)
				debug call Print("Remove item type " + GetObjectName('I060'))
				call this.character().inventory().removeItemType('I060')
				set i = i + 1
			endloop

			call character.removeOnCraftItemFunction(thistype.onCraftItemFunction)
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Nachschub für Einar", "Supplies for Einar"))
			local AQuestItem questItem = 0
			set this.m_counter = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp")
			call this.setDescription(tre("Der Waffenhändler Einar aus Talras benötigt fünf geschmiedete Kurzschwerter, die er verkaufen kann. Die Schwerter müsse neu geschmiedet werden. Er möchte keine weiterverkaufte Ware.", "The arms merchant Einar from Talras requires five forged shortswords which he can sell. The swords must be forged newly. He does not want any resold goods."))
			call this.setReward(thistype.rewardExperience, 300)
			call this.setReward(thistype.rewardGold, 1000) // 5 * 150 + 250 reward
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)

			// item 0
			set questItem = AQuestItem.create(this, tre("Schmiede fünf Kurzschwerter für Einar.", "Forge five short swords for Einar."))

			// item 0
			set questItem = AQuestItem.create(this, tre("Bringe Einar die geschmiedeten Kurzschwerter.", "Bring Einar the forged short swords."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.einar())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
