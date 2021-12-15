-- A collection of other weather icons which can be used. To use one of these:
-- require'weather'setup { weather_icons = require'weather.other_icons'.nerd_font }
local result = {}

-- NerdFonts: https://www.nerdfonts.com/
-- NerdFonts has a surprisingly good number of weather icons.
result.nerd_font = {
  day = {
    clear = '',
    fog = '',
    haze = '',
    smoke = '',
    tornado = '',
    lightning = '',
    snow = '',
    cloudy_partly = '',
    cloudy_cloudy = '',
    rain_sprinkle = '',
    rain_rain_wind = '',
    rain_showers = '',
    rain_wind = '',
    rain_rain = '',
    rain_thunderstorm = '',
    hail = '',
    wind_light = '',
    wind_windy = ''
  },
  night = {
    clear = '',
    fog = '',
    haze = '', -- no haze, using fog
    smoke = '',
    tornado = '',
    lightning = '',
    snow = '',
    cloudy_partly = '',
    cloudy_cloudy = '',
    rain_sprinkle = '',
    rain_wind = '',
    rain_showers = '',
    rain_rain = '',
    rain_thunderstorm = '',
    hail = '',
    wind_light = '',
    wind_windy = '',
  }
}

return result

