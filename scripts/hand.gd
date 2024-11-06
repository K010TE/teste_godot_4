extends Node2D

@onready var texture := $"Arma-01" as Sprite2D
@export var weapon_offset_right = 10  # Deslocamento para a direita
@export var weapon_offset_left = -8  # Deslocamento para a esquerda

func _physics_process(delta: float) -> void:
	animate_with_mouse()

func animate_with_mouse():
	if get_direction().x > 0:
		texture.flip_h = false
		adjust_weapon_position(false)
	elif get_direction().x < 0:
		texture.flip_h = true
		adjust_weapon_position(true)

func get_direction() -> Vector2:
	return global_position.direction_to(get_mouse_position())

func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

func adjust_weapon_position(is_flipped: bool):
	if texture:  # Verifica se 'texture' não é nulo
		if is_flipped:
			texture.position.x = weapon_offset_left  # Posição específica para a esquerda
		else:
			texture.position.x = weapon_offset_right  # Posição específica para a direita