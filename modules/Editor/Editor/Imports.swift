//
//  Imports.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

import EditorCommon

typealias Relay<T>                  =   EditorCommon.Relay<T>

func += <T> (_ a: Relay<T>, _ b: Relay<T>) { EditorCommon.ADHOC_add(a, b) }
func -= <T> (_ a: Relay<T>, _ b: Relay<T>) { EditorCommon.ADHOC_add(a, b) }
func += (_ a: Relay<()>, _ b: ReactiveLoop) { EditorCommon.ADHOC_add(a, b) }
func -= (_ a: Relay<()>, _ b: ReactiveLoop) { EditorCommon.ADHOC_remove(a, b) }

typealias Result<Value,Issue>       =   EditorCommon.Result<Value,Issue>
typealias Series<Snapshot>          =   EditorCommon.Series<Snapshot>
typealias ClippingSeries<Snapshot>  =   EditorCommon.ClippingSeries<Snapshot>
typealias ReactiveLoop              =   EditorCommon.ReactiveLoop
typealias ManualLoop                =   EditorCommon.ManualLoop2

typealias Target                    =   EditorCommon.Target
typealias DebugCommand              =   EditorCommon.DebugCommand
typealias ProcessSnapshot           =   EditorCommon.ProcessSnapshot
typealias StackFrameSnapshot        =   EditorCommon.StackFrameSnapshot

typealias MutableBox<T>             =   EditorCommon.MutableBox<T>

let assertMainThread                =   EditorCommon.assertMainThread

//let MARK_unimplemented              =   EditorCommon.MARK_unimplemented
//func MARK_unimplementedButSkipForNow(_ a: @autoclosure () -> () = (), file n: String = #file, line i: Int = #line, function f: String = #function) {
//    EditorCommon.MARK_unimplementedButSkipForNow(a(), file: n, line: i, function: f)
//}
//
//func DEBUG_log<T>(_ v: T) { EditorCommon.DEBUG_log(v) }
//func REPORT_ignoredSignal<S>(_ s: S) { EditorCommon.REPORT_ignoredSignal(s) }
//
//let REPORT_criticalBug              =   EditorCommon.REPORT_criticalBug
//let REPORT_fatalError               =   EditorCommon.REPORT_fatalError
//let REPORT_missingFeaturesAndContinue   =   EditorCommon.REPORT_missingFeaturesAndContinue
//let REPORT_missingIBOutletViewAndFatalError =   EditorCommon.REPORT_missingIBOutletViewAndFatalError
//let REPORT_unimplementedAndContinue         =   EditorCommon.REPORT_unimplementedAndContinue
//let REPORT_recoverableWarning               =   EditorCommon.REPORT_recoverableWarning
//
//func AUDIT_unwrap<T>(_ v: T?) -> T { return EditorCommon.AUDIT_unwrap(v) }
//func AUDIT_unwrap<T>(_ v: T?, _ s: String) -> T { return EditorCommon.AUDIT_unwrap(v, s) }
//func AUDIT_check(_ c: Bool) { EditorCommon.AUDIT_check(c) }
//func AUDIT_check(_ c: Bool, _ m: String) { EditorCommon.AUDIT_check(c, m) }

@available(*, deprecated: 0)
enum ArrayMutation<T> {
    case insert(Range<Int>)
}
