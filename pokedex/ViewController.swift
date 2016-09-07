//
//  ViewController.swift
//  pokedex
//
//  Created by Farzad Taslimi on 9/5/16.
//  Copyright © 2016 Farzad Taslimi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
    var pokemons = [Pokemon]()
    var filterPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var isOnSearchMode = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        search.delegate = self
        search.returnKeyType = .done
        parsePokemonCSV()
        initMusic()
    }
    
    func initMusic() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let musicURL = URL(string: path)
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicURL!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokemonId: id)
                pokemons.append(poke)
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            if isOnSearchMode {
                let poke = filterPokemon[indexPath.row]
                cell.configCell(poke)
                return cell
            } else {
            
            let poke = pokemons[indexPath.row]
            cell.configCell(poke)
            return cell
            }
        }else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke : Pokemon!
        if isOnSearchMode {
            poke = filterPokemon[indexPath.row]
        }else {
            poke = pokemons[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDeatailVC", sender: poke)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDeatailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOnSearchMode {
            return filterPokemon.count
        }
        return pokemons.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isOnSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else {
            isOnSearchMode = true
            let lower = searchBar.text!.lowercased()
            filterPokemon = pokemons.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
    }
    
    @IBAction func musicButton(_ sender: AnyObject) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.setAlpha(0.2)
        }else {
            musicPlayer.play()
            sender.setAlpha(1.0)
        }
    }
    
}

