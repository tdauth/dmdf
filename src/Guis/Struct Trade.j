library StructGuisTrade requires Asl, StructGameCharacter

	private struct Offer
		private Trade m_trade
		private integer m_itemTypeId
		private integer m_number
		private integer m_goldAmount

		public method setTrade takes Trade trade returns nothing
			set this.m_trade = trade
		endmethod

		public method trade takes nothing returns Trade
			return this.m_trade
		endmethod

		public method setItemTypeId takes integer itemTypeId returns nothing
			set this.m_itemTypeId = itemTypeId
		endmethod

		public method itemTypeId takes nothing returns integer
			return this.m_itemTypeId
		endmethod

		public method setNumber takes integer number returns nothing
			set this.m_number = number
		endmethod

		public method number takes nothing returns integer
			return this.m_number
		endmethod

		public method setGoldAmount takes integer goldAmount returns nothing
			set this.m_goldAmount = goldAmount
		endmethod

		public method goldAmount takes nothing returns integer
			return this.m_goldAmount
		endmethod

		public method character takes nothing returns Character
			return this.m_trade.character.evaluate()
		endmethod

		public method checkForCharacter takes Character acceptingCharacter returns boolean
			local Character character
			local integer number
			local integer i
			if (acceptingCharacter.gold() < this.m_goldAmount) then
				return false
			endif
			set character = this.character()
			set number = 0
			set i = 0
			loop
				exitwhen (i == AInventory.maxRucksackItems)

				if (character.inventory().rucksackItemData(i) != 0 and character.inventory().rucksackItemData(i).itemTypeId() == this.m_itemTypeId) then
					set number = number + character.inventory().rucksackItemData(i).charges()
				endif

				set i = i + 1
			endloop
			return number == this.m_number
		endmethod

		public method acceptForCharacter takes Character acceptingCharacter returns boolean
			local Character character = this.character()
			local AInventoryItemData itemData
			local integer number
			local integer i
			local item whichItem
			local Offer offer = character.trade().getOffer.evaluate(this)

			// offer doesn't exist anymore
			if (offer == 0) then
				return false
			endif

			if (this.checkForCharacter(acceptingCharacter)) then
				set number = this.m_number
				set i = 0
				loop
					exitwhen (i == AInventory.maxRucksackItems or number == 0)
					set itemData = character.inventory().rucksackItemData(i)

					if (itemData != 0 and itemData == this.m_itemTypeId) then
						set number = number - itemData.charges() // decrease charges afterwards!
						call character.inventory().setRucksackItemCharges(i, itemData.charges() - number)
					endif
					set i = i + 1
				endloop

				call acceptingCharacter.removeGold(this.m_goldAmount)
				call character.addGold(this.m_goldAmount)
				set whichItem = CreateItem(this.m_itemTypeId, GetUnitX(acceptingCharacter.unit()),  GetUnitY(acceptingCharacter.unit()))
				call SetItemCharges(whichItem, this.m_number)
				call UnitAddItem(acceptingCharacter.unit(), whichItem)
				set whichItem = null

				return true
			endif

			return false
		endmethod

		public method compare takes thistype other returns boolean
			return this.m_itemTypeId == other.m_itemTypeId and this.m_number == other.m_number and this.m_goldAmount == other.m_goldAmount and this != other
		endmethod

		public static method create takes Trade trade returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_itemTypeId = 0
			set this.m_number = 0
			set this.m_goldAmount = 0
			// construction members
			set this.m_trade = trade

			return this
		endmethod

		public method copy takes nothing returns thistype
			local thistype result = thistype.create(this.m_trade)
			set result.m_itemTypeId = this.m_itemTypeId
			set result.m_number = this.m_number
			set result.m_goldAmount = this.m_goldAmount
			return this
		endmethod
	endstruct

	/**
	* @todo What should happen when offers are changed while dialog is opened for player?
	* @todo NEW: Selecting an offer creates an offer copy which will be checked again when accepting it. If it's not the same anymore it will be canceled (not destroyed yet, you could accept it later when holding the dialog).
	*/
	struct Trade
		private Character m_character
		private AIntegerVector m_offers
		private Offer m_currentOffer
		private AIntegerVector m_shownOffers
		private AIntegerVector m_currentItemTypeIds
		private AIntegerVector m_currentItemTypeCharges
		private boolean m_creatingNewOffer
		private trigger m_numberTrigger
		private trigger m_goldAmountTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"Trade\"")

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		/// Gets another offer than @param offer !
		public method getOffer takes Offer offer returns Offer
			local integer i = 0
			loop
				exitwhen (i == this.m_offers.size())
				if (Offer(this.m_offers[i]).compare(offer)) then
					return Offer(this.m_offers[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		private method showOffersButtonList takes thistype other returns nothing
			local ADialogButtonAction dialogButtonAction
			local integer i

			if (other == this) then
				set dialogButtonAction = thistype.dialogButtonActionCustomOffer
			else
				set dialogButtonAction = thistype.dialogButtonActionOffer
			endif

			call other.m_shownOffers.clear()
			set i = 0
			loop
				exitwhen (i == this.m_offers.size())
				call AGui.playerGui(other.m_character.player()).dialog().addDialogButtonIndex(GetItemTypeIdName(Offer(this.m_offers[i]).itemTypeId()), dialogButtonAction)
				call other.m_shownOffers.pushBack(this.m_offers[i])
				set i = i + 1
			endloop
		endmethod

		private method showCustomOffersDialog takes nothing returns nothing
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tr("Eigene Angebote"))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBack)

			if (this.m_creatingNewOffer) then
				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Angeboterstellung abbrechen"), thistype.dialogButtonActionCancelNewOffer)
			else
				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Neues Angebot"), thistype.dialogButtonActionNewOffer)
			endif

			call this.showOffersButtonList(this)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method dialogButtonActionCustomOffers takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showCustomOffersDialog()
		endmethod

		private method showViewOffersDialog takes nothing returns nothing
			local integer i
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tr("Angebote (anderer)"))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBack)

			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)

				if (i != GetPlayerId(this.m_character.player()) and Character(ACharacter.playerCharacter(Player(i))).trade() != 0) then
					debug call this.print("Show offers of player id " + I2S(i))
					call Character(ACharacter.playerCharacter(Player(i))).trade().showOffersButtonList(Character(ACharacter.playerCharacter(Player(i))).trade())
				endif

				set i = i + 1
			endloop

			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method dialogButtonActionViewOffers takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showViewOffersDialog()
		endmethod

		private static method dialogButtonActionBackToMainMenu takes ADialogButton dialogButton returns nothing
			local MainMenu mainMenu = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call mainMenu.showDialog.evaluate()
		endmethod

		public method showDialog takes nothing returns nothing
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tr("Handel"))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Eigene Angebote"), thistype.dialogButtonActionCustomOffers)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Angebote betrachten"), thistype.dialogButtonActionViewOffers)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück zum Hauptmenü"), thistype.dialogButtonActionBackToMainMenu)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method dialogButtonActionBack takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showDialog()
		endmethod

		private method cancelNewOffer takes nothing returns nothing
