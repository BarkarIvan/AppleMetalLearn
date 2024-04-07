//
//  LinearAlgebra.swift
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

import Foundation
import simd

class LinearAlgebra{
    
    static func create_identity() -> float4x4 {
        return float4x4 (
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        )
    }
    
   static func matrix4x4_translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> matrix_float4x4 {
        return matrix_float4x4.init(columns:(vector_float4(1, 0, 0, 0),
                                             vector_float4(0, 1, 0, 0),
                                             vector_float4(0, 0, 1, 0),
                                             vector_float4(translationX, translationY, translationZ, 1)))
    }
    
    static func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
        let unitAxis = normalize(axis)
        let ct = cosf(radians)
        let st = sinf(radians)
        let ci = 1 - ct
        let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
        return matrix_float4x4.init(columns:(vector_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                             vector_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                             vector_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                             vector_float4(                  0,                   0,                   0, 1)))
    }
    
    static func create_lookat(eye: simd_float3, target: simd_float3, up: simd_float3) -> float4x4 {
        let forwards: simd_float3 = simd.normalize(target - eye)
        let right: simd_float3 = simd.normalize(simd.cross(up, forwards))
        let up2: simd_float3 = simd.normalize(simd.cross(forwards, right))
        
        
        return float4x4(
            [            right[0],             up2[0],             forwards[0],       0],
            [            right[1],             up2[1],             forwards[1],       0],
            [            right[2],             up2[2],             forwards[2],       0],
            [-simd.dot(right,eye), -simd.dot(up2,eye), -simd.dot(forwards,eye),       1]
        )
        
    }
    
    static func matrix_perspective_right_hand(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
        let ys = 1 / tanf(fovy * 0.5)
        let xs = ys / aspectRatio
        let zs = farZ / (nearZ - farZ)
        return matrix_float4x4.init(columns:(vector_float4(xs,  0, 0,   0),
                                             vector_float4( 0, ys, 0,   0),
                                             vector_float4( 0,  0, zs, -1),
                                             vector_float4( 0,  0, zs * nearZ, 0)))
    }
    
    func radians_from_degrees(_ degrees: Float) -> Float {
        return (degrees / 180) * .pi
    }
}
