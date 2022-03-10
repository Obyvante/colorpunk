local class = {}

-- Keys
class.ENDPOINT = "65.108.166.161:8080"
class.API_KEY = "BARDEN_SECRET_KEY"

-- ENDPOINTS
class.HEALTH_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/health/"

class.PET_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/pet/"
class.TRAIL_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/trail/"

class.PLAYER_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/"
class.PLAYER_UPDATE_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/update"
class.PLAYER_UPDATES_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/player/updates"

class.LEADERBOARD_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/v1/leaderboard"

class.PIST_CONVERTER_ENDPOINT = "http://" .. class.ENDPOINT .. "/api/image/converter/"

return class