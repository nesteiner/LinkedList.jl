import Base: isempty, length, push!, pop!, popat!, first, last, eltype, keys

abstract type AbstractLinkedList{NodeType, T} end

mutable struct List{NodeType <: ListCons, T} <: AbstractLinkedList{NodeType, T}
  baselist::BaseList{NodeType, T}
end

mutable struct Queue{NodeType <: ListCons, T} <: AbstractLinkedList{NodeType, T}
  baselist::BaseList{NodeType, T}
end

mutable struct Stack{NodeType <: ListCons, T} <: AbstractLinkedList{NodeType, T}
  baselist::BaseList{NodeType, T}
end

# constructor
List(T::DataType; isdouble = false) = begin
  nodetype = isdouble ? ConsDouble : ConsNode
  List{nodetype, T}(BaseList(T, nodetype))
end

Queue(T::DataType; isdouble = false) = begin
  nodetype = isdouble ? ConsDouble : ConsNode
  Queue{nodetype, T}(BaseList(T, nodetype))
end

Stack(T::DataType; isdouble = false) = begin
  nodetype = isdouble ? ConsDouble : ConsNode
  Stack{nodetype, T}(BaseList(T, nodetype))
end

# now you can give then differnt method to imply
isempty(linkedlist::ListType) where ListType <: AbstractLinkedList = isempty(linkedlist.baselist)
length(linkedlist::ListType) where ListType <: AbstractLinkedList = length(linkedlist.baselist)
keys(linkedlist::ListType) where ListType <: AbstractLinkedList = keys(linkedlist.baselist)
# dispatch push and pop function into different linkedlist
push!(list::Union{List{NodeType, T}, Queue{NodeType, T}}, data::T) where {NodeType <: ListCons, T} =
  push!(list.baselist, data)
pop!(list::List) = pop!(list.baselist)


pushnext!(list::List{NodeType, T}, iter::NodeType, data::T) where {T, NodeType <: ListCons} =
  pushnext!(list.baselist, iter, data)

popat!(list::List{NodeType, T}, iter::NodeType) where {T, NodeType <: ListCons} =
  popat!(list.baselist, iter)


push!(stack::Stack{NodeType, T}, data::T) where {NodeType <: ListCons, T} =
  pushfirst!(stack.baselist, data)

pop!(list::Union{Stack, Queue}) = popfirst!(list.baselist)

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

filter(testf::Function, linkedlist::ListType) where ListType <: AbstractLinkedList =
  filter(testf, linkedlist.baselist)
eltype(::AbstractLinkedList{NodeType, T}) where {T, NodeType <: ListCons} = T