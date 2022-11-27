extends Node

enum GAME_STATE {
	READY
	GAME_ACTIVE
	GAME_COMPLETED
}

var UI
var GameBoard
var Scoreboard
var LettersUsed
var GameTimer
var word
	

func _ready():
	set_game_vars()
	get_game_words()

func start_game():
	GameBoard.init(word, Scoreboard, LettersUsed)
	GameTimer.start_round()
	
func get_game_words():
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(OS.get_system_time_msecs())
	var words_json = File.new()
	words_json.open("user://words.json", File.READ)
	var data = parse_json(words_json.get_as_text())
	word = data[rng.randi() % data.size()].to_upper()

func set_game_vars():
	UI = get_tree().current_scene.get_node("UI")
	GameBoard = get_tree().current_scene.get_node("GameBoard")
	Scoreboard = get_tree().current_scene.get_node("Scoreboard")
	LettersUsed = get_tree().current_scene.get_node("Scoreboard")
	GameTimer = get_tree().current_scene.get_node("Timer")
