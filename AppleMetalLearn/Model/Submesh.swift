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
        var diffuseBrushMap:    MTLTexture?
        var emissionMap:        MTLTexture?
    }
    
  //  var textures: Textures
   // var materialProperties: MaterialProperties
}

extension Submesh{
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh){
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        //textures = Textures(m)
        //temp
        //var props = MaterialProperties(baseColor: [1,1,1], roughness: 0, metallic: 0, emission: 0)
       // material = Material(properties: props)//Material(material: mdlSubmesh.material)
    
    }
}


/*
private extension Submesh.Textures{
    init(material: MDLMaterial?){
        baseColor = material?.texture(type: .userDefined)
        additionalMap = material?.texture(type: .userDefined)
        diffuseBrushMap = material?.texture(type: .userDefined)
        emissionMap = material?.texture(type: .emission)
    }
}


private extension MDLMaterialProperty{
    var textureName: String{
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial{
    func texture(type semantic: MDLMaterialSemantic) -> MTLTexture?{
        if let property = property(with: semantic),
           property.type == .texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return TextureController.loadTexture(texture: mdlTexture, name: property.textureName)
        }
        return nil
    }
}

private extension MaterialProperties{
    init (material: Material?){
        self.init()
        if let baseColor = material?.properties.baseColor,
          // baseColor.type == .float3{
        { self.baseColor = baseColor}()
        
    
        if let roughness = material?.property(with: .roughness),
           roughness.type == .float{
            self.roughness = roughness.floatValue
        }
        if let metallic = material?.property(with: .metallic),
           metallic.type  == .float{
            self.metallic = metallic.floatValue
        }
    }
 */


