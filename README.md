# tdk-gdscript

## Installing the plugin

Copy the `/addons/treasure_launcher` folder into the `res://addons` folder in your project.

To enable the plugin, go to Project > Project Settings > Plugins, and check the "Enabled" box for the TreasureLauncher entry.

### Get Auth Token

```
func _ready():
	var auth_token = TreasureLauncher.get_auth_token()
	if auth_token != null:
		print(str("Found auth token: ", auth_token))
	else:
		print("No auth token found!")
```

### Start Session

Example usage available [here](/main.gd) (_on_start_session method).

Example success response
```json
{
    "result": true
}
```

Example error response
```json
{
    "error": "A user is not logged in to perform a start session call"
}
```

### Get User

Example usage available [here](/main.gd) (_on_get_user method).

Example success response
```json
{
    "id": "clziu5ii600029tse5hb91byg",
    "address": "0x6BF87Db1c25e40bEE4AB51D8382E1Eb8dFa2B3E2",
    "smartAccountAddress": "0x6BF87Db1c25e40bEE4AB51D8382E1Eb8dFa2B3E2",
    "email": null,
    "phoneNumber": null,
    "tag": null,
    "discriminant": null,
    "tagClaimed": false,
    "tagModifiedAt": null,
    "tagLastCheckedAt": null,
    "emailSecurityPhrase": null,
    "emailSecurityPhraseUpdatedAt": null,
    "featuredNftIds": [],
    "featuredBadgeIds": [],
    "highlyFeaturedBadgeId": null,
    "about": null,
    "pfp": null,
    "banner": null,
    "showMagicBalance": true,
    "showEthBalance": true,
    "showGemsBalance": true,
    "testnetFaucetLastUsedAt": null,
    "allActiveSigners": []
}
```

Example error response
```json
{
    "code": "AUTH_UNAUTHORIZED",
    "data": {
        "authError": "Invalid JWT header"
    },
    "name": "AuthError",
    "error": "Unauthorized"
}
```