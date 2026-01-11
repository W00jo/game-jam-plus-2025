extends CanvasLayer

# eunem żeby wybór był prosty, między graczami, za pomocą inspektora.
enum PlayerType { PLAYER_1, PLAYER_2 }
@export var player_hud_type: PlayerType = PlayerType.PLAYER_1

@onready var got_hit = $GotHit
@onready var crosshair: TextureRect = $Crosshair
@onready var crosshair_hit: TextureRect = $CrosshairHit
## Gracz lootujący, mimo że nie strzela, potrzebuje mieć tą kropoczkę aby móc nie tylko wycentrować swoje (jako gracza) pole widzenia, ale też jako formę walki z motion sickness.
@onready var dot_marker: TextureRect = $DotMarker
@onready var loot_indicator_panel: Panel = $LootIndicatorBackground
@onready var loot_indicator_label: RichTextLabel = $LootIndicatorBackground/LootIndicator

func _ready():
	GameManager.collectible_gathered.connect(_on_collectible_gathered)
	
	# Loading screen (trochę)
	await get_tree().process_frame
	
	# Pobranie ilości lootu z game_manager.gd
	_update_loot_display()
	
	var viewport_size = get_viewport().get_visible_rect().size

	match player_hud_type:
		PlayerType.PLAYER_1:
			got_hit.visible = false
			crosshair.visible = true
			loot_indicator_panel.visible = false
			dot_marker.visible = false
			
			crosshair.position.x = viewport_size.x / 2 - crosshair.size.x / 2
			crosshair.position.y = viewport_size.y / 2 - crosshair.size.y / 2
			crosshair_hit.position.x = viewport_size.x / 2 - crosshair.size.x / 2
			crosshair_hit.position.y = viewport_size.y / 2 - crosshair.size.y / 2

		PlayerType.PLAYER_2:
			got_hit.visible = false
			crosshair.visible = false
			crosshair_hit.visible = false
			loot_indicator_panel.visible = true
			dot_marker.visible = true
			
			dot_marker.position.x = viewport_size.x / 2 - dot_marker.size.x / 2
			dot_marker.position.y = viewport_size.y / 2 - dot_marker.size.y / 2
			
			loot_indicator_panel.position.x = viewport_size.x / 2 - loot_indicator_panel.size.x / 2
			loot_indicator_panel.position.y = 20
	
func _update_loot_display():
	var current = GameManager.collectibles_gathered
	var total = GameManager.collectibles_to_win
	loot_indicator_label.text = "[b]Loot[/b] collected: " + str(current) + "/" + str(total)
	
func _on_collectible_gathered(count: int):
	_update_loot_display()
	
## Hitmarker
func _on_enemy_hit():
	crosshair_hit.visible = true
	await get_tree().create_timer(0.35).timeout
	crosshair_hit.visible = false

func _on_player_1_player_hit() -> void:
	got_hit.visible = true
	await get_tree().create_timer(0.2).timeout
	got_hit.visible = false
	
func _on_player_2_player_hit() -> void:
	got_hit.visible = true
	await get_tree().create_timer(0.2).timeout
	got_hit.visible = false
