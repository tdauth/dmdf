library StructGameTutorial requires Asl, StructGameCharacter, StructGameSpawnPoint

	/**
	 * Provides some functionality which helps players to find their way through the game.
	 * It shows a message when a players character enables a shrine the first time.
	 * Usually there's one Tutorial instance per character which can be accessed via \ref Character#tutorial().
	 * All provided infos can be disabled via \ref setEnabled().
	 */
	struct Tutorial
		// dynamic members
		private boolean m_isEnabled
		// construction members
		private Character m_character
		// members
		private boolean m_hasEnteredShrine
		private trigger m_killTrigger

		public method setEnabled takes boolean enabled returns nothing
			set this.m_isEnabled = enabled
		endmethod

		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method hasEnteredShrine takes nothing returns boolean
			return this.m_hasEnteredShrine
		endmethod

		public method showShrineInfo takes nothing returns nothing
			call this.m_character.displayHint(Format(tre("Schreine dienen der Wiederbelebung Ihres Charakters. Sobald Ihr Charakter stirbt, wird er nach einer Dauer von %1% Sekunden an seinem aktivierten Schrein wiederbelebt. Es kann immer nur ein Schrein aktiviert sein. Ein Schrein wird aktiviert, indem der Charakter dessen näheres Umfeld betritt. Dabei wird der zuvor aktivierte Schrein automatisch deaktiviert.", "Shrines serve the revival of your character. As soon as your character dies he will be revived automatically after a duration of %1% seconds at his enabled shrine. There can only be one shrine activated at once. A shrine is being activated when the character enters its near surroundings. Here, the previously activated shrine is disabled automatically.")).i(R2I(MapData.revivalTime)).result())
			set this.m_hasEnteredShrine = true
		endmethod

		private static method triggerConditionKill takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this") 
			return GetKillingUnit() == this.character().unit() and this.isEnabled() and MapData.playerGivesXP.evaluate(GetOwningPlayer(GetTriggerUnit()))
		endmethod
		
		private static method triggerActionKill takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this") 
			call DisableTrigger(GetTriggeringTrigger())
			call this.character().displayHint(tre("Immer wenn Ihr Charakter einen Unhold tötet, erhalten alle Charaktere gleichmäßig viel Erfahrung und Beute für diesen.", "Whenever your character kills a creep all characters gain equally much experience and bounty for him."))
			set this.m_killTrigger = null
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_isEnabled = false
			// construction members
			set this.m_character = character
			// members
			set this.m_hasEnteredShrine = false

			call this.setEnabled(false)
			
			/*
			 * This trigger shows information about XP and bounty share of killing enemies.
			 */
			set this.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_killTrigger, Condition(function thistype.triggerConditionKill))
			call TriggerAddAction(this.m_killTrigger, function thistype.triggerActionKill)
			call DmdfHashTable.global().setHandleInteger(this.m_killTrigger, "this", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			if (this.m_killTrigger != null) then
				call DmdfHashTable.global().destroyTrigger(this.m_killTrigger)
			endif
		endmethod
		
		private static method onInit takes nothing returns nothing
			local quest whichQuest
			local questitem questItem
			/*
			 * Hint quest entries:
			 */
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Chat-Befehle", "Chat Commands"))
			call QuestSetDescription(whichQuest, tre("Die obigen Befehle können im Chat verwendet werden.", "The commands at the top can be used in the chat."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-menu\" öffnet das Hauptmenü.", "\"-menu\" opens the main menu."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-repick\" erlaubt die Wahl einer anderen Klasse.", "\"-repick\" allows the selection of a different class."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-save\" erlaubt das Speichern des Charakters.", "\"-save\" allows the storage of the character."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-load <Save-Code>\" erlaubt das Laden eines Charakters.", "\"-load <save code>\" allows the loading of a character."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-history n\" zeigt die n letzten Spielnachrichten an (standardmäßig fünf).", "\"-history n\" shows the recent n game messages (by default five)."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-clear\" leert den Bildschirm von Spielnachrichten.", "\"-clear\" clears the screen from game messages."))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Emotes", "Emotes"))
			call QuestSetDescription(whichQuest, tre("Emotes erlauben das Ausdrücken bestimmter Emotionen durch eine Animation Ihres Charakters.", "Emotes allow expressing certain emotions by an animation of your character."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, "\"-dance\"")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, "\"-pray\"")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, "\"-magic\"")
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Klassen", "Classes"))
			call QuestSetDescription(whichQuest, tre("Die Klasse Ihres Charakters muss zu Beginn des Spiels gewählt werden. Sie bestimmt, welche Zauber Ihr Charakter erlernen kann und welche Attributwerte Ihr Charakter besitzt. Außerdem hat die Klasse Einfluss auf Gespräche Ihres Charakters mit anderen Personen. Die Klasse kann dennoch mit \"-repick\" neu bestimmt werden.", "The class of your character has to be chosen in the beginning of the game. It defines which spells your character can learn and which attribute values your character has. Besides the class has influence on conversations of your character with other persons. However the class can be defined newly with \"-repick\"."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNVillagerMan.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Kleriker: Heil- und Schutzzauber", "Cleric: Healing and protection spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Nekromant: Beschwörungs- und Schadenszauber", "Necromancer: Summon and damage spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Druide: Heil- und Verwandlungszauber", "Druid: Healing and transformation spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Ritter: Auren und Kampfzauber", "Knight: Auras and combat spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Drachentöter: Kampf- und Beutezauber", "Dragon Slayer: Combat and bounty spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Waldläufer: Fernkampfzauber", "Waldläufer: Range combat spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Elementarmagier: Schadenszauber", "Elemental Mage: Damage spells"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Zauberer: Manazauber", "Wizard: Mana spells"))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Aufträge", "Missions"))
			call QuestSetDescription(whichQuest, tre("Aufträge im Spiel bestehen aus einem oder mehreren Zielen, die allesamt erfüllt werden müssen. Aufträge geben meist Belohnungen wie zusätzliche Erfahrungspunkte, Goldmünzen oder Gegenstände. Gemeinsame Aufträge müssen von allen Spielern gemeinsam erledigt werden, um die Handlung des Spiels voranzubringen. Eigene Aufträge können optional von jedem Spieler einzeln erledigt werden, um zusätzliche Belohnungen zu erhalten.", "Missions in the game consists of one or several objectives which has to be solved alltogether. Missions mostly give rewards like additional experience points, gold coins or items. Shared missions have to be solved by all players together to continue the plot of the game. Own missions can be solved optionally by each player to get additional rewards."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Der Gegenstand \"Aufträge\" ermöglicht die Anzeige der Ziel-Orte von Aufträgen.", "The item \"Missions\" allows you to show the target locations of missions."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Gemeinsame Aufträge müssen von allen Spielern gemeinsam erledigt werden.", "Shared missions must be completed together."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Eigene Aufträge kann jeder Spieler für sich selbst erledigen (optional).", "Custom missions can be solved by every player himself (optionally)."))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Ausrüstung", "Equipment"))
			call QuestSetDescription(whichQuest, tre("Es gibt fünf verschiede Ausrüstungstypen. Von jedem Typ kann genau ein Gegenstand angelegt werden. Das letzte Fach bleibt dauerhaft leer, damit weiterhin Gegenstände eingesammelt werden können.", "There is five different equipment types. Of each type exactly one item can be equipped. The last slot stays permanently empty to still allow picking up items."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNHelmutPurple.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf denselben Gegenstand verschiebt den Gegenstand in den Rucksack.", "RM on item and LM on the same item moves the item in the rucksack."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Ausrüstungstypen: Helm, Rüstung, Erstwaffe, Zweitwaffe, Amulett/Ring", "Equipment types: helmet, armour, primary weapon, secondary weapon, amulet/ring"))
			
			 
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Rucksack", "Backpack"))
			call QuestSetDescription(whichQuest, tre("Mit der Rucksackfähigkeit kann der Rucksack geöffnet werden. Es werden drei Gegenstände pro Tasche angezeigt. Die angezeigte Tasche kann gewechselt werden, indem man auf einen der beiden Taschengegenstände klickt.", "With the backpack ability the rucksack can be open. Three items per bag will be shown. The shown bag can be changed by clicking on one of the two bag items."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf denselben Gegenstand rüstet den Gegenstand aus.", "RM on item and LM on the same item equips the item."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf anderen Gegenstand stapelt oder vertauscht die Gegenstände.", "RM on item and LM on another item stacks or swaps the items."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf den Boden legt eine Ladung des Gegenstands ab.", "RM on item and LM on the ground drops one charge of the item."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf anderen Charakter gibt dem anderen eine Ladung des Gegenstands.", "RM on item and LM on another character gives one charge of the item to the other."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf das vierte dauerhaft freie Slot legt den Gegenstand mit allen Ladungen ab.", "RM on item and LM on the fourth permanently empty slot drops the item with all charges."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf einen Taschengegenstand verschiebt den Gegenstand in eine andere Tasche.", "RM on item and LM on a bag item moves the item to another bag."))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Schreine", "Shrines"))
			call QuestSetDescription(whichQuest, Format(tre("Schreine dienen der Wiederbelebung des Charakters. Es kann immer nur ein Schrein aktiviert werden. An diesem Schrein wird der Charakter nach %1% Sekunden wiederbelebt, wenn er gestorben ist. Den aktiven Schrein erreicht man über das Symbol links unten oder mit F8. Zu allen erkundeten Schreinen kann sich der Charakter mit Hilfe der Spruchrolle des Totenreichs teleportieren.", "Shrines are for the revival of the character. There can only be one shrine activated all the time. At this shrine the character will be revived after %1% seconds when he died. The active shrine can be reached over the symbol at the left bottom or by F8. The character can teleport himself to all discovered shrines by using the Scroll of the Realm of the Dead.")).i(R2I(MapData.revivalTime)).result())
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNResStone.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Die Spruchrolle des Totenreichs ermöglicht den Teleport zu einem erkundeten Schrein.", "The Scroll of the Realm of Death allows teleporting to a discovered shrine."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Die Spruchrolle der Ahnen ermöglicht den Teleport zu einem erkundeten Schrein mit verbündeten Einheiten.", "The Scroll of the Ancestors allows teleporting to a discovered shrine together with allied units."))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Gespräche mit Personen", "Conversations with Persons"))
			call QuestSetDescription(whichQuest, tre("Einige computergesteuerte Personen im Spiel bieten Gespräche an. Befindet sich der Charakter in der Nähe einer Person und ist der Charakter ausgewählt, so kann man mit einem Linksklick die entsprechende Person auswählen und mit einem Linksklick auf \"Person ansprechen\" ein Gespräch mit der Person beginnen. Einzelne Sätze können während des Gesprächs mit Escape übersprungen werden.", "Some Computer controlled persons in the game provide conversations. Is a character near to a person and is the character selected you can select the corresponding person with a left click and start a conversation with the person by a left click on \"Speak to person\". Separate sentences can be skipped by Escape during the conversation."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNTalking2.blp")
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Händler", "Merchants"))
			call QuestSetDescription(whichQuest, tre("Einige der computergesteuerte Personen verkaufen Waren an einem Stand. Andere verkaufen Waren aus ihrer Kiste. An den Ständen und Kisten können eigene Gegenstände für ihren Wert in Goldmünzen verkauft werden. Dazu muss ein Gegenstand mit einem Rechtsklick ausgewählt und mit einem Linksklick auf dem entsprechenden Stand oder der entsprechenden Kiste platziert werden.", "Some Computer controlled persons sell goods at a stall. Others sell goods from their box. At stalls and boxes own items can be selled for their value in gold coins. For this an item must be selected with a right click and be placed with a left click on the corresponding stall or the corresponding box."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNMerchant.blp")
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Erfahrung", "Experience"))
			call QuestSetDescription(whichQuest, tre("Die maximale Stufe ist 30. Auf Stufe 12 und Stufe 25 kann jeweils eine Ultimate-Fähigkeit erlernt werden. Erfahrung vom Töten von Unholden wird gleichmäßig auf alle Charaktere in der gesamten Karte verteilt. Aufträge geben weitaus mehr Erfahrung als das Töten von Unholden.", "The maximum level is 30. At leve l2 and level 25 each there can be learned an ultimate ability. Experience from killing of creeps will be distributed equally to the characters in the whole map. Quests give much more experience than the killing of creeps."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Erfahrung für Unholde: Unholderfahrung / Anzahl der Spieler", "Experience for creeps: Creep experience / Number of players"))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Goldmünzen", "Gold Coins"))
			call QuestSetDescription(whichQuest, tre("Goldmünzen erhält man für Aufträge und das Töten von Unholden. Die Goldmünzen durch das Töten von Unholden werden gleichmäßig an alle Charaktere auf der gesamten Karte verteilt. Aufträge geben weitaus mehr Goldmünzen als das Töten von Unholden.", "Gold coins are gained for quests and the killing of creeps. The gold coins gained by the killing of creeps will be distributed equally to all characters on the whole map. Quests give much more gold coins than the killing of creeps."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Goldmünzen für Unholde: Unholdstufe * 2 / Anzahl der Spieler", "Gold coins for creeps: Creep level / Number of players"))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Zauber", "Spells"))
			call QuestSetDescription(whichQuest, tre("Jede Klasse besitzt 15 verschiedene Zauber. Diese können im Einheitenmenü \"Zauber erlernen\" des Charakters erlernt werden. Einen Grundzauber dessen Stufe stets eins ist und der von Anfang erlernt wurde. Zwei Ultimativ-Zauber mit einer Stufe, die auf Stufe 12 und auf Stufe 25 erlernt werden können und zwölf gewöhnliche Zauber mit jeweils fünf Stufen. Das Erhöhen der Stufe eines Zaubers kostet einen Zauberpunkt. Pro Stufe erhält ein Charakter zwei Zauberpunkte. Er startet jedoch mit bereits drei Zauberpunkten. Zauberstufen können jederzeit wieder zurückgesetzt werden.", "Each class has 15 different spells. They can be learned in the unit menu \"Learn spells\" of the character. One basic spell of which the level is always one and which is learned from the beginning. Two ultimate spells with one level which can be learned at level 12 and level 25 and twelve usual spells with five levels each. Increasing the level of a spell costs one skill point. Per level a character gains two skill points. Yet he starts with already three skill points. Spell levels can be always be reset."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBook.blp")
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Berufe", "Professions"))
			call QuestSetDescription(whichQuest, tre("Um bestimmte Gegenstände herzustellen, können Bücher mit Rezepten oder Plänen erworben werden. Darin befindet sich eine Liste der herstellbaren Gegenstände. Jeder Gegenstand benötigt Rohstoffe, die sich im Rucksack befinden müssen, damit der Gegenstand hergestellt werden kann.", "To craft specific items books with receipts or plans can be acquired. They contain a list of craftable items. Each item requires resources which has to be in the backpack that the item can be crafted."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Buch der Tränke", "Book of Potions"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Buch der Schmiedekunst", "Book of Forging"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Buch der Magie", "Book of Magic"))
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Stützpunkte", "Bases"))
			call QuestSetDescription(whichQuest, tre("Jeder Spieler kann einen einzigen Stützpunkt errichten. Der Stützpunkt ist ein Gebäude, das abhängig von der Klasse des Spielercharakters ist. Um einen Stützpunkt zu errichten, muss ein entsprechender Bauplan bei einem Baumeister gekauft werden.", "Each player can construct one single base. The base is a building which is dependant on the class of the player character. To construct a base a corresponding construction plan has to be purchased from a builder."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNTinyCastle.blp")
			
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Kontakt", "Contact"))
			call QuestSetDescription(whichQuest, tre("E-Mail: barade.barade@web.de\nWebsite: http://wc3lib.org", "Email: barade.barade@web.de\nWebsite: http://wc3lib.org"))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPossession.blp")
			
		endmethod
		
		/**
		 * Prints a hint message to all players which have the tip system enabled.
		 */
		public static method printTip takes string tip returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character(Character.playerCharacter(Player(i))).tutorial().isEnabled()) then
					call Character(Character.playerCharacter(Player(i))).displayHint(tip)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary