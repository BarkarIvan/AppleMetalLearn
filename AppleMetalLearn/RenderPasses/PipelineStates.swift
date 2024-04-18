//
//  PipelineStates.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

enum PipelineStates{
    
    
    static func createPipelineState(descriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState
    {
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: descriptor)
        }catch{
            fatalError(error.localizedDescription)
        }
        
        return pipelineState
        
    }
    
    static func createGBufferPipelineState(vertexFunctionName: String, fragmentFunctionName: String) -> MTLRenderPipelineState{
        let vertexFunction = Renderer.library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = Renderer.library?.makeFunction(name: fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        
        pipelineDescriptor.stencilAttachmentPixelFormat = .r32Float
        pipelineDescriptor.colorAttachments[RenderTargetIndex.albedo.rawValue].pixelFormat = GBufferTextures.albedoMettalicPixelFormat
        pipelineDescriptor.colorAttachments[RenderTargetIndex.normal.rawValue].pixelFormat = GBufferTextures.normlRoughnessShadowPixelFormat
        
     
        if GBufferTextures.isAttachedInFinalPass
        {
            pipelineDescriptor.colorAttachments[RenderTargetIndex.lighting.rawValue].pixelFormat = GBufferTextures.albedoMettalicPixelFormat
        }
        
        pipelineDescriptor.depthAttachmentPixelFormat = GBufferTextures.depthPixelFormat
        
        pipelineDescriptor.vertexDescriptor = .defaultLayout
        
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
    /*
    static func createShadowPipelineState() -> MTLRenderPipelineState{
        let vertexFunction = Renderer.library?.makeFunction(name: "vertex_depth")
          let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = .defaultLayout
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    */
}

    

