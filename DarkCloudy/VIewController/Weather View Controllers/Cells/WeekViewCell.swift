import UIKit

class WeekViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewController()
    }
}

extension WeekViewCell {
    
    func setupViewController() {
        selectionStyle = .none
    }
    
    static func reuseIdetifier() -> String {
        return "WeekViewCell"
    }
    
    
}
