//
//  ViewController.swift
//  GroceryList_iOS
//
//  Created by Amandeep Singh on 2022-04-10.
//

import UIKit
import WidgetKit

class HomeController: UIViewController {

    
    
    @IBOutlet weak var Createbutton: UIButton!
    
    @IBOutlet weak var HometableView: UITableView!
    var arrayoflist : [String]=[String]();
    var dbHelper = SQLiteHelper();
    
    @IBAction func testNotification(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Createbutton.addTarget(self, action: #selector(clickcreatebutton), for: .touchUpInside)
        
        HometableView.delegate = self;
        HometableView.dataSource = self;
        
        
        var a = dbHelper.connect();
        print("db connection == " + (a ? "True":"false"));
        
        a = dbHelper.createTable()
        print("db create table == " + (a ? "True":"false"));
        arrayoflist = dbHelper.getlistnames();
    }
    
    @objc func clickcreatebutton()
    {
        let story  = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "ListController") as! ListController
        let navigationcontroller  = UINavigationController(rootViewController: controller);
        self.present(navigationcontroller, animated: true, completion: nil)
    }
    
    @objc func clickdeletebutton(sender: UIButton)
    {
//        let story  = UIStoryboard(name: "Main", bundle: nil)
//        let controller = story.instantiateViewController(withIdentifier: "HomeController") as! HomeController
//        let navigationcontroller  = UINavigationController(rootViewController: controller);
//        self.present(navigationcontroller, animated: true, completion: nil)
        dbHelper.deletedata(listname: arrayoflist[sender.tag])
        print(sender.tag);
        arrayoflist = dbHelper.getlistnames();
        HometableView.reloadData();
        
        
        print("delete button touched  ");
        
    }
    
    override func viewWillAppear(_ animated : Bool) {
        arrayoflist = dbHelper.getlistnames();
        HometableView.reloadData(); // to reload selected cell
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewlistsegue")
        {
            let indexPath = self.HometableView.indexPathForSelectedRow!
            
            let viewlistController = segue.destination as! ViewListController;
            viewlistController.mylistname = arrayoflist[indexPath.row];
            
        }
    }

}




extension HomeController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped");
        
        self.performSegue(withIdentifier: "viewlistsegue", sender: self)
    }
}

extension HomeController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayoflist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = HometableView.dequeueReusableCell(withIdentifier: "Homecell", for: indexPath) as! HomeViewCell;
        cell.listname_home.text = arrayoflist[indexPath.row]
        cell.Deletebutton.tag = indexPath.row;
        cell.Deletebutton.addTarget(self, action: #selector(clickdeletebutton(sender:)), for: .touchUpInside)

            
        if ( indexPath.row == 0){
            cell.orangeCell.backgroundColor = UIColor.brown
            cell.favouriteIcon.isHidden = false
        }
        else{
            cell.orangeCell.backgroundColor = UIColor.orange
            cell.favouriteIcon.isHidden = true
        }
        
        
        return cell
    }
}

