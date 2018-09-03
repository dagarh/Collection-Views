import UIKit

class DetailedNationalParkViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var park: Park?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display Park info. Usually in big projects, we follow this only that properties get set based on model object. Follow this pattern only.
        if let park = park {
            navigationItem.title = park.name
            imageView.image = UIImage(named: park.photo)
            nameLabel.text = park.name
            stateLabel.text = park.state
            dateLabel.text = park.date
        }
        
        /* Since there is only single object of navigation controller for all View Controllers[Scene] , hence be careful before doing this and do sanity tests at all the places. So set to false at those places whereever toolbar is not needed and true whereever needed. */
        navigationController?.isToolbarHidden = true
        
        /*
         This is very dangerous to do. You can not do this. Because it will set "prefersLargeTitles" to false for all the Views and hence from now on, it will not show us large title for any of the views because this instance of navigation controller is shared by all the view controllers. So better way is to grab navigation item which here is not part of navigation controller because you put that navigation item on navigation bar separately.
         
         navigationController?.navigationBar.prefersLargeTitles = false
         
         /* Or if you want to handle this using navigation controller only then do it, by making use of view controllers life cycle. */
         */
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
}
