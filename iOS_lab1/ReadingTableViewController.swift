import UIKit

class ReadingTableViewController: UITableViewController {
    var db: OpaquePointer? = nil
    var readings: [Reading] = []
    var sensors: [Sensor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabViewController
        db = tbvc.db
        readings = Reading.getReadingsFromDB(db: db)
        sensors = Sensor.getSensorsFromDB(db: db)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readings = Reading.getReadingsFromDB(db: db)
        
        var startTime = NSDate()
        let smalestAndlargest = Reading.findSmallestRecordedTimestamp(db: db)
        let measuredSmalestTime = NSDate().timeIntervalSince(startTime as Date)
        
        
        
        startTime = NSDate()
        let avgValue = Reading.averageReadingValueForAllsensors(db: db)
        let measuredAvgTime = NSDate().timeIntervalSince(startTime as Date)
        
        startTime = NSDate()
        let numberAndAvgValue = Reading.numberOfReadingsAndAvgValueIndividualSensor(db: db)
        let measuredNumberAndAvgTime = NSDate().timeIntervalSince(startTime as Date)
        
        
        print("Smalest and largest value: \(smalestAndlargest), time: \(measuredSmalestTime)")
        print("Average reading all sensors: \(avgValue), time: \(measuredAvgTime)")
        print("Sensor name, number of reading and average value for each sensor: \(numberAndAvgValue), time: \(measuredNumberAndAvgTime)")

        tableView.reloadData()
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
        return readings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReadingTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReadingTableViewCell
        let readingTmp = readings[indexPath.row]
        let sensorId: Int = readingTmp.sensor.id - 1
        
        cell?.valueLabel.text = "value: " + String(readingTmp.value)
        cell?.sensorNameLabel.text = "sensor name: " + String(sensors[sensorId].name)
        cell?.timestampLabel.text = "timestamp: " + String(readingTmp.timestamp)

        return cell!
    }

}
