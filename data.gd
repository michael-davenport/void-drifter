extends Node

var EnemyList = []

signal data_loaded

enum ITEM_TYPE {
	mineral,
	Gun_CombatLaser_MK1,
	Gun_CombatLaser_MK1_bl2,
	Gun_PlasmaCannon_MK1,
	Gun_PlasmaCannon_MK2
}

var ITEM_DICT = [
	{   #Mineral
		DisplayName = "Mineral",
		ItemScene = load("res://scenes/Objects/mineral.tscn")
	},
	{   #Gun_CombatLaser_MK1
		DisplayName = "Combat Laser MK1",
		ItemScene = load("res://scenes/Objects/Items/Item_Weapon_CombatLaser_MK1.tscn"),
		UseFunc = "equip_weapon",
		UseParams = {
			WeaponScene = load("res://scenes/Ship_Parts/Weapons/Weapon_CombatLaser_MK1.tscn")
		}
	},
	{   #Gun_CombatLaser_MK1_bl2
		DisplayName = "Combat Laser MK1 bl.2",
		ItemScene = load("res://scenes/Objects/Items/Item_Weapon_CombatLaser_MK1_bl2.tscn"),
		UseFunc = "equip_weapon",
		UseParams = {
			WeaponScene = load("res://scenes/Ship_Parts/Weapons/Weapon_CombatLaser_MK1_bl2.tscn")
		}
	},
	{   #Gun_PlasmaCannon_MK1
		DisplayName = "Plasma Cannon MK1",
		UseFunc = "equip_weapon",
		UseParams = {}
	},
	{   #Gun_PlasmaCannon_MK2
		DisplayName = "Plasma Cannon MK2",
		UseFunc = "equip_weapon",
		UseParams = {}
	}
]

func _ready() -> void:
	emit_signal("data_loaded")

func equip_weapon(caller : obj_ship, params = {}):
	var hardpoint = util.find_hardpoint(caller)
	if is_instance_valid(hardpoint):
		if is_instance_valid(hardpoint._weapon):
			hardpoint.remove_weapon()
			yield(get_tree().create_timer(0.1),"timeout")
			hardpoint.add_weapon(params.WeaponScene)
		else:
			hardpoint.add_weapon(params.WeaponScene)
	else:
		print("WARNING: Attempted to add weapon to invalid hardpoint")
