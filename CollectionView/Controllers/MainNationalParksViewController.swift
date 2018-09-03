import UIKit

/*
 Whole purpose of Collection Views is to store data in grids(i.e in rows and columns both). But from storyboard, we can not specify no of rows or columns. For that we need to do it programatically. And you can do that with the help of Layout object by determining the size of item relative to size of Collection View or Main View.
 
 Item is smallest unit using which data is stored. One cell for one item. Hence cells are used to manage items and layout is heart of collection view i.e layout is used to design and arrangement of cells. Default layout is flow layout.
 
 Item size = Cell size [for each cell].
 
 There are 2 steps which you can ignore when inheriting from UICollectionViewController directly instead of UIViewController. First one is :- no need to create outlet for collectionView, you get it from super class automatically AND second is :- your class is the datasource and delegate of collectionView automatically, so you don't have to write this or don't have to set it from connection inspector.
 */

class MainNationalParksViewController: UICollectionViewController {
    
    @IBOutlet private weak var addButton:UIBarButtonItem!
    @IBOutlet private weak var deleteButton:UIBarButtonItem!
    
    private let columns = CGFloat(3.0)
    private let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* This is the property which enables moving of cells by long press. But you need to handle your Data Model accordingly, so be careful. */
        installsStandardGestureForInteractiveMovement = true
        
        /* This is doing 2 things : First changing properties using Layout object and also doing pull to refresh. */
        configureCollectionView()
        
