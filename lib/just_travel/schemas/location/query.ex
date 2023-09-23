defmodule JustTravel.Schemas.Location.Query do
  @moduledoc """
  Query module for Location
  """
  import Ecto.Query

  @spec by_location_name(queryable :: Ecto.Queryable.t(), location_name :: String.t()) ::
          Ecto.Queryable.t()
  def by_location_name(queryable, location_name) when bit_size(location_name) > 0 do
    pattern = "%#{location_name}%"
    where(queryable, [location: location], ilike(location.name, ^pattern))
  end

  def by_location_name(queryable, _), do: queryable
end
