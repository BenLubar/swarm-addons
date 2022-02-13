function SpecialOnslaughtGlobalOn() {
	EntFireByHandle(env_global, "TurnOn", "", 0, env_global, env_global);
}

function SpecialOnslaughtGlobalOff() {
	EntFireByHandle(env_global, "TurnOff", "", 0, env_global, env_global);
}

function SpecialOnslaughtGlobalDead() {
	EntFireByHandle(env_global, "Remove", "", 0, env_global, env_global);
}

function SpecialOnslaughtGlobalOnStartTouchOnce() {
	SpecialOnslaughtGlobalOn();
	self.DisconnectOutput("OnStartTouch", "SpecialOnslaughtGlobalOnStartTouchOnce");
}

function SpecialOnslaughtGlobalOffStartTouchOnce() {
	SpecialOnslaughtGlobalOff();
	self.DisconnectOutput("OnStartTouch", "SpecialOnslaughtGlobalOffStartTouchOnce");
}

function SpecialOnslaughtGlobalSetCounter() {
	EntFireByHandle(env_global, "SetCount", SpecialOnslaughtCounterValue.tostring(), 0, env_global, env_global);
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

if (GetMapName().tolower() == "asi-jac1-landingbay_01") {
	finaleComputer <- null;
	while ((finaleComputer = Entities.FindByClassname(finaleComputer, "trigger_asw_computer_area")) != null) {
		if (finaleComputer.GetKeyValue("DownloadObjectiveName").tolower() == "downloaddata") {
			finaleComputer.ValidateScriptScope();
			finaleComputer.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
			finaleComputer.ConnectOutput("OnComputerHackStarted", "SpecialOnslaughtStartFinale");
			break;
		}
	}

	if (finaleComputer == null) {
		printl("Special Onslaught: could not find landing bay computer hack!");
	}
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
	shieldbugDead.GetScriptScope().SpecialOnslaughtGlobalDead <- SpecialOnslaughtGlobalDead;
	shieldbugDead.ConnectOutput("OnTrigger", "SpecialOnslaughtGlobalDead");

	finaleTrigger <- Entities.FindByName(null, "finale_trigger_area");
	finaleTrigger.ValidateScriptScope();
	finaleTrigger.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleTrigger.ConnectOutput("OnTrigger", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "rd-lan1_bridge") {
	finaleProp <- Entities.FindByName(null, "Platform_fall_support2");
	finaleProp.ValidateScriptScope();
	finaleProp.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleProp.ConnectOutput("OnBreak", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "rd-lan2_sewer") {
	env_global_lan_sewer_boss <- NewGlobal("special_onslaught_lan_sewer_boss");

	bossStart <- Entities.FindByClassname(null, "trigger_asw_marine_knockback");
	bossStart.ValidateScriptScope();
	bossStart.GetScriptScope().env_global <- env_global_lan_sewer_boss;
	bossStart.GetScriptScope().SpecialOnslaughtGlobalOnStartTouchOnce <- SpecialOnslaughtGlobalOnStartTouchOnce;
	bossStart.ConnectOutput("OnStartTouch", "SpecialOnslaughtGlobalOnStartTouchOnce");

	bossEnd <- Entities.FindByName(null, "count_death_boss");
	bossEnd.ValidateScriptScope();
	bossEnd.GetScriptScope().env_global <- env_global_lan_sewer_boss;
	bossEnd.GetScriptScope().SpecialOnslaughtGlobalDead <- SpecialOnslaughtGlobalDead;
	bossEnd.ConnectOutput("OnHitMax", "SpecialOnslaughtGlobalDead");

	finaleButton1 <- Entities.FindByName(null, "button_left");
	finaleButton2 <- Entities.FindByName(null, "button_right");
	finaleButton1.ValidateScriptScope();
	finaleButton2.ValidateScriptScope();
	finaleButton1.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleButton2.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleButton1.ConnectOutput("OnButtonActivated", "SpecialOnslaughtStartFinale");
	finaleButton2.ConnectOutput("OnButtonActivated", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "rd-lan3_maintenance") {
	env_global_lan_maintenance_repair <- Entities.CreateByClassname("env_global");
	env_global_lan_maintenance_repair.__KeyValueFromString("globalstate", "special_onslaught_lan_maintenance_repair");
	env_global_lan_maintenance_repair.__KeyValueFromString("targetname", "special_onslaught_lan_maintenance_repair");
	EntFireByHandle(env_global_lan_maintenance_repair, "SetCount", "0", 0, env_global_lan_maintenance_repair, env_global_lan_maintenance_repair);

	EntFire("repair_objective", "AddOutput", "OutValue special_onslaught_lan_maintenance_repair:SetCount::-1", 0);

	// rd-lan3_maintenance already calls StartFinale, so we don't do that here.
}

if (GetMapName().tolower() == "rd-lan4_vent") {
	finaleButton <- Entities.FindByName(null, "t75_detonator");
	finaleButton.ValidateScriptScope();
	finaleButton.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleButton.ConnectOutput("OnButtonActivated", "SpecialOnslaughtStartFinale");
}

if (GetMapName().tolower() == "rd-lan5_complex") {
	env_global_lan_complex_path <- Entities.CreateByClassname("env_global");
	env_global_lan_complex_path.__KeyValueFromString("globalstate", "special_onslaught_lan_complex_path");
	EntFireByHandle(env_global_lan_complex_path, "SetCounter", "1", 0, env_global_lan_complex_path, env_global_lan_complex_path);

	i <- 1;
	nukePath <- Entities.FindByName(null, "z_Nuke_Path_1");
	while (nukePath != null) {
		nukePath.ValidateScriptScope();
		nukePath.GetScriptScope().SpecialOnslaughtCounterValue <- i;
		nukePath.GetScriptScope().env_global <- env_global_lan_complex_path;
		nukePath.GetScriptScope().SpecialOnslaughtGlobalSetCounter <- SpecialOnslaughtGlobalSetCounter;
		nukePath.ConnectOutput("OnPass", "SpecialOnslaughtGlobalSetCounter");
		nukePath = Entities.FindByName(null, nukePath.GetKeyValue("target"));
		i = i + 1;
	}

	finaleCounter <- Entities.FindByName(null, "sas_counter_2");
	finaleCounter.ValidateScriptScope();
	finaleCounter.GetScriptScope().SpecialOnslaughtStartFinale <- StartFinale;
	finaleCounter.ConnectOutput("OnHitMax", "SpecialOnslaughtStartFinale");
}
