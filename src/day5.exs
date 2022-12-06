defmodule Day5 do
    def readInput(type) do
        {:ok, data} = File.read("input/day5.#{type}")
        [pileDate, moveData] = String.split(data, "\n\n")
        layers = String.split(pileDate, "\n")
            |> Enum.map(fn layer -> String.to_charlist(layer) |> Enum.drop(1) |> Enum.take_every(4) end)
            |> Enum.reverse
            |> Enum.drop(1)
        emptyPiles = hd(layers) |> Enum.map(fn _ -> [] end)
        piles = layers
            |> Enum.reduce(emptyPiles, fn layer, piles ->
                Enum.zip_with(layer, piles, fn ch, pile ->
                    if ch == 0x20,
                        do: pile,
                        else: [ch | pile]
                end)
            end)
        moves = String.split(moveData, "\n")
            |> Enum.map(fn line -> String.split(line, " ") |> Enum.drop_every(2) |> Enum.map(fn x -> {n, ""} = Integer.parse(x); n end) end)
        { piles, moves }
    end

    def applyMove9000(piles, [n, a, b]) do
        moved = piles |> Enum.at(a - 1) |> Enum.take(n) |> Enum.reverse()
        newA = piles |> Enum.at(a - 1) |> Enum.drop(n)
        newB = moved ++ (piles |> Enum.at(b - 1))
        piles |> List.replace_at(a - 1, newA) |> List.replace_at(b - 1, newB)
    end

    def applyMove9001(piles, [n, a, b]) do
        moved = piles |> Enum.at(a - 1) |> Enum.take(n)
        newA = piles |> Enum.at(a - 1) |> Enum.drop(n)
        newB = moved ++ (piles |> Enum.at(b - 1))
        piles |> List.replace_at(a - 1, newA) |> List.replace_at(b - 1, newB)
    end

    def part1(type) do
        { piles, moves } = readInput(type)
        moves
            |> Enum.reduce(piles, fn move, piles -> applyMove9000(piles, move) end)
            |> Enum.map(&hd/1)
    end

    def part2(type) do
        { piles, moves } = readInput(type)
        moves
            |> Enum.reduce(piles, fn move, piles -> applyMove9001(piles, move) end)
            |> Enum.map(&hd/1)
    end
end

IO.puts("Part 1:")
IO.puts("\tExample: #{Day5.part1("example")}")
IO.puts("\tActual: #{Day5.part1("actual")}")

IO.puts("Part 2:")
IO.puts("\tExample: #{Day5.part2("example")}")
IO.puts("\tActual: #{Day5.part2("actual")}")
