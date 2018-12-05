defmodule ConfexCachedTest do
  use ExUnit.Case
  doctest ConfexCached

  setup context do
    if app_env = context[:create_app_env] do
      {app, key, value} = app_env
      Application.put_env(app, key, value)

      on_exit(fn ->
        Application.delete_env(app, key)
      end)
    end

    :ok
  end

  @tag create_app_env: {:test, Test.CachingBehaviour, [text: "test"]}
  test "env is cached after fetching" do
    {:ok, env} = ConfexCached.fetch_env(:test, Test.CachingBehaviour)

    # delete the env so the only way it is retrieved is if it's actually cached
    :ok = Application.delete_env(:test, Test.CachingBehaviour)

    assert {:ok, ^env} = ConfexCached.fetch_env(:test, Test.CachingBehaviour)
  end

  test "env retrieved directly from cache" do
    value = [text: "test"]
    ConfexCached.put_env_cache(:test2, Test.CachingBehaviour, value)
    {:ok, ^value} = ConfexCached.fetch_env(:test2, Test.CachingBehaviour)
  end

  @tag create_app_env: {:test1, Test.FetchEnvBang, [text: "test"]}
  test "fetch_env!" do
    assert [text: "test"] = ConfexCached.fetch_env!(:test1, Test.FetchEnvBang)
  end

  test "fetch_env! raises if invalid" do
    assert_raise ArgumentError, fn -> ConfexCached.fetch_env!(:test2, Test.FetchEnvBang) end
  end

  @tag create_app_env: {:test, Test.TestPutEnvCache, [text: "test"]}
  test "put_env_cache" do
    {:ok, _} = ConfexCached.fetch_env(:test, Test.TestPutEnvCache)
    assert :ok = ConfexCached.put_env_cache(:test, Test.TestPutEnvCache, "asdf")
    assert {:ok, "asdf"} = ConfexCached.fetch_env(:test, Test.TestPutEnvCache)
  end

  test "delete_env_cache" do
    :ok = ConfexCached.put_env_cache(:test, Test.DeleteEnvCache, "test1234")
    assert {:ok, "test1234"} = ConfexCached.fetch_env(:test, Test.DeleteEnvCache)
    assert :ok = ConfexCached.delete_env_cache(:test, Test.DeleteEnvCache)
    assert :error = ConfexCached.fetch_env(:test, Test.DeleteEnvCache)
  end
end
