//
//  Camera.swift
//  AppleMetalLearn
//
//  Created by barkar on 12.04.2024.
//

import CoreGraphics

protocol Camera: Transformable{
    var projectionMatrix: float4x4 {get}
    var viewMatrix: float4x4 {get}
    mutating func update (size: CGSize)
    mutating func update (deltaTime: Float)
}


struct FPCamera: Camera{
    var transform = Transform()
    var aspect: Float = 1.0
    var fov = degrees_to_radians(45)
    var near: Float = 0.1
    var far: Float = 100
    var projectionMatrix: float4x4{
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspect, isLeftHand: false)
    }
    
    mutating func update(size: CGSize){
        aspect = Float(size.width/size.height)
    }
    
    var viewMatrix: float4x4{
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    
    mutating func update(deltaTime: Float){
        let transform = updateInput(deltaTime: deltaTime)
        rotation += transform.rotation
        position += transform.position
    }
}

extension FPCamera: Movement {}

struct OrthographicCamera: Camera, Movement{
    var transform = Transform()
    var aspect: CGFloat = 1
    var viewSize: CGFloat = 10
    var near: Float = 0.1
    var far: Float = 100
    var center = simd_float3.zero
    
    var projectionMatrix: float4x4{
        let rect = CGRect(
            x: -viewSize * aspect * 0.5,
            y: viewSize * 0.5,
            width: viewSize * aspect,
            height: viewSize)
        return float4x4(orthographic: rect, near: near, far: far)
    }

    var viewMatrix: float4x4{
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    
    mutating func update(size: CGSize) {
        aspect = size.width / size.height
      }

      mutating func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        position += transform.position
        
      }
    
}
