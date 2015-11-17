//
//  UIStateBox.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/17.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

















protocol DefaultInstantiatableUIStateType: UIStateType {
	init()
}
final class UIStateKey {
}





final class UIStateBox<StateType: DefaultInstantiatableUIStateType> {
	/// Gets an existing or attches a new associated boxed UI-state to specified model object.
	/// Point of this design is killing associated object at death of the host model object.
	static func forModel<ModelType: AnyObject>(model: ModelType, key: UIStateKey) -> UIStateBox<StateType> {
		if let some = objc_getAssociatedObject(model, unsafeAddressOf(key)) {
			if let box = some as? UIStateBox<StateType> {
				return	box
			}
			else {
				fatalError("Something else than `UIStateBox<T>` is associated to model `\(model)` for UI-state key.")
			}
		}
		else {
			let	box	=	UIStateBox(state: StateType(), key: key)
			objc_setAssociatedObject(model, unsafeAddressOf(key), box, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return	box
		}

	}






	///

	var state: StateType {
		get {
			return	_state
		}
		set {
			_state	=	newValue
		}
	}







	///

	private init(state: StateType, key: UIStateKey) {
		_state	=	state
		_key	=	key
	}
	deinit {
		
	}

	private var _state	: StateType
	private var _key	: UIStateKey		//< We need to keep a strong reference to the key to keep its address valid.
}







