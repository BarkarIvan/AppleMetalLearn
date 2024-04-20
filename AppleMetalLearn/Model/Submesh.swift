//
//  Submesh.swift
//  AppleMetalLearn
//
//  Created by barkar on 10.04.2024.
//

import MetalKit

struct Submesh{
    
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
    
    struct Textures {
        var baseColor:          MTLTexture?
        var additionalMap:      MTLTexture? //normal.xy, toughhnness, meetallic
       // var diffuseBrushMap:    MTLTexture?
        var emissionMap:        MTLTexture?
    }
    
    var textures: Textures
    var material: Material?
}

extension Submesh{
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh, textureLoader: MTKTextureLoader){
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        
        textures = Textures(baseColor: nil, additionalMap: nil, emissionMap: nil)

        
        if let mdlMaterial = mdlSubmesh.material{
            material = Material(mdlMaterial, textureLoader: textureLoader)
            textures = Textures()
            let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [.origin: MTKTextureLoader.Origin.bottomLeft,.generateMipmaps: true]
            let texture = try? textureLoader.newTexture(name: "testTexture", scaleFactor: 1.0, bundle: Bundle.main)
            textures.baseColor = texture
            textures.additionalMap = texture
            textures.emissionMap = texture
            
        }
    }
}






private extension MDLMaterialProperty{
    var textureName: String{
        stringValue ?? UUID().uuidString
    }
}


/*
 private extension Material{
 init (material: MDLMaterial?){
 self.init()
 if let baseColor = material?.property(with: .baseColor),
 baseColor.type == .float3{
 self.baseColor = baseColor.float3Value
 }
 if let roughness = material?.property(with: .roughness),
 roughness.type == .float{
 self.roughness = roughness.floatValue
 }
 if let metallic = material?.property(with: .metallic),
 metallic.type  == .float{
 self.metallic = metallic.floatValue
 }
 }
 }
 */
