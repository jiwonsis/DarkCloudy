import UIKit

class RootViewViewController: UIViewController {
    
    // MARK: -
    enum RootViewType: Int {
        case new = 0
        case day
        case week
        
        static var count: Int {
            return RootViewType.week.rawValue + 1
        }
    }
    
     // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataManager = DataManger(baseURL: API.AuthenticatedBaseURL)
    
    // MARK: -
    
    fileprivate var aspectRatio: CGFloat {
        switch traitCollection.horizontalSizeClass {
        case .compact:
            return 1.0
        default:
            return 1.0 / 3.0
        }
    }
    
    fileprivate let minimumInteritemSpacingForSection: CGFloat = 0.0
    fileprivate let minimumLineSpacingForSection: CGFloat = 0.0
    fileprivate let insetForSection = UIEdgeInsets()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Fetch Weather Data
        dataManager.weatherDataForLocation(latitude: Default.Latitude, longitude: Default.Longitude) { (response, error) in
            
        }
    }
    
    // MARK: - Content Container Methods
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

private extension RootViewViewController {
    func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.register(NowCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NowCollectionViewCell.reuseIdetifier())
        self.collectionView.register(DayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdetifier())
        self.collectionView.register(WeekCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: WeekCollectionViewCell.reuseIdetifier())
    }
    
}

extension RootViewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RootViewType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let type = RootViewType(rawValue: indexPath.row) else {
            fatalError()
        }
        
         // Dequeue Reusable Cell
        switch type {
        case .new:
            return collectionView.dequeueReusableCell(withReuseIdentifier: NowCollectionViewCell.reuseIdetifier(), for: indexPath)
        case .day:
            return collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdetifier(), for: indexPath)
        case .week:
            return collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.reuseIdetifier(), for: indexPath)
        }
        
    }
}

extension RootViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection
    }
    
}
