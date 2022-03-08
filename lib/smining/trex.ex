defmodule Smining.Trex do
  @default_port 4067

  import Smining.Util
  alias Smining.Trex.Api
  alias Smining.{Rig, Db}

  def detect_and_sync_rigs do
    rigs = default_ip_range()
    |> Enum.map(&Task.async(fn ->
      IO.puts("Scanning #{&1}...")
      Api.summary(&1, @default_port)
    end))
    |> Task.await_many(:infinity)
    |> Enum.filter(&check_response/1)
    |> Enum.map(fn {_, %{body: body}} -> body end)

    case length(rigs) do
      0 ->
        IO.puts("Found no rigs in current network")
      n ->
        IO.puts("Found #{n} potential rigs!")
        rigs
        |> Enum.map(&map_rig/1)
        |> Db.sync_rigs()
    end
  end

  defp map_rig(rig) do
    %Rig{
      gpu_total: rig.gpu_total,
      gpus: Enum.map(rig.gpus, &(%Rig.GPU{
        device_id: &1.device_id,
        fan_speed: &1.fan_speed,
        gpu_user_id: &1.gpu_user_id,
        hashrate: &1.hashrate,
        name: &1.name,
        temperature: &1.temperature
      })),
      hashrate: rig.hashrate,
      hashrate_day: rig.hashrate_day,
      hashrate_minute: rig.hashrate_minute,
      miner_name: rig.name,
      os: rig.os,
      uptime: rig.uptime
    }
  end

  defp check_response({:error, _}), do: false
  defp check_response({:ok, %{status: status}}), do: status == 200
end
