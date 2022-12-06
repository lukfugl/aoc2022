defmodule Day4 do
    def parseInput(input) do
        {:ok, data} = File.read(input)
        Enum.map(
            String.split(data, "\n"),
            fn pair -> Enum.map(
                String.split(pair, ","),
                fn range -> Enum.map(
                    String.split(range, "-"),
                    fn x -> {n, ""} = Integer.parse(x); n end
                ) end
            ) end
        )
    end

    def checkPair1(pair) do
        [[a, b], [c, d]] = pair
        (a <= c && d <= b) ||
        (c <= a && b <= d)
    end
 
    def part1(input \\ "input/day4.actual") do
        pairs = parseInput(input)
        Enum.count(pairs, &checkPair1/1)
    end

    def checkPair2(pair) do
        [[a, b], [c, d]] = pair
        !(b < c || d < a)
    end

    def part2(input \\ "input/day4.actual") do
        pairs = parseInput(input)
        Enum.count(pairs, &checkPair2/1)
    end
end

IO.puts("Example: #{Day4.part1("input/day4.example")}")
IO.puts("Example: #{Day4.part1()}")
IO.puts("Example: #{Day4.part2("input/day4.example")}")
IO.puts("Example: #{Day4.part2()}")