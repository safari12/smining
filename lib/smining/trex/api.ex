defmodule Smining.Trex.Api do
  use Tesla

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Retry, max_retries: 0
  plug Tesla.Middleware.Timeout, timeout: 1000

  def summary(ip, port) do
    get("http://#{ip}:#{port}/summary")
  end
end
