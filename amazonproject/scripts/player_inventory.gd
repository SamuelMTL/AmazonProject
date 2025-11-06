extends Node

var coins: int = 100
var collectibles: Dictionary = {"item teste": 1}
var weapons: Array = []
var armors: Array = []

signal collectible_added(item_name, amount)
signal collectible_removed(item_name)
signal coins_changed(new_value)

func add_collectible(item_name: String, amount: int = 1):
	if not collectibles.has(item_name):
		collectibles[item_name] = 0
	collectibles[item_name] += amount
	emit_signal("collectible_added", item_name, collectibles[item_name])
	print(collectibles)
	
func remove_collectible(item_name: String, amount: int = 1):
	if collectibles.has(item_name):
		collectibles[item_name] -= amount
		if collectibles[item_name] <= 0:
			collectibles.erase(item_name)
			emit_signal("collectible_removed", item_name)
			print(collectibles)
		else:
			emit_signal("collectible_added", item_name, collectibles[item_name])
			
func add_coins(amount: int):
	coins += amount
	print(coins)
	emit_signal("coins_changed", coins)
	
func remove_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		print(coins)
		emit_signal("coins_changed", coins)
		return true
	return false
	
func add_weapon(weapon_name: String):
	if weapon_name not in weapons:
		weapons.append(weapon_name)
		print("armas no inventario: " + str(weapons))
		
func add_armor(armor_name: String):
	if armor_name not in armors:
		armors.append(armor_name)
		print("armaduras no inventario: " + str(armors))
