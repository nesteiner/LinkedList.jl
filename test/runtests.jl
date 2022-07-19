using LinkedList, Test

@testset "test list" begin
  list = List(Int)

  push!(list, 1)
  node = findfirst(isequal(1), list)
  if !isnothing(node)
    popat!(list, node)
  end

  @show list

  for i in 1:10
    push!(list, i)
  end

  @show list
end

@testset "test filter" begin
  list = List(Int)

  for i in 1:10
    push!(list, i)
  end

  result = filter(iseven, list)
  @show result
  @show length(result)
end
