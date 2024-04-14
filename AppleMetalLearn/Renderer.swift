//
//  Renderer.swift
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

import Metal
import MetalKit
import simd

// выравнивание в 64 байт
let alignedUniformsSize = (MemoryLayout<Uniforms>.size + 0x3F) & -0x40

let maxBuffersInFlight = 3


class Renderer: NSObject, MTKViewDelegate{
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var dynamicUniformBuffer: MTLBuffer
    var opaquePipeLineState: MTLRenderPipelineState
    var depthState: MTLDepthStencilState
    var colorMap: MTLTexture
    
    //unoforms
    let inFlightSemaphore = DispatchSemaphore(value: maxBuffersInFlight)
    var uniformBufferOffset = 0
    var uniformBufferIndex = 0
    var uniforms: UnsafeMutablePointer<Uniforms>
    
    var projectionMatrix: matrix_float4x4 = matrix_float4x4()
    
    var shdowCamera = OrthographicCamera()
    
    
    
    init?(metalKitView: MTKView){
        let device = metalKitView.device
        
        guard
            let commandQueue = device?.makeCommandQueue() else {return nil}
        
        let uniformBufferSize = alignedUniformsSize * maxBuffersInFlight
        
        //Uniforms
        guard let buffer = device?.makeBuffer(length: uniformBufferSize, options: [MTLResourceOptions.storageModeShared]) else {return nil}
        
        dynamicUniformBuffer = buffer
        self.dynamicUniformBuffer.label = "UniformBuffer"
        uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents()).bindMemory(to: Uniforms.self, capacity:1)
        
        //states pixel
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        metalKitView.colorPixelFormat = .bgra8Unorm_srgb
        metalKitView.sampleCount = 1
        
        //render pipelines
        
        
    }
    
    func updateGameState(scene: GameScene){
        uniforms[0].projectionMatrix = scene.camera.projectionMatrix
        uniforms[0].viewMatrix = scene.camera.viewMatrix
        
    }
    
    class func buildRenderPipelineWithDevice(device: MTLDevice,
                                             metalKitView: MTKView,
                                             mtlVertexDescriptor: MTLVertexDescriptor) throws -> MTLRenderPipelineState{
        
        let library = device.makeDefaultLibrary()
        let vertexFuction = library?.makeFunction(name: "vertexDefaultShader")
        let fragmentFunctionn = library?.makeFunction(name: "fragmentGBuffer")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = "RendrPipeline"
        pipelineDescriptor.vertexFunction = vertexFuction
        pipelineDescriptor.fragmentFunction = fragmentFunctionn
        pipelineDescriptor.vertexDescriptor = mtlVertexDescriptor
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        pipelineDescriptor.stencilAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
    }
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        <#code#>
    }
    
    func draw(in view: MTKView) {
        <#code#>
    }
    
    
}
