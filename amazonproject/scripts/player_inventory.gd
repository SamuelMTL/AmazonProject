extends Node

var coins: int = 0
var collectibles: Dictionary = {}
var weapons: Array = []
var armors: Array = []

func add_collectible(item_name: String, amount: int = 1):
	if not collectibles.has(item_name):
		collectibles[item_name] = 0
	collectibles[item_name] += amount
	
func remove_collectible(item_name: String, amount: int = 1):
	if collectibles.has(item_name):
		collectibles[item_name] -= amount
		if collectibles[item_name] <= 0:
			collectibles.erase(item_name)
			
func add_coins(amount: int):
	coins += amount
	
func remove_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		return true
	return false
	
func add_weapon(weapon_name: String):
	if weapon_name not in weapons:
		weapons.append(weapon_name)
		
func add_armor(armor_name: String):
	if armor_name not in armors:
		armors.append(armor_name)
