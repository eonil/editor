////
////  ActorModelConcurrency.swift
////  EonilCancellableBlockingIO
////
////  Created by Hoon H. on 11/7/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
//
////public class Fiber {
////	private let	_sema	=	Semaphore()
////	private let	_run	=	{ f in return } as (Fiber)->()
////	
////	public init(_ run:(Fiber)->()) {
////		_run	=	run
////	}
////	deinit {
////	}
////	
////	func run() {
////		_run(self)
////	}
////	
//////	func switchTo(continuation:Fiber) {
//////		continuation._sema.signal()
//////		_sema.wait()
//////	}
////	func pause() {
////		_sema.wait()
////	}
////	func resume() {
////		_sema.signal()
////	}
////
////	
////	class func switchTo(f:Fiber) {
////		struct Global {
////			var
////			static var	value	=	nil as Fiber?
////		}
////		Slot.value?.pause()
////		Slot.value	=	f
////		Slot.value?.resume()
////	}
////}
//
//
//public struct Fiber {
//	
//	static func spawn(run:()->()) {
//		background { () -> () in
//			let	e1	=	Execution(run)
//			e1.run()
//		}
//	}
//	
//	///	Current fiber will be selected again if there's only one fiber.
//	static func switchToNext() {
//		Fiber.manager.switchToNext()
//	}
//	
//	private final class Execution {
//		private let	semaphore	=	Semaphore()
//		private let	program		=	{} as ()->()
//		private init(_ program:()->()) {
//			self.program	=	program
//		}
//		private func run() {
//			Fiber.manager.retain(self)
//			program()
//			Fiber.manager.release(self)
//		}
//		private func pause() {
//			semaphore.wait()
//		}
//		private func resume() {
//			semaphore.signal()
//		}
//	}
//	
//	private class Manager {
//		var	current		=	nil as Execution?
//		var	inactives	=	[] as [Execution]
//		
//		func retain(exec:Execution) {
//			inactives.append(exec)
//		}
//		func release(exec:Execution) {
//			assert(inactives.filter({$0 === exec}).count == 1)
//			inactives	=	inactives.filter({$0 !== exec})
//		}
//		func switchToNext() {
//			assert(current != nil)
//			
//			current!.pause()
//			if inactives.count > 0 {
//				inactives.append(current!)
//				current	=	inactives.removeAtIndex(0)
//				current!.resume()
//			}
//		}
//	}
//	
//	private static let	manager	=	Manager()
//	
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
