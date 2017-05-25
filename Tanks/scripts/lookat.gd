
extends Sprite

const ROTATION_SPEED = 1

func _process(delta):
	var mpos = get_viewport().get_mouse_pos()

	var ang = get_angle_to(mpos)
	var s = sign(ang)
	ang = abs(ang)
		
	rotate(-min(ang, ROTATION_SPEED*delta)*s)
	
func _ready():
	set_process(true)
