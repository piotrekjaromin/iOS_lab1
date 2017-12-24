
import UIKit
import os.log
import CoreData

class Sensor {
    
    static func generateTwentySensors(moc: NSManagedObjectContext, entity: NSEntityDescription) {

        for i in 1...20 {
            let sensorName = "S" + String(arc4random_uniform(100))
            let description = "Sensor number " + String(i);
            let sensor: SensorEntity = NSManagedObject(entity: entity, insertInto: moc) as! SensorEntity
            sensor.setValue(sensorName, forKey: "name")
            sensor.setValue(description, forKey: "sensorDescription")
       }
        try? moc.save()
        return;
        
    }
    
    static func getSensorsFromDB(moc: NSManagedObjectContext, fetchedSensors: NSFetchRequest<NSFetchRequestResult>) -> [SensorEntity] {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            print("Error")
            return [];
        }
        var sensors: [SensorEntity] = []
        let moc = ad.persistentContainer.viewContext
        let fetchedSensors: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorEntity");
        
        do {
        sensors = try moc.fetch(fetchedSensors) as! [SensorEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return sensors;
    }
    
}


