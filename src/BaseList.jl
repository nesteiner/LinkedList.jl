import Base: push!, popat!, pop!, pushfirst!, popfirst!,
  show, iterate,
  isempty, length,
  first, last,
  replace!, filter, keys, eltype

mutable struct BaseList{T, NodeType <: ListCons }
  dummy::DummyNode{T}
  current::Union{NodeType, DummyNode{T}}
  length::Int
end

BaseList(T::Union{DataType, UnionAll}, nodetype::Type{NodeType}) where NodeType <: ListCons = begin
  dummy = DummyNode(T)
  return BaseList{T, nodetype}(dummy, dummy, 0)
end
 

keys(list::BaseList) = next(list.dummy)

# 1. isempty, length
isempty(list::BaseList) = list.length == 0
length(list::BaseList) = list.length
# 2. push!, pop!, pushfirst!, popfirst!, first, last
function push!(list::BaseList{T, NodeType}, data::E) where {T, E <: T, NodeType <: ListCons}
  list.length += 1

  newnode = NodeType(data)
  insert_next!(list.current, newnode)
  list.current = next(list.current)
end

function pushfirst!(list::BaseList{T, NodeType}, data::E) where {T, E <: T, NodeType <: ListCons}
  list.length += 1

  newnode = NodeType(data)
  unlink = next(list.dummy)
  insert_next!(newnode, unlink)
  insert_next!(list.dummy, newnode)
end

function pop!(list::BaseList)
  @assert !isempty(list) "Fuck You, the list is empty"
  list.length -= 1
  prevnode = prev(list.current, list.dummy)
  remove_next!(prevnode)
  list.current = prevnode

end

function popfirst!(list::BaseList)
  @assert !isempty(list) "Fuck You, the list is empty"
  
  list.length -= 1
  prevnode = list.dummy
  remove_next!(prevnode)
  # STUB
  if isempty(list)
    list.current = list.dummy
  end
end
# 3. popat!, pushnext!
function popat!(list::BaseList{T, NodeType}, iter::NodeType) where {T, NodeType <: ListCons}
  list.length -= 1
  prevnode = prev(iter, list.dummy)
  remove_next!(prevnode)

  if isempty(list)
    list.current = list.dummy
  end
end

function pushnext!(list::BaseList{T, NodeType}, iter::NodeType, data::E) where {T, E <: T, NodeType <: ListCons}
  list.length += 1
  newnode = NodeType(data)
  unlink = next(iter)
  insert_next!(newnode, unlink)
  insert_next!(iter, newnode)
end
# 4. other advanced function, iterate
eltype(::Type{BaseList{T, NodeType}}) where {NodeType <: ListCons, T} = T

function iterate(list::BaseList)
  firstnode = next(list.dummy)
  if isa(firstnode, NilNode)
    return nothing
  else
    return dataof(firstnode), next(firstnode)
  end
end

function iterate(::BaseList, state::ListNode)
  if isa(state, NilNode)
    return nothing
  else
    return dataof(state), next(state)
  end
end

# 5. setter and getter
replace!(node::NodeType, data::T) where {T, NodeType <: ListCons} =
  node.data = data

first(list::BaseList) = begin
  firstnode = next(list.dummy)
  if isa(firstnode, ListNext) && isa(firstnode, ListCons)
    return dataof(firstnode)
  elseif isa(firstnode, NilNode)
    throw("there is no data in list")
  else
    throw("Fuck")
  end
end

last(list::BaseList) = begin
  lastnode = list.current
  if isa(lastnode, ListNext) && isa(lastnode, ListCons)
    return dataof(lastnode)
  elseif isa(lastnode, NilNode)
    throw("there is no data in list")
  else
    throw("Fuck")
  end
end

function show(io::IO, list::BaseList)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

function contains(list::BaseList{T, NodeType}, data::E) where {T, E <: T, NodeType <: ListCons}
  for value in list
    if value == data
      return true
    end
  end

  return false
end