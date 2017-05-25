extends RigidBody2D

var input_states = preload("res://scripts/input_states.gd")
 
var move_left = input_states.new("ui_left")
var move_right = input_states.new("ui_right")
var move_up = input_states.new("ui_up")
var move_down = input_states.new("ui_down")
       
 
export var run_speed = 100
export var acceleration = 1
export var deceleration = 2

export var rot_degree = 1
 
export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")
onready var shoot_sound = get_node("shoot")
var smoke = preload("res://scenes/smoke.tscn")


var current_speed = 0
var current_rot = 0.0
var rot = 0.0
 
func _ready():
        # Initalization here
        set_fixed_process(true)

func _fixed_process( delta ):
	if Input.is_action_pressed("ui_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()
       
	if move_left.check() == 1 or move_right.check() == 1:
		rot = get_rot()
		current_rot = get_rot()
	if move_left.check() == 2:
		rotate_player(rot_degree,delta)
	elif move_right.check() == 2:
		rotate_player(-rot_degree,delta)
       
        
	if move_up.check() == 2:
		move(-run_speed,acceleration,delta)
	elif move_down.check() == 2:
		move(run_speed*0.5,acceleration,delta)
	elif move_up.check() == 0 and move_down.check() == 0:
		move(0,deceleration,delta)
		
### apply the speed vector to the velocity     
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))
   
func move(speed, acceleration, delta):
	current_speed = lerp(current_speed, speed, acceleration*delta)

func shoot():
	gun_timer.start()
	var b = bullet.instance()
	var pos = get_node("barrel/muzzle").get_global_pos()
	var rot = get_node("barrel/muzzle").get_global_rot()
	bullet_container.add_child(b)
	b.start_at(rot, pos)
	var sm = smoke.instance()
	bullet_container.add_child(sm)
	sm.set_pos(pos)
	sm.play()
	shoot_sound.play("gun")

func rotate_player(degree,delta):
	current_rot += deg2rad(degree)
	rot = lerp(rot,current_rot,delta)
	set_rot(rot)
	
func rotate_barrel(degree, delta):
	pass