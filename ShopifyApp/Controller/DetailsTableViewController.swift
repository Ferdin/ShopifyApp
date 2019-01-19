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
    let image : String
    let title : String
    
    init(dictionary : [String : String]) {
        self.image = dictionary["image"] ?? ""
        self.title = dictionary["title"] ?? ""
    }
}

class DetailsTableViewController: UITableViewController {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var collection_id = String()
    var productIDArray = [String]()
    var productTitleArray = [String]()
    var productVariantArray = [String]()
    var productImageArray = [String]()
    var productID :String = ""
    var productTitles = String()
    let collectionModel = CollectionModel()
    var collection_name = String()
    var productQuantity = [String]()
    
    var data = [cellData]()
    
    var rowNum : Int = 0
    var selectedJSON = JSON()
    
    var collectionArray : [CollectionModel] = [CollectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        getCollections(collectionID: collection_id)
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 200
        //data = [cellData.init(image: UIImage(named : productImageArray), title: "Gell")]
        //getProductNames() - Not Worked
     
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
       // getProductNames() -- Worked
        
//        activityIndicator.stopAnimating()
//
//        UIApplication.shared.endIgnoringInteractionEvents()
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomCell
        
        
        
        let url = URL(string: productImageArray[indexPath.row])
        
        let data = try? Data(contentsOf: url!)
        
        cell.imageUI = UIImage(data: data!)
        
        cell.title = "Name : \(productTitleArray[indexPath.row])"
        
        cell.layoutSubviews()
        //cell.imageUI = UIImage(named : productImageArray[indexPath.row])
        
        //cell.textLabel?.text = productTitleArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collection_name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productTitleArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(productImageArray[indexPath.row])
        rowNum = indexPath.row
        print(rowNum)
        
        getVariantQuantities(row : rowNum)
        
        collectionModel.productVariants.removeAll()
        productQuantity.removeAll()
        
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        collectionModel.productVariants.removeAll()
//        productQuantity.removeAll()
//    }
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
        
        getProductNames()
        
        tableView.reloadData()
    }
    
    func parseJSONProducts(json : JSON){
        
        selectedJSON = json
        
        let countProducts = json["products"].count
        
        
        for countProducts in 0...(countProducts - 1){
            collectionModel.productTitle.append(json["products"][countProducts]["title"].stringValue)
            
        }
       
        productTitleArray = collectionModel.productTitle
        
        print(collectionModel.productVariants)
        //print(countVariants)
        //print(productTitleArray)
        // Sum of all quanitities in an array across all variants
       
        let counts : Int = productTitleArray.count

//        for counts in 0...(counts - 1){
//
//            getVariantQuantities(row: counts)
//
//        }
        getImageURL()
        print(counts)
        
        
        
//        getVariantQuantities(row: 2)
        tableView.reloadData()
        
    }
    
    
   // make up everything prior to the function call
    func getVariantQuantities(row : Int){
        
        let countVariants = selectedJSON["products"][row]["variants"].count
        
        //var tableViewData = [cellData]()
        
        for i in 0...(countVariants - 1){
//          collectionModel.productVariants.append(selectedJSON["products"][row]["variants"][i]["title"].stringValue)
            
            collectionModel.productVariants.append(selectedJSON["products"][row]["variants"][i]["title"].stringValue)
            
            productQuantity.append(selectedJSON["products"][row]["variants"][i]["inventory_quantity"].stringValue)
            
        }
        
         let productInt = productQuantity.compactMap { Int($0)!}
         let total = productInt.reduce(0, +)
        
        let representation = "The total quantity is \(total) and These are the available variants : \(collectionModel.productVariants.joined(separator:","))"
        
        let alert = UIAlertController(title: "Quantity across all variants ", message: representation, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        //let messageFont = UIFont(name: "Avenir-Roman", size: 12.0)!
        
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
       // productVariantArray = collectionModel.productVariants

    //    print("Row \(row) has \(countVariants) variants - \(collectionModel.productVariants.difference(from: collectionModel.productVariants))")
//        
//       let countCA = collectionArray.count
//
//        for count in 0..<countCA{
//                print(collectionArray[count].productVariants)
//        }
//
    }
    
    func getImageURL(){
        
        let countVariants = productTitleArray.count
        
        
        for count in 0..<countVariants{
            collectionModel.productImageURL.append(selectedJSON["products"][count]["image"]["src"].stringValue)
//            collectionModel.productImageURL = selectedJSON["products"][count]["image"]["src"].stringValue
//            print(collectionModel.productImageURL)
//            collectionArray.append(collectionModel)
            
        }
//        for count in 0..<countVariants{
//                print(collectionArray[count].productImageURL)
//        }
        
        print(collectionModel.productImageURL)
        
        productImageArray = collectionModel.productImageURL
    }
    
    
    //MARK: - Miscellaneous Methods
 

}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
