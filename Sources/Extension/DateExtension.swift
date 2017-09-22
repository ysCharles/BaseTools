//
//  DateExtension.swift
//  BaseProject
//
//  Created by Charles on 09/03/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import Foundation

//日期拓展属性
extension Date {
    /// 返回当前日期 年份
    public var currentYear:Int{
        
        get{
            
            return GetFormatDate("yyyy")
        }
        
    }
    /// 返回当前日期 月份
    public var currentMonth:Int{
        
        get{
            
            return GetFormatDate("MM")
        }
        
    }
    /// 返回当前日期 天
    public var currentDay:Int{
        
        get{
            
            return GetFormatDate("dd")
        }
        
    }
    /// 返回当前日期 小时
    public var currentHour:Int{
        
        get{
            
            return GetFormatDate("HH")
        }
        
    }
    /// 返回当前日期 分钟
    public var currentMinute:Int{
        
        get{
            
            return GetFormatDate("mm")
        }
        
    }
    /// 返回当前日期 秒数
    public var currentSecond:Int{
        
        get{
            
            return GetFormatDate("ss")
        }
        
    }
    
    /// 获取格式化时间
    ///
    /// - Parameter format: 例：yyyy  MM  dd  HH mm ss 比如 GetFormatDate(yyyy) 返回当前日期年份
    /// - Returns:
    func GetFormatDate(_ format:String)->Int{
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = format;
        let dateString:String = dateFormatter.string(from: self);
        var dates:[String] = dateString.components(separatedBy: "")
        let Value  = dates[0]
        if(Value==""){
            return 0
        }
        return Int(Value)!
    }
    
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth(_ date : Date   ) -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return totaldaysInMonth.length
    }
    /**
     这个月有几天
     
     - parameter date: nsdate
     
     - returns: 天数
     */
    func TotaldaysInThisMonth() -> Int {
        let totaldaysInMonth: NSRange = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: self)
        return totaldaysInMonth.length
    }
}
