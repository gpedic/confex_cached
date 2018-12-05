defmodule ConfexCached.Cache.GenServer do
  @moduledoc """
  A very simple GenServer based cache
  """
  use GenServer
  @behaviour ConfexCached.Cache

  # Public interface

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def put(key, value, _opts) do
    GenServer.call(__MODULE__, {:put, key, value})
  end

  @impl true
  def get(key, _opts) do
    GenServer.call(__MODULE__, {:get, key})
  end

  # Server (callbacks)

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    {:reply, :ok, Map.put(state, key, value)}
  end
end