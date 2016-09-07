//
//  PokeCell.swift
//  pokedex
//
//  Created by Farzad Taslimi on 9/5/16.
//  Copyright © 2016 Farzad Taslimi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
    }
    
    func configCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        
        thumbImg.image = UIImage(named: "\(self.pokemon.pokemonId)")
        nameLbl.text = self.pokemon.name
        
    }
    
}
