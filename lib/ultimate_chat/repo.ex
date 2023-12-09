defmodule UltimateChat.Repo do
  use Ecto.Repo,
    otp_app: :ultimate_chat,
    adapter: Ecto.Adapters.Postgres

  use Paginator,
    limit: 10
end
