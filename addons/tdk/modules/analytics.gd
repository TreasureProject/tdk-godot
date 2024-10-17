extends Node

var version = preload("res://addons/tdk/version.gd")
var uuid = preload("res://addons/tdk/helpers/uuid.gd")
var tdk_config = preload("res://addons/tdk/resources/tdk_config.tres")

var Http = preload("res://addons/tdk/helpers/http.gd")
var http = Http.new(self)

var _uuid_rng = RandomNumberGenerator.new()
var _session_id = null
var _device_info : Dictionary
var _app_info : Dictionary

func _init() -> void:
	_uuid_rng.randomize()
	_session_id = uuid.v4_rng(_uuid_rng)
	_device_info = _build_device_info()
	_app_info = _build_app_info()

func track_custom_event(event_name: String, event_props: Dictionary):
	var event_data = _build_base_event()
	event_data[AnalyticsConstants.PROP_NAME] = event_name
	event_data[AnalyticsConstants.PROP_PROPERTIES] = event_props # TODO ensure serialization works
	var result = await http.http_post(
		tdk_config.get_analytics_api_url().trim_suffix("/") + "/events",
		event_data,
		{ "x-api-key": tdk_config.get_api_key() }
	)
	print(result) # TODO better logging

func _build_base_event() -> Dictionary:
	return {
		# AnalyticsConstants.PROP_SMART_ACCOUNT: "", # TODO read from auth token (identity)
		# AnalyticsConstants.PROP_CHAIN_ID: "", # TODO check if auth token has it
		AnalyticsConstants.CARTRIDGE_TAG: tdk_config.get_cartridge_tag(),
		AnalyticsConstants.PROP_SESSION_ID: _session_id,
		AnalyticsConstants.PROP_ID: uuid.v4_rng(_uuid_rng),
		AnalyticsConstants.PROP_TDK_VERSION: version.version,
		AnalyticsConstants.PROP_TDK_FLAVOUR: version.name,
		# AnalyticsConstants.PROP_TIME_LOCAL: "", # TODO add TDKTimeKeeper equivalent
		# AnalyticsConstants.PROP_TIME_SERVER: "",
		AnalyticsConstants.PROP_DEVICE: _device_info,
		AnalyticsConstants.PROP_APP: _app_info,
	}

func _build_device_info() -> Dictionary:
	var result = {
		AnalyticsConstants.PROP_DEVICE_NAME: "Not available",
		AnalyticsConstants.PROP_DEVICE_MODEL: OS.get_model_name(),
		AnalyticsConstants.PROP_DEVICE_TYPE: "Not available",
		AnalyticsConstants.PROP_DEVICE_OS: OS.get_name(),
		AnalyticsConstants.PROP_DEVICE_OS_FAMILY: OS.get_distribution_name(),
		AnalyticsConstants.PROP_DEVICE_CPU: OS.get_processor_name()
	}
	if OS.get_name() != "Web":
		result[AnalyticsConstants.PROP_DEVICE_UNIQUE_ID] = OS.get_unique_id()
	else:
		# get_unique_id generates an error when used on web
		result[AnalyticsConstants.PROP_DEVICE_UNIQUE_ID] = ""
	return result

func _build_app_info() -> Dictionary:
	return {
		AnalyticsConstants.PROP_APP_IDENTIFIER: tdk_config.get_bundle_id(),
		AnalyticsConstants.PROP_APP_IS_EDITOR: Engine.is_editor_hint(),
		# NOTE this does not use any version defined as an export option: it only uses the one in project settings
		AnalyticsConstants.PROP_APP_VERSION: ProjectSettings.get_setting_with_override("application/config/version"),
		AnalyticsConstants.PROP_APP_ENVIRONMENT: tdk_config.Env.keys()[tdk_config.get_environment()],
	}

class AnalyticsConstants:
	const CARTRIDGE_TAG = "cartridge_tag"
	const PROP_NAME = "name"
	const PROP_ID = "id"
	const PROP_TIME_LOCAL = "time_local"
	const PROP_TIME_SERVER = "time_server"
	const PROP_PROPERTIES = "properties"
	const PROP_DEVICE = "device"
	const PROP_DEVICE_NAME = "device_name"
	const PROP_DEVICE_MODEL = "device_model"
	const PROP_DEVICE_TYPE = "device_type"
	const PROP_DEVICE_UNIQUE_ID = "device_unique_id"
	const PROP_DEVICE_OS = "device_os"
	const PROP_DEVICE_OS_FAMILY = "device_os_family"
	const PROP_DEVICE_CPU = "device_cpu"
	const PROP_APP = "app"
	const PROP_APP_IDENTIFIER = "app_identifier"
	const PROP_APP_IS_EDITOR = "app_is_editor"
	const PROP_APP_VERSION = "app_version"
	const PROP_TDK_FLAVOUR = "tdk_flavour"
	const PROP_TDK_VERSION = "tdk_version"
	const PROP_APP_ENVIRONMENT = "app_environment"
	const PROP_SMART_ACCOUNT = "smart_account"
	const PROP_CHAIN_ID = "chain_id"
	const PROP_TYPE = "type"
	const PROP_SESSION_ID = "session_id"
