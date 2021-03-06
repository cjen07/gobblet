defmodule Gobblet.Web.PlayerController do
  use Gobblet.Web, :controller

  plug :scrub_params, "player" when action in [:create]

  def new(conn, _params) do
    if conn.assigns.current_player do
      redirect(conn, to: game_path(conn, :new))
    else
      render conn, "new.html", name: nil
    end
  end

  def create(conn, %{"player" => player_params}) do
    player = Map.get(player_params, "name", "Anonymous")

    conn
    |> Gobblet.Web.Auth.login(player)
    |> redirect(to: game_path(conn, :new))
  end

  def delete(conn, _params) do
    conn
    |> Gobblet.Web.Auth.logout()
    |> redirect(to: player_path(conn, :new))
  end
end
