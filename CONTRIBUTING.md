# Contributing

Contributions are always welcome! Please look below for more info on specific types of contributions. PRs are wonderful!

## Bugs
I'm sure they're there. Please report them and I'll get to them ASAP.

## New Sources
Please ensure the new source roughly matches our `Weather` object. Some fields may not exist, so please document them. Not sources match this, and we want to keep the info as universal as possible.

Please look at `weather/sources/openweathermap.lua` for examples on how to write one.

## Icon Suggestions
I'm not a master of emojis, so if there is a better one out there, I am open to it. I only ask that the icon accurately represent the weather condition.

## Another `other_icons` group
I am always open to more icon groups. Please ask yourself the following:

- Is it something more than one person would use? If not, this is probably best in your `init.lua`
- Is this a localized thing (e.g. English text, references only some locales would understand)? If it is, it may be best in a gist. I am happy to aggregate commutity driven groups on the README.
- Does it represent weather, or another set of icons entirely? Again, we should keep `other_icons` more oriented towards weather, and this would be a better community group imo.

## More integrations
Integrations with other parts of the nvim community are great. Please submit an issue or a PR, and I'll take a look.

