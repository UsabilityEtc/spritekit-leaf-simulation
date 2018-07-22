//
//  macOSLeafSimulationViewController.swift
//  macOSSpriteKitLeafSimulation
//
//  Created by Jeffrey Morgan on 21/07/2018.
//  Copyright © 2018 Jeffrey Morgan. All rights reserved.
//

import Cocoa
import SpriteKit

class macOSLeafSimulationViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureScene()
  }
  
  private func configureScene() {
    guard let skView = self.view as? SKView,
          let scene = LeafSimulationScene(fileNamed: "LeafSimulationScene") else { return }
    scene.scaleMode = .aspectFill
    scene.size = skView.bounds.size

    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.presentScene(scene)
  }
  
}
