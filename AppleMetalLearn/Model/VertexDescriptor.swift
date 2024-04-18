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
        vertexDscriptor.attributes[VertexAttribute.position.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: BufferIndex.meshPositions.rawValue)
        vertexDscriptor.layouts[BufferIndex.meshPositions.rawValue] = MDLVertexBufferLayout(stride: 12)
        
        //generics
        var offset = 0
        //uv
        vertexDscriptor.attributes[VertexAttribute.texcoord.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeTextureCoordinate,
            format: .float2,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 2 * 4
        //normal
        vertexDscriptor.attributes[VertexAttribute.normal.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeNormal,
            format: .half4,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 4 * 2
        //tan
        vertexDscriptor.attributes[VertexAttribute.tangent.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeTangent,
            format: .half4,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 4 * 2
        
        //bitan
        vertexDscriptor.attributes[VertexAttribute.bitangent.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeBitangent,
            format: .half4,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 4 * 2

        vertexDscriptor.attributes[VertexAttribute.color.rawValue] = MDLVertexAttribute(
            name: MDLVertexAttributeColor,
            format: .half4,
            offset: offset,
            bufferIndex: BufferIndex.meshGenerics.rawValue)
        offset += 4 * 2 //4 half * 2 bytes
        
        
        vertexDscriptor.layouts[BufferIndex.meshGenerics.rawValue] = MDLVertexBufferLayout(stride: offset)
        
        return vertexDscriptor
            
    }
}
