//
//  DetailsTableViewController.swift
//  ShopifyApp
//
//  Created by newuser on 2019-01-11.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import UIKit


struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class DetailsTableViewController: UITableViewController {

    var collection_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      print(collection_id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