static if (DEBUG_MODE) then
			if (this.m_currentOffer == 0) then
				call this.print("There is no current offer.")
			endif

			if (not this.m_creatingNewOffer) then
				call this.print("Seems to be that you haven't started creating a new offer.")
			endif
endif
			call this.m_currentOffer.destroy()
			set this.m_currentOffer = 0
			set this.m_creatingNewOffer = false
			call DisableTrigger(this.m_numberTrigger)
			call DisableTrigger(this.m_goldAmountTrigger)
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, tr("Angebotserstellung abgebrochen"))
		endmethod

		private static method dialogButtonActionCancelNewOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.cancelNewOffer()
		endmethod

		private method showNewOfferDialog takes nothing returns nothing
			local integer i
			local integer index
			local integer shortcutIndex = 1
			local integer shortcut = '1'
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tr("Neues Angebot"))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBackToCustomOffers)

			if (this.m_currentItemTypeIds != 0) then
				call this.m_currentItemTypeIds.destroy()
				call this.m_currentItemTypeCharges.destroy()
			endif

			set this.m_currentItemTypeIds = AIntegerVector.create()
			set this.m_currentItemTypeCharges = AIntegerVector.create()

			set i = 0
			loop
				exitwhen (i == AInventory.maxRucksackItems)
				if (this.m_character.inventory().rucksackItemData(i) != 0 and this.m_character.inventory().rucksackItemData(i).pawnable()) then // has to be pawnable
					set index = this.m_currentItemTypeIds.find(this.m_character.inventory().rucksackItemData(i).itemTypeId())

					if (index == -1) then
						call this.m_currentItemTypeIds.pushBack(this.m_character.inventory().rucksackItemData(i).itemTypeId())
						call this.m_currentItemTypeCharges.pushBack(IMaxBJ(this.m_character.inventory().rucksackItemData(i).charges(), 1))
					else
						set this.m_currentItemTypeCharges[index] = this.m_currentItemTypeCharges[index] + IMaxBJ(this.m_character.inventory().rucksackItemData(i).charges(), 1)
					endif
				endif
				set i = i + 1
			endloop

			set i = 0
			loop
				exitwhen (i == this.m_currentItemTypeIds.size())
				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(Format("%1% - (%2%)").s(GetItemTypeIdName(this.m_currentItemTypeIds[i])).i(this.m_currentItemTypeCharges[i]).result(), thistype.dialogButtonActionBackOfferItemTypeId)
				set i = i + 1
			endloop

			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method dialogButtonActionNewOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showNewOfferDialog()
		endmethod

		private static method dialogButtonActionBackToCustomOffers takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showCustomOffersDialog()
		endmethod

		private method editCurrentOfferNumber takes nothing returns nothing
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, tr("Geben Sie bitte die Anzahl im Chat ein."))
			call EnableTrigger(this.m_numberTrigger)
		endmethod

		private method createNewOffer takes integer index returns nothing
			set this.m_currentOffer = Offer.create(this)
			debug call this.print("Creating offer with item type id " + I2S(this.m_currentItemTypeIds[index]))
			call this.m_currentOffer.setItemTypeId(this.m_currentItemTypeIds[index])
			call this.m_currentOffer.setNumber(1)
			call this.m_currentOffer.setGoldAmount(999999999999)
			set this.m_creatingNewOffer = true
			call this.editCurrentOfferNumber()
		endmethod

		private static method dialogButtonActionBackOfferItemTypeId takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.createNewOffer(dialogButton.index() - 1) //- back button
		endmethod

		private static method dialogButtonActionEditOfferNumber takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.editCurrentOfferNumber()
		endmethod

		private method editCurrentOfferGoldAmount takes nothing returns nothing
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, tr("Geben Sie bitte den Preis im Chat ein."))
			call EnableTrigger(this.m_goldAmountTrigger)
		endmethod

		private static method dialogButtonActionEditOfferGoldAmount takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.editCurrentOfferGoldAmount()
		endmethod

		private method removeCurrentOffer takes nothing returns nothing
			call this.m_currentOffer.destroy()
			call this.m_offers.remove(this.m_currentOffer)
			call this.showCustomOffersDialog()
		endmethod

		private static method dialogButtonActionRemoveOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.removeCurrentOffer()
		endmethod

		private static method getOfferDialogTitle takes Offer offer returns string
			return IntegerArg(IntegerArg(StringArg(tr("%s|nAnzahl: %i|nPreis: %i"), GetItemTypeIdName(offer.itemTypeId())), offer.number()), offer.goldAmount())
		endmethod

		private method showCustomOfferDialog takes integer index returns nothing
			set this.m_currentOffer = this.m_offers[index]
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(thistype.getOfferDialogTitle(Offer(this.m_offers[index])))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBackToCustomOffers)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Anzahl bearbeiten"), thistype.dialogButtonActionEditOfferNumber)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Preis bearbeiten"), thistype.dialogButtonActionEditOfferGoldAmount)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Angebot zurückziehen"), thistype.dialogButtonActionRemoveOffer)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method dialogButtonActionBackToOffers takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.m_currentOffer.destroy() // destroy the copy
			set this.m_currentOffer = 0
			call this.showViewOffersDialog()
		endmethod

		private method showOfferDialog takes integer index returns nothing
			set this.m_currentOffer = Offer(this.m_shownOffers[index]).copy()
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(thistype.getOfferDialogTitle(this.m_currentOffer))
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBackToOffers)
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Annehmen"), thistype.dialogButtonActionAcceptOffer)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private method acceptCurrentOffer takes nothing returns nothing
			local Offer offer

			if (this.m_currentOffer.acceptForCharacter(this.m_character)) then
				call this.m_character.displayMessage(ACharacter.messageTypeInfo, StringArg(tr("Sie haben %s's Angebot angenommen"), this.m_currentOffer.character().name()))
				call this.m_currentOffer.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tr("%s hat Ihr Angebot angenommen"), this.m_character.name()))
				set offer = this.m_currentOffer.trade().getOffer(this.m_currentOffer)
				call offer.trade().m_offers.remove(offer)
				call offer.destroy() // real offer

				call this.m_currentOffer.destroy() // offer copy
				set this.m_currentOffer = 0
				call this.showViewOffersDialog()
			else
				call this.m_character.displayMessage(ACharacter.messageTypeError, StringArg(tr("%s's Angebot ist nicht mehr gültig oder zu teuer."), this.m_currentOffer.character().name()))

				call this.showOfferDialog(this.m_shownOffers.find(this.m_currentOffer))
			endif
		endmethod

		private static method dialogButtonActionAcceptOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.acceptCurrentOffer()
		endmethod

		private static method dialogButtonActionCustomOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			debug call Print("Show custom offer")
			call this.showCustomOfferDialog(dialogButton.index() - 2) //- back button, - new /cancel offer button
		endmethod

		private static method dialogButtonActionOffer takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).trade()
			call this.showOfferDialog(dialogButton.index() - 1) //- back button
		endmethod

		private static method triggerActionSetNumber takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = Character(ACharacter.playerCharacter(triggerPlayer)).trade()
			local integer number = S2I(GetEventPlayerChatString())
			call this.m_currentOffer.setNumber(number)
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Die Anzahl beträgt %i."), number))

			if (this.m_creatingNewOffer) then
				/// @todo If gold amount trigger is enabled immediatly after triggering this it is triggered by the same chat event!
				call TriggerSleepAction(1.0) //test
				call this.editCurrentOfferGoldAmount()
			endif

			call DisableTrigger(triggeringTrigger)
			set triggeringTrigger = null
			set triggerPlayer = null
		endmethod

		private method createNumberTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_numberTrigger = CreateTrigger()
			set triggerEvent =  TriggerRegisterPlayerChatEvent(this.m_numberTrigger, this.m_character.player(), "", false)
			set triggerAction = TriggerAddAction(this.m_numberTrigger, function thistype.triggerActionSetNumber)
			call DisableTrigger(this.m_numberTrigger)
			set triggerEvent = null
			set triggerAction = null
		endmethod

		private static method triggerActionSetGoldAmount takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = Character(ACharacter.playerCharacter(triggerPlayer)).trade()
			local integer goldAmount = S2I(GetEventPlayerChatString())
			call this.m_currentOffer.setGoldAmount(goldAmount)
			call this.m_character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("Der Preis beträgt %i."), goldAmount))

			if (this.m_creatingNewOffer) then
				call this.m_offers.pushBack(this.m_currentOffer)
				set this.m_creatingNewOffer = false
			endif

			call DisableTrigger(triggeringTrigger)
			call this.showCustomOffersDialog()
			set triggeringTrigger = null
			set triggerPlayer = null
		endmethod

		private method createGoldAmountTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_goldAmountTrigger = CreateTrigger()
			set triggerEvent =  TriggerRegisterPlayerChatEvent(this.m_goldAmountTrigger, this.m_character.player(), "", false)
			set triggerAction = TriggerAddAction(this.m_goldAmountTrigger, function thistype.triggerActionSetGoldAmount)
			call DisableTrigger(this.m_goldAmountTrigger)
			set triggerEvent = null
			set triggerAction = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_offers = AIntegerVector.create()
			set this.m_currentOffer = 0
			set this.m_shownOffers = AIntegerVector.create()
			set this.m_currentItemTypeIds = 0
			set this.m_currentItemTypeCharges = 0
			set this.m_creatingNewOffer = false
			call this.createNumberTrigger()
			call this.createGoldAmountTrigger()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_offers.destroy()
			call this.m_shownOffers.destroy()

			if (this.m_currentItemTypeIds != 0) then
				call this.m_currentItemTypeIds.destroy()
				call this.m_currentItemTypeCharges.destroy()
			endif

			call DestroyTrigger(this.m_numberTrigger)
			set this.m_numberTrigger = null
			call DestroyTrigger(this.m_goldAmountTrigger)
			set this.m_goldAmountTrigger = null
		endmethod
	endstruct

endlibrary