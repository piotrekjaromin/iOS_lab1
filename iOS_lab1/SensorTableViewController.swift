import UIKit

class SensorTableViewController: UITableViewController {

    var db: OpaquePointer? = nil
    var sensors: [Sensor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabViewController
        db = tbvc.db
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SensorTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SensorTableViewCell
        let sensorTmp = sensors[indexPath.row]
        
        cell?.nameLabel.text = "name: " + String(sensorTmp.name)
        cell?.descriptionLabel.text = "description: " + String(sensorTmp.desc)
    
        return cell!
    }

}
