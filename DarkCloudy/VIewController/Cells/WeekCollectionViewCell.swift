import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    let viewController : WeekViewController
    
    override init(frame: CGRect) {
        // Initialize View Controller
        viewController = WeekViewController()
        
        super.init(frame: frame)
        
        setupViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Initialize View Controller
        viewController = WeekViewController()
        
        super.init(coder: aDecoder)
        
        setupViewController()
    }
    
}

extension WeekCollectionViewCell: SubViewControllerAble {
    
    static func reuseIdetifier() -> String {
        return  "WeekCollectionViewCell"
    }
    
    func setupViewController() {
        // Configure View Controller
        viewController.view.backgroundColor = .blue
        
        // Add View Controller to Content View
        contentView.addSubview(viewController.view)
        
        if let view = viewController.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        }
    }
}
