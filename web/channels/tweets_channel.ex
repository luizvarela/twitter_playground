defmodule TwitterPlayground.TweetsChannel do
  use Phoenix.Channel
  require Logger

  alias TwitterPlayground.TweetStreamer

  def join("tweets:stream", %{"track" => query}, socket) do
    Logger.debug "Joined"
    send(self, {:after_join, query})
    {:ok, socket}
  end

  def handle_info({:after_join, query}, socket) do
    push socket, "join", %{status: "connected"}
    spawn(fn() -> TweetStreamer.start(socket, query) end)
    {:noreply, socket}
  end
end

defmodule TwitterPlayground.TweetStreamer do
  def start(socket, query) do
    stream = ExTwitter.stream_filter(track: query)
    for tweet <- stream do
      Phoenix.Channel.push(socket, "tweet:stream", tweet)
    end
  end
end
