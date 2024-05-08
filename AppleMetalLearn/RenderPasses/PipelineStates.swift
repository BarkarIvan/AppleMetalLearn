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
        
        
        //RENDER TARGET PIXEL FORMAT
        pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        
        pipelineDescriptor.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].pixelFormat = PixelFormats.gBufferAlbedoShadow
        pipelineDescriptor.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].pixelFormat = PixelFormats.gbufferNormalRoughtess
        pipelineDescriptor.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].pixelFormat = PixelFormats.gBufferEmissionMetallic
        pipelineDescriptor.colorAttachments[RenderTargetIndex.depth.rawValue].pixelFormat = PixelFormats.gBufferDepth

        //ATTACHMENT PIXEL FORMATS
        pipelineDescriptor.depthAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDescriptor.stencilAttachmentPixelFormat = PixelFormats.depthStencil
        
        //VERTEX DESCRIPTOR
        pipelineDescriptor.vertexDescriptor = VertexDescriptors().basic
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
    static func createeDirectionalLightPipelineState(vertexFunctionName: String, fragmentFunctionName: String, colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState
    {
        let vertexFunction = Renderer.library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = Renderer.library?.makeFunction(name: fragmentFunctionName)
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat =  colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDescriptor.stencilAttachmentPixelFormat = PixelFormats.depthStencil
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
    static func createLightMaskPipelieState(vertexFunctionName: String, colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState
    {
        let vertexFunction = Renderer.library?.makeFunction(name: vertexFunctionName)
        let pipelineDscriptor = MTLRenderPipelineDescriptor()
        pipelineDscriptor.vertexFunction = vertexFunction
        pipelineDscriptor.depthAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDscriptor.stencilAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDscriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        
        return createPipelineState(descriptor: pipelineDscriptor)
    }
    
    static func createPointLightPipelineState(vertexFunctionName: String, fragmentFunctionName: String, colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState
    {
        let vertexFunnction = Renderer.library?.makeFunction(name: vertexFunctionName);
        let fragmetFunction = Renderer.library?.makeFunction(name: fragmentFunctionName);
        let pipelineDdescriptor = MTLRenderPipelineDescriptor()
        pipelineDdescriptor.vertexFunction = vertexFunnction;
        pipelineDdescriptor.fragmentFunction = fragmetFunction;
        pipelineDdescriptor.depthAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDdescriptor.stencilAttachmentPixelFormat = PixelFormats.depthStencil
        pipelineDdescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDdescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDdescriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        pipelineDdescriptor.colorAttachments[0].destinationAlphaBlendFactor = .one
        return createPipelineState(descriptor: pipelineDdescriptor)
    }
    
    static func createShadowPipelineState() -> MTLRenderPipelineState{
        let vertexFunction = Renderer.library?.makeFunction(name: "vertex_depth")
          let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .invalid
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float // PixelFormats.gBufferDepth
        pipelineDescriptor.vertexDescriptor = VertexDescriptors().depthOnly
        return createPipelineState(descriptor: pipelineDescriptor)
    }
    
}

    

