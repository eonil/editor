//
//  XML.Test.swift
//  RFC Formaliser
//
//  Created by Hoon H. on 10/28/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

extension XML {
	struct Test {
		static func run() {
			func test (_ name:String = "(unnamed)", test:()->()) {
				test()
			}
			
			test("simple1", { () -> () in
				
				let	s1	=	"<a><b><c>DDD</c></b></a>"
				let	d2	=	(s1 as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let	x1	=	XML.scan(d2, configurations: XML.Configurations())
				
				assert(x1 != nil)
				assert(x1!.subnodes.count == 1)
				assert(x1!.subnodes[0] is XML.Element)
				assert((x1!.subnodes[0] as XML.Element).name == "a")
				assert((x1!.subnodes[0] as XML.Element).subnodes.count == 1)
				assert(((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).name == "b")
				println(((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes.count)
				println(((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes)
				assert(((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes.count == 1)
				assert((((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes[0] as XML.Element).name == "c")
				assert((((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes.count == 1)
				assert(((((x1!.subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes[0] as XML.Element).subnodes[0] as XML.Text).characters == "DDD")
				println(x1)
			})
			
			test("small1", { () -> () in
				
				let	d2	=	(exampleData1 as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let	x1	=	XML.scan(d2, configurations: XML.Configurations())
				
				assert(x1 != nil)
				assert(x1!.subnodes.count == 1)
				assert(x1!.subnodes[0] is XML.Element)
				assert((x1!.subnodes[0] as XML.Element).name == "rfc-index")
				println((x1!.subnodes[0] as XML.Element).subnodes.count)
				println((x1!.subnodes[0] as XML.Element).subnodes)
				assert((x1!.subnodes[0] as XML.Element).subnodes.count == 3)
				assert(((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).name == "bcp-entry")
				println(((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes.count)
				println(((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes)
				assert(((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes.count == 3)
				assert((((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes[1] as XML.Element).name == "doc-id")
				assert((((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes[1] as XML.Element).subnodes.count == 1)
				assert(((((x1!.subnodes[0] as XML.Element).subnodes[1] as XML.Element).subnodes[1] as XML.Element).subnodes[0] as XML.Text).characters == "BCP0001")
				println(x1)
			})
		}
	}
}












private let exampleData1	=	"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<rfc-index xmlns=\"http://www.rfc-editor.org/rfc-index\" \r\n           xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n           xsi:schemaLocation=\"http://www.rfc-editor.org/rfc-index \r\n                               http://www.rfc-editor.org/rfc-index.xsd\">\r\n    <bcp-entry>\r\n        <doc-id>BCP0001</doc-id>\r\n    </bcp-entry>\r\n</rfc-index>"
private let	exampleData2	=	"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<rfc-index xmlns=\"http://www.rfc-editor.org/rfc-index\" \r\n           xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \r\n           xsi:schemaLocation=\"http://www.rfc-editor.org/rfc-index \r\n                               http://www.rfc-editor.org/rfc-index.xsd\">\r\n    <bcp-entry>\r\n        <doc-id>BCP0001</doc-id>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0002</doc-id>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0003</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC1915</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0004</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC1917</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0005</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC1918</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0006</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC1930</doc-id>\r\n            <doc-id>RFC6996</doc-id>\r\n            <doc-id>RFC7300</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0007</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC2008</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0008</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC2014</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0009</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC2026</doc-id>\r\n            <doc-id>RFC5657</doc-id>\r\n            <doc-id>RFC6410</doc-id>\r\n            <doc-id>RFC7100</doc-id>\r\n            <doc-id>RFC7127</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n    <bcp-entry>\r\n        <doc-id>BCP0010</doc-id>\r\n        <is-also>\r\n            <doc-id>RFC3777</doc-id>\r\n            <doc-id>RFC5633</doc-id>\r\n            <doc-id>RFC5680</doc-id>\r\n            <doc-id>RFC6859</doc-id>\r\n        </is-also>\r\n    </bcp-entry>\r\n</rfc-index>"
