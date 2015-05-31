//
//  SignalGraphMobileTest.swift
//  SignalGraphMobileTest
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import UIKit
import XCTest
import SignalGraphMobile

class SignalGraphMobileTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
	
	
	func testSignalDispatcherAndMonitorSignaling() {
		var	c	=	0
		let	vs	=	[11,23,46,70]
		func handle(s: Int) {
			XCTAssert(s == vs[c])
			c++
		}
		let	d	=	SignalDispatcher<Int>()
		let	m	=	SignalMonitor<Int>(handle)
		d.register(m)
		
		for v in vs {
			d.signal(v)
		}
		XCTAssert(c == vs.count)
		d.deregister(m)
	}
	
	func testSignalDispatcherAndMonitorDeregistration() {
		var	ss	=	[] as [Int]
		func handle(s: Int) {
			ss.append(s)
		}
		let	d	=	SignalDispatcher<Int>()
		let	m	=	SignalMonitor<Int>(handle)
		d.register(m)
		d.signal(111)
		XCTAssert(ss == [111])
		d.deregister(m)
		d.signal(222)
		XCTAssert(ss == [111])
		d.register(m)
		d.signal(333)
		XCTAssert(ss == [111,333])
		d.deregister(m)
	}
	
	func testReplicatingValueStorage() {
		let	v	=	ReplicatingValueStorage<Int>()
		let	d	=	SignalDispatcher<ValueSignal<Int>>()
		d.register(v.sensor)
		d.signal(ValueSignal.Initiation({0}))
		d.signal(ValueSignal.Transition({333}))
		XCTAssert(v.state == 333)
		d.signal(ValueSignal.Transition({888}))
		XCTAssert(v.state == 888)
		d.deregister(v.sensor)
		d.signal(ValueSignal.Transition({444}))
		XCTAssert(v.state == 888)
	}
	
	func testValueSlot() {
		let	s	=	ValueSlot<Int>(111)
		assert(s.state == 111)
		s.state	=	222
		assert(s.state == 222)
		s.state	=	333
		assert(s.state == 333)
	}

	func testEditableSetStorage() {
		let	s	=	EditableSetStorage<Int>()
		s.insert(444)
		assert(Array(s) == [444])
		
		s.insert(888)
		assert(Array(s) == [444, 888])
		
		s.remove(444)
		assert(Array(s) == [888])
		
		s.remove(111)
		//	It's fine trying to remove non-existing value.
		//	Same behavior with Swift `Set` type.
	}
	
	func testArrayEditorAndReplication() {
		let	a	=	ReplicatingArrayStorage<Int>()
		var	e	=	ArrayEditor<Int>(a)

		e.initiate()
		
		XCTAssert(a.state == [])
		e.append(111)
		XCTAssert(a.state == [111])
		e.extend([222, 333, 444])
		XCTAssert(a.state == [111, 222, 333, 444])

		e[1]	=	888
		XCTAssert(a.state == [111, 888, 333, 444])
		
		e.removeAtIndex(2)
		XCTAssert(a.state == [111, 888, 444])
		e.removeAll()
		XCTAssert(a.state == [])
		
		e.terminate()
	}
	
	func testDictionaryEditorAndReplication() {
		let	d	=	ReplicatingDictionaryStorage<Int,String>()
		var	e	=	DictionaryEditor(d)
		
		e.initiate()
		
		XCTAssert(d.state == [:])
		XCTAssert(d.state.count == 0)
		
		e[333]	=	"3rd"
		XCTAssert(d.state == [333: "3rd"])
		XCTAssert(d.state.count == 1)
		
		e.removeValueForKey(333)
		XCTAssert(d.state == [:])
		XCTAssert(d.state.count == 0)
		
		e[555]	=	"5th"
		XCTAssert(d.state == [555: "5th"])
		XCTAssert(d.state.count == 1)
		
		e[666]	=	"6th"
		XCTAssert(d.state == [555: "5th", 666: "6th"])
		XCTAssert(d.state.count == 2)
		
		e.terminate()
	}
	
	func testDictionarySortingArray() {
		func orderOf(e:(Int,String)) -> Int {
			return	e.0
		}
		
		let	dic1	=	ReplicatingDictionaryStorage<Int,String>()
		let	arr2	=	DictionarySortingArrayStorage(orderOf)
		dic1.emitter.register(arr2.sensor)
		
		var	ed1		=	DictionaryEditor(dic1)
		ed1.initiate()
		
		ed1[666]	=	"F"
		ed1[111]	=	"A"
		ed1[333]	=	"C"
		ed1[222]	=	"B"
		ed1[444]	=	"D"
		ed1[555]	=	"E"
		XCTAssert(dic1.state == [111: "A", 222: "B", 333: "C", 444: "D", 555: "E", 666: "F"])
		XCTAssert(arr2.state.map({$0.0}) == [111, 222, 333, 444, 555, 666])
		XCTAssert(arr2.state.map({$0.1}) == ["A", "B", "C", "D", "E", "F"])
		
		ed1[444]	=	"DDD"
		ed1[333]	=	"CCC"
		XCTAssert(dic1.state == [111: "A", 222: "B", 333: "CCC", 444: "DDD", 555: "E", 666: "F"])
		XCTAssert(arr2.state.map({$0.0}) == [111, 222, 333, 444, 555, 666])
		XCTAssert(arr2.state.map({$0.1}) == ["A", "B", "CCC", "DDD", "E", "F"])
		
		ed1.removeValueForKey(444)
		ed1.removeValueForKey(333)
		ed1.removeValueForKey(111)
		XCTAssert(dic1.state == [222: "B", 555: "E", 666: "F"])
		XCTAssert(arr2.state.map({$0.0}) == [222, 555, 666])
		XCTAssert(arr2.state.map({$0.1}) == ["B", "E", "F"])
		
		ed1.terminate()
		dic1.emitter.deregister(arr2.sensor)
	}
	
	func testDictionaryFilteringDictionary() {
		func filter(e: (Int, String)) -> Bool {
			return	e.0 >= 100 && e.0 <= 999
		}
		let	dic1	=	ReplicatingDictionaryStorage<Int,String>()
		let	dic2	=	DictionaryFilteringDictionaryStorage<Int,String>(filter)
		dic1.emitter.register(dic2.sensor)
		
		var	ed1		=	DictionaryEditor(dic1)
		ed1.initiate()
		
		ed1[1]		=	"a"
		ed1[111]	=	"A"
		ed1[3]		=	"c"
		ed1[333]	=	"C"
		ed1[2222]	=	"BBBB"
		XCTAssert(dic1.state == [1: "a", 111: "A", 3: "c", 333: "C", 2222: "BBBB"])
		XCTAssert(dic2.state == [111: "A", 333: "C"])
		
		ed1[1]		=	"aaa"
		ed1[333]	=	"CCC"
		XCTAssert(dic1.state == [1: "aaa", 111: "A", 3: "c", 333: "CCC", 2222: "BBBB"])
		XCTAssert(dic2.state == [111: "A", 333: "CCC"])
		
		ed1.removeValueForKey(2222)
		ed1.removeValueForKey(333)
		ed1.removeValueForKey(1)
		XCTAssert(dic1.state == [111: "A", 3: "c"])
		XCTAssert(dic2.state == [111: "A"])
		
		ed1.terminate()
		dic1.emitter.deregister(dic2.sensor)
	}
	
	func testTerminationSignal() {
		var	ok1	=	false
		let	s2	=	SignalMonitor<ValueSignal<Int>>()
		let	t1	=	{ ()->() in
			let	s1	=	ValueSlot<Int>(111)
			s1.state	=	333
			s1.emitter.register(s2)
			s2.handler	=	{ s in
				switch s {
				case .Termination(let s):
					XCTAssert(s() == 333)
					ok1	=	true
				default:
					XCTAssert(false)
				}
			}
			s1.emitter.deregister(s2)
			()
		}
		t1()
		assert(ok1)
	}
	func testSignalSequence1() {
		var	ss	=	[
			.Initiation,
			.Termination,
			] as [ChannelingSignalKind]
		let	s2	=	SignalMonitor<ValueSignal<Int>>()
		s2.handler	=	{ s in
			let	s1	=	ss.first!
			XCTAssert(s1 == s._kind)
			ss.removeAtIndex(0)
		}
		let	t1	=	{ ()->() in
			let	s1	=	ValueSlot<Int>(111)
			s1.state	=	333
			s1.emitter.register(s2)
			s1.emitter.deregister(s2)
			()
		}
		t1()
	}
}















private enum ChannelingSignalKind {
	case Initiation
	case Transition
	case Termination
}

private protocol _KindProvision {
	var _kind: ChannelingSignalKind { get }
}
extension ArraySignal: _KindProvision {
	private var _kind: ChannelingSignalKind {
		get {
			switch self {
			case .Initiation(_):	return	.Initiation
			case .Transition(_):	return	.Transition
			case .Termination(_):	return	.Termination
			}
		}
	}
}
extension DictionarySignal: _KindProvision {
	private var _kind: ChannelingSignalKind {
		get {
			switch self {
			case .Initiation(_):	return	.Initiation
			case .Transition(_):	return	.Transition
			case .Termination(_):	return	.Termination
			}
		}
	}
}
extension SetSignal: _KindProvision {
	private var _kind: ChannelingSignalKind {
		get {
			switch self {
			case .Initiation(_):	return	.Initiation
			case .Transition(_):	return	.Transition
			case .Termination(_):	return	.Termination
			}
		}
	}
}
extension ValueSignal: _KindProvision {
	private var _kind: ChannelingSignalKind {
		get {
			switch self {
			case .Initiation(_):	return	.Initiation
			case .Transition(_):	return	.Transition
			case .Termination(_):	return	.Termination
			}
		}
	}
}
















