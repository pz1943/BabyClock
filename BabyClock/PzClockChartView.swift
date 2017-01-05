//
//  PzClockChartView.swift
//  PzClockChart
//
//  Created by pz1943 on 2016/12/26.
//  Copyright © 2016年 pz1943. All rights reserved.
//

import UIKit

class PzClockChartView: UIView {

    private var scale: CGFloat = 0.75
    private var scaleLength: CGFloat = 10
    private var spaceFromTop:CGFloat = 10
    
    open var chartDate: [ClockChartData] = []
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let radius = min(rect.height * scale, rect.width * scale) / 2
        let ringRadius = radius - scaleLength
        let originX = rect.width / 2 - ringRadius
        let originY:CGFloat = spaceFromTop + scaleLength
        let centerX = rect.width / 2
        let centerY = scaleLength + radius
        let center = CGPoint(x: centerX, y: centerY)
//        let origin = CGPoint(x: originX, y: originY)
        
        //draw ring
        UIColor.lightGray.setStroke()

        let clockRect =  CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: ringRadius * 2, height: ringRadius * 2))
        let path = UIBezierPath(ovalIn: clockRect)
        path.lineWidth = 2
        path.stroke()
        
        //draw scales
        for i in 0 ... 24 {
            let angle:CGFloat = CGFloat(i) * CGFloat(M_PI) / 12
            var beginPoint = pointsOnCircle(center: center, radius: radius, angle: angle)
            var scaleBlank: CGFloat = 0
            if i % 6 == 0 {
                scaleBlank = 1
            } else {
                scaleBlank = scaleLength * 3 / 5
            }
            let endPoint = pointsOnCircle(center: center, radius: ringRadius + scaleBlank, angle: angle)
            if i == 0 {
               beginPoint = center
                print("beginPoint = \(beginPoint) endPoint = \(endPoint)")
            }
            let path = UIBezierPath()
            path.move(to: beginPoint)
            path.addLine(to: endPoint)
            path.lineWidth = 1
            path.stroke()
        }
        
        //draw date
        for data in chartDate {
            let calendar = Calendar(identifier: .chinese)
            var startHour = calendar.component(.hour, from: data.begin)
            startHour = startHour > 12 ? startHour - 12 : startHour
            let startMinute = calendar.component(.minute, from: data.begin)
            var endHour = calendar.component(.hour, from: data.end)
            endHour = endHour > 12 ? endHour - 12 : endHour
            let endMinute = calendar.component(.minute, from: data.end)
            
            let start = Double(startHour * 60 + startMinute)
            let end = Double(endHour * 60 + endMinute)
            let startAngle = CGFloat(start / 720 * M_PI * 2)
            let endAngle = CGFloat(end / 720 * M_PI * 2)
            
            let startPoint = pointsOnCircle(center: center, radius: ringRadius - 1, angle: startAngle)
            let path = UIBezierPath(arcCenter: center, radius: ringRadius - 1, startAngle: startAngle - CGFloat(M_PI/2), endAngle: endAngle - CGFloat(M_PI/2), clockwise: true)
            path.addLine(to: center)
            path.addLine(to: startPoint)
            let color = data.color.withAlphaComponent(0.5)
            color.setFill()
            path.fill()
        }
    }
    
    func pointsOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * CGFloat(sin(angle))  , y: center.y - radius * CGFloat(cos(angle)))
    }
}

struct ClockChartData {
    var begin: Date
    var end: Date
    var color: UIColor
}
