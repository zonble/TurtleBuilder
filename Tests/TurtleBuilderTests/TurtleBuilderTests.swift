import XCTest
@testable import TurtleBuilder

final class TurtleBuilderTests: XCTestCase {
	func testTurtleEmpty() {
		let t = Turtle {
			pass()
			pass()
		}
		XCTAssertTrue(t.points.count == 0)
	}

	func testTurtleNoPenDown() {
		let t = Turtle {
			forward(10)
			forward(10)
		}
		XCTAssertTrue(t.points.count == 0)
	}

	func testTurtleWithOneLine() {
		let t = Turtle {
			penDown()
			forward(10)
			penUp()
		}
		XCTAssertTrue(t.points.count == 1)
		XCTAssertTrue(t.points[0][0] == (Double(0), Double(0)))
		XCTAssertTrue(t.points[0][1] == (Double(10), Double(0)))
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
		XCTAssertTrue(t.points.count == 1)
		XCTAssertTrue(t.points.first?.count == 11)
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
		XCTAssertTrue(t.points.count == 10)
		for i in t.points {
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
		XCTAssertTrue(t.points.count == 10)
		for i in t.points {
			XCTAssertTrue(i.first?.0 == Double(0))
			XCTAssertTrue(i.first?.1 == Double(0))
		}
	}

    static var allTests = [
        ("testTurtleEmpty", testTurtleEmpty),
        ("testTurtleWithOneLine", testTurtleWithOneLine),
        ("testTurtleLoop1", testTurtleLoop1),
        ("testTurtleLoop2", testTurtleLoop2),
        ("testTurtleLoopWithCenter", testTurtleLoopWithCenter),
		]
}
