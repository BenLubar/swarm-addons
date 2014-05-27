$modelname	"props_xen/light.mdl"
$body	light	"light.smd"
$surfaceprop	"alienflesh"
$sequence	idle	"anims/idle.smd"
$sequence	idle1	"anims/idle1.smd"
$sequence	idle2	"anims/idle2.smd"
$sequence	retract	"anims/retract.smd"
$sequence	extend	"anims/extend.smd"

$opaque

$jigglebone "Bone06" {
	is_flexible {
		yaw_stiffness 700
		yaw_damping 6
		pitch_stiffness 700
		pitch_damping 8
		tip_mass 5
		length 30
		angle_constraint 37
	}
}

$attachment "light" "bone06" -8.00 16.00 -4.00 rotate 0.00 0.00 0.00
