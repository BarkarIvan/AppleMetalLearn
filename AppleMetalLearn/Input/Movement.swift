//
//  Movement.swift
//  AppleMetalLearn
//
//  Created by barkar on 12.04.2024.
//

import Foundation

enum Settings{
    static var rotationSpeed: Float {2.0}
    static var translationSpeed: Float{3.0}
    static var touchPanSestivity: Float {0.008}
    static var touchZoomSensitivity: Float{10}

}

protocol Movement where Self: Transformable{}

extension Movement{
    var forwardVector: simd_float3{
        normalize([sin(rotation.y), 0, cos(rotation.y)])
    }
    
    var rightVector: simd_float3{
        [-forwardVector.z, forwardVector.y, forwardVector.x]
    }
    
    
}


