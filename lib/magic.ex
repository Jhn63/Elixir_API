defmodule Magic do

  @cards_url       "https://api.magicthegathering.io/v1/cards"
  @sets_url        "https://api.magicthegathering.io/v1/sets"
  @types_url       "https://api.magicthegathering.io/v1/types"
  @subtypes_url    "https://api.magicthegathering.io/v1/subtypes"
  @supertypes_url  "https://api.magicthegathering.io/v1/supertypes"

  def mostrar_cartas() do
    data = Api.obtem_resposta(@cards_url)
    mostrar_cartas(data["cards"], "Creature")
  end

  defp mostrar_cartas([], _type), do: []
  defp mostrar_cartas([i | resto], type \\ "") do
    if type == "" or String.contains?(i["type"], type) do
      [Map.take(i, ["name","manaCost","type","power","toughness"]) | mostrar_cartas(resto)]
    else
      mostrar_cartas(resto,type)
    end
  end

end
