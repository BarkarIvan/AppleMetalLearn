//
//  GBufferTextures.swift
//  AppleMetalLearn
//
//  Created by barkar on 18.04.2024.
//

import Metal
import CoreGraphics

struct GBufferTextures{
    
    var albedoMetallic: MTLTexture!
    var normalRoughnessShadow: MTLTexture!
    var depth: MTLTexture!
    
    var width: UInt32{
        UInt32(albedoMetallic.width)
    }
    
    var height: UInt32{
        UInt32(albedoMetallic.width)
    }
    
    static let isAttachedInFinalPass: Bool = {
        let device = MTLCreateSystemDefaultDevice()!
        return device.supportsFamily(.apple1)
    }()
        
    static let albedoMettalicPixelFormat = MTLPixelFormat.rgba8Unorm_srgb
    static let normlRoughnessShadowPixelFormat = MTLPixelFormat.rgba8Unorm
    static let depthPixelFormat = MTLPixelFormat.r32Float
    
    
    mutating func makeTexture(device: MTLDevice, size: CGSize, storageMode: MTLStorageMode){
        
        let GBufferTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .invalid, width: Int(size.width), height: Int(size.height), mipmapped: false)
            
            
        GBufferTextureDescriptor.textureType = .type2D
        GBufferTextureDescriptor.usage = [.shaderRead, .renderTarget]
        GBufferTextureDescriptor.pixelFormat = GBufferTextures.albedoMettalicPixelFormat
        
        albedoMetallic = device.makeTexture(descriptor: GBufferTextureDescriptor)
        albedoMetallic.label = "Albedo-Metallic"
        
        GBufferTextureDescriptor.pixelFormat = GBufferTextures.normlRoughnessShadowPixelFormat;
        normalRoughnessShadow = device.makeTexture(descriptor: GBufferTextureDescriptor)
        normalRoughnessShadow.label = "NormalXY-Roughtness-Shadow"
        
        GBufferTextureDescriptor.pixelFormat = GBufferTextures.depthPixelFormat
        depth = device.makeTexture(descriptor: GBufferTextureDescriptor)
        depth.label = "Depth Buffer"
        
        
    }
    
    
}
