extends Area2D

@export var speed = 2000
var direction = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	$SelfDestructTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body is Hero:
		body.hit()
	queue_free()


func _on_self_destruct_timer_timeout():
	queue_free
