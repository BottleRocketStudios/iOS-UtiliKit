//
//  LanguageToolTests.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 10/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import UtiliKit

class LanguageToolTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWords() {
        let paragraphs = """
Let’s talk about this tea which American revolutionaries gleefully dumped into Boston harbor. With their monopoly on opium production, the East India company had solved one of its biggest dilemmas. Thus far, British merchants had to scrounge up gold and silver to buy Chinese goods. But if they could get enough Chinese people hooked on opium, that would serve as currency. And since they controlled production and prices, let’s just say it was a good deal. Over the course of the 18th and early 19th century, the East India company increased its opium exports to China manyfold.

At the turn of the 19th century, the Chinese government moved to make the opium trade illegal. British merchant-pirates resorted to smuggling to continue the trade. The Chinese government’s attempts to restrict opium imports were largely ineffective. By the 1830s, a large portion of the population (perhaps as high as 20%) was using opium. The Chinese government sought to restrict the trade even further.

Faced with a direct threat to their lucrative opium-tea trade, British naval forces and the armies of the East India company joined together to wage war on China. British forces fighting alongside the East India company’s mercenary army won the First Opium War of 1840-42. Casualties on the Chinese side (both civilian and military) were in the tens of thousands. British forces engaged in extensive looting and destruction of art works. The Qing dynasty government was forced to sign the Treaty of Nanking. It granted British merchants free access to numerous Chinese ports, and ceded the island of Hong Kong to Britain. British merchants resumed distributing thousands of tons of opium to China every year. The loss and burden of making reparations to Britain weakened the Qing dynasty and helped spark the Taiping rebellion. That bloody civil war cost 20-30 million lives and the First Opium War is seen as a seminal event in Chinese history.
"""
        XCTAssertEqual(LanguageTool().findSetOfWords(in: paragraphs).count, 120)

    }

}
