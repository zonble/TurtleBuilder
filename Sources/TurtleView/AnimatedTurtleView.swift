import Foundation
import UIKit
import TurtleBuilder

fileprivate protocol AnimationLooperDelegate: class {
	func turtleAnimatorDidEnd(_ animator: TurtleAnimator)
}

fileprivate class TurtleAnimator: NSObject, CAAnimationDelegate {
	var turtleLayer: CALayer = {
		let layer = CATextLayer()
		layer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
		layer.string = "🐢"
		return layer
	}()

	var layers: [CAShapeLayer]
	var index = 0
	var showTurtle: Bool
	weak var delegate: AnimationLooperDelegate?

	deinit {
		turtleLayer.removeFromSuperlayer()
		self.layers.forEach { layer in
			layer.removeAllAnimations()
		}
	}

	init(_ layers: [CAShapeLayer], showTurtle: Bool = false) {
		self.layers = layers
		self.showTurtle = showTurtle
		super.init()
		if self.layers.count > 0 {
			self.scheduleAnimation(layers[index])
		} else {
			delegate?.turtleAnimatorDidEnd(self)
		}
	}

	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		layers[index].removeAllAnimations()
		turtleLayer.removeAllAnimations()
		CATransaction.begin()
		CATransaction.disableActions()
		turtleLayer.removeFromSuperlayer()
		CATransaction.commit()

		if index < layers.count - 1 {
			index += 1
			scheduleAnimation(layers[index])
		}
	}

	func scheduleAnimation(_ layer: CAShapeLayer) {
		let duration = 3.0 / Double(layers.count)
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0.0
		animation.toValue = 1.0
		animation.delegate = self
		animation.duration = duration
		layer.strokeEnd = 1.0
		layer.add(animation, forKey: nil)

		if showTurtle {
			CATransaction.begin()
			CATransaction.disableActions()
			layer.addSublayer(turtleLayer)
			CATransaction.commit()

			let movingAnimation = CAKeyframeAnimation(keyPath: "position")
			movingAnimation.path = layer.path
			movingAnimation.duration = duration
			turtleLayer.add(movingAnimation, forKey: nil)
		}
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

	public func animate(showTurtle: Bool = false) {
		CATransaction.begin()
		CATransaction.disableActions()
		self.shapeLayers.forEach { layer in
			layer.removeAllAnimations()
			layer.strokeEnd = 0
		}
		CATransaction.commit()
		self.animator = TurtleAnimator(self.shapeLayers, showTurtle: showTurtle)
	}

	fileprivate func turtleAnimatorDidEnd(_ animationLooper: TurtleAnimator) {
		self.animator = nil
	}

	public func rebuildLayers() {
		self.shapeLayers = makeLayers()
	}

}


