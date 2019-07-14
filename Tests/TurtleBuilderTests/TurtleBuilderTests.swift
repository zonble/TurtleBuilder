import XCTest
@testable import TurtleBuilder

final class TurtleBuilderTests: XCTestCase {
	func testTurtleEmpty() {
		let t = Turtle {
			pass()
			pass()
		}
		XCTAssertTrue(t.lines.count == 0)
	}

	func testTurtleNoPenDown() {
		let t = Turtle {
			forward(10)
			forward(10)
		}
		XCTAssertTrue(t.lines.count == 0)
	}

	func testTurtleWithOneLine() {
		let t = Turtle {
			penDown()
			forward(10)
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)))
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)))
	}

	func testTurtleIf() {
		let t = Turtle {
			penDown()
			if true {
				forward(10)
				pass()
			} else {
				pass()
			}
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)))
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)))
	}

	func testTurtleIf2() {
		let t = Turtle {
			penDown()
			if false {
				pass()
			} else {
				forward(10)
				pass()
			}
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)))
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)))
	}

	func testTurtleLoop1() {
		let t = Turtle {
			penDown()
			loop(10) {
				forward(10)
				pass()
			}
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines.first?.count == 11)
	}

	func testTurtleLoop2() {
		let t = Turtle {
			loop(10) {
				penDown()
				left(20)
				forward(10)
				penUp()
			}
			pass()
		}
		XCTAssertTrue(t.lines.count == 10)
		for i in t.lines {
			XCTAssertTrue(i.count == 2)
		}
	}

	func testTurtleLoopWithCenter() {
		let t = Turtle {
			loop(10) {
				center()
				penDown()
				left(20)
				forward(10)
				penUp()
			}
			pass()
		}
		XCTAssertTrue(t.lines.count == 10)
		for i in t.lines {
			XCTAssertTrue(i.first?.0 == Double(0))
			XCTAssertTrue(i.first?.1 == Double(0))
		}
	}

	func testTurn1() {
		let t = Turtle {
			left(20)
			right(20)
			penDown()
			forward(10)
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)) )
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)) )
	}

	func testTurn2() {
		let t = Turtle {
		left(20)
		left(-20)
			penDown()
			forward(10)
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)) )
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)) )
	}

	func testMacro() {
		let t = Turtle {
			penDown()
			setMacro("forward") {
				forward(10)
				pass()
			}
			playMacro("forward")
			penUp()
		}
		XCTAssertTrue(t.lines.count == 1)
		XCTAssertTrue(t.lines[0][0] == (Double(0), Double(0)) )
		XCTAssertTrue(t.lines[0][1] == (Double(10), Double(0)) )
	}

	static var allTests = [
		("testTurtleEmpty", testTurtleEmpty),
		("testTurtleWithOneLine", testTurtleWithOneLine),
		//		("testTurtleIf", testTurtleIf),
		("testTurtleLoop1", testTurtleLoop1),
		("testTurtleLoop2", testTurtleLoop2),
		("testTurtleLoopWithCenter", testTurtleLoopWithCenter),
		("testTurn1", testTurn1),
		("testTurn2", testTurn2),
		("testMacro", testMacro),
	]
}

