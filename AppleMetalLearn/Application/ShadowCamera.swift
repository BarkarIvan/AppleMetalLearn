//
//  ShadowCamea.swift
//  AppleMetalLearn
//
//  Created by barkar on 23.04.2024.
//

import CoreGraphics

struct FrustumPoints
{
    var viewMatrix = float4x4.identity
    var upperLeft = simd_float3.zero
    var upperRight = simd_float3.zero
    var lowerRight = simd_float3.zero
    var lowerLeft = simd_float3.zero
}

extension Camera
{
    static func createShadowCamera ( using camera: FPCamera, lightPositionn: simd_float3) -> OrthographicCamera
    {
       
        let nearPoints = calculatePlane(camera: camera, distance: camera.near)
        let farPoints = calculatePlane(camera: camera, distance: camera.far)
        
        let radius1 = distance(nearPoints.lowerLeft, farPoints.upperRight) * 0.5
        let radius2 = distance(farPoints.lowerLeft, farPoints.upperLeft) * 0.5
        
        var center : simd_float3
        if radius1 > radius2
        {
            center = simd_mix(nearPoints.lowerLeft, farPoints.upperRight, [0.5,0.5,0.5])
        }else{
            center = simd_mix(farPoints.lowerLeft, farPoints.upperRight, [0.5,0.5,0.5])
        }
        
        let radius = max(radius1, radius2)
        
        var shadowCamera = OrthographicCamera()
        let dir = normalize(lightPositionn)
        shadowCamera.position = center + dir * radius
        shadowCamera.far = radius * 2.0
        shadowCamera.near = 0.01
        shadowCamera.viewSize = CGFloat(shadowCamera.far)
        shadowCamera.center = center
        return shadowCamera
        
    }
    
    static func calculatePlane(camera: FPCamera, distance: Float) -> FrustumPoints
    {
        let halfFov = camera.fov * 0.5
        let halfHeight = tan(halfFov) * distance
        let halfWidth = halfHeight * camera.aspect
        return calculatePlanePoints(matrix: camera.viewMatrix, halfWidth: halfWidth, halfHeight: halfHeight, distance: distance, position: camera.position)
    }
    
    static func calculatePlane(camera: OrthographicCamera, distance: Float) -> FrustumPoints
    {
        let aspect = Float(camera.aspect)
        let halfHeight = Float(camera.aspect)
        let halfWidth = halfHeight * aspect
        let matrix = float4x4(eye: camera.position, center: camera.center, up: [0,1,0])
        return calculatePlanePoints(matrix: matrix, halfWidth: halfWidth, halfHeight: halfHeight, distance: distance, position: camera.position)
    }
    
    private static func calculatePlanePoints(
        matrix: float4x4,
        halfWidth: Float,
        halfHeight: Float,
        distance: Float,
        position: simd_float3) -> FrustumPoints
    {
        let forward: simd_float3 = [matrix.columns.0.z, matrix.columns.1.z, matrix.columns.2.z]
        let right: simd_float3 = [matrix.columns.0.x, matrix.columns.1.x, matrix.columns.2.x]
        let up = cross(forward, right)
        let center = position + forward * distance
        let moveRight = right * halfWidth
        let moveDown = up * halfHeight
        
        let upperLeft = center - moveRight + moveDown
        let upperRight = center + moveRight + moveDown
        let lowerRight = center + moveRight - moveDown
        let lowerLeft = center - moveRight - moveDown
        let points = FrustumPoints(
        viewMatrix: matrix,
        upperLeft: upperLeft,
        upperRight: upperRight,
        lowerRight: lowerRight,
        lowerLeft: lowerLeft
        )
        return points
    }
    
}
