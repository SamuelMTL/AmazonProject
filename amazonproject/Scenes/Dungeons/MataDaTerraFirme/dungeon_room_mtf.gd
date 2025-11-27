extends Node2D

var room_id = 0
var dungeon_controller = null

func _ready():
	$Area2D.body_entered.connect(_on_player_enter_room)

func _on_player_enter_room(body):
	if body.name == "Player":
		dungeon_controller.player_entered_room(room_id)
