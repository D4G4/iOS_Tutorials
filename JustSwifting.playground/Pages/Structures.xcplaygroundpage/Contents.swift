typealias Miles = Double

struct Location {
    let x: Miles
    let y: Miles
    
    func getDistance(destination: Location) -> Double {
        return abs(x - destination.x) + abs(y - destination.y)
    }
}

let distance = Location(x: 2, y: 3).getDistance(destination: Location(x: 5.2, y: 4))

struct Restaurant {
    let location: Location
    var deliveryDistance: Miles
    
    func willDeliver(to location: Location) -> Bool {
        return self.location.getDistance(destination: location) <= deliveryDistance
    }
}

let restaurants = [
    Restaurant(location: Location(x: 0, y: 0), deliveryDistance: 3),
    Restaurant(location: Location(x: 5, y: 5), deliveryDistance: 2)
]

restaurants[0].willDeliver(to: Location(x: 1, y: 2))



extension Location {
    //Computed Property
    var canGetPizzaDelivery: Bool {
        print("CanGetPizzaDelivery at \(self.x) , \(self.y)")
        return restaurants.contains { restaurant in
            let result: Bool = restaurant.willDeliver(to: self)
            print("Iteration \(restaurant.deliveryDistance) \(result)")
            return result
        }
    }
}

Location(x: 3, y: 0).canGetPizzaDelivery
Location(x: 5, y: 3).canGetPizzaDelivery
Location(x: 2, y: 2).canGetPizzaDelivery

var restaurant = Restaurant(location: Location(x: 2, y: 3), deliveryDistance: 4)
var copyRestaurant = restaurant

restaurant.deliveryDistance = 5
copyRestaurant
//Thus Structures are not Reference types
