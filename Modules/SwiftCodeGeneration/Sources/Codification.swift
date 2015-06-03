//
//  Codification.swift
//  DataConverterClassGenerator
//
//  Created by Hoon H. on 11/16/14.
//
//

import Foundation





public protocol Codifiable {
	func writeTo<C:CodeWriterType>(inout w:C)
}
public protocol CodeWriterType {
	mutating func writeToken(s:String)
}
