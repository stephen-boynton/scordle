extends Node
# Cosntants ============================
enum GUESS_STATUS {
	CORRECT,
	NEUTRAL,
	PRESENT_ELSEWHERE
}

const GAME_KEY_MAP = {
	KEY_A: "A",
	KEY_B: "B",
	KEY_C: "C",
	KEY_D: "D",
	KEY_E: "E",
	KEY_F: "F",
	KEY_G: "G",
	KEY_H: "H",
	KEY_I: "I",
	KEY_J: "J",
	KEY_K: "K",
	KEY_L: "L",
	KEY_M: "M",
	KEY_N: "N",
	KEY_O: "O",
	KEY_P: "P",
	KEY_Q: "Q",
	KEY_R: "R",
	KEY_S: "S",
	KEY_T: "T",
	KEY_U: "U",
	KEY_V: "V",
	KEY_W: "W",
	KEY_X: "X",
	KEY_Y: "Y",
	KEY_Z: "Z"
}

const COLOR_CORRECT = Color(3/255.0, 155/255.0, 0, 0)
const COLOR_PRESENT = Color(153/255.0, 0, 155/255.0)
const MAX_INPUTS = 5
const MAX_ROUNDS = 6
const DEFAULT_STATUS_MAP = [
	GUESS_STATUS.NEUTRAL,
	GUESS_STATUS.NEUTRAL,
	GUESS_STATUS.NEUTRAL,
	GUESS_STATUS.NEUTRAL,
	GUESS_STATUS.NEUTRAL,
]


# Global Vars ============================
var word: String
var current_input_index = 0
var current_round = 0
var current_input: Label
var user_guesses = []
var current_guess = ""
var letters_used = []
var game_board = []
var status_maps = []

# State Functions ===========================
func _ready():
	init()


#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER:
			if(current_guess.length() == MAX_INPUTS):
				handle_enter()
				display_round_status()
				move_to_next_round()
		if  event.scancode == KEY_BACKSPACE:
			handle_backspace()
		if  event.scancode in GAME_KEY_MAP:
			handle_letter_input(GAME_KEY_MAP[event.scancode])

# State Helper ===========================
func init():
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(OS.get_system_time_msecs())
	var words_json = File.new()
	words_json.open("user://words.json", File.READ)
	var data = parse_json(words_json.get_as_text())
	var file_data = data
	word = file_data[rng.randi() % file_data.size()].to_upper()
	print(word)
	game_board.append(get_row('Row_1'))
	game_board.append(get_row('Row_2'))
	game_board.append(get_row('Row_3'))
	game_board.append(get_row('Row_4'))
	game_board.append(get_row('Row_5'))
	game_board.append(get_row('Row_6'))
	var letter_input = game_board[current_round][current_input_index]
	current_input = letter_input.get_node('Label')
	toggleHighlight(letter_input)
	
func display_round_status():
	var round_row = game_board[current_round]
	var round_status_map = status_maps[current_round]

	for i in MAX_INPUTS:
		var input_display = round_row[i]
		if(round_status_map[i] == GUESS_STATUS.CORRECT):
			input_display.display_correct()
		if(round_status_map[i] == GUESS_STATUS.PRESENT_ELSEWHERE):
			input_display.display_present_elsewhere()
			
func handle_enter():
	var round_status_map = build_round_status_map()
	user_guesses.append(current_guess)
	status_maps.append(round_status_map)


				
func handle_backspace():
	current_guess = current_guess.substr(0, current_input_index - 1)	
	if current_input_index > 0:
		if current_input.text == '':
			toggleHighlight(game_board[current_round][current_input_index])
			current_input_index -= 1
			var new_letter_input = game_board[current_round][current_input_index]
			current_input = new_letter_input.get_node('Label')
			toggleHighlight(new_letter_input)
		current_input.text = ''	
				
func handle_letter_input(letter: String):
	current_input.text = letter
	current_guess += letter
	if current_guess.length() > MAX_INPUTS:
		current_guess = current_guess.substr(0, MAX_INPUTS - 1) + letter
	if(current_input_index + 1 < MAX_INPUTS):
		var letter_input = game_board[current_round][current_input_index]
		var new_letter_input = game_board[current_round][current_input_index + 1]
		toggleHighlight(letter_input)
		toggleHighlight(new_letter_input)		
		current_input_index += 1
		current_input =  new_letter_input.get_node('Label')
	if(current_guess.length() == MAX_INPUTS):
		current_guess = current_guess.substr(0, MAX_INPUTS)
		
func move_to_next_round():
	if current_round + 1 < MAX_ROUNDS:
		toggleHighlight(game_board[current_round][current_input_index])
		current_round += 1
		current_input_index = 0
		current_guess = ''
		var new_letter_input = game_board[current_round][current_input_index]
		current_input = new_letter_input.get_node('Label')
		toggleHighlight(new_letter_input)

# Utils ===========================
func get_row(row: String):
	return get_tree().get_nodes_in_group(row)
	
func build_round_status_map():
	var letters_checked = []
	var status_map = []
	status_map.resize(MAX_INPUTS)

	for i in MAX_INPUTS:
		var guess_letter = current_guess[i]
		var correct_letter = word[i]
		# successful guess
		if guess_letter == correct_letter:
			status_map[i] = GUESS_STATUS.CORRECT
			letters_checked.append(guess_letter)
	# has letter in word, but not this letter
	# this is separate because we don't want false positive present_elsewhere if its correct later
	for i in MAX_INPUTS:
		var guess_letter = current_guess[i]
		var correct_letter = word[i]
		if word.find(guess_letter) != -1:
			var occurances_of_letter = word.count(guess_letter)
			var occurances_checked = letters_checked.count(guess_letter)
			if occurances_of_letter > occurances_checked:
				if status_map[i] != GUESS_STATUS.CORRECT:
					status_map[i] = GUESS_STATUS.PRESENT_ELSEWHERE
					letters_checked.append(guess_letter)
			continue
		# incorrect guess
		if status_map[i] != GUESS_STATUS.CORRECT or status_map[i] != GUESS_STATUS.PRESENT_ELSEWHERE:
			status_map[i] = GUESS_STATUS.NEUTRAL
			continue

	return status_map
	
func toggleHighlight(letterInput):
	var selector = letterInput.get_node('Selector')
	selector.visible = !selector.visible
	
