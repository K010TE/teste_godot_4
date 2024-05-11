extends StaticBody2D

var velocidade_player : int = 500

func _ready():
	pass


func _process(delta):
	mov_player(delta) 


func mov_player(delta : float) -> void:
		if Input.is_action_pressed("cima"):
			position.y -= velocidade_player * delta
		elif Input.is_action_pressed("baixo"):
			position.y += velocidade_player * delta
		elif Input.is_action_pressed("esquerda"):
			position.x -= velocidade_player * delta
		elif Input.is_action_pressed("direita"):
			position.x += velocidade_player * delta
			
	
