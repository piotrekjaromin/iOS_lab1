
import UIKit
import os.log

class Sensor {
    var id: Int
    var name: String
    var desc: String
    
    init (id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.desc = description
    }
    
    static func generateTwentySensors() -> [Sensor] {
        var result: [Sensor] = []
        for i in 1...20 {
            let sensorName = "S" + String(arc4random_uniform(100))
            let description = "Sensor number " + String(i);
            let sensor = Sensor(id: i, name: sensorName, description: description)
            result.append(sensor)
        }
        return result;
    }
    
    static func createSensorTable(db: OpaquePointer?) {
        let createSQL = "CREATE TABLE sensor(id INTEGER PRIMARY KEY, name VARCHAR(50), desc VARCHAR(50));"
        sqlite3_exec(db, createSQL, nil, nil, nil)
    }
    
    static func fillSensorTableWithDatas(db: OpaquePointer?, sensors: [Sensor]) {
        
        var insertSQL = "INSERT INTO sensor (id, name, desc) VALUES "
        for sensor in sensors {
            insertSQL += "(\"\(sensor.id)\", \"\(sensor.name)\", \"\(sensor.desc)\"),";
            sqlite3_exec(db, insertSQL, nil, nil, nil)
        }
        insertSQL = String(insertSQL.characters.dropLast())
        insertSQL += ";"
        sqlite3_exec(db, insertSQL, nil, nil, nil)
    }
    
    static func getSensorsFromDB(db: OpaquePointer?) -> [Sensor] {
        print("In getSensorsFromDB");
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT id, name, desc FROM sensor;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        var sensors: [Sensor] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let desc = String(cString: sqlite3_column_text(stmt, 2))
            print("\(id): \(name): \(desc)")
            sensors.append(Sensor(id: Int(id), name: name, description: desc))
        }
        sqlite3_finalize(stmt)
        
        return sensors;
    }
    
    static func checkIfTableSensorExist(db: OpaquePointer?) -> Bool {
        let selectSQL = "SELECT count(*) FROM sensor;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            return true
        } else {
            return false
        }
    }
    
}


