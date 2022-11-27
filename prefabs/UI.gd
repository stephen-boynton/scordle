extends Node2D


var start_button: TextureButton
var semi_transparent
var Game_Controller


# Called when the node enters the scene tree for the first time.
func _ready():
	Game_Controller = get_tree().current_scene.get_node('GameController')
	semi_transparent = get_node("SemiTransparent")
	start_button = get_node("SemiTransparent/PlayButton")
	start_button.connect("pressed", self, "init")



func init():
	semi_transparent.visible = false
	Game_Controller.start_game()
	
