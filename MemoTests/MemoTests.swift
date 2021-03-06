//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Memo
import XCTest

final class MemoTests: XCTestCase {
	override func setUp() {
		effects = 0
	}


	// MARK: Evaluation

	func testEvaluatesLazilyWithAutoclosureConstruction() {
		_ = Memo { ++effects }
		XCTAssertEqual(effects, 0)
	}

	func testEvaluatesLazilyWithClosureConstruction() {
		_ = Memo { ++effects }
		XCTAssertEqual(effects, 0)
	}

	func testEvaluatesEagerlyWithValueConstruction() {
		_ = Memo(evaluated: ++effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Memoization

	func testMemoizesWithAutoclosureConstruction() {
		let memo = Memo { ++effects }
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}

	func testMemoizesWithClosureConstruction() {
		let memo = Memo { ++effects }
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}

	func testMemoizesWithValueConstruction() {
		let memo = Memo(evaluated: ++effects)
		XCTAssertEqual(memo.value, memo.value)
		XCTAssertEqual(memo.value, effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Copying

	func testCopiesMemoizeTogether() {
		let memo = Memo { ++effects }
		XCTAssertEqual(effects, 0)

		let copy = memo

		XCTAssertEqual(memo.value, copy.value)
		XCTAssertEqual(copy.value, effects)
		XCTAssertEqual(effects, 1)
	}


	// MARK: Map

	func testMapEvaluatesLazily() {
		let memo = Memo { ++effects }
		let mapped = memo.map { $0 + ++effects }
		XCTAssertEqual(effects, 0)
		XCTAssertEqual(memo.value, 1)
		XCTAssertEqual(effects, 1)
		XCTAssertEqual(mapped.value, effects + memo.value)
		XCTAssertEqual(effects, 2)
	}


	// MARK: Equality

	func testEqualityOverEquatable() {
		let memo = Memo { ++effects }
		XCTAssertTrue(memo == Memo(evaluated: 1))
	}

	func testInequalityOverEquatable() {
		let memo = Memo { ++effects }
		XCTAssertTrue(memo != Memo(evaluated: 0))
	}
}


// MARK: - Fixtures

private var effects = 0
