defmodule Smining.Trex.Api do
  use Tesla

  plug Tesla.Middleware.JSON, engine_opts: [keys: :atoms]
  plug Tesla.Middleware.Retry, max_retries: 0
  plug Tesla.Middleware.Timeout, timeout: 1000
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]

  def summary(ip, port) do
    get("http://#{ip}:#{port}/summary")
  end
end
