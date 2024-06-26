class_name Enemy

extends Node2D

@export_group("Life")
@export var health: int = 10
@export var death_prefab: PackedScene
@export var deal_damage_amount: int = 2

@export_group("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var damage_digit_marker = $DamageDigitMarker


var damage_ditig_prefab: PackedScene


func _ready():
	damage_ditig_prefab = preload("res://misc/damage_digit.tscn")


func damage(amount: int) -> void:
	health -= amount
	# print("Inimigo recebeu danos de: ", amount, ". A vida total é de: ", health)
	
	# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# cria o damage digit
	var damage_digit = damage_ditig_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
		
	if health <= 0:
		die()
		
		
func die() -> void:
	# cria a caveira
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	# cria o drop
	if randf() <= drop_chance:
		drop_item()
	
	GameManager.monsters_defeated_count += 1
	queue_free()


func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)


func get_random_drop_item() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	
	# calcular chance maxima
	var max_chance: float = 0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	# jogar o dado
	var random_value = randf() * max_chance
	
	# girar a roleta
	var needle: float = 0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
			
	return drop_items[0]
		
	

