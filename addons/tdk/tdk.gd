extends Node

var Identity = preload("res://addons/tdk/modules/identity.gd")
var Analytics = preload("res://addons/tdk/modules/analytics.gd")
var Logger = preload("res://addons/tdk/helpers/logger.gd")
var TimeKeeper = preload("res://addons/tdk/helpers/time_keeper.gd")

var _identity = Identity.new()
var _analytics = Analytics.new()
var _time_keeper = TimeKeeper.new()
var logger = Logger.new()

func _init() -> void:
	add_child(_identity)
	add_child(_analytics)
	add_child(_time_keeper)
	
	_analytics.set_time_keeper(_time_keeper)

func get_auth_token():
	return _identity.get_auth_token()

func get_user(api_url: String, auth_token: String) -> Dictionary:
	return await _identity.get_user(api_url, auth_token)

func start_session(
	backendWallet: String,
	approvedTargets: Array,
	nativeTokenLimitPerTransaction: int = 0,
	sessionDurationSec: int = 0,
	sessionMinDurationLeftSec: int = 0
) -> Dictionary:
	return await _identity.start_session(
		backendWallet,
		approvedTargets,
		nativeTokenLimitPerTransaction,
		sessionDurationSec,
		sessionMinDurationLeftSec
	)

func get_wallet_address():
	return _identity.get_wallet_address()

func track_custom_event(event_name: String, event_props: Dictionary):
	await _analytics.track_custom_event(event_name, event_props)
