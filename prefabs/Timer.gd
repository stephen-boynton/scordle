extends Node2D


var timer: Timer
var amount: Label


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	amount = get_node("Amount")


func start_round():
	timer.start(120)


func _process(delta):
	amount.text = String(timer.time_left)
