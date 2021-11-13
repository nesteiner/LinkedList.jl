import Base: push!, popat!, pop!,
  show, iterate,
  isempty, length,
  first, last,
  replace!, filter, keys, eltype

mutable struct BaseList{T}
  dummy::DummyNode
  current::ListNode
  length::Int

  insertfn::Function           # insertfn(list, data)
  removefn::Function           # removefn(list)
  nodetype::DataType           # consnode, consdouble
  
  BaseList(T::DataType, N::DataType, insertfn, removefn) = begin
    dummy = DummyNode(T)
    list = new{T}()
    list.dummy = list.current = dummy
    list.length = 0
    
    list.nodetype = N
    list.insertfn = insertfn
    list.removefn = removefn
    return list
  end

end

keys(list::BaseList) = next(list.dummy)

function push!(list::BaseList{T}, data::T) where T
  list.length += 1
  list.insertfn(list, data)
end

function push_next!(list::BaseList{T}, node::ListCons, data::T) where T
  list.length += 1
  unlink = next(node)
  newnode = list.nodetype(data)
  insert_next!(node, newnode)
  insert_next!(newnode, unlink)
end

function pop!(list::BaseList) 
  if isempty(list) 
    @error "the list is empty"
  else 
    list.length -= 1
    list.removefn(list)
  end
end

function popat!(list::BaseList, iter::ListNext)
  list.length -= 1
  prevnode = prev(iter, list.dummy)
  remove_next!(prevnode)
end

replace!(node::ListCons, data::T) where T = node.data = data

eltype(::Type{BaseList{T}}) where T = T
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

first(list::BaseList) = begin
  firstnode = next(list.dummy)
  if isa(firstnode, ListCons)
    return dataof(firstnode)
  else
    @error "there is no data in list"
    return nothing
  end
end

top = first

last(list::BaseList) = begin
  lastnode = list.current
  if isa(lastnode, ListCons) 
    return dataof(lastnode)
  else
    @error "there is no data in list"
    return nothing
  end
end

isempty(list::BaseList) = list.length == 0
length(list::BaseList) = list.length

function show(io::IO, list::BaseList)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

function filter(testf::Function, list::BaseList{T}) where T
  result = BaseList(T, list.nodetype, list.insertfn, list.removefn)

  for data in list
    if testf(data)
      push!(result, data)
    end
  end

  return result
end

