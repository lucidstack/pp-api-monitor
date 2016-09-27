defmodule PpApiMonitor do
  alias PpApiMonitor.ApiClient
  use Application

  def start(_type, _args) do
    :timer.apply_interval(every, ApiClient, :summary, [])
    {:ok, self}
  end

  defp every, do: Application.get_env(:pp_api_monitor, :every)
end
