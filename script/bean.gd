extends Node2D

# Acceleration
@export var accel = 3000;

# Speed/Velocity
var speed = 0;
@export var speedMax = 500;
@export var speedMaxSprint = 1000;
var velocity = Vector2.ZERO;
var driven = Vector2.ZERO;
var isDriven : bool :
	get: return driven.length_squared() > 0
var isMoving : bool :
	get: return velocity.length_squared() > 0

# Position/Rotation
var facingLower = Vector2.UP;
var facingUpper = Vector2.UP;

# Sprinting
var isSprint = false;
var speedMaxCurr : int :
	get: return speedMaxSprint if isSprint else speedMax

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lower.look_at(position + Vector2.RIGHT);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Bean is driven to move in direction
	if isDriven:
		velocity += driven.normalized() * accel * delta;
		$lower.look_at(							# Lower half faces...
			position + 							# Position plus...
			$lower.global_transform.x.slerp(	# Forward direction of lower slerped to...
				velocity.normalized(), 			# The normalized velocity
				accel / 375 * delta));			# slerp rate is based on acceleration
	
	# Bean is not driven - decelerates to stopping.
	if (!isDriven && isMoving) || velocity.length() > speedMaxCurr:
		var decelFactor = velocity.normalized() * -accel * delta;
		velocity += decelFactor;
		
		if velocity.dot(decelFactor) > 0:
			velocity = Vector2.ZERO;
	
	# Update position from velocity
	position += velocity * delta;
	
	pass

# Drive this mech in a direction
func drive(dir: Vector2) -> void:
	driven = dir;
	pass
	
func face(target: Vector2) -> void:
	$upper.look_at(target);
	pass
	
func sprint() -> void:
	isSprint = true;
	pass
	
func run() -> void:
	isSprint = false;
	pass
