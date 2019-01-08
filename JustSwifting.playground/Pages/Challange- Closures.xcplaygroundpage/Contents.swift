//: [Previous](@previous)
import Foundation

/*:
 ## Challenge Time - Closures! 😎
 
 Create a constant array called `names` which contains some names as strings. Now use `reduce` to create a String which is the concatination of each name in the array.
 */

var names: [String] = ["daksh", "dennis", "paksh", "amit", "adi"]
let test = names.reduce("") { result, name -> String in
    if result == "" {
        return result + name
    } else {
        return result + "_" + name
    }
}
test

/*:
 Using the same `names` array, first filter the array to contain only names which have more than four characters in them, and then create the same concatenation of the names.
 */
let filteredNames = names.filter {
    $0.count > 4
}
filteredNames

let newList = filteredNames.reduce("") { result, name -> String in
    return result + "😸" + name
}
newList

/*:
 Create a constant dictionary called `namesAndAges` which contains some names as strings mapped to ages as integers. Now use `filter` to create a dictionary containing only people under the age of 18
 */
let namesAndAges: [String: Int] = [
    "Daksh": 21,
    "Adi": 13,
    "Amit": 9,
    "Prachi": 22,
    "Shivani": 21,
    "Bleh": 25
]
let namesLessThan18 = namesAndAges.filter {
    $0.value < 18
}
print(namesLessThan18)

/*:
 Using the name `namesAndAges` dictionary, filter out the adults and then use `map` to convert to an array containing just the names
 */
let adults: [String] = namesAndAges.filter {
    $0.value > 18
}.map { namesAndAges -> String in
    return namesAndAges.key
}


