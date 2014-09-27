//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by Nicholas Jayanty on 9/25/14.
//  Copyright (c) 2014 Nicholas Jayanty. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // creating main Candy array variable
    var candies = [Candy]()
    
    // initialize filteredCandies Variable
    var filteredCandies = [Candy]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiating candies objects and populating Candies Array
        self.candies = [Candy(category: "Chocolate", name: "chocolate Bar"),
          Candy(category: "Chocolate", name: "chocolate Chip"),
          Candy(category: "Chocolate", name: "dark chocolate"),
          Candy(category:"Hard", name:"lollipop"),
          Candy(category:"Hard", name:"candy cane"),
          Candy(category:"Hard", name:"jaw breaker"),
          Candy(category:"Other", name:"caramel"),
          Candy(category:"Other", name:"sour chew"),
          Candy(category:"Other", name:"gummi bear")]
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
// configures the display view based on the count of the Candies Array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
          return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }

// populates table view with candies data and toggles between search and display views
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // ask for a reusable cell from the tableview, the table view will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var candy : Candy
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        // Configure the cell
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    
// filter candies by search string
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter array using the filter method
        self.filteredCandies = self.candies.filter({( candy: Candy ) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
            })
    }
    
    
// search Functionality
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableforSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
// detail view functionality
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("candyDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
