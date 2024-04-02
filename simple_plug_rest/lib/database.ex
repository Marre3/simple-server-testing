defmodule Database do
  @moduledoc """
  A simple database which stores messages in a list
  """

  def init() do
    IO.puts("Init DB")
    Process.register(self(), :db)
    loop([])
  end

  def loop(db) do
    receive do
      # Store new message by recursive call with new `db` list
      {:store, value} ->
        loop([value | db])

      # Get stored messages and send to process `pid`, then run loop again recursively
      {:get, pid} ->
        db
        |> (fn x ->
              send(pid, {:messages, x})
              x
            end).()
        |> loop()
    end
  end
end
