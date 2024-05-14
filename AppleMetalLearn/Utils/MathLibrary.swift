import simd
import CoreGraphics



func randomVectorInsideCircle(radius: Float) -> simd_float2 {
    let angle = Float.random(in: 0..<2 * .pi)
    let r = radius
    let x = cos(angle) * r
    let y = sin(angle) * r
    return simd_float2(x, y)
}

func radians_to_degrees(_ radians: Float) -> Float {
      (radians / .pi) * 180
  }

func degrees_to_radians(_ degrees: Float) -> Float {
      (degrees / 180) * .pi
  }


// MARK: - float4
extension float4x4 {
    // MARK: - Translate
    init(translation: simd_float3) {
        let matrix = float4x4(
            [            1,             0,             0, 0],
            [            0,             1,             0, 0],
            [            0,             0,             1, 0],
            [translation.x, translation.y, translation.z, 1]
        )
        self = matrix
    }
    
    // MARK: - Scale
    init(scaling: simd_float3) {
        let matrix = float4x4(
            [scaling.x,         0,         0, 0],
            [        0, scaling.y,         0, 0],
            [        0,         0, scaling.z, 0],
            [        0,         0,         0, 1]
        )
        self = matrix
    }
    
    init(scaling: Float) {
        self = matrix_identity_float4x4
        columns.3.w = 1 / scaling
    }
    
    // MARK: - Rotate
    init(rotationX angle: Float) {
        let matrix = float4x4(
            [1,           0,          0, 0],
            [0,  cos(angle), sin(angle), 0],
            [0, -sin(angle), cos(angle), 0],
            [0,           0,          0, 1]
        )
        self = matrix
    }
    
    init(rotationY angle: Float) {
        let matrix = float4x4(
            [cos(angle), 0, -sin(angle), 0],
            [         0, 1,           0, 0],
            [sin(angle), 0,  cos(angle), 0],
            [         0, 0,           0, 1]
        )
        self = matrix
    }
    
    init(rotationZ angle: Float) {
        let matrix = float4x4(
            [ cos(angle), sin(angle), 0, 0],
            [-sin(angle), cos(angle), 0, 0],
            [          0,          0, 1, 0],
            [          0,          0, 0, 1]
        )
        self = matrix
    }
    
    init(rotation angle: simd_float3) {
        let rotationX = float4x4(rotationX: angle.x)
        let rotationY = float4x4(rotationY: angle.y)
        let rotationZ = float4x4(rotationZ: angle.z)
        self = rotationX * rotationY * rotationZ
    }
    
    init(rotationYXZ angle: simd_float3) {
        let rotationX = float4x4(rotationX: angle.x)
        let rotationY = float4x4(rotationY: angle.y)
        let rotationZ = float4x4(rotationZ: angle.z)
        self = rotationY * rotationX * rotationZ
    }
    
    // MARK: - Identity
    static var identity: float4x4 {
        matrix_identity_float4x4
    }
    
    
    var upperLeft: float3x3 {
      let x = simd_float3(columns.0.x, columns.0.y, columns.0.z)
      let y = simd_float3(columns.1.x, columns.1.y, columns.1.z)
      let z = simd_float3(columns.2.x, columns.2.y, columns.2.z)
      return float3x3(x, y, z)
    }
    
    
    init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, isLeftHand: Bool = true) {
        let y = 1 / tanf(fov * 0.5)
        let x = y / aspect
        let z = isLeftHand ? far / (far - near) : far / (near - far)
        let X = simd_float4( x,  0,  0,  0)
        let Y = simd_float4( 0,  y,  0,  0)
        let Z = isLeftHand ? simd_float4( 0,  0,  z, 1) : simd_float4( 0,  0,  z, -1)
        let W = isLeftHand ? simd_float4( 0,  0,  z * -near,  0) : simd_float4( 0,  0,  z * near,  0)
        self.init()
        columns = (X, Y, Z, W)
    }
    
    // left-handed LookAt
    init(eye: simd_float3, center: simd_float3, up: simd_float3) {
        let z = normalize(center - eye)
        let x = normalize(cross(up, z))
        let y = cross(z, x)
        
        let X = simd_float4(x.x, y.x, z.x, 0)
        let Y = simd_float4(x.y, y.y, z.y, 0)
        let Z = simd_float4(x.z, y.z, z.z, 0)
        let W = simd_float4(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1)
        
        self.init()
        columns = (X, Y, Z, W)
    }
    
    // MARK: - Orthographic matrix
    init(orthographic rect: CGRect, near: Float, far: Float) {
        let left = Float(rect.origin.x)
        let right = Float(rect.origin.x + rect.width)
        let top = Float(rect.origin.y)
        let bottom = Float(rect.origin.y - rect.height)
        let X = simd_float4(2 / (right - left), 0, 0, 0)
        let Y = simd_float4(0, 2 / (top - bottom), 0, 0)
        let Z = simd_float4(0, 0, 1 / (far - near), 0)
        let W = simd_float4(
            (left + right) / (left - right),
            (top + bottom) / (bottom - top),
            near / (near - far),
            1)
        self.init()
        columns = (X, Y, Z, W)
    }
    
    
  
 
}




