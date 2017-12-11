//
//  SensorTableViewController.swift
//  iOS_lab1
//
//  Created by Admin on 11/12/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SensorTableViewController: UITableViewController {

    var docDir: String = ""
    var dbFilePath: String = ""
    var db: OpaquePointer? = nil
    var sensors: [Sensor] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In viewDidLoad")
        docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")!.path
        print(dbFilePath)
        print("In layoutSubviews")
        if db == nil {
            print("OpenDB")
            openDatabase()
        }
        
        sensors = Sensor.getSensorsFromDB(db: db)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sensors.count
    }
    
    func openDatabase(){
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database.")
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SensorTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SensorTableViewCell
        
        let sensorTmp = sensors[indexPath.row]
        
        cell?.nameLabel.text = String(sensorTmp.name)
        cell?.descriptionLabel.text = String(sensorTmp.desc)
    
        
        return cell!
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
