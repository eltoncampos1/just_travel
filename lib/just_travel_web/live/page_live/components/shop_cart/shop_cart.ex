defmodule JustTravelWeb.PageLive.Components.ShopCart do
  alias Phoenix.LiveView
  use JustTravelWeb, :live_component
  import LiveView.Component
  # alias JustTravel.Schemas.Cart

  def empty_cart(assigns) do
    ~H"""
    <div class="w-full min-w-lg flex flex-col items-center">
      <p>Seu carrinho esta vazio</p>
      <Heroicons.shopping_cart solid class="w-6 h-6" />
    </div>
    """
  end

  def translate_category(:adult), do: "Adulto"
  def translate_category(:children), do: "Criança"

  def calculate_price(ticket) do
    Money.multiply(ticket.item.price, ticket.qty)
  end

  def calculate_discount(cart) do
    total = Enum.reduce(cart.items, Money.new(0), &Money.add(&1.item.price, &2))
    discount = Enum.reduce(cart.items, Money.new(0), &Money.add(&1.item.discount, &2))
    percent = discount.amount / total.amount * 100

    total_discount = Money.subtract(discount, total)
    %{percent: percent, discount: total_discount, total: total}
  end
end
