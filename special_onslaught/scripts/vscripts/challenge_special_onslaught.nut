function SpecialOnslaughtGlobalOn() {
	EntFireByHandle(env_global, "TurnOn", "", 0, env_global, env_global);
}

function SpecialOnslaughtGlobalOff() {
	EntFireByHandle(env_global, "TurnOff", "", 0, env_global, env_global);
}

function NewGlobal(name) {
	env_global <- Entities.CreateByClassname("env_global");
	env_global.__KeyValueFromString("globalstate", name);
	EntFireByHandle(env_global, "TurnOff", "", 0, env_global, env_global);

	return env_global;
}

function StartFinale() {
	Director.StartFinale();
}

function ResetIntensity() {
	Director.ResetIntensityForAllMarines();
}

if (GetMapName().tolower() == "rd-tft1desertoutpost") {
	finaleRelay <- Entities.FindByName(null, "intro_start_camera");
	finaleRelay.ValidateScriptScope();
	finaleRelay.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleRelay.ConnectOutput("OnTrigger", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "tft2abandonedmaintenance") {
	backupGenerator <- Entities.FindByName(null, "backup_generator_button");
	backupGenerator.ValidateScriptScope();
	backupGenerator.GetScriptScope().SpecialOnslaughtResetIntensity <- ResetIntensity;
	backupGenerator.ConnectOutput("OnTrigger", "SpecialOnslaughtResetIntensity");

	finaleGenerator <- Entities.FindByName(null, "can_activate");
	finaleGenerator.ValidateScriptScope();
	finaleGenerator.GetScriptScope().SpecialOnslaughtResetIntensity <- ResetIntensity;
	finaleGenerator.ConnectOutput("OnTrigger", "SpecialOnslaughtResetIntensity");

	finaleTrigger <- Entities.FindByName(null, "trigger_final_run");
	finaleTrigger.ValidateScriptScope();
	finaleTrigger.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleTrigger.ConnectOutput("OnTrigger", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "rd-tft3spaceport") {
	env_global_tft_spaceport_shieldbug <- NewGlobal("special_onslaught_tft_spaceport_shieldbug");

	shieldbugRetreat <- Entities.FindByName(null, "ss_shield_bug_retreat");
	shieldbugRetreat.ValidateScriptScope();
	shieldbugRetreat.GetScriptScope().env_global <- env_global_tft_spaceport_shieldbug;
	shieldbugRetreat.GetScriptScope().SpecialOnslaughtGlobalOn <- SpecialOnslaughtGlobalOn;
	shieldbugRetreat.ConnectOutput("OnEndSequence", "SpecialOnslaughtGlobalOn");

	shieldbugDead <- Entities.FindByName(null, "deadshieldbug_relay_out");
	shieldbugDead.ValidateScriptScope();
	shieldbugDead.GetScriptScope().env_global <- env_global_tft_spaceport_shieldbug;
	shieldbugDead.GetScriptScope().SpecialOnslaughtGlobalOff <- SpecialOnslaughtGlobalOff;
	shieldbugDead.ConnectOutput("OnTrigger", "SpecialOnslaughtGlobalOff");

	finaleTrigger <- Entities.FindByName(null, "finale_trigger_area");
	finaleTrigger.ValidateScriptScope();
	finaleTrigger.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleTrigger.ConnectOutput("OnTrigger", "SpecialOnslaughtStartFinale");
}
