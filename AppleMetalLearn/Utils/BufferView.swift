//
//  BufferView.swift
//  AppleMetalLearn
//
//  Created by barkar on 19.04.2024.
//

import MetalKit

struct BufferView<Element>
{
    fileprivate let buffer: MTLBuffer
    private let count: Int
    private var stride: Int{
        MemoryLayout<Element>.stride
    }
    
    //конструтор с нулями и заданным размером
    init(device: MTLDevice, count: Int, label: String? = nil, options: MTLResourceOptions = [])
    {
        guard let buffer = device.makeBuffer(length: MemoryLayout<Element>.stride * count, options: options)
        else{fatalError("Fail create MTLBuffer")
        }
        self.buffer = buffer
        self.buffer.label = label
        self.count = count
    }
    
    //консттрутор с контентом из массива
    init(device: MTLDevice, array: [Element], option: MTLResourceOptions = [])
    {
        guard let buffer = device.makeBuffer(bytes: array, length: MemoryLayout<Element>.stride * array.count, options: .storageModeShared) else
        {
            fatalError("Fail Creeatee MTLBuffer")
        }
        self.buffer = buffer
        self.count = array.count
    }
    
    /// Replaces the buffer's memory at the specified element index with the provided value.
    func assign(_ value: Element, at index: Int = 0) {
        precondition(index <= count - 1, "Index \(index) is greater than maximum allowable index of \(count - 1) for this buffer.")
        withUnsafePointer(to: value) {
            buffer.contents().advanced(by: index * stride).copyMemory(from: $0, byteCount: stride)
        }
    }
    
    /// Replaces the buffer's memory with the values in the array.
    func assign(with array: [Element]) {
        let byteCount = array.count * stride
        precondition(byteCount == buffer.length, "Mismatch between the byte count of the array's contents and the MTLBuffer length.")
        buffer.contents().copyMemory(from: array, byteCount: byteCount)
    }
    
    /// Returns a copy of the value at the specified element index in the buffer.
    subscript(index: Int) -> Element {
        precondition(stride * index <= buffer.length - stride, "This buffer is not large enough to have an element at the index: \(index)")
        return buffer.contents().advanced(by: index * stride).load(as: Element.self)
    }
}

// это расширение здесь из-за приватного MTLBuffer
extension MTLRenderCommandEncoder {
    func setVertexBuffer<T>(_ vertexBuffer: BufferView<T>?, offset: Int, index: Int) {
        setVertexBuffer(vertexBuffer?.buffer, offset: offset, index: index)
    }
    
    func setFragmentBuffer<T>(_ fragmentBuffer: BufferView<T>?, offset: Int, index: Int) {
        setFragmentBuffer(fragmentBuffer?.buffer, offset: offset, index: index)
    }
    
}
