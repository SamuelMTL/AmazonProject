extends Node2D

@export var item_name: String
 
func _on_area_2d_body_entered(body: Node2D) -> void:
	PlayerInventory.add_collectible(item_name, 1)
	print(PlayerInventory.collectibles)
	queue_free()
