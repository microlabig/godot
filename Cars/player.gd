extends KinematicBody2D

const C_drag = 0.4257
const C_rr = 12.8
const MAX_C_braking = 60000
const MAX_ENGINE = 70000
const MASS = 1500
const G = 9.8
const mu = 1.0 #коэф трения шин, может быть 1 для обычных, может 1.5 для гоночных

var screen_size = Vector2()
var u = Vector2(0, -1)

#car
var engineforce = 0
var c_braking = 0
var weight
var vel = Vector2()
var speed = 0.0
var acc = Vector2()
var pos = Vector2()

#forces
var f_traction = Vector2() #тяга двигателя
var f_drag = Vector2() #сопротивление воздуха
var f_rr = Vector2() #трение в осях (вопросный момент определния коэф)
var f_long = Vector2() #сумма всех сил
var f_braking = Vector2() # Сила торможения
var f_max = Vector2() # предел трения колеса


func _ready():
	weight = MASS * G
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_pos(pos)
	set_process(true)

func _process(delta):
	f_traction = u * engineforce
	f_drag = -C_drag * vel * vel.length_squared()
	f_rr = -C_rr * vel
	f_braking = -u * c_braking
	
	speed = sqrt(vel.x*vel.x + vel.y*vel.y)
	
	if Input.is_action_pressed("ui_up"):
		engineforce += 500
	else:
		engineforce = 0
	
	engineforce = clamp(engineforce, 0, MAX_ENGINE)

	f_long = f_traction + f_drag + f_rr
	
	if Input.is_action_pressed("ui_down"):
		c_braking +=20000
		#while speed > 0:
		f_long = f_braking + f_drag + f_rr
	
	c_braking = clamp(c_braking, 0, MAX_C_braking)
	acc = f_long / MASS
	vel = vel + delta * acc
	pos = pos + delta * vel
	set_pos(pos)
