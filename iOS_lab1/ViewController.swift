import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberOfRecordInput: UITextField!
    @IBOutlet weak var resultTextArea: UITextView!
    
    var docDir: String = ""
    var dbFilePath: String = ""
    var db: OpaquePointer? = nil
    var generatedReading: [Reading] = []
    var sensors: [Sensor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")!.path

        openDatabase()
        
        if !Sensor.checkIfTableSensorExist(db: db) {
            print("Crete table sensor.")
            Sensor.createSensorTable(db: db)
            Sensor.fillSensorTableWithDatas(db: db, sensors: Sensor.getSensorsFromDB(db: db))
        } else {
            print("Table sensor exits.")
        }
        
        if !Reading.checkIfTableRecordExist(db: db) {
            print("Create table reading.")
            Reading.createReadingTable(db: db)
        } else {
            print("Table reading exists.")
        }
    }
    
    @IBAction func addReadingToDB(_ sender: UIButton) {
        Reading.fillReadingTableWithDatas(db: db, readings: generatedReading)
    }
    
    @IBAction func generateRecording(_ sender: UIButton) {
        let numberOfReading = Int(numberOfRecordInput.text!)!
        generatedReading = Reading.generateRecords(number: numberOfReading)
        var tmp = ""
        for i in 1...numberOfReading {
            tmp += "\(generatedReading[i-1].timestamp): \(generatedReading[i-1].sensor.id): \(generatedReading[i-1].value) "
        }
        resultTextArea.text = tmp;
    }
    
    
    @IBAction func deleteGeneratedReadings(_ sender: UIButton) {
        resultTextArea.text = ""
        generatedReading = []
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////////////////////////////////////////////////////////////////////////// DB For sensor
    
    func openDatabase(){
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database.")
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
    }
    
     /////////////////////////////////////////////////////////////////////////// DB For reading
    


}

