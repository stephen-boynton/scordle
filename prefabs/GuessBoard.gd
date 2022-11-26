extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var input1 = get_node("Round1/LineEdit")
	input1.grab_focus()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
