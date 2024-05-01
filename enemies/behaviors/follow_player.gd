extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 1.0

var input_vector: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	rotate_sprite()


func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var diference = player_position - position
	input_vector = diference.normalized()
	
	velocity = input_vector * speed * 100.0
	move_and_slide()
 

func rotate_sprite() -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
