//
//  SpuristoTests.swift
//  SpuristoTests
//
//  Created by Ilya Kharabet on 17.05.16.
//  Copyright © 2016 Ilya Kharabet. All rights reserved.
//

import XCTest
@testable import Spuristo

class SpuristoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testMaxValue() {
        let tracker = Tracker(key: "testTracker", condition: TrackerCondition.every(2))
        let val = UInt.max - 1
        UserDefaults.standard.set(val, forKey: "IKAppUsageTracker.TrackertestTrackerusagesCount")
        UserDefaults.standard.synchronize()
        for _ in 0..<10 {
            tracker.commit()
        }
        XCTAssert(tracker.enabled == false)
    }
    
    func testDrop() {
        let tracker = Tracker(key: "testTracker1", condition: TrackerCondition.every(2))
        let val = 5
        UserDefaults.standard.set(val, forKey: "IKAppUsageTracker.TrackertestTracker1usagesCount")
        UserDefaults.standard.synchronize()
        XCTAssert(tracker.usagesCount == 5)
        tracker.drop()
        XCTAssert(tracker.usagesCount == 0, "Usages count = \(tracker.usagesCount)")
    }
    
    func testSatisfiesCondition() {
        let targetPower: UInt = 2
        let tracker = Tracker(key: "testTracker2", condition: TrackerCondition.quadratic(targetPower))
        tracker.checkpoint = {
            let power = log(Double(tracker.usagesCount)) / log(Double(targetPower))
            XCTAssert(floor(power) == power && power != 0, "Usages count = \(tracker.usagesCount), Power = \(power)")
        }
    }
    
}
