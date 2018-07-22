//
//  iOSLeafSimulationViewController.swift
//  iOSSpriteKitLeafSimulation
//
//  Created by Jeffrey Morgan on 10/03/2016.
//  Copyright © 2018 Jeffrey Morgan under the MIT License.
//

import UIKit
import SpriteKit

class iOSLeafSimulationViewController: UIViewController {
  
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
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
}
