
abstract type AbstractLinkedList{T, NodeType} end

mutable struct List{T} <: AbstractLinkedList{T, ConsDouble}
  baselist::BaseList{T, ConsDouble}
end

mutable struct Queue{T} <: AbstractLinkedList{T, ConsDouble}
  baselist::BaseList{T, ConsDouble}
end

mutable struct Stack{T} <: AbstractLinkedList{T, ConsDouble}
  baselist::BaseList{T, ConsDouble}
end

# constructor
List(T::Union{DataType, UnionAll}) =  List{T}(BaseList(T, ConsDouble))

Queue(T::Union{DataType, UnionAll}) = Queue{T}(BaseList(T, ConsDouble))

Stack(T::Union{DataType, UnionAll}) =  Stack{T}(BaseList(T, ConsDouble))

# now you can give then differnt method to imply
isempty(linkedlist::ListType) where ListType <: AbstractLinkedList = isempty(linkedlist.baselist)
length(linkedlist::ListType) where ListType <: AbstractLinkedList = length(linkedlist.baselist)
keys(linkedlist::ListType) where ListType <: AbstractLinkedList = keys(linkedlist.baselist)
# dispatch push and pop function into different linkedlist
push!(list::Union{List{T}, Queue{T}}, data::E) where {T, E <: T} = 
  push!(list.baselist, data)

pop!(list::List) =
  pop!(list.baselist)

pushnext!(list::List{T}, iter::NodeType, data::E) where {T, E <: T, NodeType <: ListCons} =
  pushnext!(list.baselist, iter, data)

popat!(list::List{T}, iter::NodeType) where {T, NodeType <: ListCons} =
  popat!(list.baselist, iter)

push!(stack::Stack{T}, data::T) where T =
  pushfirst!(stack.baselist, data)

pop!(list::Union{Stack, Queue}) =
  popfirst!(list.baselist)

first(list::Union{List, Queue}) = first(list.baselist)
last(list::Union{List, Queue}) = last(list.baselist)
top(list::Stack) = first(list.baselist)

iterate(linkedlist::ListType) where ListType <: AbstractLinkedList =
  iterate(linkedlist.baselist)

iterate(linkedlist::ListType, state::NodeType) where {ListType <: AbstractLinkedList, NodeType <: ListCons} =
  iterate(linkedlist.baselist, state)

iterate(::ListType, state::NilNode) where ListType <: AbstractLinkedList = nothing

show(io::IO, linkedlist::ListType) where ListType <: AbstractLinkedList =
  show(io, linkedlist.baselist)


eltype(::AbstractLinkedList{T, NodeType}) where {T, NodeType <: ListCons} = T
contains(list::AbstractLinkedList{T, NodeType}, data::T) where {T, NodeType <: ListCons} = contains(list.baselist, data)

function filter(testf::Function, linkedlist::Union{List{T}, Queue{T}}) where T
  result = List(T)
  for value in linkedlist
    if testf(value)
      push!(result, value)
    end
  end

  return result
end