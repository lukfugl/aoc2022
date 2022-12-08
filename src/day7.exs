defmodule Day7 do
    def readInput(type) do
        {:ok, data} = File.read("input/day7.#{type}")
        String.split(data, "\n") |> Enum.map(&interpretLine/1)
    end

    def interpretLine(line) do
        cond do
            String.starts_with?(line, "$ cd ") -> {:cd, String.slice(line, 5..-1)}
            String.starts_with?(line, "$ ls") -> {:ls}
            String.starts_with?(line, "dir ") -> {:dir, String.slice(line, 4..-1)}
            true ->
                [sizeStr, name] = String.split(line, " ")
                {size, ""} = Integer.parse(sizeStr)
                {:file, name, size}
        end
    end

    def deepGet({:dir, tree}, path) do
        #IO.puts("deepGet(#{inspect({:dir, tree})}, #{inspect(path)})")
        case path do
            [name] -> Map.fetch!(tree, name)
            [name | parent] ->
                {:dir, subtree} = deepGet({:dir, tree}, parent)
                Map.fetch!(subtree, name)
        end
    end

    def deepPut({:dir, tree}, path, value) do
        #IO.puts("deepPut(#{inspect({:dir, tree})}, #{inspect(path)}, #{inspect(value)})")
        case path do
            [name] -> {:dir, Map.put(tree, name, value)}
            [name | parent] ->
                {:dir, subtree} = deepGet({:dir, tree}, parent)
                deepPut({:dir, tree}, parent, {:dir, Map.put(subtree, name, value)})
        end
    end

    def buildTree(input, { tree, cwd }) do
        case input do
            {:cd, "/"} -> { tree, [] }
            {:cd, ".."} -> { tree, tl(cwd) }
            {:cd, dirName} -> { tree, [dirName | cwd] }
            {:ls} -> { tree, cwd }
            {:dir, dirName} -> { deepPut(tree, [dirName | cwd], {:dir, %{}}), cwd }
            {:file, fileName, size} -> { deepPut(tree, [fileName | cwd], {:file, size}), cwd }
        end
    end

    def annotateTree(entry) do
        case entry do
            {:file, _} -> entry
            {:dir, tree} ->
                tree
                    |> Map.to_list()
                    |> Enum.map(fn { name, subentry } ->
                        { name, annotateTree(subentry) }
                    end)
                    |> Map.new()
                    |> then(fn newtree ->
                        size = newtree
                            |> Map.values()
                            |> Enum.map(fn value -> elem(value, 1) end)
                            |> Enum.sum()
                        {:dir, size, newtree}
                    end)
        end
    end

    def flattenTree(entry, path) do
        case entry do
            {:file, _} -> [] # discard file entries
            {:dir, size, tree} ->
                [{:dir, size, path} | tree
                    |> Map.to_list()
                    |> Enum.flat_map(fn {name, subentry} ->
                        flattenTree(subentry, [name | path])
                    end)]
        end
    end

    def produceDirectorySizes(input) do
        input
            |> Enum.reduce({{:dir, %{}}, []}, &buildTree/2)
            |> elem(0)
            |> annotateTree()
            |> flattenTree([])
    end

    def part1(type) do
        readInput(type)
            |> produceDirectorySizes()
            |> Enum.filter(fn {_, size, _} -> size <= 100000 end)
            |> Enum.map(fn {_, size, _} -> size end)
            |> Enum.sum()
    end

    def part2(type) do
        sizes = readInput(type)
            |> produceDirectorySizes()
        used = elem(hd(sizes), 1)
        free = 70000000 - used
        needed = 30000000 - free
        sizes
            |> Enum.map(fn {_, size, _} -> size end)
            |> Enum.filter(fn size -> size >= needed end)
            |> Enum.min()
    end
end

IO.puts("Part 1:")
IO.puts(inspect(Day7.part1("example")))
IO.puts(inspect(Day7.part1("actual")))

IO.puts("Part 2:")
IO.puts(inspect(Day7.part2("example")))
IO.puts(inspect(Day7.part2("actual")))
