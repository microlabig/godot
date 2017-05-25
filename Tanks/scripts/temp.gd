extends Node2D

var r = Rect2(10,10,150,150)
var c = Color(54)

func _ready():
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		r = Rect2(10,10,300,300)
		update()
	pass
	
func _draw():
	draw_rect(r,c)
	pass