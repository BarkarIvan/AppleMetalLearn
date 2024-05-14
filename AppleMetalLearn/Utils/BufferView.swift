//
//  File.swift
//  AppleMetalLearn
//
//  Created by barkar on 12.05.2024.
//

import MetalKit

struct BufferView<Element>
{
    //private?
    let buffer: MTLBuffer
    private let count: Int
    
    private var stride: Int{
        MemoryLayout<Element>.stride
    }
    
    //init with zeroes
    
    init(device:MTLDevice, count: Int, label: String? = nil, oprions: MTLResourceOptions = [])
    {
        guard let buffer = device.makeBuffer(length: MemoryLayout<Element>.stride * count, options: oprions)
        else {fatalError("Create buffer fail")}
        
        self.buffer = buffer
        self.buffer.label = label
        self.count = count
    }
    
    //init with array
    init(device: MTLDevice, array: [Element], options: MTLResourceOptions = [])
    {
        guard let buffer = device.makeBuffer(bytes: array, length: MemoryLayout<Element>.stride * array.count, options: .storageModeShared)
        else{fatalError("Create buffer from array fail")}
        self.buffer = buffer
        self.count = array.count
    }
    
    //replace element
    func assign (_ value: Element, at index: Int = 0)
    {
        precondition(index <= count - 1, "Index \(index) is greater than maximum allowable index of \(count - 1) for buffer")
        withUnsafePointer(to: value)
        {
            buffer.contents().advanced(by: index * stride).copyMemory(from: $0, byteCount: stride)
        }
    }
    
    ///replace array
    func assign(with array: [Element])
    {
        let byteCount = array.count * stride
        precondition(byteCount == buffer.length, "Mismatxh between byte count in array and buffer lenght")
        buffer.contents().copyMemory(from: array, byteCount: byteCount)
    }
    
    //return copy of value
    subscript (index: Int) -> Element
    {
        precondition(stride * index <= buffer.length - stride, "index out from array bound")
        return buffer.contents().advanced(by: index * stride).load(as: Element.self)
    }
    
}
