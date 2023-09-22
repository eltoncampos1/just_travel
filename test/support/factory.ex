defmodule JustTravel.Factory do
  use ExMachina.Ecto, repo: JustTravel.Repo

  alias JustTravel.Schemas

  def location_factory(attrs) do
    %Schemas.Location{
      name: "Disney",
      country: "USA"
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def ticket_factory(attrs) do
    %Schemas.Ticket{
      name: "Viagem para a disney",
      description: "Lorem ipsum silor dolor amet",
      date: Date.utc_today(),
      location: build(:location)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def ticket_price_factory(attrs) do
    %Schemas.TicketPrice{
      price: Money.new(2000),
      category: Enum.random([:children, :adult]),
      ticket: build(:ticket)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def ticket_discount_factory(attrs) do
    %Schemas.TicketDiscount{
      discount_name: "Childrens day",
      discount_amount: Money.new(500),
      ticket: build(:ticket)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end
end
