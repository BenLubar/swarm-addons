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

function InputFireUser1() {
	batteryMaker.SpawnEntityAtEntityOrigin(caller)
	return false
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

	local chance = 0.3 - 0.01 * difficulty
	if (chance < 0.05) {
		chance = 0.05
	}

	if (RandomFloat(0, 1) < chance) {
		EntityOutputs.AddOutput(alien, "OnDeath", "@gamerules", "FireUser1", "", 0, -1)
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
