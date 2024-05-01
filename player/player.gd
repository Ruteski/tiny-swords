extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var is_running: bool = false
@export var speed: int = 3 # ou coloco 3 e multiplico la embaixo por 100?
@export var speed_factor: float = 100.0
@export_range(0,1) var lerp_factor: float = 0.2

# update da unity
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("move_up"):
		#if is_running:
			#animation_player.play("idle")
			#is_running = false
		#else:
			#animation_player.play("run")
			#is_running = true

# fixed_update da unity
func _physics_process(delta: float) -> void:
	move()


func move() -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# apaga deadzone do input vector(principalmente quando o controle esta conectado)
	var deadzone: float = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	
	var target_velocity = input_vector * speed * speed_factor
	velocity = lerp(velocity, target_velocity, lerp_factor)
	move_and_slide()
	invert_side(input_vector)
	play_animation(input_vector)


func play_animation(input_vector: Vector2) -> void:
	var was_running: bool = is_running
	is_running = not input_vector.is_zero_approx()
	
	if was_running != is_running:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")


func invert_side(input_vector: Vector2) -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

