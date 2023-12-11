defmodule UltimateChatWeb.Live.Login do
  use UltimateChatWeb, :live_view

  alias UltimateChat.Users
  alias UltimateChat.Schema.User
  alias UltimateChatWeb.LiveAuth
  alias UltimateChatWeb.ETS.UserAuth

  require Logger

  @impl true
  def mount(_params, %{"user_id" => user_id, "session_uuid" => session_uuid} = session, socket) do
    Logger.info("Login with user_id: #{inspect(session)}")
    insert_session_token(session_uuid, user_id)
    current_user = Users.get_user!(user_id)

    {:ok, socket |> assign(:current_user, current_user) |> redirect(to: "/rooms")}
  end

  def mount(_params, %{"session_uuid" => session_uuid} = session, socket) do
    Logger.info("Login with session_uuid: #{inspect(session)}")

    {:ok,
     assign(socket,
       form: to_form(Users.change_user(%User{})),
       session_uuid: session_uuid,
       current_user: nil
     )}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    Logger.info("Login validate: #{inspect(params)}")

    form =
      %User{}
      |> Users.change_user(params)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    Logger.info("User login: #{inspect(user_params)}")

    case Users.get_by_username(user_params["name"]) do
      nil ->
        case Users.create_user(user_params) do
          {:ok, user} ->
            ## insert user session
            insert_session_token(socket.assigns.session_uuid, user.id)

            {:noreply,
             socket
             |> put_flash(:info, "User created successfully!")
             |> redirect(to: ~p"/rooms")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end

      user ->
        ## insert user session
        insert_session_token(socket.assigns.session_uuid, user.id)

        {:noreply,
         socket
         |> put_flash(:info, "User logged in successfully!")
         |> push_navigate(to: ~p"/rooms")}
    end
  end

  defp insert_session_token(key, user_id) do
    salt = LiveAuth.signing_salt()
    token = Phoenix.Token.sign(UltimateChatWeb.Endpoint, salt, user_id)
    UserAuth.insert(key, token)
  end
end
