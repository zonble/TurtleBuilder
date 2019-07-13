# TurtleBuilder

[![GitHub Release](https://img.shields.io/github/release/zonble/turtlebuilder.svg)]()
![GitHub Top Language](https://img.shields.io/github/languages/top/zonble/turtlebuilder.svg)
[![License](https://img.shields.io/github/license/ethanhuang13/nsattributedstringbuilder.svg)](https://github.com/zonble/turtlebuilder/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/Twitter-%40zonble-blue.svg)](https://twitter.com/zonble)

TurtleBuilder is a [turtle graphics](https://en.wikipedia.org/wiki/Turtle_graphics) made on the top of Swift's function builder. It allows you to use a [LOGO](https://en.wikipedia.org/wiki/Logo_(programming_language))-like syntax to create and draw lines in your Swift project.

[![TurtleBuilder Example](http://img.youtube.com/vi/mPF4nlYp-1c/0.jpg)](http://www.youtube.com/watch?v=mPF4nlYp-1c)

## Why?

Because it is fun!

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

## Draw In Views

TurtleBuilder provides two views where you can let the turtle to draw graphics. One is `TurtleView`, it renders the still lines with Quartz 2D, while another is `AnimatedTurtleView`, which creates animating layers using Core Animation.

You can use `AnimatedTurtleView` as following:


``` swift
let turtleView = AnimatedTurtleView(frame: self.view.bounds) {
    penDown()
    loop(10) {
        left(10)
        forward(10)
    }
    penUp()
}
```

Then call `turtleView.animate()` to start the animation.

Patches are welcome. Enjoy! 🐢
