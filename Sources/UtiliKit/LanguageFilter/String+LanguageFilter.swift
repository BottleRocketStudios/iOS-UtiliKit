//
//  String+LanguageFilter.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 6/19/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension String {

    /// Performs rot13 (dumb) encoding on a `UnicodeScalar` to provide minimal
    /// filtering of bad words.
    /// - Parameter unicodeScalar: The character to be `rot13`'ed
    /// - Returns: the `rot13` value
    private func rot13(unicodeScalar: UnicodeScalar) -> Character {
        var result = unicodeScalar.value

        switch unicodeScalar {
        case "A"..."M", "a"..."m":
            result += 13
        case "N"..."Z", "n"..."z":
            result -= 13
        default:
            break
        }

        return Character(UnicodeScalar(result) ?? " ")
    }

    /// Encodes / decodes a `String` using rot13
    /// - Parameter input: The `String` to be encoded / decoded
    /// - Returns: The encoded or decoded `String`
    private func rot13(input: String) -> String {
        return String(input.unicodeScalars.map(rot13))
    }

    /// A list of words which could be found to be offensive. Stored in source
    /// using rot13.
    private var offensiveWords: [String] {
        ["nany", "nahf", "nefr", "nff", "onyyfnpx", "onyyf", "onfgneq", "ovgpu", "ovngpu", "oybbql",
         "oybjwbo", "oybj wbo", "obyybpx", "obyybx", "obare", "obbo", "ohttre", "ohz", "ohgg", "ohggcyht",
         "pyvgbevf", "pbpx", "pbba", "penc", "phag", "qnza", "qvpx", "qvyqb", "qlxr", "snt", "srpx",
         "sryyngr", "sryyngvb", "srypuvat", "shpx", "s h p x", "shqtrcnpxre", "shqtr cnpxre", "synatr",
         "Tbqqnza", "Tbq qnza", "uryy", "ubzb", "wrex", "wvmm", "xvxr", "xaboraq", "xabo raq", "ynovn",
         "yznb", "yzsnb", "zhss", "avttre", "avttn", "bzt", "cravf", "cvff", "cbbc", "cevpx", "chor",
         "chffl", "dhrre", "fpebghz", "frk", "fuvg", "f uvg", "fu1g", "fyhg", "fzrtzn", "fchax", "gvg",
         "gbffre", "gheq", "gjng", "intvan", "jnax", "juber", "jgs"
        ].map { rot13(input: $0) }
    }

    /// Returns true if the `String` matches a set of potentially offensive
    /// words.
    var containsOffensiveLanguage: Bool {
        !(offensiveWords.filter { self.contains($0) }.isEmpty)
    }


    /// Returns a `String` where potentially offensive language is replaced
    /// with asterisks
    var removingOffensiveLanguage: String {
        self.replacingOffensiveWords(with: "*")
    }

    /// Replaces offensive words with the provided `String` (a single character is recommended)
    /// - Parameter replacement: The `String` to use for replacement
    /// - Returns: The string with offensive words replaced.
    func replacingOffensiveWords(with substitute: String) -> String {
        if !self.containsOffensiveLanguage { return self }
        var replacement = self
        for word in offensiveWords { replacement = replacement.replacingOccurrences(of: word, with: String(repeating: (substitute.first ?? "*"), count: word.count)) }
        return replacement
    }

}
