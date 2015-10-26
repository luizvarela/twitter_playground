defmodule TwitterPlayground.TweetsSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket

  channel "tweets:*", TwitterPlayground.TweetsChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
