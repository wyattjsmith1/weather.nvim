# weather.nvim

A simple plugin to display weather in nvim.

![screenshot](https://github.com/wyattjsmith1/weather.nvim/blob/main/assets/screenshot.png)

## Installation
The usual ways. Packer below:

```lua
use {
  'wyattjsmith/weather.nvim'
  requires = {
    "nvim-lua/plenary.nvim",
  }
}
```

## Configuration
```lua
require'weather'.setup {
}
```

A full configuration is listed below:

```lua
result.default = {
  -- The OWM configuration.
  openweathermap = {
    -- Your appid. This can be found at https://home.openweathermap.org/api_keys
    app_id = "",
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
  -- The default cache duration in seconds. This is not an automatic refresh, you must manually call `get_default` again.
  cache_ttl = 15 * 60, -- 15 Minutes
  -- The default weather source when calling get_default.
  default = "openweathermap",
  -- The set of icons to use. See `day()` above for all names.
  weather_icons = {
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
  },
}
```

## Usage
`weather.nvim` doesn't do anything on its own; it need to be called. The modules and example usage with lualine are documented below.

### Objects

#### `Location`
```
{
  country = "United States,
  region = "California",
  city = "New York City",
  lat: 1234, -- latitude
  lon: 4321, -- longitude
}
```

#### `WeatherResult`
`WeatherResult` will only contain either a `success` or a `failure`, never both.

Please ignore the fact the numbers don't add up.
```lua
{
  success = Weather,
  failure = "Some reason this went wrong as a string.",
}
```

#### `Weather`
```lua
{
  temp = {
    k = 300 -- Temp in Kelvin,
    f = 100 -- Temp in F,
    c = 20 -- Temp in C,
  },
  humidity = 56, -- Humidity percentage
  condition_icon = "Some string representing the weather. There is no obligation for this to be a single unicode character",
},
```

### `require'weather'`
| Function | Args | Returns | Notes |
| -------- | ---- | ------- | ----- | 
| `location_lookup` | | `Location` | Looks up the user's location based on ip address. Uses `ip-api.com` |
| `get_default_blocking` | `location` - a table with `{lat = x, lon = y}` for the location. If not provided, defaults to the result of `location_lookup`. | `Weather` | The method chosen is `config.default` |
| `get_cached` | | `Weather?` | Gets the last cached `Weather`. May be `nil` if never fetched, or cache expired. |
| `get_default` | `location` - Same as `get_default_blocking`<br>`callback` (`function(Weather)`) - A callback function. | Same as `get_default_blocking`, but runs async. `callback` is called when the results are fetched. |

### 'require'weather.sources.openweathermap'`
Provides direct access to Open Weather Map.
| Function | Args | Returns | Notes |
| -------- | ---- | ------- | ----- |
| `get_raw` | `args` (table) - The query parameters for `onecall` | A table with one value; either `"success" = (table with OWM result)` or `"failure" = (string with OWM result)`. | Does a raw fetch of OWM data. See documentation at https://openweathermap.org/api/one-call-api.
| `get` | `location` (`Location`)<br>`config` - The configuration | `Weather` | Fetches weather from OWM and returns it as a `Weather`. |


## Integration with [`lualine`](https://github.com/nvim-lualine/lualine.nvim)
`weather.nvim` can integrate easily with `lualine`. To do so, you will need two things:

### A formatter
You will be given a `Weather` object, and you will need to convert this to a `string`. For example, this will format like "{icon} 100 F".
```lua
local function format(weather)
  return data.condition_icon .. " " .. math.floor(data.temp.f) .. "°F"
end
```
Optionally, you can use one of the following built-in formatters (avaliable from `require'weather.lualine'`

| Name | Example |
| ---- | ------- |
| `default_f` | "{icon}  100°F" |
| `default_c` | "{icon}  45°C" |

### Add to configuration
Then, tell lualine to add it to your configuration:
```lua
require('lualine').setup {
  sections = {
    ...
	lualine_a = { "require'weather.lualine'.custom(my_custom_formatter, '羽')" }
	lualine_b = { "require'weather.lualine'.custom(my_custom_formatter)" }
    lualine_c = { default_f },
  }
}
```

## Customizing
There are two layers of abstraction for converting weather results to icons. First, the weather source returns the name of an icon. See `config.openweathermap.weather_code_to_icons` for an example of what this looks like.

After that, the icon is looked up in `config.weather_icons.{day/night}`. If the returned icon id is not found in this, the text is used literally.

So, if you want to change how OWM renders condition code 771 (Squall), you can update `config.openweathermap.weather_code_to_icons` either to be another icon id listed in `config.weather_icons`, or a specific icon that you want.

If you want to update the way all `'snow'` results look, update `config.weather_icons.{day/night}.snow` to be the icon you want.

The "icons" above are not limited to a single unicode/asci character/emoji, but are any string you want. You could have `config.weather_icons.day.clear = "Tis a beautiful day today I shal have a picnic"`. I mean, you can, but that's ridiculous.

Optionally, there is `weather.other_icons` which you can use to setup nerdfonts:
```lua
require'weather'setup { 
  weather_icons = require'weather.other_icons'.nerd_font
}
```
Additional icon groups are welcome.

## Roadmap
[ ] Alerts with [`nvim-notify`](https://github.com/rcarriga/nvim-notify).
[ ] Exposing other information such as forcasts.
