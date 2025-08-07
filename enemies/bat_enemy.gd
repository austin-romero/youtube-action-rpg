extends CharacterBody2D

const SPEED = 30

@export var range: = 128

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"Idle": pass
		"Chase":
			var player = get_player()
			if player is Player:
				var distance_to_player = global_position.distance_to(player.global_position)
				if distance_to_player > 4:
					velocity = global_position.direction_to(player.global_position) * SPEED
					sprite_2d.scale.x = sign(velocity.x)
				else:
					velocity = Vector2.ZERO
			else:
				velocity = Vector2.ZERO
			move_and_slide()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var result = false
	var player: = get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < range:
			result = true
	return result

func can_see_player() -> bool:
	var is_in_range = is_player_in_range()
	if not is_in_range: return false
	var player: = get_player()
	if player is not Player: return false
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	var is_player_in_line_of_sight = not ray_cast_2d.is_colliding()
	return is_player_in_line_of_sight
	
