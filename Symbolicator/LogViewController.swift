//
//  LogViewController.swift
//  Symbolicator
//
//  Created by 岩澤 英治 on 2015/09/17.
//  Copyright (c) 2015年 iwazer. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController {
    
    @IBOutlet var logView: NSTextView!

    var data: [NSData]!

    override func viewDidLoad() {
        super.viewDidLoad()

        for d in data {
            if let string = NSString(data: d, encoding: NSUTF8StringEncoding) {
                logView.insertText(">-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=->\n")
                logView.insertText(string)
                logView.insertText("\n<-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-<\n")
            }
        }
    }

}
