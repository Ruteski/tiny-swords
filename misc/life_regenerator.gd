extends Node2D


@export var regeneration_amount: int = 10


@onready var area2d: Area2D = $Area2D


func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		queue_free()
	#print(body)
