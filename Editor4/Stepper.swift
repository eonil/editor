////
////  Stepper.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/21.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
///// A lightweight-process abstraction with immutable value stream.
///// (practically equal to an actor in actor-model)
/////
///// This is designed mainly to represent sequential processing flow
///// with hidden internal state.
/////
///// A stepper can take messages from any external steppers, and will
///// process them asynchronously.
///// A stepper may send messages to another stepper, but this is 
///// completely hidden, and there's no generalized way to observe this.
/////
///// Every stepper can access driver, and can dispatch any action to 
///// driver. This is just for convenience. Conveptually all the steppers 
///// are treated like they got addres of driver by taking some message 
///// when they boot up.
/////
//protocol StepperType {
//}
//protocol DuplicatableStepperType: StepperType {
//    /// Creates a copy of stepper with current state.
//    func fork() -> Self
//}
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// MARK: -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///// A stepper that runs in main thread (UI thread) and scheduled cooperatively by another user-interaction stepper.
///// This is designed to reduce overhead of main GCD queue.
//final class UserInteractionStepper<State> {
//}
//
///// A stepper that runs in background GCD queue and scheduled by GCD system (platform).
///// All the messages are queued and will be processed in a GCD queue.
///// This is designed
//final class BackgroundProc<State> {
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
//
//
//
