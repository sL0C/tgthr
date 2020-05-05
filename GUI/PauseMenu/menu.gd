extends Popup

var player
var already_paused
var selected_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	var player_Arr = get_tree().get_nodes_in_group("player")
	if player_Arr.size() > 0:
		player = player_Arr[0]
	if not visible:
		if Input.is_action_just_pressed("menu"):
			# Pause game
			already_paused = get_tree().paused
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			player_process_input(false)
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color()
			pass
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
			pass
		elif Input.is_action_just_pressed("shoot"):
			match selected_menu:
				0:
					# Resume game
					if not already_paused:
						get_tree().paused = false
					player_process_input(true)
					hide()
					pass
				1:
					# Restart game
					get_tree().change_scene("res://Levels/Main/main.tscn")
					get_tree().paused = false
					pass
				2:
					# Quit game
					get_tree().quit()
					pass

func player_process_input(b):
	if player:
		player.set_process_input(b)
	return

func change_menu_color():
	$resume.color = Color.gray
	$restart.color = Color.gray
	$quit.color = Color.gray
	
	match selected_menu:
		0:
			$resume.color = Color.greenyellow
		1:
			$restart.color = Color.greenyellow
		2:
			$quit.color = Color.greenyellow
