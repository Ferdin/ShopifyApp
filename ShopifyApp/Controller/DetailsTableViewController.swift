//
//  DetailsTableViewController.swift
//  ShopifyApp
//
//  Created by newuser on 2019-01-11.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class DetailsTableViewController: UITableViewController {

    var collection_id = String()
    var productIDArray = [String]()
    var productTitleArray = [String]()
    
    var productID = String()
    var productTitles = String()
    let collectionModel = CollectionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCollections(collectionID: collection_id)
        //getProductNames()
    }

    override func viewDidAppear(_ animated: Bool) {
        getProductNames()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCells", for: indexPath)
        
        cell.textLabel?.text = productTitleArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productTitleArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //productID = productIDArray[indexPath.row]
        
    }
    
    //MARK: - Networking Methods
    
    func getCollections(collectionID : String){
        
        Alamofire.request("https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collection_id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6",method : .get).responseJSON { response in
            if(response.result.isSuccess){
                let customJSON : JSON = JSON(response.result.value!)
                self.parseJSONCollection(json: customJSON)
                //print(customJSON)
            }else{
                print("Error")
            }
        }
        
        
        //getProductNames()
    }
    
    func getProductNames(){
       
            Alamofire.request("https://shopicruit.myshopify.com/admin/products.json?ids=\(productID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6",method : .get).responseJSON { response in
                if(response.result.isSuccess){
                    let customJSON : JSON = JSON(response.result.value!)
                    self.parseJSONProducts(json: customJSON)
                    //print(customJSON)
                }else{
                    print("Error")
                }
            
        }
        
    }
    
    //MARK: - JSON Parsing Methods
    
    
    func parseJSONCollection(json : JSON){
        
        let count = json["collects"].count
        
        for count in 0...(count - 1) {
            collectionModel.productIDs.append(json["collects"][count]["product_id"].stringValue)
        }
        
        productIDArray = collectionModel.productIDs
        
        productID = productIDArray.joined(separator: ",")
       
        print(productID)
        
        tableView.reloadData()
    }
    
    func parseJSONProducts(json : JSON){
        
        let count = json["products"].count

        for count in 0...(count - 1){
            collectionModel.productTitle.append(json["products"][count]["title"].stringValue)
        }
        
        productTitleArray = collectionModel.productTitle
        
        print(productTitleArray)
        
        tableView.reloadData()
        
    }
    

}
