extends Node

onready var player = get_node("player")
onready var enemy = get_node("enemy")

func _ready():
	set_process(true)
	pass

func _process(delta):
	#определим цель - игрок		
	# TO DO
	
	#повернем пушку
	if Input.is_action_pressed("ui_focus_next"): # <TAB>
		enemy.rotate_enemy_barrel(10,delta)
	pass