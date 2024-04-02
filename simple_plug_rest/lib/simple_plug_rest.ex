defmodule SimplePlugRest do
  @moduledoc """
  A simple server that receives and stores messages
  """
  use Plug.Router

  def init(options) do
    IO.puts("Init router")
    options
  end

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/get" do
    # Get stored messages from database and send them to client separated by newlines
    send(:db, {:get, self()})
    conn = put_resp_content_type(conn, "application/json")
    receive do
      {:messages, msgs} ->
        msgs
        |> Enum.reverse()
        |> Enum.map(fn {user, msg} -> %{"user" => user, "message" => msg} end)
        |> (fn x -> %{"messages" => x} end).()
        |> (fn x -> send_resp(conn, 200, Jason.encode!(x)) end).()

      _ ->
        send_resp(conn, 500, "error")
    end
  end

  post "/send" do
    # Send new message (stored in the msg variable) to the database
    IO.inspect(conn.body_params)

    case conn.body_params do
      %{"message" => msg, "user" => user} when is_binary(msg) and is_binary(user) ->
        send(:db, {:store, {user, msg}})
        send_resp(conn, 200, "success")

      _ ->
        send_resp(conn, 500, "invalid msg post")
    end
  end

  match _ do
    # Invalid request, 404 not found
    send_resp(conn, 404, "Invalid endpoint")
  end
end
