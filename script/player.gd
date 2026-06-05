extends Node2D

# Input timers
var lunge_timer: Timer = Timer.new();
var lunge_wait = 0.20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lunge_timer.wait_time = lunge_wait;
	lunge_timer.one_shot = true;
	add_child(lunge_timer);
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
	
	# Process input sprint
	if Input.is_action_pressed("player_sprint"):
		$bean.sprint();
	else:
		$bean.run();
	
	# Process input lunge
	if Input.is_action_just_pressed("player_sprint") :
		lunge_timer.start();
	if Input.is_action_just_released("player_sprint") :
		if lunge_timer.time_left > 0:
			$bean.lunge();
	
	#Control camera
	$camera.position = $bean.position
	
	pass
