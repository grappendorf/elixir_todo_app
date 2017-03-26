defmodule Store do
  defstruct state: nil, reducers: [], subscribers: [], middlewares: []

  def new(initial_state) do
    %Store{
      state: initial_state
    }
  end

  def state(store), do: store.state

  def reduce store, reducer do
    %Store{store | reducers: [reducer | store[:reducers]]}
  end

  def subscribe store, subscriber do
    %Store{store | subscribers: [subscriber | store[:subscribers]]}
  end

  def middleware store, middleware do
    %Store{store | middlewares: [middleware | store[:middlewares]]}
  end

  def dispatch store, action do
    new_action = apply_middlewares :pre, store[:middlewares], store.state, store.state, action
    new_state = case new_action do
      {} ->
        store.state
      _ ->
        reduce_state store[:reducers], store.state, new_action
    end
    apply_middlewares :post, store[:middlewares], new_state, store.state, action
    notify_subscribers store[:subscribers], new_state, store.state
    %Store{store | state: new_state}
  end

  defp reduce_state(reducers, state, action) when is_list(reducers) do
    reducers |> Enum.reduce(state, &({nil, reduce_state(&1, &2, action)}))
  end

  defp reduce_state(reducer, state, action) when is_pid(reducer) do
    GenServer.call reducer, {action, state}
  end

  defp reduce_state(reducer, state, action) when is_atom(reducer) do
    apply reducer, :reduce, [state, action]
  end

  defp reduce_state(reducer, state, action) when is_function(reducer) do
    reducer.(state, action)
  end

  defp notify_subscribers(subscribers, new_state, old_state) when is_list(subscribers) do
    subscribers |> Enum.each(&(notify_subscribers(&1, new_state, old_state)))
  end

  defp notify_subscribers(subscriber, new_state, old_state) when is_pid(subscriber) do
    GenServer.call subscriber, {:update, new_state, old_state}
  end

  defp notify_subscribers(subscriber, new_state, old_state) when is_atom(subscriber) do
    apply subscriber, :update, [new_state, old_state]
  end

  defp notify_subscribers(subscriber, new_state, old_state) when is_function(subscriber) do
    subscriber.(new_state, old_state)
  end

  defp apply_middlewares(stage, middlewares, new_state, old_state, action) when is_list(middlewares) do
    res = middlewares |> Enum.reduce(action, &({nil, apply_middlewares(stage, &1, new_state, old_state, &2)}))
    res
  end

  defp apply_middlewares(stage, middleware, new_state, old_state, action) when is_pid(middleware) do
    GenServer.call middleware, {stage, action, new_state, old_state}
  end

  defp apply_middlewares(stage, middleware, new_state, old_state, action) when is_atom(middleware) do
    apply middleware, :apply, [stage, new_state, old_state, action]
  end

  defp apply_middlewares(stage, middleware, new_state, old_state, action) when is_function(middleware) do
    middleware.(stage, new_state, old_state, action)
  end

  def start store do
    Agent.start fn -> store end, name: :store
  end

  def dispatch action do
    Agent.update :store, fn store -> Store.dispatch(store, action) end
  end
end
