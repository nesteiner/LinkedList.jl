import Base: push!, popat!, pop!, pushfirst!, popfirst!,
  show, iterate,
  isempty, length,
  first, last,
  replace!, filter, keys, eltype

mutable struct BaseList{NodeType <: ListCons, T}
  dummy::DummyNode{T}
  current::Union{NodeType, DummyNode{T}}
  length::Int
end

BaseList(T::DataType, nodetype::Type{NodeType}) where NodeType <: ListCons = begin
  dummy = DummyNode(T)
  return BaseList{nodetype, T}(dummy, dummy, 0)
end
 

keys(list::BaseList) = next(list.dummy)

# 1. isempty, length
isempty(list::BaseList) = list.length == 0
length(list::BaseList) = list.length
# 2. push!, pop!, pushfirst!, popfirst!, first, last
function push!(list::BaseList{NodeType, T}, data::T) where {T, NodeType <: ListCons}
  list.length += 1

  newnode = NodeType(data)
  insert_next!(list.current, newnode)
  list.current = next(list.current)
end

function pushfirst!(list::BaseList{NodeType, T}, data::T) where {T, NodeType <: ListCons}
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
end
# 3. popat!, pushnext!
function popat!(list::BaseList{NodeType, T}, iter::NodeType) where {T, NodeType <: ListCons}
  list.length -= 1
  prevnode = prev(iter, list.dummy)
  remove_next!(prevnode)
end

function pushnext!(list::BaseList{NodeType, T}, iter::NodeType, data::T) where {T, NodeType <: ListCons}
  list.length += 1
  newnode = NodeType(data)
  unlink = next(iter)
  insert_next!(newnode, unlink)
  insert_next!(iter, newnode)
end
# 4. other advanced function, iterate
eltype(::Type{BaseList{NodeType, T}}) where {NodeType <: ListCons, T} = T

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
  if isa(firstnode, ListCons)
    return dataof(firstnode)
  else
    @error "there is no data in list"
    return nothing
  end
end

last(list::BaseList) = begin
  lastnode = list.current
  if isa(lastnode, ListCons) 
    return dataof(lastnode)
  else
    @error "there is no data in list"
    return nothing
  end
end

function show(io::IO, list::BaseList)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

function filter(testf::Function, list::BaseList{NodeType, T}) where {T, NodeType <: ListCons}
  result = BaseList{NodeType, T}(DummyNode(T), NodeType(T), 0)

  for data in list
    if testf(data)
      push!(result, data)
    end
  end

  return result
end

