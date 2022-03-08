defmodule Smining.Trex do
  @default_port 4067

  import Smining.Util
  alias Smining.Trex.Api

  def detect_and_sync_rigs do
    rigs = default_ip_range()
    |> Enum.map(&Task.async(fn ->
      IO.puts("Scanning #{&1}...")
      Api.summary(&1, @default_port)
    end))
    |> Task.await_many(:infinity)
    |> Enum.filter(&check_response/1)

    case length(rigs) do
      0 ->
        IO.puts("Found no rigs in current network")
      n ->
        IO.puts("Found #{n} potential rigs!")
    end
  end

  defp check_response({:error, _}), do: false
  defp check_response({:ok, %{status: status}}), do: status == 200
end
