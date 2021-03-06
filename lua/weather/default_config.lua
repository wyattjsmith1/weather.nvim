local result = {}

-- A bit of a hack here. Emojis offer so little in the way of weather icons,
-- day and night are basically the same. Here, we create the default 'day'
-- icons, then modify them in `default_icons` to change a few to their
-- corresponding night icons.
local function day()
  return {
    clear = 'âī¸',
    fog = 'đ',
    haze = 'đ',
    lightning = 'đŠī¸',
    tornado = 'đĒī¸',
    snow = 'đ¨ī¸',
    cloudy_partly = 'đ¤ī¸',
    cloudy_cloudy = 'đĨī¸',
    rain_sprinkle = 'đĻī¸',
    rain_wind = 'đĻī¸',
    rain_showers = 'đĻī¸',
    rain_rain = 'đĻī¸',
    rain_thunderstorm = 'âī¸',
    hail = 'âī¸',
    wind_light = 'đŦī¸',
    wind_windy = 'đŦī¸',
  }
end

local function night()
  local n = day()
  n.clear = 'đ'
  n.cloudy_partly = 'âī¸'
  n.cloudy_cloudy = 'âī¸'
  n.rain_sprinkle = 'đ§ī¸'
  n.rain_wind = 'đ§ī¸'
  n.rain_showers = 'đ§ī¸'
  n.rain_rain = 'đ§ī¸'

  return n
end

local function default_icons()
  return {
    day = day(),
    night = night(),
  }
end

result.default = {
  update_interval = 15 * 60 * 1000, -- 15 Minutes in ms
  -- The OWM configuration.
  openweathermap = {
    -- Your appid. This can be found at https://home.openweathermap.org/api_keys
    app_id = {},
    -- A mapping of weather codes (https://openweathermap.org/weather-conditions) to icons. If the icon is a name in `weather_icons`,
    -- then this acts as a pointer to that icon. If not found, this is a literal string
    -- which will be used. For example:
    -- [200] = 'rain_thunderstorm' => returns the icon in `weather_icons` with the name 'rain_thunderstorm'
    -- [200] = 'It's rainy' => literally uses "It's rainy"
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
  -- The default weather source when calling subscribe.
  default = "openweathermap",
  -- The set of icons to use. See `day()` above for all names.
  weather_icons = default_icons(),
}

return result

