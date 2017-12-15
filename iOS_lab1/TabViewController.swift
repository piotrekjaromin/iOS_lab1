import UIKit

class TabViewController: UITabBarController {
    
    var docDir: String = ""
    var dbFilePath: String = ""
    var db: OpaquePointer? = nil
    var sensors: [Sensor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In view did load on tab")
        docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")!.path
        print("db path: \(dbFilePath)")
        if db == nil {
            print("OpenDB")
            openDatabase()
        }
        
        sensors = Sensor.getSensorsFromDB(db: db)
        
        if sensors.isEmpty {
            print("Sensor table is empty. Create sensor table and generate sensors")
            Sensor.createSensorTable(db: db)
            sensors = Sensor.generateTwentySensors();
            Sensor.fillSensorTableWithDatas(db: db, sensors: sensors)
        } else {
            print("Sensors read from db")
        }
        
        if !Reading.checkIfTableRecordExist(db: db) {
            print("Create table reading.")
            Reading.createReadingTable(db: db)
        } else {
            print("Table reading exists.")
        }
        
    }

    func openDatabase(){
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database.")
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
    }
}
