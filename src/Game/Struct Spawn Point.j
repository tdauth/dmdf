library StructGameSpawnPoint requires Asl

	struct SpawnPoint extends ASpawnPoint
		public static constant real respawnTime = 60.0
	
		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setTime(thistype.respawnTime)
			call this.setEffectFilePath("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
			call this.setSoundFilePath("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerMorph.wav")
			call this.setDropChance(70)
			call this.setDistributeItems(true)
			call this.setOwner(Player(PLAYER_NEUTRAL_AGGRESSIVE))
			call this.setTextDistributeItem( tr("%s wurde für Spieler %s fallen gelassen."))
	
			return this
		endmethod
		
	endstruct
	
	struct ItemSpawnPoint extends AItemSpawnPoint
		public static constant real respawnTime = 20.0

		public static method create takes real x, real y, item whichItem returns thistype
			local thistype this = thistype.allocate(x, y, whichItem)
			call this.setTime(thistype.respawnTime)
			call this.setEffectFilePath("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
			call this.setSoundFilePath("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerMorph.wav")

			return this
		endmethod

	endstruct

endlibrary