        /* There is no special edit functionality for the collection views. So we would provide by ourselves. This below line would add magical button, named Edit, provided by apple, which provides edit mode to us when we tap on it and calls setEditing(_:animated:) method with "editing" as true in the function parameter. So we can provide our functionality inside "setEditing(_:animated:)" method when cells are in edit mode. In the editing mode, button changes to "Done" from "Edit". So When you press "Done" then editing mode would be gone and setEditing(_:animated:) method would be called again with "editing" as false in the function parameter, hence back to the normal state. So you can undo something which you want, in "setEditing(_:animated:)" method by filtering based on "isEditing" property, when coming back to normal state. So it is always better to do things based on "isEditing" filter inside "setEditing(_:animated:)" method because it gets called when entering editing mode and also gets called when leaving editing mode. */
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        /* Always remember that there is only one single object of a navigation controller, which gets used in every View Controller. If you try to set its bar property or any other property then it would affect all the View Controllers which are inheriting navigation bar by making use of navigation controller. So always remember to set its property off whereever you want that to be off. If you don't want common sharing then it is better to go with navigationItem, which is different and not shared between view controllers.  */
        /* You can set this property through storyboard also. With a single tick :] */
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.isToolbarHidden = true
    }
    
    
    func configureCollectionView() {
        print(collectionView!.frame.size.width)
        print(view.frame.size.width)
        
        /* Uncomment it whenever needed. */
        // configureNoOfColumnsForCollectionView(noOfColumnsInVerticallyScrollCollectionView: columns)
        
        /* We can add pull to refresh technique on collection views very easily. Even though we use pull to refresh functionality to fetch the data from remote server but you can do anything literally. Let's add items at the time of pull to refresh. */
        configurePullToRefreshOnCollectionView()
    }
    
    func configureNoOfColumnsForCollectionView(noOfColumnsInVerticallyScrollCollectionView : CGFloat) {
        /* There are 2 places where this same thing can be done. You can either use UICollectionViewDelegateFlowLayout protocol method OR you can create subclass of UICollectionViewFlowLayout and then set these properties there in "prepare" method. */
        
        /* This is very powerful layout object using which you can play with the positioning, spacing, and lots of other properties of items/cells. Since we know that layout which we are using is flow layout by default, hence we are force casting it into UICollectionViewFlowLayout directly. */
        let layout = collectionView!.collectionViewLayout as! FlowLayout
        /* FlowLayout is our custom class. In case you don't have custom class then mention UICollectionViewFlowLayout after as! */
        
        // could have used collectionView's frame's width property but they are not equal here.
        let width = (view.frame.size.width - (noOfColumnsInVerticallyScrollCollectionView-1) * layout.minimumInteritemSpacing) / noOfColumnsInVerticallyScrollCollectionView
        
        /* This itemSize property is available in UICollectionViewFlowLayout only. That's why we did forced downcast. This itemSize would override the size which we provided from interface builder i.e size of the cell which is same as size of item.  */
        layout.itemSize = CGSize(width: width, height: width)
        
        /* For sticky headers. */
        layout.sectionHeadersPinToVisibleBounds = true
    }
    
    // Pull to Refresh
    func configurePullToRefreshOnCollectionView() {
        let refreshControl = UIRefreshControl()
        /* You remember that we did the same thing for textfield in order to use UIControls. So here we are adding target action method for the valueChanged UIControlEvent. */
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView!.refreshControl = refreshControl
    }
    
    
    @objc func refresh() {
        if !isEditing {
            addItem()
        }
        collectionView?.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let dest = segue.destination as? DetailedNationalParkViewController {
                /* Same pattern is being followed here, let the object itself set its properties. */
                dest.park = sender as? Park
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        /* This method does not call noOfItemsInSection or cellForItemAtIndex or any of the data source methods. It means you need to handle the functionality by yourself, of traversing all the cells and remove circled images if not in editing mode or show them if it is editing mode.  */
        
        /* This super call is very important because apple in itself providing edit functionalities. We are just adding over to those functionalities. If you don't call this then functionality provided by apple would not work and hence edit mode functionality concept would no longer be available. */
        super.setEditing(editing, animated: animated)
        
        /* Enabling or disabling the add button based on the editing mode. */
        addButton.isEnabled = !editing
        
        /* This is important if you want selection of multiple cells. */
        collectionView?.allowsMultipleSelection = editing
        
        /*
         This is not necessary now because we managed to show/hide toolbar in an efficient way. And this is inside toolbar only.
         deleteButton.isEnabled = editing
         */
        
        /*
         Could have specified it here but we want it to enable-disable based on at least one cell selection.
         navigationController?.isToolbarHidden = !editing
         
         Still we need to hide toolbar when state goes to non-editing. So write code for that below AND also handle one other scenario i.e when we select edit mode and at the time of selecting edit mode, if any one of the cells is selected then only show toolbar.
         */
        if !editing {
            navigationController?.isToolbarHidden = true
        } else {
            /* Concept of selection is only in editing mode and hence we used it here. */
            if let count = collectionView?.indexPathsForSelectedItems, !count.isEmpty {
                navigationController?.isToolbarHidden = false
            }
        }
        
        /* This is a nice way to traverse through cells when mode changes its state i.e from edit to normal or from normal to edit. */
        guard let indexes = collectionView?.indexPathsForVisibleItems else {
            return
        }
        
        for index in indexes {
            let cell = collectionView?.cellForItem(at: index) as! CollectionViewCell
            cell.isEditing = editing
        }
    }
    
    @IBAction func addItem() {
        /* In this method, they have updated data model by adding the item and returned the indexPath of addedItem. */
        let index = dataSource.indexPathForNewRandomPark()
        
        /* This object of "FlowLayout" you can fetch anywhere like this. It would be the same instance everytime. */
        let flowLayout = collectionView?.collectionViewLayout as! FlowLayout
        flowLayout.addedItem = index
        
        /* When you call this insertItems method then items would get added in collection view but before adding, "initialLayoutAttributesForAppearingItem" method would get called in custom layout class so that you can present animation while adding items. */
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: [], animations: {
            /* Never use reload data method on collection views, that is very inefficient. */
            self.collectionView?.insertItems(at: [index])
        }) { (finished: Bool) in
            flowLayout.addedItem = nil
        }
        
        /* You could also do this. */
        /* Using "performBatchUpdates" method you can update or add multiple items at the same time i.e all the animations would be shown at the same time. So collectionView is assuming it as a single update. If you take this loop, outside the batch method then animations for inserted items would be shown differently and hence bad way. */
        collectionView?.performBatchUpdates({
            // have loop here and perform batch update
        }, completion: nil)
    }
    
    @IBAction func deleteSelected() {
        
        /* I want this method to work only in edit mode because only in edit mode collection view will track of selected cells for us. There is no concept of "indexPathsForSelectedItems" in edit mode. */
        if isEditing {
            if let selected = collectionView?.indexPathsForSelectedItems {
                
                (collectionView?.collectionViewLayout as! FlowLayout).deletedItems = selected
                
                /* This updated the data model. */
                /* Theoritically speaking, IndexPath.item = IndexPath.row in case of Collection View but IndexPath.item makes more intuitive sense in case of Collection View. So stick with that. Please note that while deleting from data model here, array has to be in reversed sorted order otherwise app could crash because of indexOutOfBounds. Think yourself --> Hint: by deleting one item, positioning of other items change that's why problem could occur. So handle this scenario properly. */
                dataSource.deleteItemsAtIndexPaths(selected)
                
                /* When you call this deleteItems method then items would get deleted from collection view but before deleting, "finalLayoutAttributesForDisappearingItem" method would get called in custom layout class so that you can present animation while deleting items. */
                /* This will call data source methods to check. So we should always delete items first from our backing data model which we did. */
                // This is called as batch deletion.
                collectionView?.deleteItems(at: selected)
                
                /* After pressing delete button, we should also hide toolbar. So that's why did this. */
                navigationController?.isToolbarHidden = true
            }
        }
    }
}


