class_name Player

extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

@export_category("Movement")
@export var speed: int = 3 # ou coloco 3 e multiplico la embaixo por 100?
@export var speed_factor: float = 100.0
@export_range(0,1) var lerp_factor: float = 0.2

@export_category("Damage")
@export var sword_damage: int = 2
@export var death_prefab: PackedScene
@export var hitbox_cooldown: float = 0.0

@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene

@export_group("Life")
@export var health: int = 100
@export var max_health: int = 100

var input_vector: Vector2 = Vector2.ZERO
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var ritual_cooldown: float = 0.0


signal meat_collected(value: int)


# update da unity
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("move_up"):
		#if is_running:
			#animation_player.play("idle")
			#is_running = false
		#else:
			#animation_player.play("run")
			#is_running = true

# TODO: adicionar ataques pra cima pra baixo direita e esquerda

func _ready():
	GameManager.player = self

# update da unity
func _process(delta: float) -> void:
	GameManager.player_position = position
	
	read_input()
	
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
		
	if not is_attacking:
		rotate_sprite()
		
	play_animation()
	
	# Processa dano
	update_hitbox_detection(delta)
	
	# Ritual
	update_ritual(delta)
	
	# atualiza healt bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health


func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")	

# fixed_update da unity
func _physics_process(delta: float) -> void:
	move()


func move() -> void:
	var target_velocity = input_vector * speed * speed_factor
	if is_attacking:
		target_velocity *= .25
	
	velocity = lerp(velocity, target_velocity, lerp_factor)
	move_and_slide()


func read_input() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var deadzone: float = 0.15
	
	# apaga deadzone do input vector(principalmente quando o controle esta conectado)
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
		
	was_running = is_running
	is_running = not input_vector.is_zero_approx()


func play_animation() -> void:
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")


func rotate_sprite() -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true


func attack() -> void:
	if is_attacking:
		return

	animation_player.play("attack_side_right_down")
	attack_cooldown = 0.6
	is_attacking = true


# TODO: quando implementar os ataques cima e baixo, arrumar aqui tb
func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			var dot_product = direction_to_enemy.dot(attack_direction)
			# aqui eu indico o angulo que vai causar dano se acertar
			# limita a area que o inimigo esta pra dar o dano nele
			if dot_product >= .5: 
				enemy.damage(sword_damage)


func damage(amount: int) -> void:
	if health <= 0:
		return

	health -= amount
	print("Player recebeu danos de: ", amount, ". A vida total é de: ", health)
	
	# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
		
	if health <= 0:
		die()


func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
		
	# frequencia
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = enemy.deal_damage_amount
			damage(damage_amount)


func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	queue_free()


func heal(amount: int) -> int:
	health += amount
	
	if health > max_health:
		health = max_health
	print("Vida do Player: ",  health)
	return health


func update_ritual(delta: float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0:
		return
	
	ritual_cooldown = ritual_interval
	
	# criar o ritual
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	# coloco o ritual dentro do player, como filho
	# como o ritual esta no 0,0 sempre vai acompanhar o position do player
	add_child(ritual)
	
