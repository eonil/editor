//
//  Debugging.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

class Debugging {
	///	Tracks emitter/sensor registration states globally.
	///	
	///	TOOD:	Consider thread safety.
	///
	struct EmitterSensorRegistration {
		static func assertRegistrationOfStatefulChannelingSignaling(p: (emitter: AnyObject, sensor: AnyObject)) {
			assert(Debugging.EmitterSensorRegistration.lookupPairWithSensor(p.sensor) == nil, "Specified sensor `\(p.sensor)` must be a state-ful channeling sensor, so it can be connected to only one emitter at a time.")
			runOnlyInDebugMode {
				recordPair(Pair(emitter: p.emitter, sensor: p.sensor))
			}
		}
		static func assertDeregistrationOfStatefulChannelingSignaling(p: (emitter: AnyObject, sensor: AnyObject)) {
			assert(lookupPairWithSensor(p.sensor) != nil)
			assert(lookupPairWithSensor(p.sensor)!.emitter === p.emitter, "The only registered emitter of the sensor `\(p.sensor)` must be emitter `\(p.emitter)`.")
			runOnlyInDebugMode {

				erasePair(Pair(emitter: p.emitter, sensor: p.sensor))
			}
		}
		
		////
		
		private static func recordPair(pair: Pair) {
			assert(pair.emitter != nil)
			assert(pair.sensor != nil)
			let	oid	=	ObjectIdentifier(pair.sensor!)
			assert(sensorToPair[oid] == nil)
			sensorToPair[oid]	=	pair
		}
		private static func erasePair(pair: Pair) {
			sensorToPair.removeValueForKey(ObjectIdentifier(pair.sensor!))
		}
		private static func lookupPairWithSensor(s: AnyObject) -> Pair? {
			return	sensorToPair[ObjectIdentifier(s)]
		}
		
		////
		
		///	This was intented to be a `struct`, but became `class`
		///	due to work around a compiler bug.
		private final class Pair {
			weak var	emitter	:	AnyObject?
			weak var	sensor	:	AnyObject?
			init(_ pair: (emitter: AnyObject, sensor: AnyObject)) {
				self.emitter	=	pair.emitter
				self.sensor		=	pair.sensor
			}
		}
		
		private static var	sensorToPair	=	[:] as [ObjectIdentifier: Pair]
	}
}

private func runOnlyInDebugMode(@noescape f: ()->()) {
	assert(runAsTrue(f))
}

private func runAsTrue(@noescape f: ()->()) -> Bool {

	f()
	return	true
}



