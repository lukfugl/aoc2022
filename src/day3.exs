defmodule Day3 do
    def parseInput(input) do
        {:ok, data} = File.read(input)
        Enum.map(
            String.split(data, "\n"),
            fn sack -> Enum.map(
                String.to_charlist(sack),
                fn ch -> if ch < 0x60, do: ch - 0x26, else: ch - 0x60 end
            ) end)
    end

    def fixSack(sack) do
        n = div(length(sack), 2)
        l = MapSet.new(Enum.take(sack, n))
        r = MapSet.new(Enum.drop(sack, n))
        hd(MapSet.to_list(MapSet.intersection(l, r)))
    end
        
    def part1(input \\ "input/day3.actual") do
        sacks = parseInput(input)
        Enum.sum(Enum.map(sacks, fn sack -> fixSack(sack) end))
    end

    def identifyGroup(group) do
        [a, b, c] = Enum.map(group, fn sack -> MapSet.new(sack) end)
        hd(MapSet.to_list(MapSet.intersection(a, MapSet.intersection(b, c))))
    end

    def part2(input \\ "input/day3.actual") do
        sacks = parseInput(input)
        Enum.sum(Enum.map(Enum.chunk_every(sacks, 3), fn group -> identifyGroup(group) end))
    end
end

IO.puts("Example: #{Day3.part1("input/day3.example")}")
IO.puts("Example: #{Day3.part1()}")
IO.puts("Example: #{Day3.part2("input/day3.example")}")
IO.puts("Example: #{Day3.part2()}")