defmodule Game do
  @moduledoc """
  Módulo que implementa o jogo de adivinhar a carta usando o módulo Magic.
  """

  def start() do
    center_string("Bem-vindo ao jogo de adivinhar a carta!\n")

    # Escolha se o jogador quer adivinhar por cor ou por tipo
    center_string("Você quer adivinhar cartas por identidade de cor ou tipo?")
    center_string("Digite 1 para cor ou 2 para tipo, 0 para sair")
    opcao = IO.gets("> ") |> String.trim()

    case opcao do
      "0" ->
        center_string("Obrigado por jogar!")

      "1" ->
        iniciar_jogo_por_cor()

      "2" ->
        iniciar_jogo_por_tipo()

      _ ->
        center_string("Opção inválida! Tente novamente.")
        # Reinicia o jogo se a opção for inválida
        start()
    end
  end

  defp iniciar_jogo_por_cor() do
    center_string("Qual identidade de cor você quer? Escolha apenas uma. Exemplo: Red, Blue, Green")

    cor =
      IO.gets("> ")
      |> String.trim()
      |> Magic.get_color()

    # Pegando cartas filtradas por cor
    cartas = Magic.get_cards([%{param: "colors", term: cor}])

    if length(cartas) == 0 do
      center_string("Nenhuma carta com a cor #{cor} encontrada.")
      start()
    else
      iniciar_jogo_com_cartas(cartas)
    end
  end

  defp iniciar_jogo_por_tipo() do
    center_string("Qual tipo de carta você quer? Se desejar ver todos os tipos insira 0.")
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
      center_string("Nenhuma carta com o tipo #{tipo} encontrada.")
      start()
    else
      iniciar_jogo_com_cartas(cartas)
    end
  end

  defp iniciar_jogo_com_cartas(cartas) do
    carta_secreta = escolher_carta_aleatoria(cartas)
    center_string("Eu escolhi uma carta. Tente adivinhar!")
    # Pode remover isso, está aqui apenas para facilitar testes
    # center_string(carta_secreta["name"])

    loop_adivinhar(carta_secreta, 3)
  end

  defp escolher_carta_aleatoria(cartas) do
    Enum.random(cartas)
  end

  defp loop_adivinhar(carta_secreta, count) do
    center_string("Restam #{count} tentativas")
    center_string("Qual é o nome da carta?")
    chute = IO.gets("> ") |> String.trim()

    if chute == carta_secreta["name"] do
      center_string("Parabéns! Você acertou a carta!\n")
      start()
    else
      if count == 0 do
        center_string("Acabaram sua tentativas :(")
        center_string("O nome da carta é: #{carta_secreta["name"]}\n")
        start()
      else
        center_string("Errou! Vou te dar uma dica:")
        fornecer_dica(carta_secreta)
        loop_adivinhar(carta_secreta, count-1)
      end
    end
  end

  defp fornecer_dica(carta) do
    dicas = [
      fn -> "Tipo da carta: #{carta["type"]}\n" end,
      fn -> "Custo de mana: #{carta["manaCost"]}\n" end,
      fn -> "Poder: #{carta["power"] || "N/A"}\n" end,
      fn -> "Resistência: #{carta["toughness"] || "N/A"}\n" end,
      fn -> "Descrição: #{carta["description"] || carta["text"]}\n" end
    ]

    dica_aleatoria = Enum.random(dicas)
    center_string(dica_aleatoria.())
  end

  defp center_string(str) do
    {:ok, terminal_width} = :io.columns()

    padding = div(terminal_width - String.length(str), 2)
    space = String.duplicate(" ", max(padding, 0))
    IO.puts(space <> str)
  end

end
