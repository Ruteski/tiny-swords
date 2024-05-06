extends CanvasLayer

@onready var time_label: Label = %TimerLabel
#@onready var gold_label: Label = %GoldLabel
@onready var meat_label: Label = %MeetLabel


func _process(delta: float) -> void:
	time_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_count)
