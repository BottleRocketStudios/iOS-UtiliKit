//
//  LanguageTool.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 10/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

@available(iOSApplicationExtension 11.0, *)
class LanguageTool {

    private let badverbs = ["be", "have", "do", "say", "get", "make", "go", "know", "take", "see", "come", "think", "look", "want", "give", "use", "find", "tell", "ask", "work", "seem", "feel", "try", "leave", "call"]

    private let badnouns = ["way", "day", "thing", "place", "work", "case", "point", "company", "number"]

    private let badadjectives = ["long", "little", "own", "other", "old", "right", "big", "high", "different", "small", "large", "next", "early", "young", "important", "few", "public", "bad", "same", "able"]

    private let badprepositions = ["to", "of", "in", "for", "on", "with", "at", "by", "from", "up", "about", "into", "over", "after"]

    private let badOthers = ["the", "a", "which", "be", "to", "of", "and", "a", "an", "this", "one", "can", "it", "if", "as", "but", "they", "let", "there", "should"]


    func findSetOfWords(in str: String) -> [String] {
        let badwords = badnouns + badverbs + badadjectives + badprepositions + badOthers
        let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
        tagger.string = str
        var tags:[NSLinguisticTag] = []
        tagger.enumerateTags(in: NSRange(location: 0, length: str.count), unit: .word, scheme: .lemma, options: .omitWhitespace) { (tag, range, ptr) in
            if let tag = tag {
                tags.append(tag)
            }
        }
        let set = Array(Set(tags.map{$0.rawValue}).filter{!badwords.contains($0)})
        return set
    }
}
