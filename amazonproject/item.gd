extends Node2D

@export var item_name: String
@export var preco_item: int = 0  # define o preço aqui

 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # opcional, se quiser garantir que só o player coleta
		PlayerInventory.add_collectible(item_name, 1, preco_item)
		print(PlayerInventory.collectibles)
		queue_free()
