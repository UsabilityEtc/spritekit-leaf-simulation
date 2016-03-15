//
//  AppDelegate.swift
//  OSXSpriteKitLeafSimulation
//
//  Created by Jeffrey Morgan on 10/03/2016.
//  Copyright © 2016 Jeffrey Morgan under the MIT License.
//

import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var skView: SKView!
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    sizeAndCentreWindow()
    configureScene()
  }
  
  private func sizeAndCentreWindow() {
    let screenSize = NSScreen.mainScreen()?.frame.size
    let appSize = NSSize(width: screenSize!.width * 0.75, height: screenSize!.height * 0.75)
    let appOrigin = NSPoint(x: (screenSize!.width - appSize.width) / 2, y: (screenSize!.height - appSize.height) / 2)
    window?.setFrame(NSRect(origin: appOrigin, size: appSize), display: true)
  }
  
  private func configureScene() {
    /* Pick a size for the scene */
    if let scene = LeafSimulationScene(fileNamed:"LeafSimulationScene") {
      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .AspectFill
      
      /* Sprite Kit applies additional optimizations to improve rendering performance */
      self.skView!.ignoresSiblingOrder = true
      
      self.skView!.showsFPS = true
      self.skView!.showsNodeCount = true
      
      // Make the scene the same size as the scene's SKView
      scene.size = skView.bounds.size
      
      self.skView!.presentScene(scene)
    }
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
    return true
  }
  
}
