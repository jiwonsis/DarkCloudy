import UIKit

extension UIViewController {
    func resetLayout(targetView: UIView, addingView: UIView) {
        addingView.translatesAutoresizingMaskIntoConstraints = false
        
        addingView.topAnchor.constraint(equalTo: targetView.topAnchor, constant: 0.0).isActive = true
        addingView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 0.0).isActive = true
        addingView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 0.0).isActive = true
        addingView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: 0.0).isActive = true
    }
}
