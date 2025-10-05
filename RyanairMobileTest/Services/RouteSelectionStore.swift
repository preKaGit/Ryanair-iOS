//
//  RouteSelectionService.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import Foundation


final class UserDefaultsRouteSelectionStore {
    static let shared = UserDefaultsRouteSelectionStore()
    
    private let defaults: UserDefaults
    
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    private enum Keys {
        static let station = "route.station"
    }
    
    var originAirport: Station? {
        get {
            guard let data = defaults.data(forKey: Keys.station) else { return nil }
            return try? JSONDecoder().decode(Station.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                defaults.set(data, forKey: Keys.station)
            } else {
                defaults.removeObject(forKey: Keys.station)
            }
        }
    }
}
