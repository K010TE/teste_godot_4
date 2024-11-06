extends CharacterBody2D

@export var move_speed = 300.0
@export var acceleration: float = 0.4
@onready var animation:= $anim as AnimatedSprite2D

var is_facing_left = false  # Variável para armazenar a última direção horizontal


func _physics_process(delta: float) -> void:
	move()
	animate_with_mouse()


func move():
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	velocity = direction * move_speed
	move_and_slide()
	
	#velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
	#velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)

func animate():
	if velocity == Vector2.ZERO:
		animation.play("idle")
	else:
		# Atualiza a direção horizontal quando há movimento lateral
		if velocity.x < 0:
			is_facing_left = true
			animation.flip_h = true
			animation.play("walk_right")
		elif velocity.x > 0:
			is_facing_left = false
			animation.flip_h = false
			animation.play("walk_right")
		else:
			# Movimentos verticais mantêm o flip_h com base na última direção horizontal
			animation.flip_h = is_facing_left
			animation.play("walk_right")

func animate_with_mouse():
	if get_direction().x > 0:
		animation.flip_h = false
	
	if get_direction().x < 0:
		animation.flip_h = true
	
	if velocity != Vector2.ZERO:
		animation.play("walk_right")
		return
		
	animation.play("idle")

func dash():
	pass
	
func get_direction() -> Vector2:
	return global_position.direction_to(get_mouse_position())
	
func get_mouse_position() -> Vector2:
	return get_global_mouse_position()
