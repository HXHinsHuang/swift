//: Playground - noun: a place where people can play

import UIKit

/*
// 标准库
struct FibsIterator: IteratorProtocol {
    var status = (0, 1)
    mutating func next() -> Int? {
        guard status.1 < 100 else { return nil }
        let temp = status.1
        status.1 = status.0 + status.1
        status.0 = temp
        return status.0
    }
}

struct SquareIterator: IteratorProtocol {
    var status = 1
    mutating func next() -> Int? {
        guard status < 100 else { return nil }
        defer {
            status = status * 2
        }
        return status
    }
}
// fibsIterator的type: AnyIterator<Int>
let fibsIterator = AnyIterator(FibsIterator())
// squareIterator的type: AnyIterator<Int>
let squareIterator = AnyIterator(SquareIterator())
// anyIteratorArray的type: [AnyIterator<Int>]
let anyIteratorArray = [fibsIterator, squareIterator]
// fibsSequence的type: AnySequence<Int>
let fibsSequence = AnySequence { return FibsIterator() }
// 这里因为实现一个Collection协议比较麻烦就直接用数组好了🌚
// c的type: AnyCollection<Int>
let c = AnyCollection(Array<Int>())
print(fibsIterator.next()!)
print(fibsIterator.next()!)
let fibs2 = fibsIterator
print(fibsIterator.next()!)
print(fibsIterator.next()!)
print(fibs2.next()!)
print(fibs2.next()!)
*/


/**************  类型抹消  ****************/
protocol MyIteratorProtocol {
    associatedtype Element
    mutating func next() -> Self.Element?
}

struct FibsIterator: MyIteratorProtocol {
    var status = (0, 1)
    mutating func next() -> Int? {
        guard status.1 < 100 else { return nil }
        let temp = status.1
        status.1 = status.0 + status.1
        status.0 = temp
        return status.0
    }
}

struct SquareIterator: MyIteratorProtocol {
    var status = 1
    mutating func next() -> Int? {
        guard status < 100 else { return nil }
        defer {
            status = status * 2
        }
        return status
    }
}

/*
// 尝试造轮子
class IteratorBox<I: MyIteratorProtocol> {
    var iterator: I
    init(_ iterator: I) {
        self.iterator = iterator
    }
    func next() -> I.Element? {
        return iterator.next()
    }
}
// fibsIteratorBox的type: IteratorBox<FibsIterator>
let fibsIteratorBox = IteratorBox(FibsIterator())
// squareIteratorBox的type: IteratorBox<SquareIterator>
let squareIteratorBox = IteratorBox(SquareIterator())
// 报错！类型不同，所以Boxs需要转成[Any]
let Boxs = [fibsIteratorBox, squareIteratorBox]
*/


/*
// 方法一：通过属性保存迭代器方法的实现
struct IteratorBox<A>: MyIteratorProtocol {
    private var nextIMP: () -> A?
    init<I: MyIteratorProtocol>(_ iterator: I) where I.Element == A {
        var iteratorCopy = iterator // Swift中参数被隐式声明为let
        self.nextIMP = { iteratorCopy.next() }
    }
    func next() -> A? {
        return nextIMP()
    }
}
// fibsIteratorBox的type: IteratorBox<Int>
let fibsIteratorBox = IteratorBox(FibsIterator())
// squareIteratorBox的type: IteratorBox<Int>
let squareIteratorBox = IteratorBox(SquareIterator())
// Boxs的type: [IteratorBox<Int>]
let Boxs = [fibsIteratorBox, squareIteratorBox]
print(fibsIteratorBox.next()!)
print(fibsIteratorBox.next()!)
let fibs2 = fibsIteratorBox
print(fibsIteratorBox.next()!)
print(fibsIteratorBox.next()!)
print(fibs2.next()!)
print(fibs2.next()!)
*/

/*
// 方法二：利用面向对象中的继承和多态特性
class IteratorBox<A>: MyIteratorProtocol {
    func next() -> A? {
        fatalError("This method is abstract, you need to implement it!")
    }
}

/*
 class IteratorBoxHelper<I: MyIteratorProtocol> {
     var iterator: I
     init(_ iterator: I) {
         self.iterator = iterator
     }
     func next() -> I.Element? {
         return iterator.next()
     }
 }
 */

class IteratorBoxHelper<I: MyIteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(_ iterator: I) {
        self.iterator = iterator
    }
    override func next() -> I.Element? {
        return iterator.next()
    }
}

// fibsIteratorBox的type: IteratorBox<Int>
let fibsIteratorBox: IteratorBox = IteratorBoxHelper(FibsIterator())
// squareIteratorBox的type: IteratorBox<Int>
let squareIteratorBox: IteratorBox = IteratorBoxHelper(SquareIterator())
// Boxs的type: [IteratorBox<Int>]
let Boxs = [fibsIteratorBox, squareIteratorBox]

//print("调用fibsIteratorBox的next方法")
//while let num = fibsIteratorBox.next() {
//    print(num)
//}
//print("调用squareIteratorBox的next方法")
//while let num = squareIteratorBox.next() {
//    print(num)
//}


//var fib1 = FibsIterator()
//print(fib1.next()!) // 1
//print(fib1.next()!) // 1
//var fib2 = fib1
//print(fib1.next()!) // 2
//print(fib1.next()!) // 3
//print(fib2.next()!) // 2
//print(fib2.next()!) // 3
print(fibsIteratorBox.next()!) // 1
print(fibsIteratorBox.next()!) // 1
let fibsBox2 = fibsIteratorBox
print(fibsIteratorBox.next()!) // 2
print(fibsIteratorBox.next()!) // 3
print(fibsBox2.next()!)        // 5
print(fibsBox2.next()!)        // 8
*/

