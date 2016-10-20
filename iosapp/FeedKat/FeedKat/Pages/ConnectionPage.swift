//
//  ViewController.swift
//  FeedKat
//
//  Created by Mike OLIVA on 13/09/2016.
//  Copyright © 2016 Mike OLIVA. All rights reserved.
//

import UIKit

class ConnectionPage: UIViewController {

    //MARK : Properties
    @IBOutlet var account: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var UIcontent: UIView!
    
    @IBAction func tryConnection(_ sender: UIButton)
    {
        FeedKatAPI.login(account.text!.lowercased(), password: password.text!)
        {
            response, error in
            if(error == nil && response != nil)
            {
                let id = response!.value(forKey: "id_user") as? String
                if(id != nil)
                {
                    Static.userId = Int(id!)!
                    FeedKatAPI.getCatbyUserId(Static.userId)
                    {
                        response, error in
                        if(error == nil)
                        {
                            let ar = response?.value(forKey: "cats") as? [NSDictionary]
                            if(ar != nil)
                            {
                                for a in ar!
                                {
                                    a.value(forKey: "")
                                }
                            }
                            self.performSegue(withIdentifier: "gotoDashBoard", sender: self)
                        }
                        else
                        {
                            print("error getCatbyId : \(error)")
                        }
                    }
                }
                else
                {
                    print("error Id")
                }
            }
            else
            {
                let pop = popUp(view: self.UIcontent, text: "Le couple Login/MotDePasse incorrect")
//                self.UIcontent.addSubview(pop)
                pop.ViewFunc()
            }
        }
    }
    
    @IBAction func gotoRegister(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

