extends RigidBody2D

export var acceleration = 0.5 #ускорение для движения вперед
export var decceleration = 0.1 #ускорение для движения назад
export var speed = -100 #скорость перемещения по-умолчанию (на определенной местности) 
export (PackedScene) var bullet #пуля (Node)

onready var bullet_container = get_node("bullet_container")
onready var gun = get_node("gun")
onready var gun_timer = get_node("gun_timer")

var smoke = preload("res://scenes/smoke.tscn")

var current_speed = 0 #текущая скорость
var current_rot = 0.0 #текущий поворот
#var current_rot_gun = 0.0 #текущий поворот пушки
var linear_damp = 0.0 #для отдачи и отскоков

var target_pos = Vector2()

#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
func _ready():
	target_pos = Vector2(10,10) #цель	
	set_linear_damp(10.0) #для притормаживания (эффект "не постоянного" торможения)
	set_fixed_process(true)	 #создадим процесс для просчета физики и запустим его	
	pass		

func _fixed_process( delta ):	
	rotate_enemy(90,delta)
	if Input.is_action_pressed("ui_up"):
		rotate_enemy_gun(180, delta)
		if not gun_timer.get_time_left():	
			shoot(delta)
	#find_target(target_pos)
	if Input.is_action_pressed("ui_down"):
		braking_enemy(delta)
	else:
		pass
		move_enemy(speed, delta)
		#print("speed= ",speed," cs= ",current_speed)
	#print("mass = ", get_mass()," cur_speed = ", current_speed, " linear_damp = ", linear_damp)
	#print("g_lv = ", get_linear_velocity())	
	pass
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------

#установим линейную скорость перемещения и вращение
#если скорость sp положительна - движение вперед, отрицательна - назад
func move_enemy(sp, delta):	
	sp *= -1
	if sp<=0:
		current_speed = lerp(current_speed, sp, acceleration*delta)
	else:
		current_speed = lerp(current_speed, sp/2, decceleration*delta)	
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))
	pass

#установим линейное торможение 
func braking_enemy(delta):
	current_speed = lerp(current_speed, 0, get_mass()*delta)#acceleration*delta)
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))
	pass	

#повернем тело танка (не пушку!) на угол degree
func rotate_enemy(degree, delta):
	current_rot = deg2rad(degree)
	var rot = lerp(rot, current_rot, delta)
	set_rot(rot)
	#set_angular_velocity(rot)
	pass
	
#стрельба
func shoot(delta):	
	# старт таймера стрельбы
	gun_timer.start()
	# добавляем в контейнер пулю
	var b = bullet.instance()
	var pos = get_node("gun/muzzle").get_global_pos()
	var rot = get_node("gun/muzzle").get_global_rot()
	bullet_container.add_child(b)
	b.start_at(rot, pos)
	# добавляем эффект дыма после выстрела
	var sm = smoke.instance()
	bullet_container.add_child(sm)
	sm.set_pos(pos)
	sm.set_scale(Vector2(0.7,0.7))
	sm.play()
	# отдача от стрельбы и установка скорости
	var impulse = -Vector2((get_node("gun/muzzle").get_global_pos()-get_global_pos())).rotated(-get_rot())		
	var ang = gun.current_rot 
	impulse *= cos(ang)
	current_speed += impulse.y*cos(ang)	
	apply_impulse(Vector2(0,0),impulse)	
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))		
	#shoot_sound.play("gun")
	pass
	
#повернем пушку на угол degree
func rotate_enemy_gun(degree, delta):
	gun.degree = degree#+rad2deg(gun.get_rot())
	gun.set_fixed_process(true)
	pass	
	
#определить цель: повернуться к ней (если необходимо), потом ехать прямо на нее
func find_target(target):	
	# TO DO	
	pass