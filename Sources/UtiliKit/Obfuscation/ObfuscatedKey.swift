//
//  ObfuscatedKey.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 7/23/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

// Inspired by https://github.com/onmyway133/Arcane/blob/master/Sources/Arcane/Obfuscator.swift

import Foundation

/// One should never commit keys directly into one's source; this is an unsafe practice.
/// When it is impossible to avoid doing so, the key should at least be obfuscated.
/// By using the ObfuscatedKey struct, you can build a human-readable key that nonetheless
/// will not appear simply by running "strings" against your compiled code, and will even
/// not appear as a string within your source code.
public struct ObfuscatedKey {
    public let value: String

    public init() {
        self.value = ""
    }

    public init(_ value: String) {
        self.value = value
    }

}

public extension ObfuscatedKey {
    // codebeat:disable[TOO_MANY_FUNCTIONS]
    var A: ObfuscatedKey { return ObfuscatedKey(value + "A") }
    var B: ObfuscatedKey { return ObfuscatedKey(value + "B") }
    var C: ObfuscatedKey { return ObfuscatedKey(value + "C") }
    var D: ObfuscatedKey { return ObfuscatedKey(value + "D") }
    var E: ObfuscatedKey { return ObfuscatedKey(value + "E") }
    var F: ObfuscatedKey { return ObfuscatedKey(value + "F") }
    var G: ObfuscatedKey { return ObfuscatedKey(value + "G") }
    var H: ObfuscatedKey { return ObfuscatedKey(value + "H") }
    var I: ObfuscatedKey { return ObfuscatedKey(value + "I") }
    var J: ObfuscatedKey { return ObfuscatedKey(value + "J") }
    var K: ObfuscatedKey { return ObfuscatedKey(value + "K") }
    var L: ObfuscatedKey { return ObfuscatedKey(value + "L") }
    var M: ObfuscatedKey { return ObfuscatedKey(value + "M") }
    var N: ObfuscatedKey { return ObfuscatedKey(value + "N") }
    var O: ObfuscatedKey { return ObfuscatedKey(value + "O") }
    var P: ObfuscatedKey { return ObfuscatedKey(value + "P") }
    var Q: ObfuscatedKey { return ObfuscatedKey(value + "Q") }
    var R: ObfuscatedKey { return ObfuscatedKey(value + "R") }
    var S: ObfuscatedKey { return ObfuscatedKey(value + "S") }
    var T: ObfuscatedKey { return ObfuscatedKey(value + "T") }
    var U: ObfuscatedKey { return ObfuscatedKey(value + "U") }
    var V: ObfuscatedKey { return ObfuscatedKey(value + "V") }
    var W: ObfuscatedKey { return ObfuscatedKey(value + "W") }
    var X: ObfuscatedKey { return ObfuscatedKey(value + "X") }
    var Y: ObfuscatedKey { return ObfuscatedKey(value + "Y") }
    var Z: ObfuscatedKey { return ObfuscatedKey(value + "Z") }
    var a: ObfuscatedKey { return ObfuscatedKey(value + "a") }
    var b: ObfuscatedKey { return ObfuscatedKey(value + "b") }
    var c: ObfuscatedKey { return ObfuscatedKey(value + "c") }
    var d: ObfuscatedKey { return ObfuscatedKey(value + "d") }
    var e: ObfuscatedKey { return ObfuscatedKey(value + "e") }
    var f: ObfuscatedKey { return ObfuscatedKey(value + "f") }
    var g: ObfuscatedKey { return ObfuscatedKey(value + "g") }
    var h: ObfuscatedKey { return ObfuscatedKey(value + "h") }
    var i: ObfuscatedKey { return ObfuscatedKey(value + "i") }
    var j: ObfuscatedKey { return ObfuscatedKey(value + "j") }
    var k: ObfuscatedKey { return ObfuscatedKey(value + "k") }
    var l: ObfuscatedKey { return ObfuscatedKey(value + "l") }
    var m: ObfuscatedKey { return ObfuscatedKey(value + "m") }
    var n: ObfuscatedKey { return ObfuscatedKey(value + "n") }
    var o: ObfuscatedKey { return ObfuscatedKey(value + "o") }
    var p: ObfuscatedKey { return ObfuscatedKey(value + "p") }
    var q: ObfuscatedKey { return ObfuscatedKey(value + "q") }
    var r: ObfuscatedKey { return ObfuscatedKey(value + "r") }
    var s: ObfuscatedKey { return ObfuscatedKey(value + "s") }
    var t: ObfuscatedKey { return ObfuscatedKey(value + "t") }
    var u: ObfuscatedKey { return ObfuscatedKey(value + "u") }
    var v: ObfuscatedKey { return ObfuscatedKey(value + "v") }
    var w: ObfuscatedKey { return ObfuscatedKey(value + "w") }
    var x: ObfuscatedKey { return ObfuscatedKey(value + "x") }
    var y: ObfuscatedKey { return ObfuscatedKey(value + "y") }
    var z: ObfuscatedKey { return ObfuscatedKey(value + "z") }
    var n0: ObfuscatedKey { return ObfuscatedKey(value + "0") }
    var n1: ObfuscatedKey { return ObfuscatedKey(value + "1") }
    var n2: ObfuscatedKey { return ObfuscatedKey(value + "2") }
    var n3: ObfuscatedKey { return ObfuscatedKey(value + "3") }
    var n4: ObfuscatedKey { return ObfuscatedKey(value + "4") }
    var n5: ObfuscatedKey { return ObfuscatedKey(value + "5") }
    var n6: ObfuscatedKey { return ObfuscatedKey(value + "6") }
    var n7: ObfuscatedKey { return ObfuscatedKey(value + "7") }
    var n8: ObfuscatedKey { return ObfuscatedKey(value + "8") }
    var n9: ObfuscatedKey { return ObfuscatedKey(value + "9") }

    var dot: ObfuscatedKey { return ObfuscatedKey(value + ".") }
    var dash: ObfuscatedKey { return ObfuscatedKey(value + "-") }
    var underscore: ObfuscatedKey { return ObfuscatedKey(value + "_") }

    func literal(_ extra: String) -> ObfuscatedKey {
        return ObfuscatedKey(value + extra)
    }
    // codebeat:enable[TOO_MANY_FUNCTIONS]    
}
