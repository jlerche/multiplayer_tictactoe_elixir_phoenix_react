[![Build Status](https://travis-ci.org/jlerche/multiplayer_tictactoe_elixir_phoenix_react.svg?branch=master)](https://travis-ci.org/jlerche/multiplayer_tictactoe_elixir_phoenix_react)
# Tee

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## About

Phoenix provides a lot of features that are well suited to be used for creating
online turn based games.

Channels provide the obvious soft real-time communication
between backend and frontend. One of the challenges though is how to properly
trigger an action at certain points in database transaction. Rails provides
ActiveRecord callbacks and Ecto provided something similar prior to 2.0. However
this has been deprecated in favor of `Ecto.Multi` which provides an idiomatic
pipeline-esque approach to chaining `Repo` methods with the possibility of
including custom functions and actions. Each step of the `Ecto.Multi` chain
must be successful for the entire transaction to be as well. So for example,
if we want to communicate the creation of a resource model to the frontend via
a channel, but only if the creation was actually committed to the database
(for obvious reasons), we can simply do `Multi.new |> Multi.insert(changeset) |> Multi.run(:foo, &foo/1)`
where `foo` is a function that broadcasts to a channel. 
