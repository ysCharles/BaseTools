//
//  StringExtension.swift
//  wxsmk
//
//  Created by Charles on 21/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import UIKit

extension String {
    
    /// trim 去掉字符串前后的空白字符
    public mutating func trim() {
        self = self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    /// 字符串时间转换 （返回 x分钟前/x小时前/昨天/x天前/x个月前/x年前）
    /// 注意，格式必须正确 默认 yyyy-MM-dd HH:mm:ss 类型字符 否则转换出错
    /// - Returns: 距离现在的时间字符串
    public func compareCurrentTime(formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        //把字符串转为 Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let date: Date = dateFormatter.date(from: self)!
        
        let curDate = Date()
        let time: TimeInterval = -date.timeIntervalSince(curDate)
        
        let year:Int = (Int)(curDate.currentYear - date.currentYear);
        let month:Int = (Int)( curDate.currentMonth - date.currentMonth);
        let day:Int = (Int)(curDate.currentDay - date.currentDay);
        
        var  retTime:TimeInterval = 1.0;
        
        // 小于一小时
        if (time < 3600) {
            retTime = time / 60
            retTime = retTime <= 0.0 ? 1.0 : retTime
            if(retTime.format(".0")=="0"){
                return "刚刚"
            }
            else{
                return retTime.format(".0")+"分钟前"
            }
        }
            // 小于一天，也就是今天
        else if (time < 3600 * 24) {
            retTime = time / 3600
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return retTime.format(".0")+"小时前"
        }
            // 昨天
        else if (time < 3600 * 24 * 2) {
            return "昨天"
        }
            // 第一个条件是同年，且相隔时间在一个月内
            // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
        else if ((abs(year) == 0 && abs(month) <= 1)
            || (abs(year) == 1 &&  curDate.currentMonth == 1 && date.currentMonth == 12)) {
            var   retDay:Int = 0;
            // 同年
            if (year == 0) {
                // 同月
                if (month == 0) {
                    retDay = day;
                }
            }
            
            if (retDay <= 0) {
                // 这里按月最大值来计算
                // 获取发布日期中，该月总共有多少天
                let totalDays:Int = date.TotaldaysInThisMonth()
                
                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
                retDay = curDate.currentDay + (totalDays - date.currentDay)
                
                if (retDay >= totalDays) {
                    let value = abs(max(retDay / date.TotaldaysInThisMonth(), 1))
                    return  value.description + "个月前"
                }
            }
            return abs(retDay).description + "天前"
        }
        else  {
            if (abs(year) <= 1) {
                if (year == 0) { // 同年
                    return abs(month).description+"个月前"
                }
                
                // 相差一年
                let month:Int =  curDate.currentMonth
                let preMonth:Int = date.currentMonth
                
                // 隔年，但同月，就作为满一年来计算
                if (month == 12 && preMonth == 12) {
                    return  "1年前"
                }
                // 也不看，但非同月
                return abs(12 - preMonth + month).description + "个月前"
                
            }
            return abs(year).description + "年前"
        }
        
    }
}
