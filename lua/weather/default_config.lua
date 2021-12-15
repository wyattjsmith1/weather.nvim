local result = {}

-- A bit of a hack here. Emojis offer so little in the way of weather icons,
-- day and night are basically the same. Here, we create the default 'day'
-- icons, then modify them in `default_icons` to change a few to their
-- corresponding night icons.
local function day()
  return {
    clear = '☀️',
    fog = '🌁',
    haze = '🌁',
    lightning = '🌩️',
    tornado = '🌪️',
    snow = '🌨️',
    cloudy_partly = '🌤️',
    cloudy_cloudy = '🌥️',
    rain_sprinkle = '🌦️',
    rain_wind = '🌦️',
    rain_showers = '🌦️',
    rain_rain = '🌦️',
    rain_thunderstorm = '⛈️',
    hail = '⛈️',
    wind_light = '🌬️',
    wind_windy = '🌬️',
  }
end

local function night()
  local n = day()
  n.clear = '🌕'
  n.cloudy_partly = '☁️'
  n.cloudy_cloudy = '☁️'
  n.rain_sprinkle = '🌧️'
  n.rain_wind = '🌧️'
  n.rain_showers = '🌧️'
  n.rain_rain = '🌧️'

  return n
end

local function default_icons()
  return {
    day = day(),
    night = night(),
  }
end

result.default = {
  openweathermap = {
    app_id = "",
    weather_code_to_icons = {
      -- 2xx: Thunderstorms
      [200] = 'rain_thunderstorm',
      [201] = 'rain_thunderstorm',
      [202] = 'rain_thunderstorm',
      [210] = 'lightning',
      [211] = 'lightning',
      [212] = 'lightning',
      [221] = 'lightning',
      [230] = 'rain_thunderstorm',
      [231] = 'rain_thunderstorm',
      [232] = 'rain_thunderstorm',
      -- 3xx: Drizzle
      [300] = 'rain_sprinkle',
      [301] = 'rain_sprinkle',
      [302] = 'rain_sprinkle',
      [310] = 'rain_showers',
      [311] = 'rain_showers',
      [312] = 'rain_showers',
      [313] = 'rain_showers',
      [314] = 'rain_showers',
      [321] = 'rain_showers',
      -- 5xx: Rain
      [500] = 'rain_rain',
      [501] = 'rain_rain',
      [502] = 'rain_rain',
      [503] = 'rain_rain',
      [504] = 'rain_rain',
      [511] = 'rain_hail',
      [520] = 'rain_showers',
      [521] = 'rain_showers',
      [522] = 'rain_showers',
      [531] = 'rain_showers',
      -- 6xx: Snow
      [600] = 'snow',
      [601] = 'snow',
      [602] = 'snow',
      [611] = 'snow',
      [612] = 'snow',
      [613] = 'snow',
      [615] = 'snow',
      [616] = 'snow',
      [620] = 'snow',
      [621] = 'snow',
      [622] = 'snow',
      -- 7xx: Atmosphere
      [701] = 'fog',
      [711] = 'smoke',
      [721] = 'haze',
      [731] = 'haze',
      [741] = 'fog',
      [751] = 'haze',
      [761] = 'haze',
      [762] = 'haze',
      [771] = 'haze',
      [781] = 'haze',
      -- 800: Clear
      [800] = 'clear',
      -- 80x: Clouds
      [801] = 'cloudy_partly',
      [802] = 'cloudy_partly',
      [803] = 'cloudy_cloudy',
      [804] = 'cloudy_cloudy',
    },
  },
  cache_ttl = 15 * 60, -- 15 Minutes
  default = "openweathermap",
  weather_icons = default_icons(),
}


return result

