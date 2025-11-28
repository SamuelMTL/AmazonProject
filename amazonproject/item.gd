extends Node2D

@export var item_name: String
@export var preco_item: int = 0  # define o preço aqui

# Lista de itens coletáveis
@onready var item_names = PlayerInventory.collectibles.keys()

func _ready() -> void:
	# Selecionar aleatoriamente um item coletável
	item_name = item_names.pick_random()
	preco_item = PlayerInventory.collectibles[item_name]["preco"]
	print("Item dropado: ", item_name, ", ", preco_item)
	# Qual sprite mostrar:
	if item_name == "Flores da Lua":
		get_node("Area2D/FlorLua").visible = true
		get_node("Area2D/ResinaAncestral").visible = false
	elif item_name == "Resina Ancestral":
		get_node("Area2D/FlorLua").visible = false
		get_node("Area2D/ResinaAncestral").visible = true
	else:
		get_node("Area2D/FlorLua").visible = true
		get_node("Area2D/ResinaAncestral").visible = false
		get_node("Area2D/FlorLua").texture = load("res://assets/arvore.png")
 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # opcional, se quiser garantir que só o player coleta
		PlayerInventory.add_collectible(item_name, 1, preco_item)
		print(PlayerInventory.collectibles)
		queue_free()
