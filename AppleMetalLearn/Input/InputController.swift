//
//  InputController.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

import GameController

class InputController{
    struct Point{
        var x: Float
        var y: Float
        static let zero = Point(x:0, y:0)
    }
    
    var touchPressed = false
    var pointerDelta = Point.zero
    var pointerLocation: CGPoint?
    var lastTouchLocation: CGPoint?

    var touchDelta: CGSize?{
        didSet{
            touchDelta?.height *= -1
            if let delta = touchDelta{
                pointerDelta = Point(x: Float(delta.width), y: Float(delta.height))
            }
            touchPressed = touchDelta != nil//?
        }
    }
    
    static let shared = InputController()
    
    func touchBegan(location: CGPoint) {
            lastTouchLocation = location
            touchPressed = true
        }

        func touchMoved(location: CGPoint) {
            guard let lastLocation = lastTouchLocation else { return }
            let deltaX = location.x - lastLocation.x
            let deltaY = location.y - lastLocation.y
            pointerDelta = Point(x: Float(deltaX), y: Float(deltaY))
            lastTouchLocation = location
        }

        func touchEnded() {
            touchPressed = false
            pointerDelta = Point.zero
            lastTouchLocation = nil
        }
}
