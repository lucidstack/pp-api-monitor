defmodule PpApiMonitor.ApiClient do
  use Timex
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://appsignal.com"
  plug Tesla.Middleware.Headers
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger

  def summary do
    text = "Total: #{hits}\nCountries: #{hits(:countries)} | Protected areas: #{hits(:pas)}"
    System.cmd("terminal-notifier", ["-title", "PP API Summary", "-message", text])
  end

  def hits,             do: query_api |> sum("total_hits")
  def hits(:all),       do: query_api |> sum("total_hits")
  def hits(:pas),       do: query_api |> sum("protected_areas_hits")
  def hits(:countries), do: query_api |> sum("countries_hits")
  def hits(:per_user),  do: query_api |> group(~r/token_.{32}_hits$/)

  defp query_api do
    make_url
    |> get
    |> Map.get(:body)
    |> Map.get("data")
    |> Enum.map(& &1["data"])
    |> Enum.map(&Map.get(&1, "c"))
  end

  defp sum(data, what) do
    Enum.reduce data, 0, fn
      (%{^what => value}, acc) -> acc + value
      (_metric, acc)           -> acc
    end
  end

  defp group(data, regex) do
    Enum.reduce(data, %{}, &accumulate_tokens(&1, &2, regex))
  end

  defp accumulate_tokens(metric, final, regex) do
    metric
    |> Map.keys
    |> Enum.filter(&Regex.match?(regex, &1))
    |> Enum.reduce(final, fn(key, map) ->
      <<"token_", token::binary-size(32), _rest::binary>> = key
      Map.update(map, token, 0, &(&1 + metric[key]))
    end)
  end

  defp make_url do
    app_id = Application.get_env(:pp_api_monitor, :app_id)
    token = Application.get_env(:pp_api_monitor, :token)
    {:ok, date} = Timex.today
      |> Timex.shift(months: -1)
      |> Timex.format("{ISO:Extended}")

    "/api/#{app_id}/graphs/custom.json?token=#{token}&from=#{date}&kind=custom"
  end
end
