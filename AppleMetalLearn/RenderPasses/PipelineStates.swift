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
       // pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        pipelineDescriptor.colorAttachments[RenderTargetIndex.albedo.rawValue].pixelFormat = .bgra8Unorm_srgb
        pipelineDescriptor.colorAttachments[RenderTargetIndex.normal.rawValue].pixelFormat = .rgba16Float
        pipelineDescriptor.colorAttachments[RenderTargetIndex.position.rawValue].pixelFormat = .rgba16Float
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
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

    

