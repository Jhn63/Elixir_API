defmodule Magic do
  @cards_url "https://api.magicthegathering.io/v1/cards"
  @sets_url "https://api.magicthegathering.io/v1/sets"
  @types_url "https://api.magicthegathering.io/v1/types"
  @subtypes_url "https://api.magicthegathering.io/v1/subtypes"
  @supertypes_url "https://api.magicthegathering.io/v1/supertypes"

  def get_cards() do
    data = Api.get(@cards_url)
  end

  def get_types() do
    data = Api.get(@types_url)
  end

  def get_cards(params) when is_list(params) do
    data =
      Api.build_url(@cards_url, params)
      |> Api.get()
  end

  @spec mostrar_cartas(String.t(), String.t()) :: [map()]
  def mostrar_cartas(card_name, language) do
    data = buscar_cartas_por_idioma(card_name, language)
    mostrar_cartas(data["cards"], "", language)
  end

  defp mostrar_cartas([], _type, _language), do: []

  defp mostrar_cartas([i | resto], type, language) do
    if type == "" or String.contains?(i["type"], type) do
      carta = Map.take(i, ["name", "manaCost", "type", "power", "toughness", "foreignNames"])

      carta =
        if language != "" do
          carta_descricao = buscar_descricao(carta, language)
          Map.put(carta, "description", carta_descricao)
        else
          carta
        end

      carta = Map.drop(carta, ["foreignNames"])
      [carta | mostrar_cartas(resto, type, language)]
    else
      mostrar_cartas(resto, type, language)
    end
  end

  defp buscar_cartas_por_idioma(name, language) do
    url = "#{@cards_url}?name=#{name}&language=#{language}"
    Api.get(url)
  end

  defp buscar_descricao(carta, language) do
    carta["foreignNames"]
    |> Enum.find(fn f -> f["language"] == language end)
    |> case do
      nil -> "Descrição em português não encontrada."
      desc -> desc["text"]
    end
  end
end
