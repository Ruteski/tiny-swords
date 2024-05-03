extends CanvasLayer

@onready var time_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel
@onready var meet_label: Label = %MeetLabel

var time_elapsed: float = 0


func _process(delta: float) -> void:
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	
	#time_label.text = str(minutes,":",seconds)
	time_label.text = "%02d:%02d" % [minutes, seconds]
