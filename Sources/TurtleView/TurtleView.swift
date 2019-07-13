import Foundation
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif
import TurtleBuilder

public class TurtleView: PlatformView {
	var turtle: Turtle
	func update() {
		#if os(macOS)
		self.setNeedsDisplay(self.bounds)
		#endif
		#if os(iOS)
		self.setNeedsDisplay()
		#endif
	}
	var strokeColor: PlatformColor = PlatformColor.green {
		didSet { update() }
	}
	public var fillColor: UIColor = UIColor.clear {
		didSet { update() }
	}

	public init(frame: CGRect, turtle: Turtle) {
		self.turtle = turtle
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}

	public convenience init(frame: CGRect, @TurtleBuilder builder:()-> [TurtleCommand]) {
		let turtle = Turtle(builder:builder)
		self.init(frame:frame, turtle: turtle )
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if os(macOS)
	// For macOS.
	public override var isFlipped: Bool {
		true
	}
	#endif

	public override func draw(_ rect: CGRect) {
		super.draw(rect)

		let center = CGPoint(x: self.bounds.width / 2, y:self.bounds.height / 2)
		strokeColor.setStroke()
		for sequence in turtle.lines {
			if sequence.count < 2 {
				continue
			}
			let path = PlatformPath()
			path.lineWidth = 3
			path.move(to: transalte(sequence[0], center: center))
			for point in sequence[1...] {
				#if os(macOS)
				path.line(to: transalte(point, center: center))
				#endif
				#if os(iOS)
				path.addLine(to: transalte(point, center: center))
				#endif
			}
			path.stroke()
		}

	}
}
