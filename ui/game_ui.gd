extends CanvasLayer

@onready var time_label: Label = %TimerLabel
#@onready var gold_label: Label = %GoldLabel
@onready var meat_label: Label = %MeetLabel

var time_elapsed: float = 0
var meat_count: int = 0


func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_count)


func _process(delta: float) -> void:
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	
	#time_label.text = str(minutes,":",seconds)
	time_label.text = "%02d:%02d" % [minutes, seconds]


func on_meat_collected(regeneration_value: int) -> void:
	meat_count += regeneration_value
	meat_label.text = str(meat_count)
