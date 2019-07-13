import Foundation

public enum Command {
	/// Does nothing.
	case pass
	/// Center the turtle.
	case center
	/// Pen up.
	case penUp
	/// Pen down.
	case penDown
	/// Turn left to given angle.
	case turn(Int)
	/// Move forward.
	case forward(Int)
	/// Do a looping.
	case loop(UInt, [Command])
}

public typealias TurtlePoint = (Double, Double)

/// Do nothing.
public func pass()-> Command { .pass }

/// Center the turtle.
public func center()-> Command { .center }

/// Move the turtle without drawing a line.
public func penUp()-> Command { .penUp }

/// Move the turtle with drawing a line.
public func penDown()-> Command { .penDown }

/// Turn to the given angle. It works as `left`.
/// - Parameter angle: The angle.
public func turn(_ angle: Int) -> Command { .turn(angle) }

/// Turn left to the given angle.
/// - Parameter angle: The angle.
public func left(_ angle: Int) -> Command { .turn(angle) }

/// Turn right to the given angle.
/// - Parameter angle: The angle.
public func right(_ angle: Int) -> Command { return .turn(angle * -1) }

/// Move forward.
/// - Parameter length: How long do we move.
public func forward(_ length:Int) -> Command { return .forward(length) }

/// Run a loop.
/// - Parameter repeatCount: How many times do we repeat.
/// - Parameter builder: The commands to run.
public func loop(_ repeatCount: UInt, @TurtleBuilder builder:()-> [Command]) -> Command {
	return .loop(repeatCount, builder())
}

@_functionBuilder
public struct TurtleBuilder {

	public static func buildIf(_ commands: [Command]?) -> Command {
		if let commands = commands {
			return  .loop(1, commands)
		}
		return .pass
	}

	public static func buildBlock(_ commands: Command...) -> [Command] {
		return commands
	}
}

public class Turtle {
	private var commands:[Command]

	public init(@TurtleBuilder builder:()-> [Command]) {
		self.commands = builder()
	}

	static func deg2rad(_ number: Double) -> Double {
		return number * .pi / 180
	}

	public lazy var points = self.complie()
}

extension Turtle {

	private func exec(_ command: Command, points:inout [[TurtlePoint]],
					  radian: inout Double,
					  lastPoint: inout TurtlePoint,
					  isPenDown: inout Bool
		) {
		switch command {
		case .penUp:
			isPenDown = false
		case .penDown:
			if isPenDown == false {
				points.append([lastPoint])
			}
			isPenDown = true
		case .center:
			let newPoint = (Double(0), Double(0))
			if isPenDown {
				if var lastSequence = points.last {
					lastSequence.append(newPoint)
					points[points.count - 1] = lastSequence
				}
			}
			lastPoint = newPoint
		case .forward(let length):
			let x = cos(radian) * Double(length)
			let y = sin(radian) * Double(length)
			let newPoint = (lastPoint.0 + x, lastPoint.1 +  y)
			if isPenDown {
				if var lastSequence = points.last {
					lastSequence.append(newPoint)
					points[points.count - 1] = lastSequence
				}
			}
			lastPoint = newPoint
		case .turn(let degree):
			let rad = Turtle.deg2rad(Double(degree))
			radian += rad
		case .loop(let count, let commands):
			for _ in 0..<count {
				for command in commands {
					exec(command, points: &points,
						 radian: &radian,
						 lastPoint: &lastPoint,
						 isPenDown: &isPenDown)
				}
			}
		case .pass:
			break
		}
	}

	private func complie() -> [[TurtlePoint]] {
		var points:[[TurtlePoint]] = []
		var radian: Double = 0
		var lastPoint = (Double(0), Double(0))
		var isPenDown: Bool = false
		for command in self.commands {
			exec(command, points: &points,
				 radian: &radian,
				 lastPoint: &lastPoint,
				 isPenDown: &isPenDown)
		}
		return points
	}

}
