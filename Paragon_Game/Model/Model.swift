

import Foundation

struct Warrior: Equatable {
    var level = 1
    var name: String
    var damage: Int
    var life: Int
    var xPos = 0
    var yPos = 0
}
    
struct Pos: Equatable {
        var x: CGFloat
        var y: CGFloat
    }

struct Achieve: Equatable {
    var on: String
    var off: String
}


class Arrays {
    
    static let achievementsImageArray = [
        Achieve(on: "achieveOn_1", off: "achieveOff_1"),
        Achieve(on: "achieveOn_2", off: "achieveOff_2"),
        Achieve(on: "achieveOn_3", off: "achieveOff_3"),
        Achieve(on: "achieveOn_4", off: "achieveOff_4"),
        Achieve(on: "achieveOn_5", off: "achieveOff_5")
    ]
    
    static var shopWarrior = [
        "yourWarrior_2",
        "yourArcher_2",
        "yourArcher_3"
    ]
    
    static var shopBackgrounds = [
        "shopMap_1",
        "shopMap_2",
        "shopMap_3"
    ]
    
    static var textsArray = ["text_1","text_2","text_3","text_4","text_5","text_6","text_7","text_8"]
    
    static var yourCageCoordinates: [Pos] = [
        Pos(x: -277, y: 20),
        Pos(x: -277, y: 78),
        Pos(x: -277, y: 136),
        
        Pos(x: -178, y: 49),
        Pos(x: -178, y: 107),
        
        Pos(x: -79, y: 20),
        Pos(x: -79, y: 78),
        Pos(x: -79, y: 136)
    ]
    
    static var enemyCageCoordinates: [Pos] = [
        Pos(x: 79, y: 20),
        Pos(x: 79, y: 78),
        Pos(x: 79, y: 136),
        
        Pos(x: 178, y: 49),
        Pos(x: 178, y: 107),
        
        Pos(x: 277, y: 20),
        Pos(x: 277, y: 78),
        Pos(x: 277, y: 136)
    ]
    
    static var yourWarriorsCoordinates: [Pos] = [
        Pos(x: -274, y: -27),  // было -47, стало -27 (+20)
        Pos(x: -274, y: 28),   // было 8, стало 28 (+20)
        Pos(x: -274, y: 87),   // было 67, стало 87 (+20)
        
        Pos(x: -181, y: 3),    // было -17, стало 3 (+20)
        Pos(x: -181, y: 60),   // было 40, стало 60 (+20)
        
        Pos(x: -80, y: -27),   // было -47, стало -27 (+20)
        Pos(x: -80, y: 28),    // было 8, стало 28 (+20)
        Pos(x: -80, y: 87)     // было 67, стало 87 (+20)
    ]
    
    static var enemyWarriorsCoordinates: [Pos] = [
        Pos(x: 82, y: -27),    // было -47, стало -27 (+20)
        Pos(x: 82, y: 28),     // было 8, стало 28 (+20)
        Pos(x: 82, y: 87),     // было 67, стало 87 (+20)
        
        Pos(x: 181, y: 3),     // было -17, стало 3 (+20)
        Pos(x: 181, y: 60),    // было 40, стало 60 (+20)
        
        Pos(x: 280, y: -27),   // было -47, стало -27 (+20)
        Pos(x: 280, y: 28),    // было 8, стало 28 (+20)
        Pos(x: 280, y: 87)     // было 67, стало 87 (+20)
    ]
    
}
