defmodule Smining.Util do
  def default_ip_range do
    0..254 |> Enum.map(&"192.168.1.#{&1}")
  end
end
