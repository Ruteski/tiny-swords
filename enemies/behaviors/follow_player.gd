extends CharacterBody2D


@export var speed: float = 1.0


func _physics_process(delta: float) -> void:
	var player_position = Vector2(100,100)
	var diference = player_position - position
	var input_vector = diference.normalized()
	
	velocity = input_vector * speed * 100.0
	move_and_slide()
