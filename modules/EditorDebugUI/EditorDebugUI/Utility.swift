//
//  Utility.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

func newListWithReusingNodeForSameDataID<Data: LocallyIdentifiable, Node: DataNode where Node.Data == Data>(oldNodeList: [Node], newDataList: [Data], instantiate: ()->Node) -> [Node] {
	func makeOldIDNodeMapping() -> [Data.ID: Node] {
		var	mappings	=	Dictionary<Data.ID, Node>()
		for node in oldNodeList {
			assert(node.data != nil)
			mappings[node.data!.getID()]	=	node
		}
		return	mappings
	}

	let	oldIDNodeMap	=	makeOldIDNodeMapping()
	var	newNodeList	=	[Node]()
	for data in newDataList {
		let	newID	=	data.getID()
		let	newNode	=	oldIDNodeMap[newID] ?? instantiate()
		newNode.reconfigure(data)
		newNodeList.append(newNode)
	}
	return	newNodeList
}









protocol DataNode: class {
	typealias	Data: LocallyIdentifiable
	var data: Data? { get }
	func reconfigure(data: Data?) 
}






protocol LocallyIdentifiable {
	typealias	ID: Hashable
	func getID() -> ID
}








