defmodule ConfexCached do
  @moduledoc """
  Documentation for ConfexCached.
  """
  use Application
  import Supervisor.Spec

  @default_cache ConfexCached.Cache.GenServer
  @cache Application.get_env(:confex_cached, :cache) || @default_cache

  def start(_type, _args) do
    children = [
      worker(@cache, [])
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def start() do
    {:ok, _} = Application.ensure_all_started(:confex_cached)
  end

  @spec fetch_env(app :: atom(), key :: atom(), opts :: keyword()) :: {:ok, term()} | :error
  def fetch_env(app, key, opts \\ []) do
    env = case @cache.get({app, key}, opts) do
      nil -> Confex.fetch_env(app, key)
      value -> {:cached, value}
    end

    case env do
      {:ok, value} ->
        @cache.put({app, key}, value, opts)
        env
      {:cached, value} ->
        {:ok, value}
      _ -> :error
    end
  end

  @spec fetch_env!(app :: atom(), key :: atom(), opts :: keyword()) :: {:ok, term()} | :error
  def fetch_env!(app, key, opts \\ []) do
    with {:ok, value} <- fetch_env(app, key, opts) do
      value
    else
      _ ->
        raise ArgumentError, "can't fetch value for key `#{inspect(key)}` of application `#{inspect(app)}`"
    end
  end

  def clear_cached_env(app, key, opts \\ []) do
    @cache.put({app, key}, nil, opts)
  end

  def set_cached_env(app, key, value, opts \\ []) do
    @cache.put({app, key}, value, opts)
  end
end
