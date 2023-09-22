extends Area2D

var screensize = Vector2.ZERO
var addTime  = 10

func powerup_pickup():
	$CollisionShape2D.set_deferred("disabled",true)
	var tw  = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self,"scale",scale * 3,0.3)
	tw.tween_property(self,"modulate:a",0.0,0.3)
	await tw.finished
	queue_free()