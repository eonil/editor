//
//  AppDelegate.swift
//  ManualViewTestdrive
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa
import ManualView

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    private let vc1 = VC1()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //        window.setContentSize(NSSize(width: 400, height: 400))
        vc1.view.wantsLayer = true
        window.contentViewController = vc1
    }
}

class V3: ManualView {
    let vv = V3A()
    override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(vv)
        vv.layer = CALayer(backgroundColor: NSColor.white.withAlphaComponent(0.2).cgColor)
    }
    override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        vv.frame = bounds
        vv.frame.origin.x += 10
        vv.frame.origin.y += 10
        vv.frame.size.width -= 20
        vv.frame.size.height -= 20
    }
}
class V3A: ManualView {
    let vv = V3B()
    override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(vv)
        vv.layer = CALayer(backgroundColor: NSColor.white.withAlphaComponent(0.2).cgColor)
    }
    override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
//        vv.frame = bounds
//        vv.frame.origin.x += 10
//        vv.frame.origin.y += 10
//        vv.frame.size.width -= 20
//        vv.frame.size.height -= 20
        vv.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
    }
}
class V3B: ManualView {
    let vv = V3C()
    override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(vv)
        vv.layer = CALayer(backgroundColor: NSColor.white.withAlphaComponent(0.2).cgColor)
    }
    override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        vv.frame = bounds
        vv.frame.origin.x += 10
        vv.frame.origin.y += 10
        vv.frame.size.width -= 20
        vv.frame.size.height -= 20
    }
}
class V3C: ManualView {
    let vv = ManualLabel()
    override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(vv)
        vv.reload(NSAttributedString(string: "SSSSS"))
        vv.layer = CALayer(backgroundColor: NSColor.white.withAlphaComponent(0.2).cgColor)
    }
    override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        vv.frame = bounds
        vv.frame.origin.x += 10
        vv.frame.origin.y += 10
        vv.frame.size.width -= 20
        vv.frame.size.height -= 20
    }
}


class VC1: NSViewController {
    let v1 = ManualView()
    let v2 = ManualStackView()
    let v3 = V3()
    let v4 = ManualLabel()
    let v5 = ManualTextField()
    override func loadView() {
        view = NSView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.autoresizingMask = [.viewHeightSizable, .viewWidthSizable, .viewMaxXMargin, .viewMaxYMargin, .viewMinXMargin, .viewMinYMargin]
        view.addSubview(v1)
        v1.addSubview(v2)
        v2.reload(ManualStackViewState(axis: ManualAxis.x,
                                       segments: [
                                        ManualStackViewSegment(filling: v3),
                                        ManualStackViewSegment(fitting: v4, alignment: .center),
                                        ManualStackViewSegment(view: v5, filling: 1),
                                        ]).spaced(10))
        v4.reload(NSAttributedString(string: "AAAA"))
        v5.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        v1.layer = CALayer(backgroundColor: NSColor.red.cgColor)
        v2.layer = CALayer(backgroundColor: NSColor.green.cgColor)
        v3.layer = CALayer(backgroundColor: NSColor.blue.cgColor)
        v4.layer = CALayer(backgroundColor: NSColor.white.cgColor)
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        v1.frame = view.bounds
        v2.frame = v1.bounds
    }
}
class V1: ManualView {
    //    override func manual_layoutSubviews() {
    //        super.manual_layoutSubviews()
    //        Swift.print(frame)
    //    }
}

extension CALayer {
    convenience init(backgroundColor: CGColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}
