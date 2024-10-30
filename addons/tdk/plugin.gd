@tool
extends EditorPlugin

const AUTOLOAD_NAME = "TDK"
const TOOL_NAME = "TDK Config (Treasure)";
const CONFIG_DOCK_SCENE_PATH = "addons/tdk/editor_nodes/TreasurePluginConfigDock.tscn";

var dockNode = null

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/tdk/tdk.gd")
	add_tool_menu_item(TOOL_NAME, _open_config_dock)

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_tool_menu_item(TOOL_NAME)
	_remove_dock_node()

func _open_config_dock():
	if dockNode == null:
		dockNode = load(CONFIG_DOCK_SCENE_PATH).instantiate()
		dockNode.close_requested.connect(_remove_dock_node)
		add_control_to_bottom_panel(dockNode, "TDK Config")
	make_bottom_panel_item_visible(dockNode)

func _remove_dock_node():
	if dockNode != null:
		remove_control_from_bottom_panel(dockNode)
		dockNode.queue_free()
		dockNode = null
