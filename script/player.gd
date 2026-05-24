extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var direction = Vector2.ZERO;
	
	#Process input
	if Input.is_action_pressed("player_move_north"):
		direction += Vector2.UP;
	if Input.is_action_pressed("player_move_south"):
		direction += Vector2.DOWN;
	if Input.is_action_pressed("player_move_east"):
		direction += Vector2.RIGHT;
	if Input.is_action_pressed("player_move_west"):
		direction += Vector2.LEFT;
	
	#Control player character
	$bean.drive(direction);
	$bean.face(get_global_mouse_position());
	if Input.is_action_pressed("player_sprint"):
		$bean.sprint();
	else:
		$bean.run();
	
	#Control camera
	$camera.position = $bean.position
	
	pass
