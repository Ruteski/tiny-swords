class_name Enemy

extends Node2D


@export var health: int = 10

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu danos de: ", amount, ". A vida total é de: ", health)
