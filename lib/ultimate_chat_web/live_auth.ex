defmodule UltimateChatWeb.LiveAuth do
  alias UltimateChat.Schema.User
  alias UltimateChat.Users
  alias UltimateChatWeb.ETS.UserAuth

  import Phoenix.LiveView
  import Phoenix.Component

  require Logger

  def on_mount(:require_authenticated_user, _, session, socket) do
    socket = assign_current_user(socket, session)

    Logger.info("Authenticate user: #{inspect(socket.assigns)}")

    case socket.assigns.current_user do
      nil ->
        {:halt,
         socket
         |> put_flash(:error, "You have to Sign in to continue")
         |> redirect(to: "/")}

      %User{} ->
        {:cont, socket}
    end
  end

  defp assign_current_user(socket, session) do
    Logger.info("LiveAuth session_uuid: #{session["session_uuid"]}")

    case session["session_uuid"] do
      nil ->
        socket |> assign_new(:user_id, fn -> nil end) |> assign_new(:current_user, fn -> nil end)

      session_uuid ->
        user_id = get_user_id(session_uuid)
        Logger.debug("LiveAuth user_id: #{user_id}")

        case user_id do
          nil ->
            socket
            |> assign_new(:user_id, fn -> nil end)
            |> assign_new(:current_user, fn -> nil end)

          user_id ->
            user = Users.get_user!(user_id)
            Logger.debug("LiveAuth user: #{inspect(user)}")

            socket
            |> assign_new(:user_id, fn -> user_id end)
            |> assign_new(:current_user, fn -> user end)
        end
    end
  end

  defp get_user_id(session_uuid) do
    user_auth = UserAuth.lookup(session_uuid)
    Logger.debug("LiveAuth get_user_id: #{inspect(user_auth)}")

    case user_auth do
      [{_, token}] ->
        case Phoenix.Token.verify(UltimateChatWeb.Endpoint, signing_salt(), token,
               max_age: 806_400
             ) do
          {:ok, user_id} -> user_id
          _ -> nil
        end

      _ ->
        nil
    end
  end

  def signing_salt do
    UltimateChatWeb.Endpoint.config(:live_view)[:signing_salt] ||
      raise "missing signing_salt"
  end
end
