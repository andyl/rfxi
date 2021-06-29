defmodule RfxiWeb.RfxSocket do
  @behaviour Phoenix.Socket.Transport

  def child_spec(_opts) do
    # We won't spawn any process, so let's return a dummy task
    # %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
    %{id: :ws_rfx, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  def connect(state) do
    IO.inspect state, label: "CONNECT_RFX_SOCKET"
    # Callback to retrieve relevant data from the connection.
    # The map contains options, params, transport and endpoint keys.
    {:ok, state}
  end

  def init(state) do
    # Now we are effectively inside the process that maintains the socket.
    {:ok, state}
  end

  def handle_in({text, _opts}, state) do
    output = RfxCli.Base.main_core(text).json
    {:reply, :ok, {:text, output}, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
