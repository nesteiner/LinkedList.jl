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

  queue = Queue(Int)
  for i in 1:10
    push!(queue, i)
  end

  result = filter(iseven, queue)
  @show result
end


@testset "when element is union all" begin
  list = List(NamedTuple{(:x, :y), Tuple{T1, T2}} where {T1 <: Number, T2 <: Number})

  array = [
    (x = 1, y = 1.9),
    (x = 2, y = 2),
    (x = 3, y = 3),
    (x = 4, y = 4)
  ]

  for value in array
    push!(list, value)
  end

  @show list
end

@testset "when element is Number" begin
  list = List(Number)

  for value in [1, 2.0, 3.0]
    push!(list, value)
  end

  @show list
end