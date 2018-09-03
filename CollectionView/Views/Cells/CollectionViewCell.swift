import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var titleLabel:UILabel!
    @IBOutlet weak private var selectionImage:UIImageView!
    @IBOutlet weak private var mainImage: UIImageView!
    
    /* This is important to notice that cell object setting functionality should be done in its own object only, not in view controller. And this kind of pattern you have to follow everywhere. Always remember this. */
    /* Here we are setting cell object based on data model object. This is perfect pattern to follow. Always focus on writing good code. */
    /* So View Controller will set this property of a cell. Because View Controller has access to data model objects. */
    var park : Park? {
        didSet {
            if let park = park {
                titleLabel.text = park.name
                mainImage.image = UIImage(named: park.photo)
            }
        }
    }
    
    /* This is user-defined property. */
    var isEditing: Bool = false {
        didSet {
            selectionImage.isHidden = !isEditing
        }
    }
    
    
    /* "isSelected" is the property of a UICollectionViewCell, which would tell us about the state of a cell i.e whether cell is selected or not [we use this property only when cells are in editing mode, hence need to put a filter because it would still get called when cells are in normal mode. Hence filter is mandatory], based on its true or false value. We are overriding this property. */
    /* So there are 2 ways of performing actions when cell is selected --> one way is this, by overriding property from UICollectionViewCell [We use this when cells are in Edit Mode] and other way is to use "didSelectItemAt" delegate method [We use this when cells are in non-edit mode]. These usages are typical i.e we can do something in else part if we want. */
    /*
     If you actually want to know how both of these work when cells are in normal mode --> in normal mode there is only one click to the cell[There is no selection and de-selection, just one single click everytime]. When you click the cell, first this property would get called and then "didSelectItemAt" method would be called.
     
     If you actually want to know how both of these work when cells are in edit mode ---> in edit mode there are 2 clicks associated with a cell i.e selection and de-selection. At the time of selection of a cell, it first calls this property with a true value and then "didSelectItemAt" method gets called. But in case of de-selection, it first calls this property with a false value and then after this, "didDeselectItemAt" gets called.
     */
    /* You can read about this property here : https://developer.apple.com/documentation/uikit/uicollectionviewcell/1620130-isselected. We can add property observers to ‘inherited’ property by method ‘overriding’. "isSelected" is a stored property(not a property observer) in UICollectionViewCell class. And here we are overriding that as a stored property observer. But you can not specify an initial value to this here. Always remember that if we want to override any stored property then we can override that with either computed property or property observers[can't provide initial value here while overriding].   */
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
    
    /* This would be called for the clean up while reusing cell. */
    override func prepareForReuse() {
        mainImage.image = nil
    }
}
