defmodule UltimateChat.MessagesTest do
  use UltimateChat.DataCase

  alias UltimateChat.Messages

  describe "messages" do
    alias UltimateChat.Schema.Message

    import UltimateChat.MessagesFixtures

    @invalid_attrs %{text: nil, sender_id: nil, room_id: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "list_messages_by_room/2 returns paginated list of messages" do
      room = UltimateChat.RoomsFixtures.room_fixture()

      message_1 = message_fixture(%{room_id: room.id})
      message_2 = message_fixture(%{room_id: room.id})

      assert %Paginator.Page{
               metadata: %Paginator.Page.Metadata{after: after_metadata, before: before_metadata},
               entries: [result_message]
             } = Messages.list_messages_by_room(room.id, limit: 1)

      assert result_message == message_2
      refute is_nil(after_metadata)
      assert is_nil(before_metadata)

      assert %Paginator.Page{
               metadata: %Paginator.Page.Metadata{after: after_metadata, before: before_metadata},
               entries: [result_message]
             } = Messages.list_messages_by_room(room.id, after: after_metadata)

      assert result_message == message_1
      assert is_nil(after_metadata)
      refute is_nil(before_metadata)
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      user = UltimateChat.UsersFixtures.user_fixture()
      room = UltimateChat.RoomsFixtures.room_fixture()

      valid_attrs = %{text: "some text", sender_id: user.id, room_id: room.id}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.text == "some text"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.text == "some updated text"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
