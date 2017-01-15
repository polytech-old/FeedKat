//
//  Cat.swift
//  FeedKat
//
//  Created by Mike OLIVA on 07/10/2016.
//  Copyright © 2016 Mike OLIVA. All rights reserved.
//

import UIKit

class Cat:NSObject
{
    static var list:[Cat] = []
    var Name:String
    var ID:Int
    var Status:Int
    var Message:String
    var Photo:String
    var Birthdate:Date
    var feeds:[FeedTime]
    var image:UIImage? = nil
    var loaded:Bool = false
    var weight:Int = 1000
    var statusBattery:Int = 75
    var historyWeight:[Int] = [Int]()
    var historyActivity:[Int] = [Int]()
    
    static func getList() -> [Cat]
    {
        return list
    }
    
    init(ID: Int, Name: String, Message:String, Photo:String, Status:Int, Weight:Int, FeedTimes : [NSDictionary]?)
    {
        self.Name = Name
        self.ID = ID
        self.Message = Message
        self.Status = Status
        self.Photo = Photo
        self.Birthdate=Date()
        self.weight = Weight
        self.feeds = []
        if(FeedTimes != nil)
        {
            for a in FeedTimes!
            {
                let id_ft = a.value(forKey: "id_feedtime") as! Int
                let id_ds = a.value(forKey: "id_dispenser") as! Int
                let time = a.value(forKey: "time") as! String
                let weight = a.value(forKey: "weight") as! Int
                let iena = a.value(forKey: "enabled") as! Int
                let ena = iena == 1
                
                feeds.append(FeedTime(ID: id_ft, Id_cat: ID, Id_dispenser: id_ds, Weight: weight, Hour: time, Enable: ena))
            }
        }
        super.init()
        Cat.list.append(self)
    }
    
    func getDetails(handler: @escaping(Bool?)->())
    {
        if(loaded)
        {
            handler(true)
            return
        }
        FeedKatAPI.getCatDetails(ID)
        {
            response, error in
            if(error == nil)
            {
                let cats = response?.value(forKey: "cats") as! NSDictionary
                self.statusBattery = cats.value(forKey: "battery") as? Int ?? -1
                self.loaded = true
                let sDate = cats.value(forKey: "birth") as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.Birthdate = dateFormatter.date(from: sDate)!
                self.historyActivity = cats.value(forKey: "activity_histo") as! [Int]
                self.historyWeight = cats.value(forKey: "weight_histo") as! [Int]
                
                handler(true)
            }
            else
            {
                handler(false)
            }
        }
    }
    
    func getName() -> String
    {
        return self.Name
    }
    
    func getID() -> Int
    {
        return self.ID
    }
    
    func getMessage() -> String
    {
        return self.Message
    }
    
    func getPhoto() -> String
    {
        return self.Photo
    }
    
    func getStatus() -> Int
    {
        return self.Status
    }
    
    func getBirthdate() -> Date
    {
        return self.Birthdate;
    }
    
    func getFeeds() -> [FeedTime]
    {
        return self.feeds
    }
}
