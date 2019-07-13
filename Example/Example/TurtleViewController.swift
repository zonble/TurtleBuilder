import UIKit
import TurtleBuilder
import TurtleView

class TurtleViewController: UIViewController {
	@TurtleBuilder
	func builder() -> [TurtleCommand] {
		pass()
		pass()
	}

	var turtleView: TurtleView!

	override func loadView() {
		self.view = UIView()
		self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.backgroundColor = UIColor.white
		turtleView = TurtleView(frame: self.view.bounds, builder: self.builder)
		turtleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.addSubview(turtleView)
	}

	override func viewDidLayoutSubviews() {
		self.turtleView.setNeedsDisplay()
	}
}

class StarViewController: TurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		forward(50)
		right(90)
		forward(15)
		left(90)
		penDown()
		loop(9) {
			turn(140)
			forward(30)
			turn(-100)
			forward(30)
		}
		penUp()
	}
}

class EmitViewController: TurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		loop(18) {
			center()
			penDown()
			turn(20)
			forward(100)
			penUp()
		}
	}
}

class StarAndEmitViewController: TurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		forward(50)
		right(90)
		forward(15)
		left(90)
		penDown()
		loop(9) {
			turn(140)
			forward(30)
			turn(-100)
			forward(30)
		}
		penUp()

		loop(18) {
			center()
			penDown()
			turn(20)
			forward(100)
			penUp()
		}
	}
}

class WaveViewController: TurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		left(180)
		forward(150)
		right(180)
		penDown()
		left(45)
		forward(30)
		loop(10) {
			right(90)
			forward(30)
			left(90)
			forward(30)
		}
		penUp()
	}
}

