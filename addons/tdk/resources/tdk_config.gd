extends Resource

enum Env { DEV, PROD }

@export var _environment : Env
# TODO get bundleId from engine if possible
@export var _bundleId = "com.companyName.productName"
# TODO logger level/enabled flag

@export_group("General")
@export var _cartridgeTag = ""
@export var _cartridgeName = ""
@export var _devApiUrl = ""
@export var _prodApiUrl = ""
@export var _devApiKey = ""
@export var _prodApiKey = ""
@export var _devClientId = ""
@export var _prodClientId = ""
@export var _ecosystemId = ""
@export var _ecosystemPartnerId = ""

@export_group("Analytics", "_analytics")
@export var _analyticsDevApiUrl : String
@export var _analyticsProdApiUrl : String

func get_cartridge_tag():
	return _cartridgeTag

func get_analytics_api_url():
	return _analyticsDevApiUrl if is_dev_env() else _analyticsProdApiUrl

func get_api_url():
	return _devApiUrl if is_dev_env() else _prodApiUrl

func get_api_key():
	return _devApiKey if is_dev_env() else _prodApiKey

func get_client_id():
	return _devClientId if is_dev_env() else _prodClientId

func get_bundle_id():
	return _bundleId

func get_environment():
	return _environment

func is_dev_env():
	return _environment == Env.DEV

func populate_from_json(json : Dictionary):
	# general
	_cartridgeTag = json.general.cartridgeTag
	_cartridgeName = json.general.cartridgeName
	_devApiUrl = json.general.devApiUrl
	_prodApiUrl = json.general.prodApiUrl
	_devApiKey = json.general.devApiKey
	_prodApiKey = json.general.prodApiKey
	_devClientId = json.general.devClientId
	_prodClientId = json.general.prodClientId
	_ecosystemId = json.general.get("ecosystemId", "ecosystem.treasure")
	_ecosystemPartnerId = json.general.ecosystemPartnerId
	# analytics
	_analyticsDevApiUrl = json.analytics.get("devApiUrl", "https://darkmatter.spellcaster.lol/ingress")
	_analyticsProdApiUrl = json.analytics.get("prodApiUrl", "https://darkmatter.treasure.lol/ingress")
