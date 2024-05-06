extends Node


@export var speed: float = 1.0


var enemy: Enemy
var sprite: AnimatedSprite2D
var input_vector: Vector2 = Vector2.ZERO


func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D") # aqui eu passo o nome do Node

func _process(delta: float) -> void:
	rotate_sprite()


func _physics_process(delta: float) -> void:
	if GameManager.is_game_over: 
		return 
		
	var player_position = GameManager.player_position
	var diference = player_position - enemy.position
	input_vector = diference.normalized()
	
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
 

func rotate_sprite() -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
