class_name GameOverUI extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %MonstersLabel

@export var restart_delay: float = 5

var restart_cooldown: float


func _ready():
	restart_cooldown = restart_delay
	time_label.text = GameManager.time_elapsed_string
	monsters_label.text = str(GameManager.monsters_defeated_count)


func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()


func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()