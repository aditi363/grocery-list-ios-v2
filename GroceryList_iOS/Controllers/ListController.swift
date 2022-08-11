//
//  ListController.swift
//  GroceryList_iOS
//
//  Created by Amandeep Singh on 2022-04-10.
//

import UIKit

class ListController: UIViewController {

    
    
    @IBOutlet weak var listname: UITextField!
    
    @IBOutlet weak var Amount: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var addbuttoon: UIButton!
    @IBOutlet weak var Itemname: UITextField!
    var listarray : [ListModel] = [ListModel]();
    
    var dbHelper = SQLiteHelper();
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TableView.delegate = self;
        TableView.dataSource = self;
        var a = dbHelper.connect();
        print("db connection == " + (a ? "True":"false"));
        
        a = dbHelper.createTable()
        print("db create table == " + (a ? "True":"false"));
        
    }
    

    @IBAction func addbuttontouched(_ sender: UIButton) {
        
        let list: ListModel = ListModel();
        list.listname = listname.text ?? "List Name";
        list.itemname = Itemname.text ?? "Item Name";
        list.quantity = Int(quantity.text ?? "0") ?? 0;
        list.cost = Double(Amount.text ?? "0.0") ?? 0.0;
        list.bought = 0;
        let p : Bool  = dbHelper.insertData(list: list)
        listarray = dbHelper.getdata(filter: list.listname);
        TableView.reloadData();
        addNotification(message: list.listname + " added to Grocery lists")
        
        
        print(p);
        
//        TableView.reloadData()
//        self.viewDidLoad()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addNotification(message:String){
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert,.sound])
           {(granted, error)in}
           let content = UNMutableNotificationContent()
           content.title = "Grocery List"
           content.body = message
           content.sound = .default
           let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
           let uuidString = UUID().uuidString
           let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: timeTrigger)
           center.add(request) { (error) in
           }
    }
    
    

}


extension ListController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped " + listarray[indexPath.row].itemname)
    }
    
}

extension ListController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listarray.count)
        return listarray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListViewCell
        cell.Itemname.text = listarray[indexPath.row].itemname;
        cell.quantity.text = String(listarray[indexPath.row].quantity);
        cell.cost.text = String(listarray[indexPath.row].cost);
        
        return cell;
    }
}
