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

class CollectionTableViewController: UITableViewController {

    
    let SHOPIFY_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
    let collectionModel = CollectionModel()
    
    var arrayCollections : [String] = []
    
    var arrayCollectionIDs : [String] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCollections(url: SHOPIFY_URL)
       
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
        
        return cell
        
    }
    
    //MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.collection_id = arrayCollectionIDs[indexPath.row]
            
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
    
//    func collectionManager(){
//
//        let params : [String : String] = ["title" : title!];
//
//    }

    
    
    
    
    
    

}
