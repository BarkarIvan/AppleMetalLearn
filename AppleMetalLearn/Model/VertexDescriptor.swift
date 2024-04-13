//
//  VertexDescriptor.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

import MetalKit

extension MTLVertexDescriptor{
    static var defaultLayout: MTLVertexDescriptor?{
        MTKMetalVertexDescriptorFromModelIO(.defaultLayout)
    }
}

extension MDLVertexDescriptor {
    static var defaultLayout: MDLVertexDescriptor{
        let vertexDscriptor = MDLVertexDescriptor()
        
        //pos
        var offset = 0
        vertexDscriptor.attributes[VertexAttribute.position.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: offset,
            bufferIndex: BufferIndex.meshPositions.rawValue)
        offset += MemoryLayout<SIMD3<Float>>.stride
        vertexDscriptor.layouts[BufferIndex.meshPositions.rawValue] = MDLVertexBufferLayout(stride: offset)
        
        //generics
        offset = 0
        //uv
        vertexDscriptor.attributes[VertexAttribute.texcoord.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeTextureCoordinate,
            format: .float2,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += MemoryLayout<SIMD2<Float>>.stride
        //normal
        vertexDscriptor.attributes[VertexAttribute.normal.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeNormal,
            format: .float3,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += MemoryLayout<SIMD3<Float>>.stride
        //tan
        vertexDscriptor.attributes[VertexAttribute.tangent.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeTangent,
            format: .float3,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += MemoryLayout<SIMD3<Float>>.stride
        //bitan
        vertexDscriptor.attributes[VertexAttribute.bitangent.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeBitangent,
            format: .float3,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        //color
        //TODO: test stride and format
        vertexDscriptor.attributes[VertexAttribute.color.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeColor,
            format: .half4,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 8 //4 half * 2 bytes
        vertexDscriptor.layouts[BufferIndex.meshGenerics.rawValue] = MDLVertexBufferLayout(stride: offset)
        
        return vertexDscriptor
            
    }
}
