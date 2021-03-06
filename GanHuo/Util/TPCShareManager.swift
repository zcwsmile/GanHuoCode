//
//  TPCShareManager.swift
//  WKCC
//
//  Created by tripleCC on 15/11/22.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

import UIKit
import MonkeyKing

let SINAAPPKEY = "3199956444"
let SINASECRET = "e1d432235af5294b6f2a461b5bbce02f"
let REDIRECTURL = "http://triplecc.github.io/"

let QQAPPID = "1104952241"
let QQAPPKEY = "H1ZRpoVdQXKX7F1q"

let WXAPPID = "wxf2761a30bf35afd1"
let WXSECRET = "a042b3ae84766ae67f5d507167200a43"

class TPCShareManager {
    var accessTokenWeiBo: String?
    var accessTokenWX: String?
    var accessTokenQQ: String?
    var shareing: Bool = false
    static let shareInstance = TPCShareManager()
    
    func registerSinaAccount() {
        let accountWeiBo = MonkeyKing.Account.Weibo(appID: SINAAPPKEY, appKey: SINASECRET, redirectURL: REDIRECTURL)
        MonkeyKing.registerAccount(accountWeiBo)
        if !accountWeiBo.isAppInstalled {
            MonkeyKing.OAuth(accountWeiBo, completionHandler: { (dictionary, response, error) -> Void in
                if let json = dictionary, accessToken = json["access_token"] as? String {
                    self.accessTokenWeiBo = accessToken
                }
                
                print("dictionary \(dictionary) error \(error)")
            })
        }
    }
    
    func registerQQAccount() {
        let accountQQ = MonkeyKing.Account.QQ(appID: QQAPPID)
        MonkeyKing.registerAccount(accountQQ)
        if !accountQQ.isAppInstalled {
            MonkeyKing.OAuth(accountQQ, completionHandler: { (dictionary, response, error) -> Void in
                if let json = dictionary, accessToken = json["access_token"] as? String {
                    self.accessTokenQQ = accessToken
                }
                
                print("dictionary \(dictionary) error \(error)")
            })
        }
    }
    
    func registerWXAccount() {
        let accountWX = MonkeyKing.Account.WeChat(appID: WXAPPID, appKey: WXSECRET)
        MonkeyKing.registerAccount(accountWX)
        if !accountWX.isAppInstalled {
            MonkeyKing.OAuth(accountWX, completionHandler: { (dictionary, response, error) -> Void in
                if let json = dictionary, accessToken = json["access_token"] as? String {
                    self.accessTokenWX = accessToken
                }
                
                print("dictionary \(dictionary) error \(error)")
            })
        }
    }
    
    func shareSinaWithTitle(title: String?, desc: String?, image: UIImage? = nil, mediaURL: NSURL? = nil) {
        registerSinaAccount()
        shareing = true
        let lMediaURL: MonkeyKing.Media?
        if image == nil && mediaURL == nil {
            lMediaURL = nil
        } else if image != nil && mediaURL == nil {
            lMediaURL = MonkeyKing.Media.Image(image!)
        } else {
            lMediaURL = MonkeyKing.Media.URL(mediaURL!)
        }
        
        debugPrint(title, desc, image)
        let message = MonkeyKing.Message.Weibo(.Default(info: (
            title: title,
            description: desc,
            thumbnail: image,
            media: lMediaURL
            ), accessToken: accessTokenWeiBo))

        MonkeyKing.shareMessage(message) { success in
            self.shareing = false
            print("success: \(success)")
        }
    }
    
    func shareQQWithTitle(title: String?, desc: String?, image: UIImage? = nil, mediaURL: NSURL? = nil) {
        registerQQAccount()
        shareing = true
        let lMediaURL: MonkeyKing.Media?
        if image == nil && mediaURL == nil {
            lMediaURL = nil
        } else if image != nil && mediaURL == nil {
            lMediaURL = MonkeyKing.Media.Image(image!)
        } else {
            lMediaURL = MonkeyKing.Media.URL(mediaURL!)
        }
        
        debugPrint(title, desc, image)
        let message = MonkeyKing.Message.QQ(.Friends(info: (title: title, description: desc, thumbnail: image, media: lMediaURL)))
        MonkeyKing.shareMessage(message) { success in
            self.shareing = false
            print("success: \(success)")
        }
    }
    
    func shareQQZoneWithTitle(title: String?, desc: String?, image: UIImage? = nil, mediaURL: NSURL? = nil) {
        registerQQAccount()
        shareing = true
        let lMediaURL: MonkeyKing.Media?
        if image == nil && mediaURL == nil {
            lMediaURL = nil
        } else if image != nil && mediaURL == nil {
            lMediaURL = MonkeyKing.Media.Image(image!)
        } else {
            lMediaURL = MonkeyKing.Media.URL(mediaURL!)
        }
        
        debugPrint(title, desc, image)
        let message = MonkeyKing.Message.QQ(.Zone(info: (title: title, description: desc, thumbnail: image, media: lMediaURL)))
        MonkeyKing.shareMessage(message) { success in
            self.shareing = false
            print("success: \(success)")
        }
    }
    
    func shareWXWithTitle(title: String?, desc: String? = nil, image: UIImage? = nil, mediaURL: NSURL? = nil) {
        registerWXAccount()
        shareing = true
        let lMediaURL: MonkeyKing.Media?
        let shareImage = image?.getShareImage()
        if shareImage == nil && mediaURL == nil {
            lMediaURL = nil
        } else if shareImage != nil && mediaURL == nil {
            lMediaURL = MonkeyKing.Media.Image(shareImage!)
        } else {
            lMediaURL = MonkeyKing.Media.URL(mediaURL!)
        }
        let message = MonkeyKing.Message.WeChat(.Session(info: (title: title, description: desc, thumbnail: shareImage, media: lMediaURL)))
        MonkeyKing.shareMessage(message) { success in
            self.shareing = false
            print("success: \(success)")
        }
    }
}

extension UIImage {
    //Share we chat fail when image is too big
    func getShareImage() -> UIImage {
        let maxSize = CGSize(width: 400, height: 400)
        let xScale = maxSize.width / self.size.width;
        let yScale = maxSize.height / self.size.height;
        let minScale = min(xScale, yScale);
        
        UIGraphicsBeginImageContextWithOptions(self.size, true, minScale)
        self.drawAtPoint(CGPointZero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}