defmodule JustTravel.Utils.Repo do
  import Ecto.Query

  def paginate(queryable, opts) do
    page = Map.get(opts, :page, 1)
    per_page = Map.get(opts, :per_page, 10)
    do_paginate(queryable, page, per_page)
  end

  defp do_paginate(queryable, page, per_page) when is_binary(per_page) or is_binary(per_page) do
    page = String.to_integer(page)
    per_page = String.to_integer(per_pagex)
    do_paginate(queryable, page, per_page)
  end

  defp do_paginate(queryable, page, per_page) when page > 0 do
    offset = per_page * (page - 1)

    from queryable,
      limit: ^per_page,
      offset: ^offset
  end

  defp do_paginate(queryable, _page, per_page), do: do_paginate(queryable, 1, per_page)
end
