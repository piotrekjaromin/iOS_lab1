import UIKit
import os.log
import CoreData

class Reading {
    
    static func generateRecords(number: Int, sensors: [SensorEntity]) -> [ReadingEntity] {
        var result: [ReadingEntity] = []
        
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            print("Error")
            return []
        }
        
        let moc = ad.persistentContainer.viewContext
        let readingEntity = NSEntityDescription.entity(forEntityName: "ReadingEntity", in: moc)!
        
        for i in 1...number {
            let timestamp1 = NSTimeIntervalSince1970;
            let timestamp2 = Double(arc4random_uniform(31556926))
            let timestamp = timestamp1 - timestamp2
            let value = Double(arc4random_uniform(100))
            let sensorId = Int(arc4random_uniform(19)) + 1
            let reading: ReadingEntity = NSManagedObject(entity: readingEntity, insertInto: moc) as! ReadingEntity
            reading.setValue(timestamp, forKey: "timestamp")
            reading.setValue(value, forKey: "value")
            reading.setValue(sensors[sensorId], forKey: "sensor")
            result.append(reading)
            
        }
        
        return result
    }
    
    static func fillReadingTableWithDatas(moc: NSManagedObjectContext) {
        try? moc.save()
    }
    
    static func getRecordingFromDB() -> [ReadingEntity] {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            print("Error")
            return [];
        }
        var readings: [ReadingEntity] = []
        let moc = ad.persistentContainer.viewContext
        let fetchedRecording: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        do {
            readings = try moc.fetch(fetchedRecording) as! [ReadingEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return readings;
    }
    
    static func findSmallestRecordedTimestamp() -> String {
        
        var ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result = ""
        
        let fetchedReading = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        var sd = NSSortDescriptor(key: "timestamp", ascending: true);
        
        fetchedReading.sortDescriptors = [sd]
        fetchedReading.fetchLimit = 1
        
        var readings: [ReadingEntity] = []
        
        do {
            readings = try moc.fetch(fetchedReading) as! [ReadingEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        
        result = String(readings[0].timestamp)
        
        sd = NSSortDescriptor(key: "timestamp", ascending: false);
        fetchedReading.sortDescriptors = [sd]
        
        do {
            readings = try moc.fetch(fetchedReading) as! [ReadingEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        
        result += " " + String(readings[0].timestamp)
        
        return result;
    }
    
    
    static func averageReadingValueForAllsensors() -> NSDictionary {
        
        var ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result: NSDictionary
        
        let fetchedReading = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        let keypathExp = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "average:", arguments: [keypathExp])
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "average"
        countDesc.expressionResultType = .doubleAttributeType
        
        fetchedReading.returnsObjectsAsFaults = false
        fetchedReading.propertiesToFetch = [countDesc]
        fetchedReading.resultType = .dictionaryResultType
        
        
        do {
            result = try moc.fetch(fetchedReading)[0] as! NSDictionary
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return result
    }
    
    static func numberOfReadingsAndAvgValueIndividualSensor() -> [NSDictionary] {
        
        var ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result: [NSDictionary]
        
        let fetchedReading = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        let keypathExp = NSExpression(forKeyPath: "value")
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        let expression2 = NSExpression(forFunction: "average:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        
        let countDesc2 = NSExpressionDescription()
        countDesc2.expression = expression2
        countDesc2.name = "average"
        countDesc2.expressionResultType = .integer64AttributeType
        
        fetchedReading.returnsObjectsAsFaults = false
        fetchedReading.propertiesToGroupBy = ["sensor"]
        fetchedReading.propertiesToFetch = [countDesc, countDesc2]
        fetchedReading.resultType = .dictionaryResultType
        
        
        do {
             result = try moc.fetch(fetchedReading) as! [NSDictionary]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return result;
    }
}
