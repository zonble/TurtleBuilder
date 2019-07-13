import Foundation
import UIKit
import TurtleBuilder

fileprivate protocol AnimationLooperDelegate: class {
	func turtleAnimatorDidEnd(_ animator: TurtleAnimator)
}

fileprivate class TurtleAnimator: NSObject, CAAnimationDelegate {
	var layers: [CAShapeLayer]
	var index = 0
	weak var delegate: AnimationLooperDelegate?

	deinit {
		self.layers.forEach { layer in
			layer.removeAllAnimations()
		}
	}

	init(_ layers: [CAShapeLayer]) {
		self.layers = layers
		super.init()
		if self.layers.count > 0 {
			self.scheduleAnimation(layers[index])
		} else {
			delegate?.turtleAnimatorDidEnd(self)
		}
	}

	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		layers[index].removeAllAnimations()
		if index < layers.count - 1 {
			index += 1
			scheduleAnimation(layers[index])
		}
	}

	func scheduleAnimation(_ layer: CAShapeLayer) {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0.0
		animation.toValue = 1.0
		animation.delegate = self
		animation.duration = 3.0 / Double(layers.count)
		layer.strokeEnd = 1.0
		layer.add(animation, forKey: nil)
	}
}

public class AnimatedTurtleView: UIView, AnimationLooperDelegate {

	public private(set) var turtle: Turtle
	public var strokeColor: UIColor = UIColor.green {
		didSet {
			self.shapeLayers.forEach { layer in
				layer.strokeColor = strokeColor.cgColor
			}
		}
	}
	public var fillColor: UIColor = UIColor.clear {
		didSet {
			self.shapeLayers.forEach { layer in
				layer.fillColor = fillColor.cgColor
			}
		}
	}

	public init(frame: CGRect, turtle: Turtle) {
		self.turtle = turtle
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		self.shapeLayers = makeLayers()
	}

	public convenience init(frame: CGRect,
							@TurtleBuilder builder:()-> [TurtleCommand]) {
		let turtle = Turtle(builder: builder)
		self.init(frame: frame, turtle: turtle)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var shapeLayers: [CAShapeLayer] = [] {
		willSet {
			self.shapeLayers.forEach { layer in
				layer.removeFromSuperlayer()
			}
		}
		didSet {
			self.shapeLayers.forEach { layer in
				self.layer.addSublayer(layer)
			}
		}
	}

	private func makeLayers() -> [CAShapeLayer] {
		let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
		var layers = [CAShapeLayer]()
		for sequence in turtle.lines {
			if sequence.count < 2 {
				continue
			}
			let path = UIBezierPath()
			path.lineWidth = 3
			path.move(to: transalte(sequence[0], center: center))
			for point in sequence[1...] {
				path.addLine(to: transalte(point, center: center))
			}
			let layer = CAShapeLayer()
			layer.frame = self.bounds
			layer.path = path.cgPath
			layer.strokeColor = strokeColor.cgColor
			layer.fillColor = fillColor.cgColor
			layer.lineWidth = 3
			layers.append(layer)
		}
		return layers
	}

	private var animator: TurtleAnimator?

	public func animate() {
		CATransaction.begin()
		CATransaction.disableActions()
		self.shapeLayers.forEach { layer in
			layer.removeAllAnimations()
			layer.strokeEnd = 0
		}
		CATransaction.commit()
		self.animator = TurtleAnimator(self.shapeLayers)
	}

	fileprivate func turtleAnimatorDidEnd(_ animationLooper: TurtleAnimator) {
		self.animator = nil
	}

	public func rebuildLayers() {
		self.shapeLayers = makeLayers()
	}

}


