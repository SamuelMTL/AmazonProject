extends Control

@onready var items_list = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var coin_label = $PanelContainer/VBoxContainer/HBoxContainer3/Coins
@onready var item_scene = preload("res://Components/InventarioComponent/inventoryitem.tscn")

func _ready() -> void:
	PlayerInventory.connect("collectible_added", Callable(self, "_on_collectible_added"))
	PlayerInventory.connect("collectible_removed", Callable(self, "_on_collectible_removed"))
	PlayerInventory.connect("coins_changed", Callable(self, "_on_coins_changed"))
	
	_on_coins_changed(PlayerInventory.coins)
	for item_name in PlayerInventory.collectibles.keys():
		_on_collectible_added(item_name, PlayerInventory.collectibles[item_name])
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventario"):
		get_tree().paused = true
		visible = true
		
func _on_coins_changed(new_value):
	coin_label.text = str(new_value)
	
func _on_collectible_added(item_name, amount):
	var item_node = items_list.get_node_or_null(item_name)
	if item_node:
		# Atualiza quantidade
		item_node.get_node("AmountLabel").text = str(amount)
	else:
		# Cria novo slot
		var new_item = item_scene.instantiate()
		new_item.name = item_name # importante para encontrar depois
		new_item.get_node("ItemName").text = item_name
		new_item.get_node("AmountLabel").text = str(amount)
		items_list.add_child(new_item)

func _on_collectible_removed(item_name):
	var item_node = items_list.get_node_or_null(item_name)
	if item_node:
		item_node.queue_free()


func _on_voltar_pressed() -> void:
	get_tree().paused = false
	visible = false
