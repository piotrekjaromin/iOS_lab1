import UIKit
import CoreData
import os.log

class TabViewController: UITabBarController {
    
    var sensors: [SensorEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        
        var sensorEntity = NSEntityDescription.entity(forEntityName: "SensorEntity", in: moc)!
        let fetchedSensors = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorEntity");
        
        sensors = Sensor.getSensorsFromDB(moc: moc, fetchedSensors: fetchedSensors)
        if sensors.isEmpty {
            Sensor.generateTwentySensors(moc: moc, entity: sensorEntity)
            sensors = Sensor.getSensorsFromDB(moc: moc, fetchedSensors: fetchedSensors)
        }
      
    }
}
