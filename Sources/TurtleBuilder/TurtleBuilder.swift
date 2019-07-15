import Foundation

/// The commands for `Turtle`.
public enum TurtleCommand {
	/// Does nothing.
	case pass
	/// Center the turtle.
	case center
	/// Reset the direction of the turtle.
	case resetHeading
	/// Set the direction of the turtle.
	case setHeading(Int)
	/// Set the position of the turtle.
	case setPoistion(Int, Int)
	/// Pen up.
	case penUp
	/// Pen down.
	case penDown
	/// Turn left to given angle.
	case turn(Int)
	/// Move forward.
	case forward(Int)
	/// Do a looping.
	case loop(Int, [TurtleCommand])
	/// Set a macro.
	case setMacro(String, [TurtleCommand])
	/// Play a macro.
	case playMacro(String)
}

public typealias TurtlePoint = (Double, Double)

/// Do nothing.
public func pass()-> TurtleCommand { .pass }

/// Center the turtle.
public func center()-> TurtleCommand { .center }

/// Reset the direction of the turtle.
public func resetHeading()-> TurtleCommand { .resetHeading }

/// An alias of `resetHeading`
public let resetH = resetHeading

/// Set the direction of the turtle.
public func setHeading(_ degree: Int)-> TurtleCommand { .setHeading(degree) }

/// An alias of `setHeading`
public let setH = setHeading

/// Set the position of the turtle.
public func setPosition(_ x: Int, _ y: Int)-> TurtleCommand { .setPoistion(x, y) }

/// Move the turtle without drawing a line.
public func penUp()-> TurtleCommand { .penUp }

/// Move the turtle with drawing a line.
public func penDown()-> TurtleCommand { .penDown }

/// Turn left to the given angle.
/// - Parameter angle: The angle.
public func left(_ angle: Int) -> TurtleCommand { .turn(angle) }

/// An alias of `left`
public let lt = left

/// Turn right to the given angle.
/// - Parameter angle: The angle.
public func right(_ angle: Int) -> TurtleCommand { .turn(angle * -1) }

/// An alias of `right`
public let rt = right

/// Move forward.
/// - Parameter length: How long do we move.
public func forward(_ length:Int) -> TurtleCommand { .forward(length) }

/// An alias of `forward`.
public let fd = forward

/// Run a loop.
/// - Parameter repeatCount: How many times do we repeat.
/// - Parameter builder: The commands to run.
public func loop(_ repeatCount: Int, @TurtleBuilder builder:()-> [TurtleCommand]) -> TurtleCommand {
	.loop(repeatCount, builder())
}

/// An alias of `loop`.
public let `repeat` = loop

/// Set a macro.
/// - Parameter name: Name of the macro.
/// - Parameter builder: The commands to run.
public func setMacro(_ name: String, @TurtleBuilder builder:()-> [TurtleCommand]) -> TurtleCommand {
	.setMacro(name, builder())
}

/// Play a macro.
/// - Parameter name: Name of the macro.
public func playMacro(_ name: String) -> TurtleCommand {
	.playMacro(name)
}

@_functionBuilder
/// Function builder for `Turtle`
public struct TurtleBuilder {

	public static func buildIf(_ commands: [TurtleCommand]?) -> TurtleCommand {
		if let commands = commands {
			return .loop(1, commands)
		}
		return .pass
	}

	public static func buildEither(first commands: [TurtleCommand]) -> TurtleCommand {
		.loop(1, commands)
	}

	public static func buildEither(second commands: [TurtleCommand]) -> TurtleCommand {
		.loop(1, commands)
	}

	public static func buildBlock(_ commands: TurtleCommand...) -> [TurtleCommand] {
		commands
	}
}

/// The turtle that draws graphics.
public class Turtle {
	private var commands: [TurtleCommand]

	/// Creates a new instance.
	/// - Parameter builder: The commands sent to the turtle.
	public init(@TurtleBuilder builder:()-> [TurtleCommand]) {
		self.commands = builder()
	}

	public private (set) lazy var lines = self.complie()
}

extension Turtle {

	private static func deg2rad(_ number: Double) -> Double {
		return number * .pi / 180
	}

	private func exec(_ command: TurtleCommand, lines:inout [[TurtlePoint]],
					  radian: inout Double,
					  lastPoint: inout TurtlePoint,
					  isPenDown: inout Bool,
					  macros: inout [String:[TurtleCommand]]
		) {
		switch command {
		case .pass:
			break
		case .penUp:
			isPenDown = false
		case .penDown:
			if isPenDown == false {
				lines.append([lastPoint])
			}
			isPenDown = true
		case .center:
			let newPoint = (Double(0), Double(0))
			if isPenDown {
				if var lastSequence = lines.last {
					lastSequence.append(newPoint)
					lines[lines.count - 1] = lastSequence
				}
			}
			lastPoint = newPoint
		case .resetHeading:
			radian = Turtle.deg2rad(Double(90))
		case .setHeading(let degree):
			radian = Turtle.deg2rad(Double(90 + degree))
		case .setPoistion(let x, let y):
			let newPoint = (Double(x), Double(y))
			if lastPoint == newPoint {
				return
			}
			if isPenDown {
				if var lastSequence = lines.last {
					lastSequence.append(newPoint)
					lines[lines.count - 1] = lastSequence
				}
			}
			lastPoint = newPoint
		case .forward(let length):
			var x = cos(radian)
			var y = sin(radian)
			if abs(x) == 1.0 {
				y = 0
			} else if abs(y) == 1.0 {
				x = 0
			}
			x = x * Double(length)
			y = y * Double(length)
			let newPoint = (lastPoint.0 + x, lastPoint.1 +  y)
			if isPenDown {
				if var lastSequence = lines.last {
					lastSequence.append(newPoint)
					lines[lines.count - 1] = lastSequence
				}
			}
			lastPoint = newPoint
		case .turn(let degree):
			let rad = Turtle.deg2rad(Double(degree))
			radian += rad
		case .loop(let count, let commands):
			for _ in 0..<count {
				for command in commands {
					exec(command, lines: &lines,
						 radian: &radian,
						 lastPoint: &lastPoint,
						 isPenDown: &isPenDown,
						 macros: &macros)
				}
			}
		case .setMacro(let name, let commands):
			macros[name] = commands
		case .playMacro(let name):
			guard let commands = macros[name] else {
				break
			}
			for command in commands {
				exec(command, lines: &lines,
					 radian: &radian,
					 lastPoint: &lastPoint,
					 isPenDown: &isPenDown,
					 macros: &macros)
			}
		}
	}

	private func complie() -> [[TurtlePoint]] {
		var lines:[[TurtlePoint]] = []
		var radian: Double = Turtle.deg2rad(Double(90))
		var lastPoint = (Double(0), Double(0))
		var isPenDown: Bool = false
		var macros = [String:[TurtleCommand]]()
		for command in self.commands {
			exec(command, lines: &lines,
				 radian: &radian,
				 lastPoint: &lastPoint,
				 isPenDown: &isPenDown,
				 macros: &macros)
		}
		return lines
	}

}

