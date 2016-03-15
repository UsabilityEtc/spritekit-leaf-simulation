//
//  LeafSimulationScene.swift
//  SpriteKitLeafSimulation
//
//  Created by Jeffrey Morgan on 10/03/2016.
//  Copyright © 2016 Jeffrey Morgan under the MIT License.
//

import SpriteKit

enum WindDirection: CGFloat {
  case Easterly = -1.0
  case Westerly =  1.0
}

struct CollisionCategory {
  static let WorldEdge = UInt32(1)
  static let Leaf      = UInt32(2)
}

class LeafSimulationScene: SKScene {
  
  private var rockLeafAction: SKAction!
  private let numberOfLeaves = 100
  private let delayBetweenLeaves = 0.5

  override func didMoveToView(view: SKView) {
    createRockLeafAction()
    addWorldEdges()
    addLeaves()
  }
  
  /** Rotate each leaf from -45 degrees to 45 degrees to rock it back and forth on its way down */
  private func createRockLeafAction() {
    let rotateClockwiseAction = SKAction.rotateByAngle(CGFloat(M_PI_4 / 2), duration: 1)
    let rotateCounterClockwiseAction = rotateClockwiseAction.reversedAction()
    let fullRockAction = SKAction.sequence([rotateClockwiseAction, rotateCounterClockwiseAction, rotateCounterClockwiseAction, rotateClockwiseAction])
    rockLeafAction = SKAction.repeatActionForever(fullRockAction)
  }
  
  private func addWorldEdges() {
    physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
    physicsBody?.categoryBitMask = CollisionCategory.WorldEdge
  }
  
  private func addLeaves() {
    let spawnLeafAction = SKAction.runBlock {
      self.spawnLeaf()
    }
    let waitAction = SKAction.waitForDuration(delayBetweenLeaves)
    let addLeafAction = SKAction.sequence([spawnLeafAction, waitAction])
    runAction(SKAction.repeatAction(addLeafAction, count: numberOfLeaves))
  }
  
  private func spawnLeaf() {
    let leaf = createLeafNode()
    leaf.zRotation = CGFloat(M_PI_2) // Rotate the leaf by 90 degrees to make it horizont
    leaf.position = CGPoint(x: randomX(), y: size.height - leaf.size.height)
    leaf.physicsBody = SKPhysicsBody(polygonFromPath: leafPhysicsBodyPath(leaf))
    leaf.physicsBody?.categoryBitMask = CollisionCategory.Leaf
    leaf.physicsBody?.collisionBitMask = CollisionCategory.WorldEdge
    leaf.physicsBody?.restitution = 0.05
    leaf.runAction(rockLeafAction)
    addChild(leaf)
  }
  
  private func randomX() -> CGFloat {
    return randomFloat() * size.width
  }
  
  /** Return a random CGFloat between 0 and 1 */
  private func randomFloat() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
  }
  
  private func createLeafNode() -> SKSpriteNode {
    let leafSize = chooseLeafSize()
    let leafColor = chooseLeafColor()
    let leafFilename = "\(leafSize)\(leafColor)Leaf"
    let leaf = SKSpriteNode(imageNamed: leafFilename)
    leaf.name = leafSize
    return leaf
  }
  
  /** Choose the size part of the leaf PNG image filename */
  private func chooseLeafSize() -> String {
    if coinTossIsHeads() {
      return "Large"
    } else {
      return "Small"
    }
  }

  private func coinTossIsHeads() -> Bool {
    print(randomInt(1))
    return randomInt(1) == 0
  }
  
  /** Return a random Int between 0 and n */
  private func randomInt(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n + 1)))
  }
  
  /** Choose the color part of the leaf PNG image filename */
  private func chooseLeafColor() -> String {
    if coinTossIsHeads() {
      return "Dark"
    } else {
      return "Light"
    }
  }

  /** A diamond path works well as the physics body for each leaf */
  private func leafPhysicsBodyPath(leafNode: SKSpriteNode) -> CGPathRef {
    let diamondPath = CGPathCreateMutable()
    CGPathMoveToPoint(diamondPath, nil, -leafNode.size.width / 2, 0)
    CGPathAddLineToPoint(diamondPath, nil, 0, leafNode.size.height / 2)
    CGPathAddLineToPoint(diamondPath, nil, leafNode.size.width / 2, 0)
    CGPathAddLineToPoint(diamondPath, nil, 0, -leafNode.size.height / 2)
    CGPathAddLineToPoint(diamondPath, nil, -leafNode.size.width / 2, 0)
    return diamondPath
  }
  
  override func update(currentTime: NSTimeInterval) {
    applySlowingImpulse()
    applyWindImpulse()
  }
  
  /** Apply an upwards impulse to each leaf to slow its fall */
  private func applySlowingImpulse() {
    for node in children {
      let slowingImpulseVector = CGVector(dx: 0, dy: slowingMagnitude(node))
      node.physicsBody?.applyImpulse(slowingImpulseVector)
    }
  }
  
  /** Choose the size of the upwards impulse based on the size of the leaf */
  private func slowingMagnitude(leafNode: SKNode) -> CGFloat {
    if leafNode.name == "Large" {
      return 1.75
    } else {
      return 1.0
    }
  }
  
  private func applyWindImpulse() {
    guard shouldApplyWindImpulse() else { return }
    let windForceMagnitude: CGFloat = 1.0
    let windForce = CGVector(dx: randomWindDirection().rawValue * windForceMagnitude, dy: 0)
    for node in children {
      node.physicsBody?.applyImpulse(windForce)
    }
  }
  
  /** Apply a wind impulse roughly a third of the time */
  private func shouldApplyWindImpulse() -> Bool {
    return randomInt(100) < 33
  }
  
  private func randomWindDirection() -> WindDirection {
    if coinTossIsHeads() {
      return .Easterly
    } else {
      return .Westerly
    }
  }

}
