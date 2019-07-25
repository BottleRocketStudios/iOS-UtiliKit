//
//  ObfuscationTests.swift
//  UtiliKit-iOSTests
//
//  Created by Russell Mirabelli on 7/23/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import XCTest
import UtiliKit

class ObfuscationTests: XCTestCase {

    func testSimpleObfuscatedString() {
        let key = ObfuscatedKey().A.B.A.B.value
        let expected = "ABAB"
        XCTAssertEqual(key, expected, "Keys do not match: \(key) is not \(expected)")
    }

    func testUppercase() {
        let key = ObfuscatedKey().A.B.C.D.E.F.G.H.I.J.K.L.M.N.O.P.Q.R.S.T.U.V.W.X.Y.Z.value
        let expected = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        XCTAssertEqual(key, expected, "Keys do not match: \(key) is not \(expected)")
    }

    func testLowercase() {
        let key = ObfuscatedKey().a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z.value
        let expected = "abcdefghijklmnopqrstuvwxyz"
        XCTAssertEqual(key, expected, "Keys do not match: \(key) is not \(expected)")
    }

    func testDigits() {
        let key = ObfuscatedKey().n0.n1.n2.n3.n4.n5.n6.n7.n8.n9.value
        let expected = "0123456789"
        XCTAssertEqual(key, expected, "Keys do not match: \(key) is not \(expected)")
    }

    func testExtras() {
        let key = ObfuscatedKey().dot.dash.underscore.literal("=").value
        let expected = ".-_="
        XCTAssertEqual(key, expected, "Keys do not match: \(key) is not \(expected)")
    }

}
