print("Hello, world!")

import xcodeproj

let p = try XcodeProj(path: "/Users/Eonil/Temp/a/Sample1/Sample1.xcodeproj")
for o in p.pbxproj.objects {
    print(o)
}

//import Foundation
//import XcodeEdit
//
//let u = URL(fileURLWithPath: "/Users/Eonil/Temp/a/Sample1/Sample1.xcodeproj")
//let p = try XCProjectFile(xcodeprojURL: u)
//
//for a in p.project.mainGroup.children {
//    print(a)
////    p.project.mainGroup.subGroups.append(PBXGroup(reference: <#T##UUID#>, children: <#T##Set<UUID>#>, sourceTree: <#T##PBXSourceTree#>)
////    p.project.mainGroup.subGroups.append(PBXGroup(id: "AAAA", fields: Fields, allObjects: <#T##AllObjects#>)
//}
////for t in p.project.targets {
////    t.name = "Sample2222"
////    print(t)
////}
//
//try p.write(to: u)
