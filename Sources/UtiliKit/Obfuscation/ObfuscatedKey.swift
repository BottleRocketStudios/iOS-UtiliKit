//
//  ObfuscatedKey.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 7/23/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

// Inspired by https://github.com/onmyway133/Arcane/blob/master/Sources/Arcane/Obfuscator.swift

import Foundation

/// One should never commit keys directly into one's source; this is an unsafe practice.
/// When it is impossible to avoid doing so, the key should at least be obfuscated.
/// By using the ObfuscatedKey struct, you can build a human-readable key that nonetheless
/// will not appear simply by running "strings" against your compiled code, and will even
/// not appear as a string within your source code.
struct ObfuscatedKey {
    private let _value: String

    init() {
        self._value = ""
    }

    init(_ value: String) {
        self._value = value
    }

    var value: String {
        get {
            return _value
        }
    }

    var A: ObfuscatedKey { return ObfuscatedKey(_value + "A") }
    var B: ObfuscatedKey { return ObfuscatedKey(_value + "B") }
    var C: ObfuscatedKey { return ObfuscatedKey(_value + "C") }
    var D: ObfuscatedKey { return ObfuscatedKey(_value + "D") }
    var E: ObfuscatedKey { return ObfuscatedKey(_value + "E") }
    var F: ObfuscatedKey { return ObfuscatedKey(_value + "F") }
    var G: ObfuscatedKey { return ObfuscatedKey(_value + "G") }
    var H: ObfuscatedKey { return ObfuscatedKey(_value + "H") }
    var I: ObfuscatedKey { return ObfuscatedKey(_value + "I") }
    var J: ObfuscatedKey { return ObfuscatedKey(_value + "J") }
    var K: ObfuscatedKey { return ObfuscatedKey(_value + "K") }
    var L: ObfuscatedKey { return ObfuscatedKey(_value + "L") }
    var M: ObfuscatedKey { return ObfuscatedKey(_value + "M") }
    var N: ObfuscatedKey { return ObfuscatedKey(_value + "N") }
    var O: ObfuscatedKey { return ObfuscatedKey(_value + "O") }
    var P: ObfuscatedKey { return ObfuscatedKey(_value + "P") }
    var Q: ObfuscatedKey { return ObfuscatedKey(_value + "Q") }
    var R: ObfuscatedKey { return ObfuscatedKey(_value + "R") }
    var S: ObfuscatedKey { return ObfuscatedKey(_value + "S") }
    var T: ObfuscatedKey { return ObfuscatedKey(_value + "T") }
    var U: ObfuscatedKey { return ObfuscatedKey(_value + "U") }
    var V: ObfuscatedKey { return ObfuscatedKey(_value + "V") }
    var W: ObfuscatedKey { return ObfuscatedKey(_value + "W") }
    var X: ObfuscatedKey { return ObfuscatedKey(_value + "X") }
    var Y: ObfuscatedKey { return ObfuscatedKey(_value + "Y") }
    var Z: ObfuscatedKey { return ObfuscatedKey(_value + "Z") }

    var a: ObfuscatedKey { return ObfuscatedKey(_value + "a") }
    var b: ObfuscatedKey { return ObfuscatedKey(_value + "b") }
    var c: ObfuscatedKey { return ObfuscatedKey(_value + "c") }
    var d: ObfuscatedKey { return ObfuscatedKey(_value + "d") }
    var e: ObfuscatedKey { return ObfuscatedKey(_value + "e") }
    var f: ObfuscatedKey { return ObfuscatedKey(_value + "f") }
    var g: ObfuscatedKey { return ObfuscatedKey(_value + "g") }
    var h: ObfuscatedKey { return ObfuscatedKey(_value + "h") }
    var i: ObfuscatedKey { return ObfuscatedKey(_value + "i") }
    var j: ObfuscatedKey { return ObfuscatedKey(_value + "j") }
    var k: ObfuscatedKey { return ObfuscatedKey(_value + "k") }
    var l: ObfuscatedKey { return ObfuscatedKey(_value + "l") }
    var m: ObfuscatedKey { return ObfuscatedKey(_value + "m") }
    var n: ObfuscatedKey { return ObfuscatedKey(_value + "n") }
    var o: ObfuscatedKey { return ObfuscatedKey(_value + "o") }
    var p: ObfuscatedKey { return ObfuscatedKey(_value + "p") }
    var q: ObfuscatedKey { return ObfuscatedKey(_value + "q") }
    var r: ObfuscatedKey { return ObfuscatedKey(_value + "r") }
    var s: ObfuscatedKey { return ObfuscatedKey(_value + "s") }
    var t: ObfuscatedKey { return ObfuscatedKey(_value + "t") }
    var u: ObfuscatedKey { return ObfuscatedKey(_value + "u") }
    var v: ObfuscatedKey { return ObfuscatedKey(_value + "v") }
    var w: ObfuscatedKey { return ObfuscatedKey(_value + "w") }
    var x: ObfuscatedKey { return ObfuscatedKey(_value + "x") }
    var y: ObfuscatedKey { return ObfuscatedKey(_value + "y") }
    var z: ObfuscatedKey { return ObfuscatedKey(_value + "z") }

    var n0: ObfuscatedKey { return ObfuscatedKey(_value + "0") }
    var n1: ObfuscatedKey { return ObfuscatedKey(_value + "1") }
    var n2: ObfuscatedKey { return ObfuscatedKey(_value + "2") }
    var n3: ObfuscatedKey { return ObfuscatedKey(_value + "3") }
    var n4: ObfuscatedKey { return ObfuscatedKey(_value + "4") }
    var n5: ObfuscatedKey { return ObfuscatedKey(_value + "5") }
    var n6: ObfuscatedKey { return ObfuscatedKey(_value + "6") }
    var n7: ObfuscatedKey { return ObfuscatedKey(_value + "7") }
    var n8: ObfuscatedKey { return ObfuscatedKey(_value + "8") }
    var n9: ObfuscatedKey { return ObfuscatedKey(_value + "9") }

    var dot: ObfuscatedKey { return ObfuscatedKey(_value + ".") }
    var dash: ObfuscatedKey { return ObfuscatedKey(_value + "-") }
    var underscore: ObfuscatedKey { return ObfuscatedKey(_value + "_") }

    func anything(_ extra: String) -> ObfuscatedKey {
        return ObfuscatedKey(_value + extra)
    }
}
