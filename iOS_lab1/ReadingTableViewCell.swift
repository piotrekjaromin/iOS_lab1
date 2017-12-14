import UIKit

class ReadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
