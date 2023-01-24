# The following code is referenced from:
# https://gist.github.com/joshnuss/08603e11615ee0de65724be4d63354755
defmodule NginxLivebookUtils.UdpLogParser do
  use GenServer

  ## Client
  def start_link(opts) do
    port  = Keyword.get(opts, :port, 514)
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def set_packet_handler(handler_fn) do
    GenServer.cast(__MODULE__, {:set_packet_handler, handler_fn})
  end

  ## Server

  @impl true
  def init(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])
    {:ok, %{handler_fn: nil, socket: socket}}
  end

  @impl true
  def handle_cast({:set_packet_handler, handler_fn}, state) do
    {:noreply, Map.put(state, :handler_fn, handler_fn)}
  end

  @impl true
  def handle_info({:udp, _socket, _address, _port, data}, state) do
    handle_packet(data, state)
  end

  defp handle_packet("quit\n", %{socket: socket}) do
    IO.puts("Received: quit from udp")
    :gen_udp.close(socket)
    {:stop, :normal, nil}
  end

  defp handle_packet(_log_message, %{handler_fn: nil} = state) do
    {:noreply, state}
  end

  # Handle the pertinent log entry from the frontend
  defp handle_packet(log_message, %{handler_fn: handler_fn} = state) do
    handler_fn.(log_message)
    {:noreply, state}
  end

  # fallback pattern match to handle all other (non-"quit") messages
  defp handle_packet(_data, state) do
    {:noreply, state}
  end
end
