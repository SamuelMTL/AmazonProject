extends Node

var player_attacking = false
var enemy_counter = 0

var player_max_health = 100
var player_health = 100

var player_speed = 300

func update_stats():
	if PlayerInventory.armors.has("Lança de Madeira Petrificada"):
		player_max_health += 10
	elif PlayerInventory.armors.has("Peitoral de Casca de Samaúma"):
		player_max_health += 20
		player_speed -= 100
	elif PlayerInventory.armors.has("Botas de Borracha Natural"):
		player_max_health += 10
		player_speed += 100
