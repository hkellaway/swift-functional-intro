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
