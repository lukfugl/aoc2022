defmodule Day6 do
    def readInput(type) do
        {:ok, data} = File.read("input/day6.#{type}")
        String.split(data, "\n") |> Enum.map(&String.to_charlist/1)
    end

    def notStartOfSection(prefix) do
        (MapSet.new(prefix) |> MapSet.size()) < length(prefix)
    end

    def findStartOfSection(message, n) do
        (message
            |> Enum.chunk_every(n, 1, :discard)
            |> Enum.take_while(&notStartOfSection/1)
            |> length()) + n
    end

    def findStartOfPacket(message) do
        findStartOfSection(message, 4)
    end

    def findStartOfMessage(message) do
        findStartOfSection(message, 14)
    end

    def part1(type) do
        readInput(type)
            |> Enum.map(&findStartOfPacket/1)
            |> Enum.join(",")
    end

    def part2(type) do
        readInput(type)
            |> Enum.map(&findStartOfMessage/1)
            |> Enum.join(",")
    end
end

IO.puts("Part 1:")
IO.puts("\tExample: #{Day6.part1("example")}")
IO.puts("\tActual: #{Day6.part1("actual")}")

IO.puts("Part 2:")
IO.puts("\tExample: #{Day6.part2("example")}")
IO.puts("\tActual: #{Day6.part2("actual")}")
