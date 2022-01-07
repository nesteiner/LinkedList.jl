
# Table of Contents

1.  [LinkedList](#org8732e4f)
    1.  [更新 2022.1.7](#orge3ce40d)
        1.  [issue](#orgea9ed1b)
    2.  [更新 好像是12月份](#orgf701c6b)
    3.  [文档](#orgdf2add3)
    4.  [Usage](#org7bcea14)
        1.  [创建链表](#org369474e)
        2.  [添加数据](#orgea21931)
        3.  [删除数据](#orgd871c27)
        4.  [迭代相关](#orgbccf9e5)
        5.  [查找相关](#org3e5080e)



<a id="org8732e4f"></a>

# LinkedList


<a id="orge3ce40d"></a>

## 更新 2022.1.7


<a id="orgea9ed1b"></a>

### issue

1.  problem

    在函数中为 `list` 标注类型很别扭, `fn(list::List{Int, ConsDouble})`  

2.  fix

    全都改为双链表节点，老子乐意， `fn(list::List{Int})` 的类型标注以解决  
    另外，如果需要定义单链表，可以参考 `Dispatch.jl` 定义链表结构  


<a id="orgf701c6b"></a>

## 更新 好像是12月份

大幅度删改了以下，文档也是  


<a id="orgdf2add3"></a>

## 文档

[旧版本文档](./docs/oldversion.md)  
[新版本文档](./docs/LinkedList.md)  


<a id="org7bcea14"></a>

## Usage


<a id="org369474e"></a>

### 创建链表

    list = List(Int) # 创建一个单链表
    queue = Queue(Int) # 创建一个单链表队列
    stack = Stack(Int) # 创建一个单链表栈
    
    double_list = List(Int; isdouble = true) # 创建一个双链表，其他链表类似的，可以对 isdouble 赋值


<a id="orgea21931"></a>

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


<a id="orgd871c27"></a>

### 删除数据

1.  通用的方法

        pop!(list) # 默认删除末尾的数据
        pop!(queue); pop!(stack) # 默认删除头的数据

2.  建议只用在 `List` 上

        iter = findfirst(isequal(-1), list)
        if !isnothing(iter)
          popat!(list, iter)
        end


<a id="orgbccf9e5"></a>

### 迭代相关

迭代方法已经为定义好了  

    iterate(linkedlist::ListType) where ListType <: AbstractLinkedList =
      iterate(linkedlist.baselist)
    
    iterate(linkedlist::ListType, state::NodeType) where {ListType <: AbstractLinkedList, NodeType <: ListCons} =
      iterate(linkedlist.baselist, state)
    
    iterate(::ListType, state::NilNode) where ListType <: AbstractLinkedList = nothing

相关高阶函数可以调用，如 `map` , `reduce`  
不过 `filter` 需要自己定义，还好我也写了  


<a id="org3e5080e"></a>

### 查找相关

查找所需要的接口是 `keys` 函数  

    keys(linkedlist::ListType) where ListType <: AbstractLinkedList = keys(linkedlist.baselist)

这样以后，可以直接调用 `find` 系列函数，返回值是 `链表节点` 或者空值 `nothing`  

