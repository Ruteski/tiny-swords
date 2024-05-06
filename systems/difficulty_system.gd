extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60
@export var spawn_rate_per_minute: float = 30
@export var wave_duration: float = 20
@export var break_intensity: float = 0.5

var time: float = 0

func _process(delta: float) -> void:
	time += delta
	# dificuldade linear
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60)
	
	# sistema de ondas
	# sin() # Pi = 3.14     0 ~ 2Pi | TAU = 2Pi = 6.28
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate *= wave_factor
	
	mob_spawner.mobs_per_minute = spawn_rate
