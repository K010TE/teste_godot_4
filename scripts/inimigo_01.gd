extends CharacterBody2D
@onready var sprite := $Anim as AnimatedSprite2D 

func _ready():
	pass

func _process(delta):
	sprite.play("default") 
	


	#move_and_slide()
