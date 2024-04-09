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
    public let device: MTLDevice
    let commandQueue: MTLCommandQueue
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
    
    //temp
    var rotation = 0
    var mesh: MTKMesh
    
    
    init?(metalKitView: MTKView){
        self.device = metalKitView.device!
        
        guard let cmdQueue = self.device.makeCommandQueue() else {return nil}
        self.commandQueue = cmdQueue
        
        let uniformBufferSize = alignedUniformsSize * maxBuffersInFlight
        
        //Uniforms
        guard let buffer = self.device.makeBuffer(length: uniformBufferSize, options: [MTLResourceOptions.storageModeShared]) else {return nil}
        
        dynamicUniformBuffer = buffer
        self.dynamicUniformBuffer.label = "UniformBuffer"
        uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents()).bindMemory(to: Uniforms.self, capacity:1)
        
        //states pixel
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        metalKitView.colorPixelFormat = .bgra8Unorm_srgb
        metalKitView.sampleCount = 1
        
        //render pipelines
        
        
    }
    
    // TODO: to mesh class
    class func buildMTLVertexDescriptor() -> MTLVertexDescriptor{
        
        var offset: Int = 0
        //позиции (в 0 буфере)
        let mtlVertexDescriptor = MTLVertexDescriptor()
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].format = MTLVertexFormat.float3;
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.position.rawValue].bufferIndex = BufferIndex.meshPositions.rawValue
        
        offset += MemoryLayout<SIMD3<Float>>.stride
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stride = offset
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stepRate = 1
        mtlVertexDescriptor.layouts[BufferIndex.meshPositions.rawValue].stepFunction = MTLVertexStepFunction.perVertex
        
        //MESH GENERICS
        //uv
        offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].format = MTLVertexFormat.float2
        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.texcoord.rawValue].bufferIndex = BufferIndex.meshGenerics.rawValue
        offset += MemoryLayout<SIMD2<Float>>.stride
        
        //test color float3
        mtlVertexDescriptor.attributes[VertexAttribute.color.rawValue].format = MTLVertexFormat.float3
        mtlVertexDescriptor.attributes[VertexAttribute.color.rawValue].offset = offset
        mtlVertexDescriptor.attributes[VertexAttribute.color.rawValue].bufferIndex = BufferIndex.meshGenerics.rawValue
        offset += MemoryLayout<SIMD3<Float>>.stride
        //
       
        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stride = offset
        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stepRate = 1
        mtlVertexDescriptor.layouts[BufferIndex.meshGenerics.rawValue].stepFunction = MTLVertexStepFunction.perVertex
        
        return mtlVertexDescriptor
        
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
