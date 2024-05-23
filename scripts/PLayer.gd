extends CharacterBody2D

var velocidade_player : int = 300
var ultima_direcao: String = "cima"
var dash_speed = 1000
var dash_duration = 0.2
var is_dashing = false
var can_dash = true
var dash_count = 0
var dash_direction: Vector2

@onready var dash_timer: Timer = get_node("DashTimer")

@onready var sprite := $Anim as AnimatedSprite2D

func _ready():
	dash_timer.wait_time = dash_duration
	dash_timer.connect("timeout", Callable(self, "_on_dash_timer_timeout"))

func _physics_process(delta):
	if is_dashing:
		position += dash_direction * dash_speed * delta
	else:
		mov_player(delta)

	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

func mov_player(delta : float) -> void:
	var movimento = Vector2.ZERO

	if Input.is_action_pressed("cima"):
		movimento.y -= 1
	if Input.is_action_pressed("baixo"):
		movimento.y += 1
	if Input.is_action_pressed("esquerda"):
		movimento.x -= 1
	if Input.is_action_pressed("direita"):
		movimento.x += 1

	if movimento != Vector2.ZERO:
		movimento = movimento.normalized()
		dash_direction = movimento
		movimento *= velocidade_player * delta
		update_sprite_animation(movimento)
		if not is_dashing:
			position += movimento
	move_and_slide()

func dash():
	if can_dash and dash_direction != Vector2.ZERO:
		is_dashing = true
		can_dash = false
		dash_count += 1
		dash_timer.start()

func _on_dash_timer_timeout():
	is_dashing = false
	if dash_count >= 2:
		await get_tree().create_timer(5.0).timeout  # Cooldown de 5 segundos após 2 dashes
		dash_count = 0
	else:
		await get_tree().create_timer(1.0).timeout  # Cooldown curto se ainda pode dashar
	can_dash = true

func update_sprite_animation(movimento: Vector2):
	if movimento == Vector2.ZERO and not is_dashing:
		sprite.stop()
		return

	if abs(movimento.x) > abs(movimento.y):
		sprite.play("run_right" if movimento.x > 0 else "run_left")
	else:
		sprite.play("run_down" if movimento.y > 0 else "run_up")

func _on_virtual_joystick_analogic_chage(movimento : Vector2) -> void:
	dash_direction = movimento.normalized()
	velocity = movimento * velocidade_player
	update_sprite_animation(movimento)
	mov_player(get_physics_process_delta_time())
	
func get_movement_input() -> Vector2:
	var movimento = Vector2.ZERO
	if Input.is_action_pressed("cima"):
		movimento.y -= 1
	if Input.is_action_pressed("baixo"):
		movimento.y += 1
	if Input.is_action_pressed("esquerda"):
		movimento.x -= 1
	if Input.is_action_pressed("direita"):
		movimento.x += 1
	return movimento
