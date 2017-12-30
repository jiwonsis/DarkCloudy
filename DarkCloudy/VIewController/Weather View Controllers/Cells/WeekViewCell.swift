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
    
    func configure(viewModel: WeatherDayRepresentable) {
        dayLabel.text = viewModel.day
        dateLabel.text = viewModel.date
        windSpeedLabel.text = viewModel.windSpeed
        temperatureLabel.text = viewModel.temperature
        iconImageView.image = viewModel.image
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
