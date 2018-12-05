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

  @tag create_app_env: {:myapp, MyApp.Test, [text: "test"]}
  test "env is cached after retrieval" do
    {:ok, env} = ConfexCached.fetch_env(:myapp, MyApp.Test)

    # delete the env so the only way it is retrieved is if it's
    # actually cached
    :ok = Application.delete_env(:myapp, MyApp.Test)

    {:ok, cached_env} = ConfexCached.fetch_env(:myapp, MyApp.Test)

    assert env == cached_env
  end

  test "when env is already cached" do
    ConfexCached.set_cached_env(:myapp11, MyApp.Test, [text: "test"])
    {:ok, env} = ConfexCached.fetch_env(:myapp11, MyApp.Test)
    assert [text: "test"] = env
  end

  @tag create_app_env: {:myapp2, MyApp.Test, [text: "test"]}
  test "fetch_env!" do
    assert [text: "test"] = ConfexCached.fetch_env!(:myapp2, MyApp.Test)
  end

  test "fetch_env! raises if invalid" do
    assert_raise ArgumentError, fn -> ConfexCached.fetch_env!(:myapp22, MyApp.Test) end
  end

  @tag create_app_env: {:myapp3, MyApp.Test, [text: "test"]}
  test "put_cached_env" do
    {:ok, _} = ConfexCached.fetch_env(:myapp3, MyApp.Test)
    assert :ok = ConfexCached.set_cached_env(:myapp3, MyApp.Test, "asdf")
    assert {:ok, "asdf"} = ConfexCached.fetch_env(:myapp3, MyApp.Test)
  end

  test "clear_cached_env" do
    :ok = ConfexCached.set_cached_env(:myapp4, MyApp.Test, "test1234")
    assert {:ok, "test1234"} = ConfexCached.fetch_env(:myapp4, MyApp.Test)
    assert :ok = ConfexCached.clear_cached_env(:myapp4, MyApp.Test)
    assert :error = ConfexCached.fetch_env(:myapp4, MyApp.Test)
  end
end
