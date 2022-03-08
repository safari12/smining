defmodule Smining.Rig do
  defstruct [
    :gpu_total,
    :gpus,
    :hashrate,
    :hashrate_day,
    :hashrate_minute,
    :miner_name,
    :os,
    :uptime,
    :gpio_on_pin,
    :gpio_off_pin
  ]

  defmodule GPU do
    defstruct [
      :device_id,
      :fan_speed,
      :gpu_user_id,
      :hashrate,
      :name,
      :temperature
    ]
  end
end
