import UIKit
import CoreData
import os.log

class ViewController: UIViewController {
    
    @IBOutlet weak var numberOfRecordInput: UITextField!
    @IBOutlet weak var resultTextArea: UITextView!
    
    var generatedReading: [ReadingEntity] = []
    var sensors: [SensorEntity] = []
    var readings: [ReadingEntity] = []
    var ad: AppDelegate? = nil
    var moc: NSManagedObjectContext? = nil
    var readingEntity: NSEntityDescription? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TabViewController
        sensors = tbvc.sensors
        ad = UIApplication.shared.delegate as? AppDelegate
        moc = ad!.persistentContainer.viewContext
        readingEntity = NSEntityDescription.entity(forEntityName: "ReadingEntity", in: moc!)!
        resultTextArea.text = ""
        
    }
    
    @IBAction func addReadingToDB(_ sender: UIButton) {

        if(generatedReading.count > 0) {
            let startTime = NSDate()
            Reading.fillReadingTableWithDatas(moc: moc!)
            resultTextArea.text = "Correct save \(generatedReading.count) readings."
            let writingtime = NSDate().timeIntervalSince(startTime as Date)
            readings = Reading.getRecordingFromDB()
            
             print("Writing reading to db time: \(writingtime)")
        }
    }
    
    @IBAction func generateRecording(_ sender: UIButton) {
        generatedReading = Reading.generateRecords(number: Int(numberOfRecordInput.text!)!, sensors: sensors)

        var tmp = ""
        for i in 1...generatedReading.count {
        
            tmp += "timestamp: \(generatedReading[i-1].timestamp), sensor: \(generatedReading[i-1].sensor!.name!), value: \(generatedReading[i-1].value) \n"
        }
        resultTextArea.text = tmp;
    }
    
    
    @IBAction func deleteGeneratedReadings(_ sender: UIButton) {
        resultTextArea.text = ""
        generatedReading = []
        moc = ad!.persistentContainer.viewContext
    }
    
}

