extends Node2D


var check_mark: TextureRect
var exclamation_mark: TextureRect


func _ready():
	check_mark = get_node("Checkmark")
	exclamation_mark = get_node("ExclamationMark")
	

func display_correct():
	check_mark.visible = true
	

func display_present_elsewhere():
	exclamation_mark.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
