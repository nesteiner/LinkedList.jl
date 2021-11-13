module List

export createList, createQueue, createStack, ConsNode, ConsDouble
export  copy, ==,
  push_next!, popat!, replace!, first, last, isempty, length, filter, top, eltype, push!, pop!,
  show, keys

include("ListNode.jl")
include("BaseList.jl")

createList(T::DataType; nodetype = ConsNode) = BaseList(T, nodetype{T}, _push_back!, _pop_back!)
createQueue(T::DataType; nodetype = ConsNode) = BaseList(T, nodetype{T}, _push_back!, _pop_front!)
createStack(T::DataType; nodetype = ConsNode) = BaseList(T, nodetype{T}, _push_front!, _pop_front!)


function _push_back!(list::BaseList{T}, data::T) where T
  newnode = list.nodetype(data)
  insert_next!(list.current, newnode)
  list.current = next(list.current)
end

function _push_front!(list::BaseList{T}, data::T) where T
  newnode = list.nodetype(data)
  unlink = next(list.dummy)
  insert_next!(newnode, unlink)
  insert_next!(list.dummy, newnode)
end

function _pop_back!(list::BaseList) 
  prevnode = prev(list.current, list.dummy)
  remove_next!(prevnode)
  list.current = prevnode
end

function _pop_front!(list::BaseList)
  prevnode = list.dummy
  remove_next!(prevnode)
end

end