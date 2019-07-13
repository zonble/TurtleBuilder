import UIKit
import TurtleBuilder
import TurtleView

class AnimatedTurtleViewController: UIViewController {
	@TurtleBuilder
	func builder() -> [Command] {
		pass()
		pass()
	}

	var turtleView: AnimatedTurtleView!
	
	override func loadView() {
		self.view = UIView()
		self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.backgroundColor = UIColor.white
		turtleView = AnimatedTurtleView(frame: self.view.bounds, builder: self.builder)
		turtleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view.addSubview(turtleView)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
			self.turtleView.animate()
		}
	}

	override func viewDidLayoutSubviews() {
		self.turtleView.setNeedsDisplay()
	}
}

class AnimatedStarViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [Command] {
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

class AnimatedEmitViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [Command] {
		loop(18) {
			center()
			penDown()
			turn(20)
			forward(100)
			penUp()
		}
	}
}

class AnimatedStarAndEmitViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [Command] {
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

class AnimatedWaveViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [Command] {
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
