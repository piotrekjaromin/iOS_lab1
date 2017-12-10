import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var numberOfRecordInput: UITextField!
    
    @IBOutlet weak var resultTextArea: UITextView!
    
    var docDir: String = ""
    var dbFilePath: String = ""
    var db: OpaquePointer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")!.path

        openDatabase()
        createSensorTable()
        getSensors()
        //generateTwentySensors()
    }
    
    
    @IBAction func generateRecords(_ sender: UIButton) {
        resultTextArea.text = numberOfRecordInput.text
        let numberOfRecord: Int = Int(numberOfRecordInput.text!)!
        
    }
    
    func generateTwentySensors() -> [Sensor] {
        
        var result: [Sensor] = []
        for i in 1...20 {
            let sensorName = "S" + String(arc4random_uniform(100))
            let description = "Sensor number " + String(i);
            let sensor = Sensor(name: sensorName, description: description)
            result.append(sensor)
        }
        return result;
    }
    
    
    @IBAction func addRecords(_ sender: UIButton) {
    }
    
    @IBAction func deleteRecords(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openDatabase(){
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbFilePath)")
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
    }
    
    func createSensorTable() {
        print("Create table: sensor");
        let createSQL = "CREATE TABLE sensor(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(50), desc VARCHAR(50));"
        sqlite3_exec(db, createSQL, nil, nil, nil)
        
        var sensors: [Sensor] = []
        sensors = generateTwentySensors()
        var insertSQL = "INSERT INTO sensor (name, desc) VALUES "
        
        for sensor in sensors {
            insertSQL += "(\"\(sensor.name)\", \"\(sensor.desc)\"),";
            sqlite3_exec(db, insertSQL, nil, nil, nil)
        }
        insertSQL = String(insertSQL.characters.dropLast())
        insertSQL += ";"
        
        print(insertSQL)
        
        sqlite3_exec(db, insertSQL, nil, nil, nil)
    }
    
    func getSensorsFromDB() {
        print("Get sensors");
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT name, desc FROM sensor;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let desc = String(cString: sqlite3_column_text(stmt, 1))
            print("sensor \(name) with desc \(desc)")
        }
        sqlite3_finalize(stmt)
    }
    

}

