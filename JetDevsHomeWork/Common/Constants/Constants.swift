//
//  Constants.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit

// Constant Strings
let loggedInUserStr = "LoggedInUser"
let createdDateFormate = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let emailStr = "Email"
let passwordStr = "Password"
let xAccHeaderTokenStr = "xAccHeader"
let applicationJsonStr = "application/json"
let contentTypeStr = "Content-Type"
let loadingStr = "Loading.."
let somethingWentWrongStr = "Something went wrong!"
let unknownErrorStr = "Unknown error"

let screenFrame: CGRect = UIScreen.main.bounds
let screenWidth = screenFrame.size.width
let screenHeight = screenFrame.size.height

let isIPhoneX = (screenWidth >= 375.0 && screenHeight >= 812.0) ? true : false
let isIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false

let statusBarHeight: CGFloat = isIPhoneX ? 44.0 : 20.0
let navigationBarHeight: CGFloat = 44.0
let statusBarNavigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0

let tabbarSafeBottomMargin: CGFloat = isIPhoneX ? 34.0 : 0.0
let tabBarHeight: CGFloat = isIPhoneX ? (tabBarTrueHeight+34.0) : tabBarTrueHeight
let tabBarTrueHeight: CGFloat = 49.0


/// Check for valid email.
/// Parameter email: The email which you want to validate.
/// Returns: A bool value show email is valid or not.
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func timeAgoString(from dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = createdDateFormate
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }
    
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date, to: currentDate)
    
    if let years = components.year, years > 0 {
        if years == 1 {
            return "1 year ago"
        } else {
            return "\(years) years ago"
        }
    } else if let months = components.month, months > 0 {
        if months == 1 {
            return "1 month ago"
        } else {
            return "\(months) months ago"
        }
    } else if let days = components.day, days > 0 {
        if days == 1 {
            return "1 day ago"
        } else {
            return "\(days) days ago"
        }
    } else {
        return "Today"
    }
}
