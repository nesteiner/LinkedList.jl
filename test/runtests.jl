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