defmodule JustTravel.Schemas.Cart.Repository do
  alias JustTravel.Schemas.Cart
  alias JustTravel.Server.Cart, as: CartServer

  @name CartServer.server_name()

  @spec new(cart_id :: binary()) :: JustTravel.Schemas.Cart.t()
  def new(cart_id) do
    %Cart{id: cart_id}
    |> upsert(cart_id)
  end

  def add_item(cart_id, item) do
    case find_cart(cart_id) do
      {:ok, cart} ->
        cart
        |> add(item)
        |> upsert(cart_id)

      {:error, :not_found} ->
        with {:ok, cart} <- new(cart_id),
             %Cart{} = cart <- add(cart, item) do
          upsert(cart, cart_id)
        end
    end
  end

  def find_cart(cart_id) do
    case :ets.lookup(@name, cart_id) do
      [] -> {:error, :not_found}
      [{_cart_id, value}] -> {:ok, value}
    end
  end

  def remove_item(cart_id, item_id, :decrease) do
    case find_cart(cart_id) do
      {:ok, cart} ->
        cart
        |> do_decrease(item_id)
        |> upsert(cart_id)

      err ->
        err
    end
  end

  def remove_item(cart_id, item_id, :delete) do
    case find_cart(cart_id) do
      {:ok, cart} ->
        cart
        |> do_delete(item_id)
        |> upsert(cart_id)

      err ->
        err
    end
  end

  def do_delete(cart, item_id) do
    previous_item = find_item(cart.items, item_id)
    price = Money.multiply(previous_item.item.price, previous_item.qty)
    discount = Money.multiply(previous_item.item.discount, previous_item.qty)
    new_price = change_price_on_remove_item(price, discount, cart.total_price)
    new_items = cart.items -- [previous_item]

    %Cart{
      cart
      | items: new_items,
        total_qty: cart.total_qty - previous_item.qty,
        total_price: new_price
    }
  end

  defp change_price_on_remove_item(price, discount, total_price) do
    new_price = Money.subtract(price, discount)
    Money.subtract(total_price, new_price)
  end

  defp do_decrease(cart, item_id) do
    case Enum.find_index(cart.items, &(&1.item.id == item_id)) do
      nil ->
        cart

      index ->
        previous_item = find_item(cart.items, item_id)

        new_items =
          if decrease_total_qty(previous_item.qty) == 0 do
            cart.items -- [previous_item]
          else
            List.replace_at(cart.items, index, %{
              item: previous_item.item,
              qty: decrease_total_qty(previous_item.qty)
            })
          end

        new_price =
          change_price_on_remove_item(
            previous_item.item.price,
            previous_item.item.discount,
            cart.total_price
          )

        total_qty = decrease_total_qty(cart.total_qty)

        %Cart{
          cart
          | items: new_items,
            total_qty: total_qty,
            total_price: new_price
        }
    end
  end

  defp decrease_total_qty(0), do: 0
  defp decrease_total_qty(value), do: value - 1

  defp add(%Cart{} = cart, item) do
    new_price = calculate_total_price(cart.total_price, item)

    new_items = add_or_update_qty(cart.items, item)

    %Cart{
      cart
      | items: new_items,
        total_qty: cart.total_qty + 1,
        total_price: new_price
    }
  end

  defp calculate_total_price(total_price, item) do
    discount = Map.get(item, :discount, Money.new(0))
    new_price = Money.subtract(item.price, discount)
    Money.add(total_price, new_price)
  end

  defp add_or_update_qty(items, item) do
    case Enum.find_index(items, &(&1.item.id == item.id)) do
      nil ->
        [%{item: item, qty: 1}] ++ items

      index ->
        previous_item = find_item(items, item.id)
        List.replace_at(items, index, %{item: previous_item.item, qty: previous_item.qty + 1})
    end
  end

  defp find_item(items, item_id) do
    Enum.find(items, &(&1.item.id == item_id))
  end

  defp upsert(cart, cart_id) do
    :ets.insert(@name, {cart_id, cart})
    {:ok, cart}
  end
end
