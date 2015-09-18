//
//  ViewController.swift
//  Symbolicator
//
//  Created by 岩澤 英治 on 2015/09/16.
//  Copyright (c) 2015年 iwazer. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var devPathField: NSTextField!
    @IBOutlet weak var dsymPathField: NSTextField!
    @IBOutlet weak var crashlogPathField: NSTextField!
    
    var symbolicateCrashPath: NSURL?
    var results: [NSMutableData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        devPathField.stringValue = "/Applications/Xcode.app/Contents/Developer"
        symbolicateCrashPath = NSURL(fileURLWithPath: "/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash", isDirectory: false)
        crashlogPathField.stringValue = ""
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func selectDevPath(sender: NSButton) {
        let op = NSOpenPanel()
        op.directoryURL = NSURL(fileURLWithPath: devPathField.stringValue, isDirectory: true)
        op.canChooseDirectories = true
        op.canChooseFiles = false
        op.allowsMultipleSelection = false
        if op.runModal() == NSModalResponseOK && op.URLs.count == 1 {
            if let path = op.URL?.path {
                devPathField.stringValue = path
            }
        }
    }
    
    @IBAction func selectDSymPath(sender: NSButton) {
        let op = NSOpenPanel()
        let initPath = dsymPathField.stringValue.isEmpty ? NSHomeDirectory() : dsymPathField!.stringValue
        op.directoryURL = NSURL(fileURLWithPath: initPath, isDirectory: true)
        op.canChooseDirectories = false
        op.canChooseFiles = true
        op.allowsMultipleSelection = false
        if op.runModal() == NSModalResponseOK && op.URLs.count == 1 {
            if let path = op.URL?.path {
                dsymPathField.stringValue = path
            }
        }
    }

    @IBAction func selectCrashLog(sender: NSButton) {
        let op = NSOpenPanel()
        let initPath = crashlogPathField.stringValue.isEmpty ? NSHomeDirectory() : crashlogPathField!.stringValue
        op.directoryURL = NSURL(fileURLWithPath: initPath, isDirectory: true)
        op.canChooseDirectories = false
        op.canChooseFiles = true
        op.allowsMultipleSelection = false
        if op.runModal() == NSModalResponseOK && op.URLs.count == 1 {
            if let path = op.URL?.path {
                crashlogPathField.stringValue = path
            }
        }
    }

    @IBAction func exec(sender: NSButton) {
        var crashLogPaths: [String] = []
        self.results = []
        if crashlogPathField.stringValue.hasSuffix(".xccrashpoint") {
            let dir = crashlogPathField.stringValue + "/DistributionInfos/all/Logs"
            for file in NSFileManager.defaultManager().enumeratorAtPath(dir)! {
                if let f = file as? String where f.hasSuffix(".crash") {
                    crashLogPaths.append("\(dir)/\(f)")
                }
            }
        } else if crashlogPathField.stringValue.hasSuffix(".crash") {
            crashLogPaths.append(crashlogPathField.stringValue)
        }
        for crashLogPath in crashLogPaths {
            let result = NSMutableData()
            let pipe = NSPipe()
            let file = pipe.fileHandleForReading
            let task = NSTask()
            task.launchPath = "/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash"

            task.arguments = [crashLogPath, dsymPathField.stringValue]
            task.environment = ["DEVELOPER_DIR": devPathField.stringValue]
            task.standardOutput = pipe
            task.standardError = task.standardOutput
            file.waitForDataInBackgroundAndNotify()

            var obs1: NSObjectProtocol!
            obs1 = NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification,  object: file, queue: nil) { notification -> Void in
                let data = file.availableData
                if data.length > 0 {
                    result.appendData(data)
                    file.waitForDataInBackgroundAndNotify()
                } else {
                    NSNotificationCenter.defaultCenter().removeObserver(obs1)
                    self.results.append(result)
                    print(self.results.count)
                    if self.results.count == crashLogPaths.count {
                        self.performSegueWithIdentifier("LogViewSegue", sender: self)
                    }
                }
            }
            var obs2: NSObjectProtocol!
            obs2 = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification, object: task, queue: nil) { notification -> Void in
                NSNotificationCenter.defaultCenter().removeObserver(obs2)

            }
            task.launch()
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogViewSegue" {
            let controller = segue.destinationController as! LogViewController
            controller.data = results
        }
    }

}

