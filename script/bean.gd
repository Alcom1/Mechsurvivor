extends Node2D

# Acceleration
@export var accel = 3000;

# Speed/Velocity
var speed = 0;
@export var speedMax = 200;			# Forward speed
@export var speedStrafe = 150;		# Strafing speed
@export var speedBack = 100;		# Backwards speed
@export var speedLunge = 1500;		# Initial speed of a lunge
@export var sprintMultiplier = 3;	# Speed multiplier for sprinting
var velocity = Vector2.ZERO;
var driven = Vector2.ZERO;
var isDriven : bool :
	get: return driven.length_squared() > 0
var isMoving : bool :
	get: return velocity.length_squared() > 0

# Position/Rotation
var target = Vector2.ZERO;
var altitude = 0;			# How high a bean is when jumping, etc.
var altitudeLunge = 1;		# How much altitude increases when lunging
var fallingSpeed = 5;		# Falling speed
var altitudeScale = 0.25;	# How much visual scale is affected by altitude

# Sprinting
var isSprint = false;
var upperAngle : int :		# Angle between upper body and current velocity
	get: return abs(velocity.angle_to($upper.global_transform.x) * 180 / PI)
var speedMaxCurr : int :	# Current maximum speed based on sprinting and uppper body angle for run/strafe/backwards
	get: return (
		speedMax if upperAngle < 60				# Forward
		else speedStrafe if upperAngle < 150 	# Strafe
		else speedBack) * (						# Backwards
		sprintMultiplier if isSprint else 1)	# run vs sprint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lower.look_at(position + Vector2.RIGHT);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Bean is driven to move in direction
	if isDriven :
		var accelFactor = driven.normalized() * accel * delta
		
		if (velocity + accelFactor).length_squared() > velocity.length_squared() && velocity.length() > speedMaxCurr :
			pass
		else :
			velocity += accelFactor;
	
	# Bean is not driven - decelerates to stopping.
	if (!isDriven && isMoving) || velocity.length() > speedMaxCurr:
		var decelFactor = velocity.normalized() * -accel * delta;
		velocity += decelFactor;
		
		if velocity.dot(decelFactor) > 0:
			velocity = Vector2.ZERO;
	
	# Update position from velocity
	position += velocity * delta;
	
	# Update lower facing direction
	$lower.look_at(							# Lower half faces...
		position + 							# Position plus...
		$lower.global_transform.x.slerp(	# Forward direction of lower slerped to...
			velocity.normalized(), 			# The normalized velocity
			accel / 375 * delta));			# slerp rate is based on acceleration
	
	# Update upper facing direction
	$upper.look_at(target);
	
	if altitude > 0 :
		altitude -= fallingSpeed * delta;
		var scaleFactor = 1 + altitude * altitudeScale;
		scale = Vector2(scaleFactor, scaleFactor);
	else :
		altitude = 0;
		scale = Vector2.ONE;
		pass
	
	pass

# Drive this mech in a direction
func drive(dir: Vector2) -> void:
	driven = dir;
	pass
	
func face(tar: Vector2) -> void:
	target = tar;
	pass
	
func run() -> void:
	isSprint = false;
	pass
	
func sprint() -> void:
	isSprint = true;
	pass
	
func lunge() -> void:
	if altitude <= 0 && isDriven :
		velocity = velocity.normalized() * speedLunge;
		altitude = altitudeLunge;
	pass;
