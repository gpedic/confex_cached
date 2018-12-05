defmodule ConfexCached.Cache do

  @typep value :: any()
  @typep key :: tuple()
  @typep opts :: keyword()

  @doc """
  Retrieve a cashed value by key

  nil if value does not exist
  """
  @callback get(key, opts) :: value

  @doc """
  Cache a value
  """
  @callback put(key, value, opts) :: atom()
end