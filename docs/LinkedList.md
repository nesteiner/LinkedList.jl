
# Table of Contents

1.  [LinkedList](#org6502fb6)
    1.  [Usage](#orgc598f36)
        1.  [创建链表](#org9dfd645)
        2.  [添加数据](#org5bde5d9)
        3.  [删除数据](#org27ebfe4)
        4.  [迭代相关](#org441cb13)
        5.  [查找相关](#orge0ccd4c)
        6.  [setter and getter](#org567f142)



<a id="org6502fb6"></a>

# LinkedList

Updated at 2021.12.29  
这里重新写了一遍链表类，主要解决了用 `BaseList` 为别名，表示链表，队列，栈，从而无法判断这三个类的类型的问题  
新的方法使用组合的方式，重新构建了一遍类  

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


<a id="orgc598f36"></a>

## Usage


<a id="org9dfd645"></a>

### 创建链表

    list = List(Int) # 创建一个单链表
    queue = Queue(Int) # 创建一个单链表队列
    stack = Stack(Int) # 创建一个单链表栈
    
    double_list = List(Int; isdouble = true) # 创建一个双链表，其他链表类似的，可以对 isdouble 赋值


<a id="org5bde5d9"></a>

### 添加数据

1.  通用的方法

        push!(list, 1) # 对 List 类型会默认添加到末尾
        push!(queue, 1) # 同上
        push!(stack, 1) # 对 Stack 类型默认添加到头

2.  建议只用在 `List` 上

        iter = findfirst(isequal(1), list)
        if !isnothing(iter)
          pushnext!(list, iter, -1)
        end


<a id="org27ebfe4"></a>

### 删除数据

1.  通用的方法

        pop!(list) # 默认删除末尾的数据
        pop!(queue); pop!(stack) # 默认删除头的数据

2.  建议只用在 `List` 上

        iter = findfirst(isequal(-1), list)
        if !isnothing(iter)
          popat!(list, iter)
        end


<a id="org441cb13"></a>

### 迭代相关

迭代方法已经为定义好了  

    iterate(linkedlist::ListType) where ListType <: AbstractLinkedList =
      iterate(linkedlist.baselist)
    
    iterate(linkedlist::ListType, state::NodeType) where {ListType <: AbstractLinkedList, NodeType <: ListCons} =
      iterate(linkedlist.baselist, state)
    
    iterate(::ListType, state::NilNode) where ListType <: AbstractLinkedList = nothing

相关高阶函数可以调用，如 `map` , `reduce`  
不过 `filter` 需要自己定义，还好我也写了  


<a id="orge0ccd4c"></a>

### 查找相关

查找所需要的接口是 `keys` 函数  

    keys(linkedlist::ListType) where ListType <: AbstractLinkedList = keys(linkedlist.baselist)

这样以后，可以直接调用 `find` 系列函数，返回值是 `链表节点` 或者空值 `nothing`  


<a id="org567f142"></a>

### setter and getter

-   `fisrt`
-   `last`
-   `isempty`
-   `length`
-   `replace!(list, iter, data)`

