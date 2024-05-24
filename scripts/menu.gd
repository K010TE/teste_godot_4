extends Control


func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited"))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_button_pressed(button: Button):
	match button.name:
		"Play":
			var _game: bool = get_tree().change_scene_to_file("res://.godot/exported/133200997/export-6f07a446ac45a12f54917b3208bb2605-cena.scn")
		
		"Quit":
			get_tree().quit()
			
func mouse_interaction(button: Button, state: String):
	match state:
		"exited":
			button.modulate.a = 1.0
			
		"entered":
			button.modulate.a = 0.5
