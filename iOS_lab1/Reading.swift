import UIKit

class Reading {
    var timestamp: Double
    var sensor: Sensor
    var value: Double
    
    init(timestamp: Double, sensor: Sensor, value: Double) {
        self.timestamp = timestamp
        self.sensor = sensor
        self.value = value
    }
    
    static func createReadingTable(db: OpaquePointer?) {
        let createSQL = "CREATE TABLE reading(id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp NUMBER, value number, sensor_id INTEGER);"
        sqlite3_exec(db, createSQL, nil, nil, nil)
    }
    
    static func checkIfTableRecordExist(db: OpaquePointer?) -> Bool {
        let selectSQL = "SELECT count(*) FROM reading;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            return true
        } else {
            return false
        }
    }
    
    static func generateRecords(number: Int) -> [Reading] {
        var result: [Reading] = []
        for i in 1...number {
            let timestamp1 = NSTimeIntervalSince1970;
            let timestamp2 = Double(arc4random_uniform(31556926))
            let timestamp = timestamp1 - timestamp2
            let value = Double(arc4random_uniform(100))
            let sensor = Sensor(id: Int(arc4random_uniform(19)) + 1,name: "",description: "")
            result.append(Reading(timestamp: timestamp, sensor: sensor, value: value))
            
        }
        return result
    }
    
    static func fillReadingTableWithDatas(db: OpaquePointer?, readings: [Reading]) {
        
        var insertSQL = "INSERT INTO reading (timestamp, value, sensor_id) VALUES "
        for reading in readings {
            insertSQL += "(\"\(reading.timestamp)\", \"\(reading.value)\", \"\(reading.sensor.id)\"),";
        }
        insertSQL = String(insertSQL.characters.dropLast())
        insertSQL += ";"
        print("Prepared date. Now insert to sql")
        sqlite3_exec(db, insertSQL, nil, nil, nil)
    }
    
    static func getReadingsFromDB(db: OpaquePointer?) -> [Reading] {
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT timestamp, value, sensor_id FROM reading;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        var readings: [Reading] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let timestamp = sqlite3_column_double(stmt, 0)
            let value = sqlite3_column_double(stmt, 1)
            let sensor_id = sqlite3_column_int(stmt, 2)
            readings.append(Reading(timestamp: timestamp, sensor: Sensor(id: Int(sensor_id), name: "", description: ""), value: value))
        }
        sqlite3_finalize(stmt)
        
        return readings;
    }
    
    static func findSmallestRecordedTimestamp(db: OpaquePointer?) -> String {
        var selectSQL = "select MIN(timestamp), MAX(timestamp) from reading;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        let min = sqlite3_column_double(stmt, 0)
        let max = sqlite3_column_double(stmt, 1)
        
        let value =  String(min) + "; " + String(max)
        sqlite3_finalize(stmt)
        return value;
    }
    
    
    static func averageReadingValueForAllsensors(db: OpaquePointer?) -> Double {
        var selectSQL = "select avg(value) from reading;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        let value = sqlite3_column_double(stmt, 0)
        sqlite3_finalize(stmt)
        return value;
    }
    
    static func numberOfReadingsAndAvgValueIndividualSensor(db: OpaquePointer?) -> [String] {
        var selectSQL = "Select Sensor.name, count(reading.id), avg(reading.value) from reading inner join sensor ON reading.sensor_id=sensor.id group by sensor.name;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        var result: [String] = []
        var value: String;
        while sqlite3_step(stmt) == SQLITE_ROW {
            var sensorName = String(cString: sqlite3_column_text(stmt, 0))
            var counter = sqlite3_column_int(stmt, 1)
            var avg = sqlite3_column_double(stmt, 2)
            var value = sensorName + " ; " + String(counter) + " ;" + String(avg)
            result.append(value);
        }
        sqlite3_finalize(stmt)
        return result;
    }
}
