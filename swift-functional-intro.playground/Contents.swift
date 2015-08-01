import UIKit

/*** What is functional programming? ***/

/* This is an unfunctional function */

var a = 0

func incrementUnfunctional() -> () {
    a += 1
}

incrementUnfunctional()
print(a)

/* This is a functional function */

a = 0

func incrementFunctional(num: Int) -> Int {
    return num + 1
}

a = incrementFunctional(a)
print(a)

 ///////////////////////////////////////////////////////

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

print(languages)

// Functional

let randomLanguages = languages.map { _ in randomElement(newLanguages) }

print(randomLanguages)


/* Reduce - Example 1 */

let sum = [0, 1, 2, 3, 4].reduce(0, combine: { $0 + $1 })

print(sum)

/* Reduce - Example 2 */

let greetings = ["Hello, World", "Hello, Swift.", "Later, Objective-C"]

func string(str: String, #contains: String) -> Bool {
    return str.lowercaseString.rangeOfString(contains.lowercaseString) != nil
}

// Unfunctional

var helloCount1 = 0

for greeting in greetings {
    if(string(greeting, contains:"hello")) {
        helloCount1 += 1
    }
}

print(helloCount1)

// Functional

let helloCount2 = greetings.reduce(0, combine: { $0 + ((string($1, contains:"hello")) ? 1 : 0) })

print(helloCount2)

///////////////////////////////////////////////////////
