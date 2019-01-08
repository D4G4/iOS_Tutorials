import UIKit

protocol Persist {
    func save()
}

class Monster: Persist {
    func save() {
        print("Moster saved")
    }
}

class Sword: Persist {
    func save() {
        print("Sword saved")
    }
}

class Player {

}

let monster = Monster()
let sword = Sword()
let player = Player()

let items: [Persist] = [monster, sword /*, player -> Error*/]

class GameManager {
    func saveLevel(_ items: [Persist]) {
        for item in items {
            item.save() //Only this method is available so far
        }
    }
}

let gameManager = GameManager()
gameManager.saveLevel(items)

