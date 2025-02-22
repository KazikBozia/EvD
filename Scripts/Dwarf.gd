extends Area2D

signal died

export(float) var move_speed

var velocity : Vector2
var hp : float
var damage : float

onready var hp_bar
onready var hp_label

func _ready():
	go_forward()
	
func set_hp(new_hp):
	hp = new_hp
	hp_bar = find_node("HPBar")
	hp_label = find_node("HPLabel")
	
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_label.text = str(hp)
	
func _physics_process(delta):
	position += velocity * delta
		
	if $ElfRayCast.is_colliding():
		velocity = Vector2.ZERO
		$NextAttackTimer.start()
		set_physics_process(false)
		
func on_arrow_hit(arrow):
	hp -= arrow.damage
	arrow.queue_free()
	
	if hp <= 0:
		emit_signal("died")
		queue_free()
	else:
		hp_bar.value = hp
		
	hp_label.text = str(hp)
		
func go_forward():
	velocity = Vector2(-move_speed, 0)
	
func _on_NextAttackTimer_timeout():
	attack()
	
func attack():
	var elf = $ElfRayCast.get_collider()
	if not elf.on_dwarf_hit(damage):
		queue_free()

func _on_Dwarf_area_entered(area):
	# Because of collision masks this area is Arrow
	on_arrow_hit(area) 
