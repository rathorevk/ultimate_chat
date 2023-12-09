defmodule UltimateChat.PubSub do
  @moduledoc """
  The Polls PubSub context module.
  """

  @pub_sub_topic "rooms:"
  # ===========================================================================
  @spec subscribe_to_message_updates(integer()) :: :ok | {:error, {:already_registered, pid()}}
  def subscribe_to_message_updates(room_id) do
    Phoenix.PubSub.subscribe(UltimateChat.PubSub, topic(room_id))
  end

  # ===========================================================================
  @spec broadcast_message_update(integer(), any()) :: :ok | {:error, any()}
  def broadcast_message_update(room_id, msg) do
    Phoenix.PubSub.broadcast(
      UltimateChat.PubSub,
      topic(room_id),
      msg
    )
  end

  defp topic(room_id) do
    @pub_sub_topic <> Integer.to_string(room_id)
  end
end
