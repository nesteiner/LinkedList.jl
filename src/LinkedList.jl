module LinkedList

include("BaseListNode.jl")
include("BaseList.jl")
include("Dispatch.jl")

export List, Queue, Stack, ConsNode, ConsDouble
export push!, pop!, pushnext!, popat!, first, last, isempty, length, filter, eltype, dataof, show, keys, top
end