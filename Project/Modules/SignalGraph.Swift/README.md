SignalGraph.Swift
=====================
2015/05/09
Hoon H.




Provides components to build data signal graphs to define data processing pipeline in
a declarative manner.





Deisng Goals
------------
-	Data-consumers care only registration/deregistration, and will automatically 
	takes full data integrity without any extra query on data-source. Implementors
	(you!) just follow single signal protocol, and everything becomes automatically
	integrate.
-	Data-signals can freely be chained without concerning of data-loss.
-	You don't need to worry about memory leak by making cycles. No node keeps
	strong reference to another.
-	Most of disallowed operations are prohibited by type system statically.
	If it's impossible, it will be prohibited by runtime assertions in debug mode.
	


Design Intentions
-----------------
These are my original intention of how to use this library.

-	Basically, signals are state-less. This means emitter does not maintain any
	state for the signal. You will get signals only while you are registered to
	an emitter. Otherwise, signals will be lost.

-	As a kind of specialization, there're also state-ful signals. These are sent
	by a state-ful emitter. State-ful emitter maintains a state, and sends signals
	to synchronize state of sensors with emitter itself. 

-	For that reason, state-ful signals are divided into three kinds.
	
	-	Initiation snapshot.
	-	Transition delta.
	-	Termination snapshot.

	When a sensor registeres itself to an emitter, it will receive an initiation
	snapshot signal. Emitter sends snapshot of its state at once, and sensor can
	perform initial synchronization. And then, mutations of emitter will be sent
	in delta-set form. When sensor deregisters itself from the emitter, emitter
	will send termination snapshot. This is redundant information, but useful to
	validate sensor state, and some sensors require this.

	Also, initiation/termination signals can be sent multiple times in a signaling
	session to reset whole state at once. But still should be sent in order.

-	Emitter does not provide guarantee of specific state. So do not assume emitter
	state will be equal with sensor state when they're receiving signals. Sensors
	must depend only on the signals to reconstruct state. They just guarantees 
	state-full signals to be sent *in order*.

-	But, some specialized emitters can provide such guarantee for your convenience.
	In that case, the class should note that in documentation.

-	Don't forget that just "signal" is state-less, and 

-	Clarity is far more important than shorter code. Small benefit of short code
	will be sacrificed for huge benefit of clarity.

-	If you set it up, you must tear it down yourself.

	If you call `register`, then you must call a paired `deregister`. No exception
	on this rule. This is a policy, but there's also a technical reason. I simply 
	cannot deregister sensors automatically in `deinit` due to early nil-lization 
	of weak references in Swift. Anyway, don't worry too much. This framework will
	check it and fire errors if you forgot deregistration in debug build.

Now let's see how to use these actually.







Getting Started
---------------
(to be filled)






Usage
-----
Usually, front-end applications will be configured like this.

	*	EditableDictionaryStorage				Stores origin data model values.
		->	DictionaryFilteringDictionaryStorage		Filter it.
			->	DictionarySortingArrayStorage		Sort it.
				->	ArraySignalMapStorage		Convert into view model values.







Rules
-----














State-ful Signals
-----------------
State-ful signals presume you're sending signals to represent mutable state, and
representin it by sening multiple immutable states over time. It also presumes 
you cannot access the signal origin, so you cannot get current state of the origin.

With these premises, signals are designed to allow receivers to reconstruct full
state by accumulating them. To make tracking clear and easier, signals are usually 
sent in form of mutation commands rather then state snapshot.

State signals usually have three cases. 

-	Initiation
-	Transition
-	Termination

Please note that signals does not provide timing guarantee. A transition can be
sent asynchronously (after or even before!) from actual transition happens, and 
source state can actually be non-existent. So you shouldn't expect emitter state
to be synchronized with timing of signal transferring, and should reconstruct 
everything only from the information passed within the signal itself.

Transition passes mutation command instead of state snapshot. There're many reasons
of sending mutation command.

-	Some subsystems need mutation *ordering* information to perform processing
	correctly. For example, sometimes end-users want to know which one of 
	deletion or insertion happen first or last precisely. Snapshot of diff-set
	are not approptiate for this purpose.

-	Current view systems are usually state-ful, and works far better with 
	diff-set rather than full state. If I send snapshot, views need to resolve
	diffset themselves. 

-	Because you usually need to transform signals, and passing full state
	snapshot usually means full conversion that is usually inacceptable cost.
	This will affect performance.

If you think there're too many mutations, and sending snapshot is faster, then you
can send pair of termination/initiation signals instead of. Which means resetting 
by snapshot that means semantically same with sening full snapshot state.
So transition signal can be thought as a kind of optimization.








Type Roles and Hierarchy
------------------------

-	*Gate*					--	Defines in/out signal types.
	-	*Emitter*			--	A signal sender.
		-	*Dispatcher*		--	An initial emitter that exposes a method to send signals actually.
	-	*Sensor*			--	A signal receiver
		-	*Monitor*		--	A terminal sensor.

-	*Storage*				--	A read-only state view that emits state mutation signals.
	-	*Replication*			--	A storage that receives mutation signals to reconstruct state.
		-	*Slot*			--	A replication that allows you to edit the value directly.
							And you cannot send signals to this type objects.

See `Protocols.swift` for details. It also serves as a documentation for each concepts.

Emitter/sensor protocols does not define uni/multi-casting/catching behaviors.
But implementations can define specific limitations. 

-	`SignalEmitter`				A multicasting emitter. This can send signals to multiple sensors.
-	`SignalSensor`				A unicatching sensor. This can receive signals from only one emitter.

Storage and replication roles are implemented by these specialized classes.
These implementations require multicasting emitter and unicatching sensor, and using default
implementation of signal emitter and signal sensor.

-	`ValueStorage`				A single value storage.
-	`SetStorage`				A multiple unique value (key) storage.
-	`DictionaryStorage`			A multiple key/value pair storage.
-	`ArrayStorage`				A multiple index/value pair storage. Index is treated as a 
								specialized key.

There are utility classes you will eventually feel need for them.

-	`SignalMap`				Maps a source state-less signals into destination signals.
-	`SignalFilter`				Filters to select a subset of state-less signals.

Also for state-ful signals.

-	`DictionaryFilteringDictionaryStorage`	Provides a filtered subset from a dictionary.
-	`DictionarySortingArrayStorage`		Provides a sorted array from a dictionary.
-	`ArraySignalMap`			Maps all values in array signals into another type.
-	`StateHandler`				Provides simplified predefined state event handling points.























Credits & License
-----------------
This framework is written by Hoon H., and licensed under "MIT License".




