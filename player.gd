extends Area2D

signal pickup
signal hurt
signal powerup
signal game_over


@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	print(velocity.x)
	position += velocity * speed * delta
	#Clamp position for player to go off the linited screen
	position.x  = clamp(position.x,0,screensize.x)
	position.y  = clamp(position.y,0,screensize.y)
	
	##Animation
	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		

func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.play("idle")
func die():
	$AnimatedSprite2D.play("hurt")
	set_process(false)


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		die()
		game_over.emit()
