# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :pp_api_monitor,
  app_id: "xxxxxxxxxxxxxxxxxxxxxxxx",
  token: "xxxxxxxxxxxxxxxxxxxxxx",

  # you get a notification (metrics are checked) every
  # 10*60*1000 milliseconds (that's 10 minutes)
  every: 60*10*1000

# As a safer alternative, create a config.local.exs file, and set your config
# in there (copy the config above and edit the values). That path is
# gitignored, so it'll never end up being pushed to origin
if File.exists?("config/config.local.exs") do
  import_config "config.local.exs"
end
