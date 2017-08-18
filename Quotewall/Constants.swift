//
//  Constants.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/18/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation

public struct Constants {
    public static let receivedQuoteRecordIDKey = "receivedQuoteRecordID"
    
    //Notification Center notification names
    
    public static let sharedQuotesFetchedNotification: Notification.Name = Notification.Name(rawValue: "sharedQuotesFetched")
    
    public static let favoriteQuotesFetchedNotification: Notification.Name = Notification.Name(rawValue: "favoriteQuotesFetched")
    
    public static let personalQuotesFetchedNotification: Notification.Name = Notification.Name(rawValue: "personalQuotesFetched")
    
    public static let currentUserFetchedSuccessful: Notification.Name = Notification.Name(rawValue: "currentUserFetched")
    
    
}
