import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberOfRecordInput: UITextField!
    @IBOutlet weak var resultTextArea: UITextView!
    
    var docDir: String = ""
    var dbFilePath: String = ""
    var db: OpaquePointer? = nil
    var generatedReading: [Reading] = []
    var sensors: [Sensor] = []
    var readings: [Reading] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TabViewController
        db = tbvc.db
        readings = Reading.getReadingsFromDB(db: db)
        resultTextArea.text = ""
        sensors = Sensor.getSensorsFromDB(db: db)
    }
    
    @IBAction func addReadingToDB(_ sender: UIButton) {
        Reading.fillReadingTableWithDatas(db: db, readings: generatedReading)
        resultTextArea.text = "Added \(generatedReading.count) readings do db."
        readings = Reading.getReadingsFromDB(db: db)
    }
    
    @IBAction func generateRecording(_ sender: UIButton) {
        let numberOfReading = Int(numberOfRecordInput.text!)!
        generatedReading = Reading.generateRecords(number: numberOfReading)
        var tmp = ""
        var sensorId: Int;
        for i in 1...numberOfReading {
            sensorId = generatedReading[i-1].sensor.id - 1
            tmp += "timestamp: \(generatedReading[i-1].timestamp), sensor: \(sensors[sensorId].name), value: \(generatedReading[i-1].value) \n"
        }
        resultTextArea.text = tmp;
    }
    
    
    @IBAction func deleteGeneratedReadings(_ sender: UIButton) {
        resultTextArea.text = ""
        generatedReading = []
    }
}

