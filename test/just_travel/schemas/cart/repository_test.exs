defmodule JustTravel.Schemas.Cart.RepositoryTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Schemas.Cart.Repository
  alias JustTravel.Schemas.Cart

  @default_cart %Cart{
    id: nil,
    items: [],
    total_price: Money.new(0),
    total_qty: 0
  }

  describe "new/1" do
    cart_id = Ecto.UUID.generate()
    assert {:ok, %Cart{id: ^cart_id} = cart} = Repository.new(cart_id)
    assert cart.items == @default_cart.items
    assert cart.total_price == @default_cart.total_price
    assert cart.total_qty == @default_cart.total_qty
  end

  describe "" do
    setup [:add_default_cart, :setup_cart_item]

    test "add new item to cart", %{cart: cart, item: item} do
      item_id = item.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Repository.add_item(cart.id, item)

      assert cart_id == cart.id
    end

    test "should create a cart and add item if cart_id does not exists", %{item: item} do
      item_id = item.id
      cart_id = Ecto.UUID.generate()

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Repository.add_item(cart_id, item)
    end

    test "update item quantity if item is already in the cart", %{cart: cart, item: item} do
      item_id = item.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Repository.add_item(cart.id, item)

      assert cart_id == cart.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [
                  %{
                    item: %{
                      id: ^item_id,
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 2
                  }
                ],
                total_price: %Money{amount: 4000, currency: :BRL},
                total_qty: 2
              }} = Repository.add_item(cart_id, item)
    end

    test "should add new item on the list of items", %{cart: cart, item: old_item} do
      item_id = old_item.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Repository.add_item(cart.id, old_item)

      assert cart_id == cart.id
      new_item_id = Ecto.UUID.generate()
      item = %{price: Money.new(6000), name: "new item", id: new_item_id}

      new_price = Money.add(old_item.price, item.price)

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [
                  %{
                    item: %{
                      id: ^new_item_id,
                      name: "new item",
                      price: %Money{amount: 6000, currency: :BRL}
                    },
                    qty: 1
                  },
                  %{
                    item: %{
                      id: ^item_id,
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 1
                  }
                ],
                total_price: ^new_price,
                total_qty: 2
              }} = Repository.add_item(cart_id, item)
    end

    test "should add new item on the list of items and update if already in the list", %{
      cart: cart,
      item: old_item
    } do
      item_id = old_item.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Repository.add_item(cart.id, old_item)

      assert cart_id == cart.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL},
                      id: ^item_id
                    },
                    qty: 2
                  }
                ],
                total_price: %Money{amount: 4000, currency: :BRL},
                total_qty: 2
              }} = Repository.add_item(cart.id, old_item)

      assert cart_id == cart.id
      new_item_id = Ecto.UUID.generate()
      item = %{price: Money.new(6000), name: "new item", id: new_item_id}

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [
                  %{
                    item: %{
                      id: ^new_item_id,
                      name: "new item",
                      price: %Money{amount: 6000, currency: :BRL}
                    },
                    qty: 1
                  },
                  %{
                    item: %{
                      id: ^item_id,
                      name: "Lorem ipsum",
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 2
                  }
                ],
                total_price: %Money{amount: 10000, currency: :BRL},
                total_qty: 3
              }} = Repository.add_item(cart_id, item)
    end
  end

  describe "find_cart/1" do
    setup [:add_default_cart]

    test "should return cart" do
      cart_id = Ecto.UUID.generate()

      assert {:error, :not_found} = Repository.find_cart(cart_id)
    end

    test "should not found ", %{cart: cart} do
      cart_id = cart.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [],
                total_price: %Money{amount: 0, currency: :BRL},
                total_qty: 0
              }} = Repository.find_cart(cart_id)
    end
  end

  def add_default_cart(_) do
    cart_id = Ecto.UUID.generate()
    {:ok, cart} = Repository.new(cart_id)

    %{cart: cart}
  end

  def setup_cart_item(_) do
    item_id = Ecto.UUID.generate()
    item = %{price: Money.new(2000), name: "Lorem ipsum", id: item_id}
    %{item: item}
  end
end
