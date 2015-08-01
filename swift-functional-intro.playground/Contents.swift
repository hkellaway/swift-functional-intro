//: Playground - noun: a place where people can play

import UIKit

/*** What is functional programming? ***/

/* This is an unfunctional function */

var a = 0

func incrementUnfunctional() -> () {
    a += 1
}

incrementUnfunctional()
print(a) // a = 1

/* This is a functional function */

a = 0

func incrementFunctional(num: Int) -> Int {
    return num + 1
}

a = incrementFunctional(a)
print(a) // a = 1


/*** Don’t iterate over lists. Use map and reduce. ***/

/* Map - Example 1 */

var languages = ["Objective-C", "Java", "Smalltalk"]

let languageLengths = languages.map { language in count(language) }

print(languageLengths)

let squares = [0, 1, 2, 3, 4].map { x in x * x }

print(squares)

/* Map - Example 2 */

let newLanguages = ["Swift", "Haskell", "Erlang"]

func randomElement<T>(array: Array<T>) -> T {
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    return array[randomIndex]
}

// Unfunctional

for index in 0..<languages.count {
    languages[index] = randomElement(newLanguages)
}

// Functional

let randomLanguages = languages.map { _ in randomElement(newLanguages) }

print(randomLanguages)
