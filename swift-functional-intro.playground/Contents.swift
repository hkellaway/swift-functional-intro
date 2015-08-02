/* Examples of functional programming in Swift inspired by Mary Rose Cook's "A practical introduction to functional programming" http://maryrosecook.com/blog/post/a-practical-introduction-to-functional-programming
*/

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

func randomPositiveNumberUpTo(number: Int) -> Int {
    return Int(arc4random_uniform(UInt32(number)))
}

func randomElement<T>(array: Array<T>) -> T {
    let randomIndex = randomPositiveNumberUpTo(array.count)
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

var helloCount = 0

for greeting in greetings {
    if(string(greeting, contains:"hello")) {
        helloCount += 1
    }
}

print(helloCount)

// Functional

let helloCountFunctional = greetings.reduce(0, combine: { $0 + ((string($1, contains:"hello")) ? 1 : 0) })

print(helloCountFunctional)

///////////////////////////////////////////////////////

/*** Write declaratively, not imperatively ***/

// Unfunctional

var time = 5
var carPositions = [1, 1, 1]

while(time > 0) {
    time -= 1
    
    print("\n")
    
    for index in 0..<carPositions.count {
        if(randomPositiveNumberUpTo(10) > 3) {
            carPositions[index] += 1
        }
        
        for _ in 0..<carPositions[index] {
            print("-")
        }
        
        print("\n")
    }
}

// Better, but still unfunctional

time = 5
carPositions = [1, 1, 1]

func runStepOfRace() -> () {
    time -= 1
    moveCars()
}

func draw() {
    print("\n")
    
    for carPosition in carPositions {
        drawCar(carPosition)
    }
}

func moveCars() -> () {
    for index in 0..<carPositions.count {
        if(randomPositiveNumberUpTo(10) > 3) {
            carPositions[index] += 1
        }
    }
}

func drawCar(carPosition: Int) -> () {
    for _ in 0..<carPosition {
        print("-")
    }
    
    print("\n")
}

while(time > 0) {
    runStepOfRace()
    draw()
}

// Functional

typealias Time = Dictionary<String, Int>
typealias Positions = Dictionary<String, Array<Int>>
typealias State = (time: Time, positions: Positions)

func moveCarsFunctional(positions: Array<Int>) -> Array<Int> {
    return positions.map { position in (randomPositiveNumberUpTo(10) > 3) ? position + 1 : position }
}

func outputCar(carPosition: Int) -> String {
    let output = (0..<carPosition).map { _ in "-" }
    
    return join("", output)
}

func runStepOfRaceFunctional(state: State) -> State {
    let newTime = state.time["time"]! - 1
    let newPositions = moveCarsFunctional(state.positions["positions"]!)
    
    return (["time" : newTime], ["positions" : newPositions])
}

func drawFunctional(state: State) -> () {
    let outputs: Array<String> = state.positions["positions"]!.map { position in outputCar(position) }
    
    print(join("\n", outputs))
}

func race(state: State) -> () {
    drawFunctional(state)
    
    if(state.time["time"]! > 1) {
        print("\n\n")
        race(runStepOfRaceFunctional(state))
    }
}

let state: State = (["time" : 5], ["positions" : [1, 1, 1]])
race(state)


///////////////////////////////////////////////////////

/*** Use pipelines ***/

// Unfunctional

var originalBands: Array<Dictionary<String, String>> = [
    ["name" : "sunset rubdown", "country" : "UK"],
    ["name" : "women", "country" : "Germany"],
    ["name" : "a silver mt. zion", "country" : "Spain"]
]
var bands = originalBands // copy so we can use original data in other examples

func formatBands(inout bands: Array<Dictionary<String, String>>) -> () {
    var newBands: Array<Dictionary<String, String>> = []
    
    for band in bands {
        var newBand: Dictionary<String, String> = band
        newBand["country"] = "Canada"
        newBand["name"] = newBand["name"]!.capitalizedString
        
        newBands.append(newBand)
    }
    
    bands = newBands
}

formatBands(&bands)
print(bands)

// Functional 0

typealias BandProperty = String
typealias Band = Dictionary<String, BandProperty>
typealias BandTransform = Band -> Band
typealias BandPropertyTransform = BandProperty -> BandProperty

func call(fn: BandProperty -> BandProperty, onValueForKey key: String) -> Band -> Band {
    return {
        band in
        
        var newBand = band
        newBand[key] = fn(band[key]!)
        return newBand
        
    }
}

let getCanada: BandPropertyTransform = { _ in return "Canada" };
let capitalize: BandPropertyTransform = { return $0.capitalizedString }

let setCanadaAsCountry = call(getCanada, onValueForKey: "country")
let capitalizeName = call(capitalize, onValueForKey: "name")

func formattedBands(bands: Array<Band>, fns: Array<BandTransform>) -> Array<Band> {
    return bands.map {
        band in
        
        var newBand = band
        fns.map { fn in newBand = fn(newBand) }
        
        return newBand
    }
}

print(originalBands)
print(formattedBands(originalBands, [setCanadaAsCountry, capitalizeName]))

// Functional 1

func setCanadaAsCountry(band: Band) -> Band {
    var newBand = band
    newBand["country"] = "Canada"
    return newBand
}

func capitalizeName(band: Band) -> Band {
    var newBand = band
    newBand["name"] = newBand["name"]!.capitalizedString
    return newBand
}

func formatBandsFunctional1(bands: Array<Band>) -> Array<Band> {
    var newBands: Array<Band> = []
    
    for band in bands {
        var newBand = setCanadaAsCountry(band)
        newBand = capitalizeName(newBand)
        
        newBands.append(newBand)
    }
    
    return newBands
}

formatBandsFunctional1(originalBands)

// Functional 2

typealias BandTransformation = Band -> Band

func setCanadaAsCountryTransformation() -> BandTransformation {
    return {
        band in
        
        var newBand = band
        newBand["country"] = "Canada"
        return newBand
    }
}

func capitalizeNameTransformation() -> BandTransformation {
    return {
        band in
        
        var newBand = band
        newBand["name"] = newBand["name"]!.capitalizedString
        return newBand
    }
}

func formatBandsFunctional2(bands: Array<Band>) -> Array<Band> {
    var newBands: Array<Band> = []
    
    for band in bands {
        var newBand = setCanadaAsCountryTransformation()(band)
        newBand = capitalizeNameTransformation()(newBand)
        
        newBands.append(newBand)
    }
    
    return newBands
}

formatBandsFunctional2(originalBands)

// Functional 3

func composeBandTransformations(transformation1: BandTransformation, transformation2: BandTransformation) -> BandTransformation {
    return {
        band in
        
        transformation2(transformation1(band))
    }
}

func formatBandsFunctional3(bands: Array<Band>) -> Array<Band> {
    var newBands: Array<Band> = []
    let myBandTransformation: BandTransformation = composeBandTransformations(setCanadaAsCountryTransformation(), capitalizeNameTransformation())
    
    for band in bands {
        newBands.append(myBandTransformation(band))
    }
    
    return newBands
}


formatBandsFunctional3(originalBands)

// Functional 4

func updatePropertyForBand(band: Band, key: String, update: BandProperty? -> BandProperty?) -> Band {
    var newBand = band
    newBand[key] = update(newBand[key])
    return newBand
}

///////////////////////////////////////////////////////

/*** Extra Credit: Generics ***/

// Generic call(_:onValueForKey:)

func call<T, U>(fn: U -> U, onValueForKey key: T) -> Dictionary<T, U> -> Dictionary<T, U> {
    return {
        dictionary in
        
        var newDictionary = dictionary
        newDictionary[key] = fn(dictionary[key]!)
        return newDictionary
    }
}
