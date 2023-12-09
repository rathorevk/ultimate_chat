defmodule UltimateChatWeb.Plug.Session do
  import Plug.Conn, only: [get_session: 2, put_session: 3, assign: 3]
  # import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  alias UltimateChatWeb.ETS.UserAuth

  require Logger

  def validate_session(conn, _opts) do
    case get_session(conn, :session_uuid) do
      nil ->
        session_uuid = Ecto.UUID.generate()
        Logger.debug("New session: #{session_uuid}")

        conn
        |> put_session(:session_uuid, session_uuid)

      session_uuid ->
        Logger.debug("Existing session: #{session_uuid}")

        conn
        |> validate_session_token(session_uuid)
    end
  end

  defp validate_session_token(conn, session_uuid) do
    case get_user_id(session_uuid) do
      nil ->
        conn

      user_id ->
        Logger.debug("Validate user session: #{user_id}")

        conn |> assign(:user_id, user_id) |> put_session(:user_id, user_id)
    end
  end

  defp get_user_id(session_uuid) do
    case UserAuth.lookup(session_uuid) do
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

  defp signing_salt do
    UltimateChatWeb.Endpoint.config(:live_view)[:signing_salt] ||
      raise "missing signing_salt"
  end
end
