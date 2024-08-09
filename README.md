# tdk-gdscript

### Get Auth Token

```
const AuthToken = preload("res://TDK/Source/auth_token.gd")

func _ready():
	var authToken = AuthToken.new().getAuthToken()
	if authToken != null:
		print("Found auth token: ", authToken)
	else:
		print("No auth token found!")
```

### Start Session

Example usage available [here](/TDK/Examples/auth_and_session.gd).

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

Example usage available [here](/TDK/Examples/auth_and_user.gd).

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