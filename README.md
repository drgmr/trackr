# Trackr

To start the application:

  * Ensure the database is running with `docker-compose up -d`
  * Install dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.setup`
  * Start the Phoenix endpoint with `iex -S mix phx.server`

Tests can be run with `mix test`.

Now you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser.
