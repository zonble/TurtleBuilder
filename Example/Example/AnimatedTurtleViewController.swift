import UIKit
import TurtleBuilder
import TurtleView

class AnimatedTurtleViewController: UIViewController {
	@TurtleBuilder
	func builder() -> [TurtleCommand] {
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
			self.turtleView.animate(showTurtle: true)
		}
	}

	override func viewDidLayoutSubviews() {
		self.turtleView.rebuildLayers()
	}
}

class AnimatedLogoViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		penDown()
		loop(20) {
			loop(180) {
				forward(25)
				right(20)
			}
			right(18)
		}
	}
}

class AnimatedStarViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		forward(50)
		right(90)
		forward(15)
		left(90)
		penDown()
		loop(9) {
			left(140)
			forward(30)
			left(-100)
			forward(30)
		}
		penUp()
	}
}

class AnimatedEmitViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		loop(18) {
			center()
			penDown()
			left(20)
			forward(100)
			penUp()
		}
	}
}

class AnimatedStarAndEmitViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		forward(50)
		right(90)
		forward(15)
		left(90)
		penDown()
		loop(9) {
			left(140)
			forward(30)
			left(-100)
			forward(30)
		}
		penUp()

		loop(18) {
			center()
			penDown()
			left(20)
			forward(100)
			penUp()
		}
	}
}

class AnimatedWaveViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		left(90)
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

class AnimatedMultipleStarsViewController: AnimatedTurtleViewController {
	@TurtleBuilder
	override func builder() -> [TurtleCommand] {
		setMacro("star") {
			forward(50)
			right(90)
			forward(15)
			left(90)
			penDown()
			loop(9) {
				left(140)
				forward(30)
				left(-100)
				forward(30)
			}
			penUp()
		}

		center(); resetHeading()
		forward(200)
		playMacro("star")

		center(); resetHeading()
		forward(100)
		playMacro("star")

		center(); resetHeading()
		playMacro("star")

		center(); resetHeading()
		right(180)
		forward(100)
		playMacro("star")

		center(); resetHeading()
		right(180)
		forward(200)
		playMacro("star")
	}
}


