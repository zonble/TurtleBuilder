# TurtleBuilder

TurtleBuilder is a [turtle graphics](https://en.wikipedia.org/wiki/Turtle_graphics) made on the top of Swift's function builder. It allows you to use a [LOGO](https://en.wikipedia.org/wiki/Logo_(programming_language))-like syntax to create and draw lines in your Swift project.

https://www.youtube.com/watch?v=mPF4nlYp-1c

## Requirement

- Xcode 11 or above
- Swift 5.1 or above

## Installation

You can install TurtleBuilder into your project via Swift Package Manager.

## Usage

### Build a Turtle

You can use a build block to build a turtle. For example:

``` swift
let turtle = Turtle {
    penDown()
    loop(10) {
        left(10)
        forward(10)
    }
    penUp()
}
```

Then you can get lines from the turtle, by calling `turtle.lines`.

### Commands

TurtleBuilder provides following commands to let you control your turtle:

- pass: The command does nothing.
- center: Move the turtle to the center of the canvas.
- resetDirection: Resets the direction of the turtle. The turtle is facing to the right side by default.
- penUp: After the command is called, the turtle moves without drawing a line.
- penDown: After the command is called, the turtle draw a line when it is moving.
- left: Turn the turtle to left with a given degree.
- right: Turn the turtle to right with a given degree.
- turn: An alias of `left`.
- forward: Ask the turtle to move forward.
- loop: Repeat running a set of commands.
- setMacro: Set a set of commands as a macro with a given name.
- playMacro: Play a macro. The macro needs to be set before.
