defmodule Day2 do
    def parseInput(input) do
        {:ok, data} = File.read(input)
        Enum.map(
            String.split(data, "\n"),
            fn round -> String.split(round, " ") end)
    end

    def scoreRound(round) do
        case round do
            ["A", "X"] -> 3 + 1
            ["A", "Y"] -> 6 + 2
            ["A", "Z"] -> 0 + 3
            ["B", "X"] -> 0 + 1
            ["B", "Y"] -> 3 + 2
            ["B", "Z"] -> 6 + 3
            ["C", "X"] -> 6 + 1
            ["C", "Y"] -> 0 + 2
            ["C", "Z"] -> 3 + 3
        end
    end

    def chooseMove(round) do
        case round do
            ["A", "X"] -> "Z"
            ["A", "Y"] -> "X"
            ["A", "Z"] -> "Y"
            ["B", "X"] -> "X"
            ["B", "Y"] -> "Y"
            ["B", "Z"] -> "Z"
            ["C", "X"] -> "Y"
            ["C", "Y"] -> "Z"
            ["C", "Z"] -> "X"
        end
    end

    def part1(input \\ "input/day2.actual") do
        scores = Enum.map(parseInput(input), fn round -> scoreRound(round) end)
        Enum.sum(scores)
    end

    def part2(input \\ "input/day2.actual") do
        scores = Enum.map(parseInput(input), fn round -> scoreRound([hd(round), chooseMove(round)]) end)
        Enum.sum(scores)
    end
end

IO.puts("Example: #{Day2.part1("input/day2.example")}")
IO.puts("Part 1: #{Day2.part1()}")

IO.puts("Example: #{Day2.part2("input/day2.example")}")
IO.puts("Part 2: #{Day2.part2()}")
