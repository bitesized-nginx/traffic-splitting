defmodule NginxLivebookUtils.TrafficGenerator do
  @moduledoc """
  Simple module to generate http requests. We use
  https://github.com/elixir-mint/mint since it's very explicit.
  
  Currently it's a very simple module that reconnects every single request
  """

  @doc """
  
  """
  def run(host, path, opts \\ []) do
    port = Keyword.get(opts, :port, 80)
    request_count = Keyword.get(opts, :call_count, 1)
    call_delay_ms = Keyword.get(opts, :call_delay_ms, 0)
    method = Keyword.get(opts, :method, "GET")

    for _i <- 1..request_count do
      {:ok, conn} = Mint.HTTP.connect(_scheme = :http, _host = host, port, opts)
      {:ok, _conn, _request_ref} = Mint.HTTP.request(conn, method, path, [], "")


      Process.sleep(call_delay_ms)
    end

    "Completed #{request_count} calls"
  end
end
