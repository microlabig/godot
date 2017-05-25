extends RigidBody2D

const ROTATION_SPEED = 1
var current_rot = 0.0 #текущий поворот
var degree = 0.0

func _ready():		
	set_fixed_process(true) 
	pass
	
func _fixed_process(delta):	
	rotate(delta)	
	if ( abs(deg2rad(degree)) - abs(get_rot())  <= 0.01 ):
		if degree>360:
			degree -= 360
		current_rot = degree
		set_fixed_process(false)		
	pass	
	
func rotate(delta):		
	current_rot = lerp(current_rot, degree, ROTATION_SPEED*delta)	
	set_rot(-deg2rad(current_rot))
	pass







