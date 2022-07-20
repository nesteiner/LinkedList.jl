import Base: show, iterate

abstract type ListNode end
abstract type ListNext <: ListNode end
abstract type ListCons <: ListNext end

mutable struct NilNode{T} <: ListNode end

mutable struct DummyNode{T} <: ListNext
  next::ListNode
  DummyNode(E::Union{DataType, UnionAll})  = new{E}(NilNode{E}())
end

mutable struct ConsNode{T} <: ListCons 
  data::T
  next::ListNode
  
  ConsNode(data::T) where T = new{T}(data, NilNode{T}())
  ConsNode{T}(data::T) where T = ConsNode(data)
end


mutable struct ConsDouble{T} <: ListCons
  data::T
  next::ListNode
  prev::ListNode
  
  ConsDouble(data::T) where T = new{T}(data, NilNode{T}(), NilNode{T}())
  ConsDouble{T}(data::T) where T = ConsDouble(data)
end

# insert
insert_next!(node::ListNext, nextnode::ListNode) = node.next = nextnode

insert_next!(node::ListNext, nextnode::ConsDouble) = begin
  node.next = nextnode
  nextnode.prev = node
end

# function insert_data_next_1!(node::ListNext, data::T) where T 
#   newnode = ConsNode(data)
#   insert_next!(node, newnode)
# end

# function insert_data_next_2!(node::ListNext, data::T) where T
#   newnode = ConsDouble(data)
#   insert_next!(node, newnode)
# end

# remove next
remove_next!(node::ListNext) = begin
  targetnode = next(node)
  unlinknode = next(targetnode)
  
  insert_next!(node, unlinknode)
end

# next
next(node::ListNext) = node.next
prev(node::ConsDouble, ::ListNode) = node.prev
prev(node::ConsNode, startnode::ListNext) = begin
  cursor = next(startnode)
  prev = startnode

  # locate
  while cursor != node 
    prev = cursor
    cursor = next(cursor)
  end

  return prev
    
end
dataof(node::ListCons) = node.data
# prev

# iterate for findfirst
iterate(node::ListCons) = node, next(node)
iterate(::ListCons, nextnode::ListCons) = nextnode, next(nextnode)
iterate(::ListCons, nextnode::NilNode) = nothing
iterate(::NilNode) = nothing

# show
show(io::IO, node::ListCons) = print(io, dataof(node))
show(io::IO, ::NilNode) = print(io, "nil")
show(io::IO, node::DummyNode) = print(io, "dummy")