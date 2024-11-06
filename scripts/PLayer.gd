extends CharacterBody2D

@export var move_speed = 300.0
@export var dash_distance = 400.0  # Distância que o dash deve percorrer
@export var dash_duration = 0.4  # Duração do dash em segundos
@export var dash_cooldown = 3.0  # Tempo de recarga do dash em segundos
@export var acceleration: float = 0.4
@onready var animation := $anim as AnimatedSprite2D
@onready var hand := $Hand as Node2D

var can_dash = true  # Controla se o dash está disponível
var is_dashing = false  # Controla se o personagem está dashing
var is_facing_left = false  # Variável para armazenar a última direção horizontal
var dash_direction = Vector2.ZERO  # Direção do dash, baseada no movimento atual

func _ready():
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	if not is_dashing:
		move()  # Apenas move se não estiver dashing
	else:
		move_and_slide()  # Aplica o dash ao longo da duração

	# Apenas anima se não estiver dashing
	if not is_dashing:
		animate_with_mouse()
	dash()

func move():
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	velocity = direction * move_speed
	move_and_slide()  # Chamado sem argumentos

	# Define a direção do dash baseada no movimento atual, se houver movimento
	if direction != Vector2.ZERO:
		dash_direction = direction

func animate():
	if not is_dashing and can_dash:  # Apenas executa as animações de movimento se não estiver dashing
		if velocity == Vector2.ZERO:
			animation.play("idle")
		else:
			if velocity.x < 0:
				is_facing_left = true
				animation.flip_h = true
				animation.play("walk_right")
			elif velocity.x > 0:
				is_facing_left = false
				animation.flip_h = false
				animation.play("walk_right")
			else:
				animation.flip_h = is_facing_left
				animation.play("walk_right")

func animate_with_mouse():
	if is_dashing:
		return  # Não anima com o mouse enquanto está dashing

	if get_direction().x > 0:
		animation.flip_h = false
	
	if get_direction().x < 0:
		animation.flip_h = true
	
	if velocity != Vector2.ZERO:
		animation.play("walk_right")
		return
		
	animation.play("idle")

func dash():
	if Input.is_action_just_pressed("dash") and can_dash and dash_direction != Vector2.ZERO:
		can_dash = false
		is_dashing = true

		# Calcula a velocidade necessária para cobrir a distância em dash_duration
		var dash_speed = dash_distance / dash_duration
		velocity = dash_direction.normalized() * dash_speed

		# Aplica a animação de dash
		print("Dash animation playing")  # Depuração
		animation.play("dash")
		animation.flip_h = dash_direction.x < 0  # Ajusta a direção da animação do dash

		# Temporizador para a duração do dash
		await get_tree().create_timer(dash_duration).timeout

		# Para o movimento ao término do dash
		velocity = Vector2.ZERO
		is_dashing = false

		# Temporizador para o cooldown do dash
		await get_tree().create_timer(dash_cooldown).timeout

		# Permite que o dash seja usado novamente após o cooldown
		can_dash = true

func _on_animation_finished():
	# Verifica se o dash terminou antes de trocar de animação
	if not is_dashing:
		if velocity == Vector2.ZERO:
			animation.play("idle")
		else:
			animate()  # Retorna à animação de movimento

func get_direction() -> Vector2:
	return global_position.direction_to(get_mouse_position())
	
func get_mouse_position() -> Vector2:
	return get_global_mouse_position()
