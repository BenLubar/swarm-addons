$modelname "props/dm_icy_outpost/vent_grate.mdl"
$body ref "vent_grate.smd"

$surfaceprop "metal"
$cdmaterials "models/props/dm_icy_outpost"

$sequence BindPose "vent_grate.smd"
$collisionmodel "vent_grate_phys.smd"
{
	$automass
}

$opaque
$staticprop
