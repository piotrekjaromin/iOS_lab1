import UIKit
import CoreData
import os.log

class ReadingTableViewController: UITableViewController {
    var readings: [ReadingEntity] = []
    var ad: AppDelegate? = nil
    var moc: NSManagedObjectContext? = nil
    var readingEntity: NSEntityDescription? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ad = UIApplication.shared.delegate as? AppDelegate
        moc = ad!.persistentContainer.viewContext
        
        readingEntity = NSEntityDescription.entity(forEntityName: "ReadingEntity", in: moc!)!

        readings = Reading.getRecordingFromDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readings = Reading.getRecordingFromDB()
    
        var startTime = NSDate()
        let smalestAndlargest = Reading.findSmallestRecordedTimestamp()
        let measuredSmalestTime = NSDate().timeIntervalSince(startTime as Date)
        
        
        startTime = NSDate()
        let avgValue = Reading.averageReadingValueForAllsensors()
        let measuredAvgTime = NSDate().timeIntervalSince(startTime as Date)
        
        startTime = NSDate()
        let numberAndAvgValue = Reading.numberOfReadingsAndAvgValueIndividualSensor()
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
        
        cell?.valueLabel.text = "value: " + String(readingTmp.value)
        cell?.sensorNameLabel.text = "sensor name: " + String(describing: readingTmp.sensor!.name!)
        cell?.timestampLabel.text = "timestamp: " + String(readingTmp.timestamp)

        return cell!
    }

}
