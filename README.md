[![Build Status](https://travis-ci.com/gpedic/confex_cached.svg?branch=master)](https://travis-ci.com/gpedic/confex_cached)
[![codecov](https://codecov.io/gh/gpedic/confex_cached/branch/master/graph/badge.svg)](https://codecov.io/gh/gpedic/confex_cached)

# ConfexCached

A simple wrapper for confex adding caching functionality to `fetch_env` calls.
Mostly intended to be used with [confex_parameter_store](https://github.com/gpedic/confex_parameter_store).

## Installation

The package can be installed by adding `confex_cached` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:confex_cached, "~> 0.1.0"}
  ]
end
```

Read the full [documentation](https://hexdocs.pm/confex_cached).

## Basic Usage

To start using ConfexCached simply replace any calls to `Confex.fetch_env/2` or `Confex.fetch_env!/2` with `ConfexCached.fetch_env/3` and `ConfexCached.fetch_env!/3`.

After the first call the whole response will be cached and subsequent calls will return the cached value.

The added third parameter `opts` is optional and is intened to be used as options keyword list for custom cache mechanisms.

When using the basic GenServer based cache the cached values stay cached until either the app is restarted or they are deleted or overriden via `Confex.delete_env_cache/3` or `Confex.put_env_cache/3`.

```elixir
ConfexCached.put_env_cache(:myapp, MyApp.Example, "hello")
ConfexCached.delete_env_cache(:myapp, MyApp.Example)
```


## Custom cache

You can plug your custom cache mechanism by implementing the `ConfexCached.Cache` behavior define by [cache.ex](./lib/cache.ex) and defining it in the config.

```elixir
config :confex_cached, cache: MyApp.ConfexCustomCache
```