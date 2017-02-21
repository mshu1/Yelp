//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate
{
    
    var businesses: [Business]!
    var filteredbusinesses: [Business]!
    var searchBar = UISearchBar()
    var offset = 20
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        searchBar.sizeToFit()
        
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self

        Business.searchWithTerm(term: "", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredbusinesses = self.businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )}
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Initiated?????")
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData(){
        self.offset = self.offset + 20
        Business.searchWithTerm(term: "", sort: .distance, categories: [], deals: false, offset: offset, completion: { (businesses: [Business]?, error: Error? ) -> Void in
            
            self.businesses.append(contentsOf: businesses!)
            self.filteredbusinesses = self.businesses
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        })
    }
    
    
    
    /* Example of Yelp search with more search options specified
     Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
     self.businesses = businesses
     
     for business in businesses {
     print(business.name!)
     print(business.address!)
     }
     }
     */


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if businesses != nil {
        return filteredbusinesses!.count
    } else {
        return 0
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
    cell.business = filteredbusinesses[indexPath.row]
    return cell
}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredbusinesses = self.businesses
            tableView.reloadData()
        } else {
            filteredbusinesses = searchText.isEmpty ? businesses : businesses.filter({(business: Business) -> Bool in
                return business.name!.range(of: searchText, options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
    }





override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

/*
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 let record = self.movies
 
 if searchText.isEmpty == false {
 filteredMovies = searchText.isEmpty ?
 record: record!.filter({(movie : NSDictionary) -> Bool in
 let title = movie["title"] as! String
 return title.range(of: searchText, options: .caseInsensitive) != nil
 })
 
 self.collectionView.reloadData()
 
 } else {
 filteredMovies = self.movies
 self.collectionView.reloadData()
 }
 }
 */
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
