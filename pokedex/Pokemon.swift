//
//  Pokemon.swift
//  pokedex
//
//  Created by Farzad Taslimi on 9/5/16.
//  Copyright © 2016 Farzad Taslimi. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name:String!
    private var _pokedexId:Int!
    private var _description: String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt:String!
    private var _pokemonURL:String!
    private var _nextEvoId:String!
    private var _nextEvoName:String!
    private var _nextEvoLevel:String!
    
    var nextEvoId:String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoName:String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoLevel:String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var description:String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type:String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    
    var defense:String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height:String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight:String {
        if _weight == nil   {
            _weight = ""
        }
        return _weight
    }
    
    var attack:String {
        if  _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutiontxt:String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    
    
    var name:String {
        return _name
    }
    var pokemonId:Int {
        return _pokedexId
    }
    
    init(name: String, pokemonId:Int) {
        self._name = name
        self._pokedexId = pokemonId
        self._pokemonURL = "\(BASE_URL)\(POKEMONE_URL)\(self._pokedexId!)/"
    }
    
    
    func downloadApi (completed: completeDownload) {
        
    Alamofire.request(self._pokemonURL, method: .get, parameters: nil, encoding:.json, headers: nil).responseJSON { (response) in
        let resualt = response.result
        if let dict = resualt.value as? Dictionary<String, AnyObject>{
            if let weight = dict["weight"] as? String {
                self._weight = weight
            }
            if let height = dict["height"] as? String {
                self._height = height
            }
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            print(self._weight)
            print(self._height)
            print(self._attack)
            print(self._defense)
            print(self._pokemonURL)
            
            if let types = dict["types"] as? [Dictionary<String,AnyObject>] , types.count > 0{
                if let name = types[0]["name"] as? String {
                    self._type = name.capitalized
                }
                if types.count > 1 {
                    
                    for x in 1..<types.count {
                        if let name = types[x]["name"] as? String {
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                }
                print(self._type)
                
            }else {
                self._type = ""
            }
         
            if let descriptionDict = dict["descriptions"] as? [Dictionary<String,String>] , descriptionDict.count > 0 {
                if let url = descriptionDict[0]["resource_uri"] {
                    let descURL = "\(BASE_URL)\(url)"
                    Alamofire.request(descURL, method: .get, parameters: nil, encoding: .json, headers: nil).responseJSON(completionHandler: { (response) in
                        let result = response.result
                        if let descDict = result.value as? Dictionary<String, AnyObject> {
                            if let descripion = descDict["description"] as? String {
                                let newDescription = descripion.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                
                                self._description = newDescription
                                print(newDescription)
                            }
                        }
                        completed()
                    })
                    
                }
            }else {
                self._description = ""
            }
            
            if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0 {
                if let nextEvo = evolutions[0]["to"] as? String {
                    if nextEvo.range(of: "mega") == nil {
                        self._nextEvoName = nextEvo
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            let newstr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let newEvoId = newstr.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvoId = newEvoId
                            if let lvlExist = evolutions[0]["level"] {
                                if let lvl = lvlExist as? Int {
                                    self._nextEvoLevel = "\(lvl)"
                                }
                            }else {
                                self._nextEvoLevel = ""
                            }
                        }
                    }
                }
            }
            
            
        }
        completed()
        }
        
    }
    
}
