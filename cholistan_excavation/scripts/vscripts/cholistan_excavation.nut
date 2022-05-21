excavatorsActive <- Entities.FindByName(null, "@excavators_active")
excavationsComplete <- Entities.FindByName(null, "@excavations_complete")
batteryMaker <- Entities.FindByName(null, "@battery_maker")

::g_GameRulesScope <- self.GetScriptScope()

function UpdateExcavatorsActive() {
	EntityOutputs.GetValue(excavatorsActive, "OutValue")
}

function UpdateExcavationsComplete() {
	EntityOutputs.GetValue(excavationsComplete, "OutValue")
}

function SpawnBatteryWhereAlienDied() {
	batteryMaker.SpawnEntityAtEntityOrigin(caller)
}

function ReplaceNamedTargetsWithLoot() {
	local names = [
		"@random_empty_weapon",
		"@random_empty_weapon_constrained",
		"@random_small_pickup",
	]
	foreach (name in names) {
		local randomSpawn = Entities.FindByName(null, name)
		if (randomSpawn == null) {
			continue
		}

		local choices = []
		local maker = null
		while (maker = Entities.FindByName(maker, name + "_maker")) {
			choices.push(maker)
		}
		printl("selecting for " + name)

		while (randomSpawn) {
			maker = choices[RandomInt(0, choices.len() - 1)]
			maker.SpawnEntityAtEntityOrigin(randomSpawn)

			local prev = randomSpawn
			randomSpawn = Entities.FindByName(randomSpawn, name)
			prev.Destroy()
		}
	}
}

function MaybeMakeAlienCarrier(alien) {
	local batteryCount = 0
	local battery = null
	while (battery = Entities.FindByName(battery, "@battery_weapon")) {
		batteryCount++
	}

	if (batteryCount > 100) {
		return
	}

	local difficulty = EntityOutputs.GetValue(self, "MissionDifficulty")
	if (difficulty == null) {
		return
	}

	local chance = 0.2 - 0.01 * difficulty
	if (chance < 0.01) {
		chance = 0.01
	}

	if (RandomFloat(0, 1) < chance) {
		EntityOutputs.AddOutput(alien, "OnDeath", "@gamerules", "RunScriptCode", "SpawnBatteryWhereAlienDied()", 0, -1)
		EntFireByHandle(alien, "Color", "48 128 192", 0.0, alien, alien)
	}
}

::OnGameEvent_alien_spawn <- function(params) {
	local alien = EntIndexToHScript(params.entindex)
	g_GameRulesScope.MaybeMakeAlienCarrier(alien)
}

::OnGameEvent_buzzer_spawn <- function(params) {
	local alien = EntIndexToHScript(params.entindex)
	g_GameRulesScope.MaybeMakeAlienCarrier(alien)
}
