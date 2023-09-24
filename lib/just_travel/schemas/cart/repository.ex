defmodule JustTravel.Schemas.Cart.Repository do
  alias JustTravel.Schemas.Cart
  alias JustTravel.Server.Cart, as: CartServer

  @name CartServer.server_name()

  @spec new(cart_id :: binary()) :: JustTravel.Schemas.Cart.t()
  def new(cart_id) do
    cart = %Cart{id: cart_id}
    upsert(cart_id, cart)
  end

  defp upsert(cart_id, cart) do
    :ets.insert(@name, {cart_id, cart})
    {:ok, cart}
  end

  def add_item(cart_id, item) do
    case find_cart(cart_id) do
      {:ok, cart} ->
        cart = add(cart, item)
        upsert(cart_id, cart)

      {:error, :not_found} ->
        with {:ok, cart} <- new(cart_id),
             %Cart{} = cart <- add(cart, item) do
          upsert(cart_id, cart)
        end
    end
  end

  def find_cart(cart_id) do
    case :ets.lookup(@name, cart_id) do
      [] -> {:error, :not_found}
      [{_cart_id, value}] -> {:ok, value}
    end
  end

  defp add(%Cart{} = cart, item) do
    new_price = Money.add(cart.total_price, item.price)

    %Cart{
      cart
      | items: add_or_update_qty(cart.items, item),
        total_qty: cart.total_qty + 1,
        total_price: new_price
    }
  end

  defp add_or_update_qty(items, item) do
    case Enum.find_index(items, &(&1.item.id == item.id)) do
      nil -> [%{item: item, qty: 1}] ++ items
      index -> List.replace_at(items, index, &%{&1 | qty: &1.qty + 1})
    end
  end
end
