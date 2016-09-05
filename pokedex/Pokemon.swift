//
//  Pokemon.swift
//  pokedex
//
//  Created by Farzad Taslimi on 9/5/16.
//  Copyright © 2016 Farzad Taslimi. All rights reserved.
//

import Foundation
class Pokemon {
    private var _name:String!
    private var _pokedexId:Int!
    
    var name:String {
        return _name
    }
    var pokemonId:Int {
        return _pokedexId
    }
    
    init(name: String, pokemonId:Int) {
        self._name = name
        self._pokedexId = pokemonId
    }
    
    
}
