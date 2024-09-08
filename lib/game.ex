defmodule Game do
  @moduledoc """
  Módulo que implementa o jogo de adivinhar a carta usando o módulo Magic.
  """

  def start() do
    IO.puts("Bem-vindo ao jogo de adivinhar a carta!")

    # Escolha se o jogador quer adivinhar por cor ou por tipo
    IO.puts("Você quer adivinhar cartas por identidade de cor ou tipo?")
    IO.puts("Digite 1 para cor ou 2 para tipo")
    opcao = IO.gets("> ") |> String.trim()

    case opcao do
      "1" ->
        iniciar_jogo_por_cor()

      "2" ->
        iniciar_jogo_por_tipo()

      _ ->
        IO.puts("Opção inválida! Tente novamente.")
        # Reinicia o jogo se a opção for inválida
        start()
    end
  end

  defp iniciar_jogo_por_cor() do
    IO.puts("Qual identidade de cor você quer? Escolha apenas uma. Exemplo: Red, Blue, Green")

    cor =
      IO.gets("> ")
      |> String.trim()
      |> Magic.get_color()

    # Pegando cartas filtradas por cor
    cartas = Magic.get_cards([%{param: "colors", term: cor}])

    if length(cartas) == 0 do
      IO.puts("Nenhuma carta com a cor #{cor} encontrada.")
      start()
    else
      iniciar_jogo_com_cartas(cartas)
    end
  end

  defp iniciar_jogo_por_tipo() do
    IO.puts("Qual tipo de carta você quer? Se desejar ver todos os tipos insira 0.")
    tipo = IO.gets("> ") |> String.trim()

    tipo =
      if tipo == "0" do
        IO.inspect(Magic.get_types())
        IO.gets("> ") |> String.trim()
      else
        tipo
      end

    # Pegando cartas filtradas por tipo
    cartas = Magic.get_cards([%{param: "types", term: tipo}])

    if length(cartas) == 0 do
      IO.puts("Nenhuma carta com o tipo #{tipo} encontrada.")
      start()
    else
      iniciar_jogo_com_cartas(cartas)
    end
  end

  defp iniciar_jogo_com_cartas(cartas) do
    carta_secreta = escolher_carta_aleatoria(cartas)
    IO.puts("Eu escolhi uma carta. Tente adivinhar!")
    # Pode remover isso, está aqui apenas para facilitar testes
    IO.puts(carta_secreta["name"])

    loop_adivinhar(carta_secreta)
  end

  defp escolher_carta_aleatoria(cartas) do
    Enum.random(cartas)
  end

  defp loop_adivinhar(carta_secreta) do
    IO.puts("Qual é o nome da carta?")
    chute = IO.gets("> ") |> String.trim()

    if chute == carta_secreta["name"] do
      IO.puts("Parabéns! Você acertou a carta!")
    else
      IO.puts("Errou! Vou te dar uma dica:")
      fornecer_dica(carta_secreta)
      loop_adivinhar(carta_secreta)
    end
  end

  defp fornecer_dica(carta) do
    dicas = [
      fn -> "Tipo da carta: #{carta["type"]}" end,
      fn -> "Custo de mana: #{carta["manaCost"]}" end,
      fn -> "Poder: #{carta["power"] || "N/A"}" end,
      fn -> "Resistência: #{carta["toughness"] || "N/A"}" end,
      fn -> "Descrição: #{carta["description"] || carta["text"]}" end
    ]

    dica_aleatoria = Enum.random(dicas)
    IO.puts(dica_aleatoria.())
  end
end
