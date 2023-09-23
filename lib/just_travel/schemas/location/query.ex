defmodule JustTravel.Schemas.Location.Query do
  @moduledoc """
  Query module for Location
  """
  import Ecto.Query

  def by_location_name(queryable, location_name) when bit_size(location_name) > 0 do
    pattern = "%#{location_name}%"
    where(queryable, [location: location], ilike(location.name, ^pattern))
  end

  def by_location_name(queryable, _), do: queryable
end
