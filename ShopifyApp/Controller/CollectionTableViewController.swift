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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        getCollections(url: SHOPIFY_URL)
        //print(collectionModel.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionModel.title.count;
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func getCollections(url : String){
        
       
        Alamofire.request(url,method : .get).responseJSON{
            response in
            if(response.result.isSuccess){
                let customJSON : JSON = JSON(response.result.value!)
                self.jsonParse(json: customJSON)
                //print(customJSON)
            }else{
                print("Error")
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func jsonParse(json : JSON){
        
        let counts = json["custom_collections"].count
        print(counts)
        for count in 0...counts {
            collectionModel.title.append(json["custom_collections"][count]["title"].stringValue)
            
        }
        print(collectionModel.title)
        
        
    }
    
//    func collectionManager(){
//
//        let params : [String : String] = ["title" : title!];
//
//    }

    
    
    
    
    
    

}
