//
//  CollectionTableViewController.swift
//  ShopifyApp
//
//  Created by newuser on 2019-01-11.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework


class CollectionTableViewController: UITableViewController {

    
    let SHOPIFY_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
    let collectionModel = CollectionModel()
    
    var arrayCollections : [String] = []
    
    var arrayCollectionIDs : [String] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //self.navigationController?.hidesNavigationBarHairline = true
        
        //view.backgroundColor = UIColor.flatGreen()
        
        getCollections(url: SHOPIFY_URL)
       
        tableView.separatorStyle = .none
        
        tableView.layer.cornerRadius = 5;
        
        self.view.backgroundColor = UIColor.init(hexString: "FFA114")
        
        //navigationController?.navigationBar.barTintColor = UIColor.flatOrangeColorDark()
        
        updateNavBar(withHexCode: UIColor.flatOrangeColorDark().hexValue())
        
        print(arrayCollections)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCollections.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        performSegue(withIdentifier: "goToCollections", sender: self)
    
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = arrayCollections[indexPath.row]
        
        cell.layer.cornerRadius = 5.0
        
        cell.layer.masksToBounds = true
        
        cell.textLabel?.font = UIFont(name:"Avenir", size:22)
        
        cell.backgroundColor = UIColor.flatOrange().flatten()
        
        return cell
        
    }
    
    //MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.collection_id = arrayCollectionIDs[indexPath.row]
            destinationVC.collection_name = arrayCollections[indexPath.row]
        }
        
    }
    
    //MARK: - Networking with Alamofire
    
    
    func getCollections(url : String){
        
       
        Alamofire.request(url,method : .get).responseJSON{
            response in
            if(response.result.isSuccess){
                let customJSON : JSON = JSON(response.result.value!)
                self.jsonParse(json: customJSON)
               // print(customJSON)
            }else{
                print("Error")
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func jsonParse(json : JSON){
        
        let counts = json["custom_collections"].count
        //print(counts)
        for count in 0...(counts - 1) {
            collectionModel.title.append(json["custom_collections"][count]["title"].stringValue)
            collectionModel.ids.append(json["custom_collections"][count]["id"].stringValue)
        }
        //print(collectionModel.title)
        
        arrayCollections = collectionModel.title
        
        arrayCollectionIDs = collectionModel.ids
        
        //print(arrayCollectionIDs)
        
        tableView.reloadData()
        
        
    }
    
    //MARK: - NavBar SetUp Methods
    
    func updateNavBar(withHexCode colourHexCode : String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Bar doesnot exist")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode)else { fatalError()}
        
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn:navBarColour, isFlat:true)
        navBar.barTintColor = navBarColour
        //searchBar.barTintColor = navBarColour
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:navBarColour, isFlat:true)]
        
    }
    
    
//    func collectionManager(){
//
//        let params : [String : String] = ["title" : title!];
//
//    }

    
    
    
    
    
    

}
