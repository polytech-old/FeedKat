import UIKit

class TabTile:Tile
{
    var UiImage:UIImageView!
    var cat:Cat
    var type:Int?
    var nameText:UILabel?
    var nameEdit:UITextField?
    var name:String = ""
    var eLabel:UILabel?
    var tLabel:UILabel?
    
    init(cat:Cat, type:Int)
    {
        self.cat = cat
        self.type = type
        super.init(type: type)
        self.frame = CGRect (x: 0, y: 0, width: Static.tileWidth, height: Static.tileHeight*3)
        let top = UIView(frame: CGRect(x: 0, y: 0, width: Static.tileWidth, height: Static.tileHeight*0.6))
        top.backgroundColor = Static.BlueColor
        var title:String = ""
        switch type
        {
        case 0:
            title = "Informations"
        case 1:
            title = "FeedTimes"
        case 2:
            title = "Graphiques"
        default: break
        }
        tLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Static.tileWidth, height: Static.tileHeight*0.6))
        tLabel!.text = title
        tLabel!.textColor = UIColor.white
        tLabel!.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        tLabel!.textAlignment = NSTextAlignment.center
        
        top.addSubview(tLabel!)
        self.addSubview(top)
        
    }
    
    func setContent(type: Int)
    {
        switch type
        {
        case 0:
            initInfo()
        case 1:
            initFeed()
        case 2:
            initGraph()
        default: break
            
        }
    }
    
    func initInfo()
    {
        let offsetx = Static.tileWidth*0.04 + Static.tileHeight*1.2
        let offsety = Static.tileHeight*0.6 + Static.tileWidth*0.02
        self.name = cat.getName()
        
        eLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Static.tileWidth - Static.tileWidth*0.02, height: Static.tileHeight*0.6))
        eLabel!.text = "Editer"
        eLabel!.textColor = Static.OrangeColor
        eLabel!.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        eLabel!.textAlignment = NSTextAlignment.right
        eLabel!.isUserInteractionEnabled = true
        let aSelector : Selector = #selector(TabTile.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        eLabel!.addGestureRecognizer(tapGesture)
        
        nameText = UILabel(frame:CGRect(x: Static.tileWidth*0.03, y: Static.tileHeight*1.2 + offsety, width: Static.tileWidth*0.6, height: Static.tileHeight*0.2))
        nameText!.text = name
        nameText!.textColor = UIColor.black
        nameText!.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        nameText!.textAlignment = NSTextAlignment.left
        nameText!.isHidden = false
        
        nameEdit = UITextField(frame:CGRect(x: Static.tileWidth*0.03, y: Static.tileHeight*1.2 + offsety, width: Static.tileWidth*0.6, height: Static.tileHeight*0.2))
        nameEdit!.text = name
        nameEdit!.textColor = Static.BlueColor
        nameEdit!.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        nameEdit!.textAlignment = NSTextAlignment.left
        nameEdit!.isHidden = true

        addSubview(nameText!)
        addSubview(nameEdit!)
        addSubview(eLabel!)
        
        UiImage = UIImageView(frame : CGRect(x: Static.tileWidth*0.01, y: Static.tileHeight*0.6, width: Static.tileHeight*1.2, height: Static.tileHeight*1.2))
        
        if(self.cat.getPhoto() != "")
        {
            if(self.cat.image == nil)
            {
                self.UiImage.image = Static.getScaledImageWithHeight("Icon", height: Static.tileHeight)
                if let checkedUrl = URL(string: cat.getPhoto())
                {
                    UiImage.contentMode = .scaleAspectFit
                    FeedKatAPI.downloadImage(url: checkedUrl, view: UiImage)
                    {
                        data in
                        self.cat.image = data
                    }
                }
            }
            else
            {
                UiImage.image = cat.image!
            }
        }
        else
        {
            self.UiImage.image = Static.getScaledImageWithHeight("Icon", height: Static.tileHeight)
        }
        
        addSubview(UiImage)
        
        let bat = UILabel(frame: CGRect(x: offsetx, y: offsety, width: Static.tileWidth*0.6, height: Static.tileHeight*0.3))
        bat.text = "Batterie : \(cat.statusBaterie)%"
        bat.textColor = UIColor.black
        bat.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        bat.textAlignment = NSTextAlignment.left
        addSubview(bat)
        
        let weight = UILabel(frame: CGRect(x: offsetx, y: offsety + Static.tileHeight*0.3, width: Static.tileWidth*0.6, height: Static.tileHeight*0.3))
        weight.text = "Poids : \(Double(cat.weight)*0.001)Kg"
        weight.textColor = UIColor.black
        weight.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        weight.textAlignment = NSTextAlignment.left
        addSubview(weight)
        
    }
    
    func initFeed()
    {
        
    }
    
    func initGraph()
    {
        
    }
    
    func lblTapped()
    {
        if(nameText!.isHidden)
        {
            _ = textFieldShouldReturn(userText: nameEdit!)
        }
        else
        {
            eLabel!.text = "Valider"
            nameText!.isHidden = true
            nameEdit!.isHidden = false
            nameText!.text = nameEdit!.text

        }
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool
    {
        userText.resignFirstResponder()
        nameEdit!.isHidden = true
        nameText!.isHidden = false
        nameText!.text = nameEdit!.text
        eLabel!.text = "Editer"
        name = nameEdit!.text!
        
        FeedKatAPI.modifyCat(cat.getID(), key: "name", data: name as NSObject)
        {
            response, error in
            if(error == nil)
            {
                print("Ici")
                self.cat.Name = self.name
                self.tLabel!.text = self.name
                
            }
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