//MARK: - Collection View Datasource Methods
extension MainNationalParksViewController {
    
    /* "isEditing" is the property which is coming from UIViewController. UICollectionViewController inheriting from UIViewController. So, using this property in this View Controller, we can easily get to know whether mode is editing mode or non-editing(normal) mode. */
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfParksInSection(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        /*
         If you were not made custom cell class then you could have accessed the elements inside cell using their tags.
         
         if let label = cell.viewWithtag(100) as? UILabel {
         label.text = collectionData[indexPath.row]
         }
         ...so on ... many more other elements
         */
        
        /* Always follow this pattern. Let the custom cell object handle everything related to itself. */
        cell.park = dataSource.parkForItemAtIndexPath(indexPath)
        
        /* This "isEditing" property on the right side is the property of UIViewController class which tells about the current editing state i.e whether current state is editing state or normal state. We are changing states based on the editButtonItem on navigation item. */
        cell.isEditing = isEditing
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        /* we can check the kind here like this [in order to check whether it is header or footer]:  kind == UICollectionElementKindSectionHeader OR kind == UICollectionElementKindSectionFooter. */
        
        let reusableSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! CollectionViewSectionHeader
        
        /* Remember this pattern, you have to do it exactly like this. */
        reusableSectionHeaderView.sectionInfo = dataSource.getSectionInfoAtIndexPath(indexPath)
        
        return reusableSectionHeaderView
    }
    
}


//MARK: - CollectionView Delegate Methods
extension MainNationalParksViewController {
    
    /* "isEditing" is the property which is coming from UIViewController. UICollectionViewController inheriting from UIViewController. So, using this property in this View Controller, we can easily get to know whether mode is editing mode or non-editing(normal) mode. */
    
    /* One way to perform action when cell is selected is this. This is the way when there is no edit mode. And generally this should not be used when cell is in edit mode. That's why I put filter on this. When cell is in edit mode then look at the Cutom UICollectionViewCell class's property. */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let park = dataSource.parkForItemAtIndexPath(indexPath)
            performSegue(withIdentifier: "DetailSegue", sender: park)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    /* This method would be called at the time of de-selection of a cell, which makes sense only when cells are in edit mode. And this would be called after the "isSelected" property observer. */
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    /* This would be called when cell is long pressed. */
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /* This updation of datasource is mandatory otherwise whatever shown in collection view would not be consistent with the data source. */
        dataSource.moveParkAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}


//MARK: - Collection View Delegate FlowLayout Methods
/* Whatever things you do using methods of this protocol can be done using the FlowLayout class which inherits from UICollectionViewFlowLayout class. Here we need to return but there we need to set properties explicity which are coming from super class. Remember that these delegate methods would be called after the "prepare" method of custom layout class. */
extension MainNationalParksViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        /* This below thing can be done in "prepare" method of FlowLayout class. "prepare" method would be called before these delegate methods. */
        
        /* For sticky headers */
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true

        /* So this is the advantage here, we don't need to get the layout object from collection view and then set its itemSize. This method in delegate flow layout will take care of things. */
        let width = collectionView.frame.size.width / columns
        return CGSize(width:width, height:width)
    }
}
