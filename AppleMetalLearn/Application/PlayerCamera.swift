//
//  PlayerCamera.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

import Foundation

struct PlayerCamera: Camera{
    
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = degrees_to_radians(45)
    var near: Float = 0.1
    var far: Float = 100
    
    var projectionMatrix: float4x4{
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    
    var viewMatrix: float4x4{
        let rotateMatrix = float4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        return (float4x4(translation: position) * rotateMatrix).inverse
    }
    
    mutating func update(size: CGSize) {
        aspect = Float(size.width / size.height)
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
        
        let input = InputController.shared
        if(input.touchPressed){
            let setsitivity = Settings.touchPanSestivity
            rotation.x += input.pointerDelta.y * setsitivity
            rotation.y += input.pointerDelta.x * setsitivity
            rotation.x = max(-.pi / 2, min(rotation.x, .pi/2))
            input.pointerDelta = .zero
        }
    }
}
   

extension PlayerCamera: Movement{}
    
    
    
    

