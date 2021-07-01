defmodule RfxiWeb.EchoChannel do
  use Phoenix.Channel

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("echo", payload, socket) do
    IO.inspect payload, label: "PAYLOAD"
    {:reply, {:ok, %{echo: "PONG"}}, socket}
  end
end
