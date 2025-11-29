extends Node

var coins: int = 0
var collectibles: Dictionary = {
	"Resina Ancestral": {"quantidade": 2, "preco": 5},
	"Flores da Lua": {"quantidade": 1, "preco": 7}
}
var weapons: Array = []
var armors: Array = []

var powerups: Array = []

signal collectible_added(item_name, amount)
signal collectible_removed(item_name)
signal coins_changed(new_value)

func add_collectible(item_name: String, amount: int = 1, preco: int = 0):
	if not collectibles.has(item_name):
		collectibles[item_name] = {"quantidade": 0, "preco": preco}
	collectibles[item_name]["quantidade"] += amount
	emit_signal("collectible_added", item_name, collectibles[item_name]["quantidade"])
	print(collectibles)
	
func remove_collectible(item_name: String, amount: int = 1):
	if collectibles.has(item_name):
		collectibles[item_name]["quantidade"] -= amount
		if collectibles[item_name]["quantidade"] <= 0:
			collectibles.erase(item_name)
			
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
		Global.update_stats()
