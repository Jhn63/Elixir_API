defmodule Magic do
  @cards_url "https://api.magicthegathering.io/v1/cards"
  @types_url "https://api.magicthegathering.io/v1/types"
  @color_identity %{
    "White" => "W",
    "Blue" => "U",
    "Black" => "B",
    "Red" => "R",
    "Green" => "G"
  }

  def teste() do
    Magic.get_cards([
      %{param: "language", term: "Portuguese (Brazil)"},
      %{param: "type", term: "Creature"},
      %{param: "pageSize", term: "20"}
      # %{param: "name", term: "Não É PRA VIR NADA"}
    ])
  end

  def get_cards() do
    @cards_url
    |> Api.get()
    |> format_data()
  end

  def get_color(color) do
    @color_identity
    |> Map.get(String.capitalize(color), "Cor inválida")
  end

  def get_types() do
    @types_url
    |> Api.get()
    |> Map.get("types")
  end

  def get_cards(params) when is_list(params) do
    @cards_url
    |> Api.build_url(params)
    |> Api.get()
    |> format_data(params)
  end

  defp format_data(data), do: data["cards"]

  defp format_data(data, []), do: data["cards"]

  defp format_data(data, params) do
    formats = %{
      "language" => &format_language/2
    }

    Enum.map(data["cards"], fn card ->
      Enum.reduce(params, card, fn map, acc_card ->
        param_value = Map.get(map, :param)
        term_value = Map.get(map, :term)

        case Map.get(formats, param_value) do
          nil -> acc_card
          format_func -> format_func.(acc_card, term_value)
        end
      end)
    end)
  end

  defp format_language(card, language) do
    description = get_description(card, language)

    card
    |> Map.delete("foreignNames")
    |> Map.put("description", description)
  end

  defp get_description(card, language) do
    foreign_names = Map.get(card, "foreignNames", [])

    foreign_names
    |> Enum.find(fn f -> f["language"] == language end)
    |> case do
      nil -> "Descrição em #{language} não encontrada."
      desc -> desc["text"]
    end
  end
end
