local class = {}

-- Keys
class.ENDPOINT = ""
class.API_KEY = "MY_SUPER_SECRET_KEY"

-- ENDPOINTS
class.HEALTH_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/health/"

class.PET_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/pet/"
class.TRAIL_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/trail/"
class.PRODUCT_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/product/"

class.TRANSACTION_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/transaction/process"

class.PLAYER_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/"
class.PLAYER_UPDATE_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/update"
class.PLAYER_UPDATES_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/updates"

class.LEADERBOARD_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/leaderboard"
class.STATISTICS_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/metrics/write"

class.PIST_CONVERTER_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/image/converter/"

return class
