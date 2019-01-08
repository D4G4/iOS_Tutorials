import UIKit

var str = "Hello, playground"

var pastries: [String] = []
pastries.append("daksh")
pastries[0] = "cookie"
pastries += ["cupcake", "donut", "pie", "brownie"]

pastries.count
pastries.first

if let first = pastries.first,
    let min = pastries.min(),
    let max = pastries.max() {
    print(first, min, max)
}

var emptyStringArray: [String] = []

if let min = emptyStringArray.min() {
    print("Minimum exist -> \(min)")
} else {
    print("Nope")
}



var players = ["Alice", "Bob", "Dan", "Eli", "Frank"]

players.firstIndex(of: "Dan")



//Closures

typealias Operate = (Int, Int) -> (Int) //A function which takes two Integer arguments and return an Integer value

func add(number1: Int, number2: Int) -> Int {
    return number1 + number2
}

func printResultOf(_ a: Int, _ b: Int, operation: Operate) {
    let result = operation(a, b)
    print("Result is \(result)")
}

printResultOf(5, 3, operation: add)

///Declaring a Closure
// A closure takes two parameters, they don't have argument labels
let multiplyA: (Int, Int) -> Int = {
    (a: Int, b: Int) -> Int in/*Indicates that we are going to start a closure*/
    return a * b
}
multiplyA(4, 2)

//Type inferrence
let multiplyB: (Int, Int) -> Int = {
    (a, b) in return a * b
}
multiplyB(4, 2)

//Closure without any argument list or return type
let multiplyC: (Int, Int) -> Int = {
    $0 * $1
}
multiplyC(4, 2)

//Operator closure
let multiplyD: (Int, Int) -> Int = (*)
multiplyD(2, 2)

printResultOf(6, 8, operation: multiplyD)

printResultOf(4, 2, operation: { $0 - $1 })

///If the closure is the LAST parameter passed to a function, you can move the closure outside the function call
///AKA- Trailing Closures
printResultOf(10, 5) { print("Pussy"); return $0 - $1 }

let voidClosure: () -> Void = {
    print("Yay, Swift!")
}
voidClosure()


func makeCounterClosure() -> () -> Int {
    var count = 0
    let incrementCurrentCounterClosure: () -> Int = {
        count += 1
        return count
    }
    return incrementCurrentCounterClosure
}

let counter1 = makeCounterClosure()
let counter2 = makeCounterClosure()

counter1()
counter2()
counter1()
counter2()
counter2()


///CLOSURES and COLLECTIONS
var names = ["Zeus", "Poseidon", "Ares", "Demeter"]

// sort() & sort(by:) - Sorts in place / mutates the original
names.sort()

names.sort(by: { (a, b) -> Bool in
    a > b
})
// sorted() & sorted(by:) - Returns a new collection that is stored
let longToShortNames = names.sorted {
    $0.count > $1.count //Trailing closures syntax
}

//: `filter`
var prices = [1.50, 10.00, 4.99, 2.30, 8.19]
let largePrices = prices.filter { price -> Bool in
    return price > 5
}
print(largePrices)
let largePrices2 = prices.filter { $0 > 5 }
print(largePrices2)
// `filter` as a `for` loop
var arrayForFilteredResults: [Double] = []
for price in prices where price > 5 {
    arrayForFilteredResults.append(price)
}
arrayForFilteredResults


//: `map` takes a closure, executes the algo on each item and returns a new list/array
let salePrices = prices.map { price -> Double in
    return price * 0.9
}
print(salePrices)


//: `reduce`
//reduce via for loop
var doubleForSum = 0.0
for price in prices {
    doubleForSum += price
}
doubleForSum

//Take a starting value and a closure
let sum = prices.reduce(0) { result, price -> Double in
    print("result = \(result)")
    print("price = \(price)")
    return result + price
}

let sum2 = prices.reduce(0, +)

//: `reduce: into`
var stock = [1.50: 5, 10.00: 2, 4.99: 20, 2.30: 4, 8.19: 30]

let stockSum = stock.reduce(into: []) { resultantArray, pair in
    resultantArray.append(pair.key * Double(pair.value))
}
print(stockSum)


//: `compactMap` & `flatMap`

//: `compactMap` -> Let's say I want to check if the UserInput can be converted into Int and then insert it into my Aray
let userInput = ["meow!", "15", "37.5", "seven"]

var arrayForValidInput: [Int] = []
for input in userInput {
    guard let input = Int(input) else {
        continue
    }
    arrayForValidInput.append(input)
}
arrayForValidInput

//Using compactMap
let usingCompactMap = userInput.compactMap { input in
    Int(input)
}
usingCompactMap


//: Flat Map (to flatten a MultiDimentional array)
let arrayOfDwarfArrays = [
    ["Sleepy", "Grumpy", "Doc"],
    ["Thorin", "Nori"]
]

let dravesAfterM = arrayOfDwarfArrays.flatMap { array -> [String] in
    print("array is \(array)")
    return array.filter { dwarf -> Bool in dwarf
        > "M"
    }
}
print(dravesAfterM)
print(dravesAfterM.sorted())
