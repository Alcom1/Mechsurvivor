extends Node2D

# Acceleration
@export var accel = 3000;

# Velocity
var speed = 0;
@export var speedMax = 500;
var velocity = Vector2.ZERO;
var driven = Vector2.ZERO;

# Position/rotation
var facingLower = Vector2.UP;
var facingUpper = Vector2.UP;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lower.look_at(position + Vector2.RIGHT);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Bean is driven to move in direction
	if driven.length_squared() > 0:
		velocity += driven.normalized() * accel * delta;
		$lower.look_at(							# Lower half faces...
			position + 							# Position plus...
			$lower.global_transform.x.slerp(	# Forward direction of lower slerped to...
				velocity.normalized(), 			# The normalized velocity
				accel / 375 * delta));			# slerp rate is based on acceleration
	
	# Bean is not driven - accelerates to stopping.
	if driven.length_squared() == 0 && velocity.length_squared() > 0:
		var decelFactor = velocity.normalized() * -accel * delta;
		velocity += decelFactor;
		
		if velocity.dot(decelFactor) > 0:
			velocity = Vector2.ZERO;
		
	# Limit to max velocity
	if velocity.length() > speedMax:
		velocity = velocity.normalized() * speedMax;
	
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
