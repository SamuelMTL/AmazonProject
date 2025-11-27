extends Node2D

var room_id = 0
var dungeon_controller = null
var already_entered = false

var has_top: bool = false
var has_bottom: bool = false
var has_left: bool = false
var has_right: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_player_enter_room)

func _on_player_enter_room(body):
	if body.is_in_group("Player"):
		dungeon_controller.player_entered_room(room_id)
