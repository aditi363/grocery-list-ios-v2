//
//  ViewListController.swift
//  GroceryList_iOS
//
//  Created by Amandeep Singh on 2022-04-13.
//

import UIKit

class ViewListController: UIViewController {

    
    var listarray : [ListModel] = [ListModel]();
    @IBOutlet weak var ViewList: UITableView!
    var dbHelper = SQLiteHelper();
    var mylistname : String?;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ViewList.delegate = self;
        ViewList.dataSource = self;
        var a = dbHelper.connect();
        print("db connection == " + (a ? "True":"false"));
        
        a = dbHelper.createTable()
        print("db create table == " + (a ? "True":"false"));
        listarray = dbHelper.getdata(filter: mylistname ?? "");
        self.navigationItem.title = mylistname;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension ViewListController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped " + listarray[indexPath.row].itemname)
    }
    
}

extension ViewListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listarray.count)
        return listarray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ViewList.dequeueReusableCell(withIdentifier: "viewlistcell", for: indexPath) as! Viewlistcell
        cell.itemname.text = listarray[indexPath.row].itemname;
        cell.quantity.text = String(listarray[indexPath.row].quantity);
        cell.cost.text = String(listarray[indexPath.row].cost);
        
        return cell;
    }
}
