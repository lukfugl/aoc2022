defmodule Day1 do
    def parseInput(input) do
        {:ok, data} = File.read(input)
        Enum.map(
            String.split(data, "\n\n"),
            fn group ->
                Enum.map(
                    String.split(group, "\n"),
                    fn x -> {n, ""} = Integer.parse(x); n end)
            end)
    end

    def foodPerElf(elves) do
        Enum.map(elves, fn elf -> Enum.sum(elf) end)
    end

    def part1(input \\ "input/day1.actual") do
        elves = parseInput(input)
        Enum.max(foodPerElf(elves))
    end

    def part2(input \\ "input/day1.actual") do
        elves = parseInput(input)
        Enum.sum(Enum.take(Enum.sort(foodPerElf(elves)), -3))
    end
end

IO.puts("Example: #{Day1.part1("input/day1.example")}")
IO.puts("Part 1: #{Day1.part1()}")
IO.puts("Example: #{Day1.part2("input/day1.example")}")
IO.puts("Part 2: #{Day1.part2()}")