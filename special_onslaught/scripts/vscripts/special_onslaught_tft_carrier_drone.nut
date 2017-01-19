parasiteProp <- CreateProp("prop_dynamic", self.GetOrigin() + Vector(0, 0, 40), "models/aliens/parasite/parasite.mdl", 17);
parasiteProp.SetOwner(self);
parasiteProp.SetLocalAngles(-67.5, 0, 0);

EntFireByHandle(self, "Color", "250 103 5", 0, self, self);
self.__KeyValueFromString("rendermode", "1");
parasiteProp.__KeyValueFromString("rendermode", "1");
EntFireByHandle(parasiteProp, "SetDefaultAnimation", "ragdoll", 0, self, self);
EntFireByHandle(parasiteProp, "SetAnimation", "ragdoll", 0, self, self);
EntFireByHandle(parasiteProp, "DisableShadow", "", 0, self, self);
EntFireByHandle(parasiteProp, "DisableCollision", "", 0, self, self);
EntFireByHandle(parasiteProp, "SetParent", "!activator", 0, self, self);

timer <- Entities.CreateByClassname("logic_timer");
timer.__KeyValueFromInt("UseRandomTime", 1);
timer.__KeyValueFromFloat("LowerRandomBound", 2.5);
timer.__KeyValueFromFloat("UpperRandomBound", 5);
timer.__KeyValueFromFloat("RefireTime", 3);
EntFireByHandle(timer, "Disable", "", 0, self, self);

function LongDeathTimer() {
	if (drone == null) {
		return;
	}

	drone.GetScriptScope().timer <- null;

	EntFireByHandle(drone, "SetHealth", "0", 0, self, self);

	realParasite1 <- Director.SpawnAlienAt("asw_parasite", parasiteProp.GetOrigin(), parasiteProp.GetAngles() + Vector(0, 100, 0));
	realParasite1.JumpAttack();

	realParasite2 <- Director.SpawnAlienAt("asw_parasite", parasiteProp.GetOrigin(), parasiteProp.GetAngles() + Vector(0, 260, 0));
	realParasite2.JumpAttack();

	self.DisconnectOutput("OnTimer", "LongDeathTimer");
	self.Destroy();
}

timer.ValidateScriptScope();
timer.GetScriptScope().drone <- self;
timer.GetScriptScope().parasiteProp <- parasiteProp;
timer.GetScriptScope().LongDeathTimer <- LongDeathTimer;
timer.ConnectOutput("OnTimer", "LongDeathTimer");

function CarrierDroneDied() {
	realParasite <- Director.SpawnAlienAt("asw_parasite", parasiteProp.GetOrigin(), parasiteProp.GetAngles());
	parasiteProp.Destroy();

	if (timer == null) {
		realParasite.JumpAttack();
	} else {
		timer.DisconnectOutput("OnTimer", "LongDeathTimer");
		timer.Destroy();
		timer.GetScriptScope().drone <- null;
	}

	self.DisconnectOutput("OnDeath", "CarrierDroneDied");
	self.DisconnectOutput("OnFoundEnemy", "CarrierDroneFoundEnemy");
}

function CarrierDroneFoundEnemy() {
	EntFireByHandle(timer, "Enable", "", 0, self, self);

	self.DisconnectOutput("OnFoundEnemy", "CarrierDroneFoundEnemy");
}

self.ValidateScriptScope();
self.GetScriptScope().timer <- timer;
self.GetScriptScope().parasiteProp <- parasiteProp;
self.GetScriptScope().CarrierDroneDied <- CarrierDroneDied;
self.ConnectOutput("OnDeath", "CarrierDroneDied");
self.GetScriptScope().CarrierDroneFoundEnemy <- CarrierDroneFoundEnemy;
self.ConnectOutput("OnFoundEnemy", "CarrierDroneFoundEnemy");
