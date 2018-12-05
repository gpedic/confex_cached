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
    try do
      {:ok, fetch_env!(app, key, opts)}
    rescue
      _ -> :error
    end
  end

  @spec fetch_env!(app :: atom(), key :: atom(), opts :: keyword()) :: {:ok, term()} | :error
  def fetch_env!(app, key, opts \\ []) do
    case @cache.get({app, key}, opts) do
      nil ->
        value = Confex.fetch_env!(app, key)
        :ok = @cache.put({app, key}, value, opts)
        value
      value -> value
    end
  end

  @spec delete_env_cache(app :: atom(), key :: atom(), opts :: keyword()) :: :ok | :error
  def delete_env_cache(app, key, opts \\ []) do
    @cache.delete({app, key}, opts)
  end

  @spec put_env_cache(app :: atom(), key :: atom(), value :: any(), opts :: keyword()) :: :ok | :error
  def put_env_cache(app, key, value, opts \\ []) do
    @cache.put({app, key}, value, opts)
  end
end
