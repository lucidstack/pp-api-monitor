# Protected Planet API Monitor

This is a tiny monitor and aggregator for the [Protected Planet API](http://api.protectedplanet.net)
metrics from [Appsignal](https://appsignal.com).

## Installation

1. Clone this repository
2. Ensure you have `terminal-notifier` installed
3. Edit your `config/config.exs` with your `app_id` and `token` (you can grab those by inspecting the Appsignal API calls made in the custom metrics interface 👌)
4. Run `mix run --no-halt` 🎉
