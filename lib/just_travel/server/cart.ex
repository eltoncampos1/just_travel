defmodule JustTravel.Server.Cart do
  @moduledoc """
  GenServer to handle with shop carts
  """
  use GenServer
  @name :cart_session

  alias JustTravel.Schemas.Cart.Repository, as: CartRepository

  def server_name, do: @name

  def start_link(_) do
    GenServer.start_link(__MODULE__, @name, name: @name)
  end

  def init(name) do
    :ets.new(name, [:set, :public, :named_table])
    {:ok, name}
  end

  def add(cart_id, item), do: GenServer.cast(@name, {:add, cart_id, item})
  def create(cart_id), do: GenServer.cast(@name, {:create, cart_id})

  def delete(cart_id, item_id), do: GenServer.cast(@name, {:delete, cart_id, item_id})

  def get(cart_id), do: GenServer.call(@name, {:get, cart_id})

  def handle_cast({:create, cart_id}, name) do
    case CartRepository.find_cart(cart_id) do
      {:error, :not_found} -> CartRepository.new(cart_id)
      {:ok, _} -> :ok
    end

    {:noreply, name}
  end

  def handle_cast({:add, cart_id, item}, name) do
    case CartRepository.find_cart(cart_id) do
      {:error, :not_found} ->
        {:ok, _cart} = CartRepository.new(cart_id)
        CartRepository.add_item(cart_id, item)

      {:ok, _} ->
        CartRepository.add_item(cart_id, item)
    end

    {:noreply, name}
  end

  def handle_cast({:delete, cart_id, item_id}, name) do
    case CartRepository.find_cart(cart_id) do
      {:error, :not_found} ->
        send(JustTravelWeb.PageLive, {:delete_error, cart_id})

      {:ok, _} ->
        CartRepository.remove_item(cart_id, item_id, :delete)
    end

    {:noreply, name}
  end

  def handle_call({:get, cart_id}, _from, name) do
    case CartRepository.find_cart(cart_id) do
      {:error, :not_found} -> {:reply, :not_found, name}
      {:ok, cart} -> {:reply, cart, name}
    end
  end
end
