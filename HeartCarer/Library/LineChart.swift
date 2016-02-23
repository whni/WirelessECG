//
//  LineChart.swift
//  HeartCarer
//
//  Pulled from Github
//  Re-written by Weiheng Ni
//

import UIKit
import QuartzCore


// Dot layer class for the line chart
class DotCALayer: CALayer {
    
    var innerRadius: CGFloat = 8
    var dotInnerColor = UIColor.blackColor()
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject!) {
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        var inset = self.bounds.size.width - innerRadius
        var innerDotLayer = CALayer()
        innerDotLayer.frame = CGRectInset(self.bounds, inset/2, inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.CGColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
    
}


// delegate method
protocol LineChartDelegate {
    func didSelectDataPoint(point: CGPoint)
}


// LineChart class
class LineChart: UIControl {
    
    // coordinate configuration
    // data coordinate (to draw dataOrigin.x--xDataLength-- ||| dataOrigin.y--yDataLength--)
    var dataFollowMode: Bool = false
    var dataOrigin: CGPoint = CGPointMake(0.0, 0.0)
    var xDataLength: CGFloat = 10.0
    var yDataLength: CGFloat = 5.0
    // drawing coordinate
    var drawingHeight: CGFloat {
        get {
            return self.bounds.height - (2 * axisInset)
        }
    }
    var drawingWidth: CGFloat {
        get {
            return self.bounds.width - (2 * axisInset)
        }
    }
    // drawing <---> machine coordinate methods
    internal func xDtoM(x: CGFloat) -> CGFloat {
        return axisInset + x
    }
    internal func xMtoD(x: CGFloat) -> CGFloat {
        return x - axisInset
    }
    internal func yDtoM(y: CGFloat) -> CGFloat {
        return self.bounds.height - axisInset - y
    }
    internal func yMtoD(y: CGFloat) -> CGFloat {
        return self.bounds.height - axisInset - y
    }
    
    internal func LCContextMoveToPoint(c: CGContext!, x: CGFloat, y: CGFloat) {
        CGContextMoveToPoint(c, xDtoM(x), yDtoM(y))
    }
    internal func LCContextAddLineToPoint(c: CGContext!, x: CGFloat, y: CGFloat) {
        CGContextAddLineToPoint(c, xDtoM(x), yDtoM(y))
    }

    // axes configuration
    var axesVisible = true
    var labelsXVisible = true
    var labelsYVisible = true
    var axisInset: CGFloat = 10
    var axisWidth: CGFloat = 1.0
    
    // grid configuration
    var gridVisible = true
    var numberOfGridLinesX: CGFloat = 10
    var numberOfGridLinesY: CGFloat = 10
    var gridLineWidth: CGFloat = 1.0
    

    // line & dot configuration
    var dotsVisible = false
    var lineWidth: CGFloat = 2
    var outerRadius: CGFloat = 12
    var innerRadius: CGFloat = 8
    var outerRadiusHighlighted: CGFloat = 12
    var innerRadiusHighlighted: CGFloat = 8
    
    var drawPointInterval: Int = 1
    var maxDrawPointInterval: Int = 1

    // animation configuration
    var animationEnabled = false
    var animationDuration: CFTimeInterval = 1
    
    // color configuration
    var lineColor = UIColor.blackColor()
    var dotsBackgroundColor = UIColor.whiteColor()
    var gridColor = UIColorPlatte.red500
    var axesColor = UIColorPlatte.red600

    
    // data stores
    var dataStore: Array<CGFloat> = []
    var lineLayer: CAShapeLayer? = nil
    var dotLayers: Array<DotCALayer> = []
    
    var delegate: LineChartDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // enable multiple touches for line chart
        self.multipleTouchEnabled = true
    }
    
    
    // touch event variables
    var oneTouchTrigger: Bool = false
    var twoTouchTrigger: Bool = false
    var touchXLock: Bool = true
    var touchYLock: Bool = true
    var preTouchedPoint: [CGPoint] = []     // drawing coordinate
    var preTouchedData: [CGPoint] = []      // data coordinate
    
    
    convenience override init() {
        self.init(frame: CGRectZero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // called when re-drawing the uicontrol region
    override func drawRect(rect: CGRect) {

        assert(drawingWidth >= 10.0 && drawingHeight >= 10.0 && xDataLength >= 1.0 && yDataLength > 0.0, "The coordinate system requires: \n 1) non-negative origin coordinates \n 2) at least 1-length x axis \n 3) positive-length y axis")
        
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove line layer (effective for layer-based line)
        lineLayer?.removeFromSuperlayer()
        lineLayer = nil
        
        // remove dot layers
        for dotLayer in dotLayers {
            dotLayer.removeFromSuperlayer()
        }
        dotLayers.removeAll()
        
        // clear all drawing region
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backgroundColor?.CGColor)
        CGContextFillRect(context, rect)
        
        // set x orgin in data follow mode
        if dataFollowMode == true {
            dataOrigin.x = round(CGFloat(dataStore.count) - xDataLength - 1)
            dataOrigin.x = dataOrigin.x < 0.0 ? 0.0 : dataOrigin.x
        }
        
        
        // set limits to the plot
        //dataOrigin.y = dataOrigin.y < 0.0 ? 0.0 : dataOrigin.y
        
        // the interval ranges from 'drawPointInterval' to at most 'maxDrawPointInterval'
        drawPointInterval = drawPointInterval <= 0 ? 1 : drawPointInterval
        maxDrawPointInterval = maxDrawPointInterval < drawPointInterval ? drawPointInterval : maxDrawPointInterval
        if xDataLength > drawingWidth * CGFloat(maxDrawPointInterval)  {
            xDataLength = drawingWidth * CGFloat(maxDrawPointInterval)
        }
        
        
        // draw grid
        if gridVisible { drawGrid() }
        
        // draw lines and cover protruding parts with background color
        drawDataStore()
        CGContextFillRect(context, CGRectMake(xDtoM(0), yDtoM(0), drawingWidth, axisInset))
        CGContextFillRect(context, CGRectMake(xDtoM(0), yDtoM(drawingHeight + axisInset), drawingWidth, axisInset))
        
        // draw axes
        if axesVisible { drawAxes() }
        
        // draw labels
        if labelsXVisible { drawXLabels() }
        if labelsYVisible { drawYLabels() }
 

    }
    
    
    //Draw x and y axis
    func drawAxes() {
        var height = self.bounds.height
        var width = self.bounds.width
        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, axesColor.CGColor)
        CGContextSetLineWidth(context, axisWidth)
        // draw x-axis
        CGContextMoveToPoint(context, axisInset, height-axisInset)
        CGContextAddLineToPoint(context, width-axisInset, height-axisInset)
        // draw y-axis
        CGContextMoveToPoint(context, axisInset, height-axisInset)
        CGContextAddLineToPoint(context, axisInset, axisInset)
        CGContextStrokePath(context)
    }
    
    
    
    // Draw grid
    func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    // Draw x grid
    func drawXGrid() {
        
        // coordinate in terms of data
        var xGridSpace = quantizeSpace(xDataLength / numberOfGridLinesX)
        var xFirstGrid = (xGridSpace - (dataOrigin.x % xGridSpace)) % xGridSpace
        // scale factor for transferring data coordinate into drawing metric
        var scaleFactor = drawingWidth / xDataLength
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        CGContextSetLineWidth(context, gridLineWidth)
        for var gridPos = xFirstGrid; gridPos <= xDataLength; gridPos += xGridSpace {
            LCContextMoveToPoint(context, x: gridPos * scaleFactor, y: 0)
            LCContextAddLineToPoint(context, x: gridPos * scaleFactor, y: drawingHeight)
        }
        CGContextStrokePath(context)
    }
    
    
    // Draw y grid
    func drawYGrid() {
        
        // coordinate in terms of data
        var yGridSpace = quantizeSpace(yDataLength / numberOfGridLinesY)
        var yFirstGrid = (yGridSpace - (dataOrigin.y % yGridSpace)) % yGridSpace
        // coordinate in terms of drawing metric
        var scaleFactor = drawingHeight / yDataLength
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor)
        for var gridPos: CGFloat = yFirstGrid; gridPos <= yDataLength; gridPos += yGridSpace {
            LCContextMoveToPoint(context, x: 0, y: gridPos * scaleFactor)
            LCContextAddLineToPoint(context, x: drawingWidth, y: gridPos * scaleFactor)
        }
        CGContextStrokePath(context)
    }
    
    
    // Draw x labels
    func drawXLabels() {
        // coordinate in terms of data
        var xLabelSpace = quantizeSpace(xDataLength / numberOfGridLinesX)
        var xFirstLabel = (xLabelSpace - (dataOrigin.x % xLabelSpace)) % xLabelSpace
        // coordinate in terms of drawing metric
        var scaleFactor = drawingWidth / xDataLength
        
        //  var context = UIGraphicsGetCurrentContext()
        
        for var labelPos = xFirstLabel; labelPos <= xDataLength; labelPos += xLabelSpace {
            var label = UILabel(frame: CGRect(x: 0, y: 0, width: axisInset*2, height: axisInset))
            label.center = CGPointMake(xDtoM(labelPos * scaleFactor), yDtoM(0) + axisInset/2)
            label.font = UIFont.systemFontOfSize(6)
            label.textAlignment = NSTextAlignment.Center
            label.text = String(Int(labelPos + dataOrigin.x) * plotSampleLen)
            self.addSubview(label)
            
        }
    }
    
    
    // Draw y labels
    func drawYLabels() {

        // coordinate in terms of data
        var yLabelSpace = quantizeSpace(yDataLength / numberOfGridLinesY)
        var yFirstLabel = (yLabelSpace - (dataOrigin.y % yLabelSpace)) % yLabelSpace
        // coordinate in terms of drawing metric
        var scaleFactor = drawingHeight / yDataLength

        for var labelPos: CGFloat = yFirstLabel; labelPos <= yDataLength; labelPos += yLabelSpace {
            var label = UILabel(frame: CGRect(x: 0, y: 0 , width: axisInset*2, height: axisInset))
            label.center = CGPointMake(xDtoM(0.0), yDtoM(labelPos * scaleFactor))
            label.font = UIFont.systemFontOfSize(6)
            label.textAlignment = NSTextAlignment.Center
            let nf = NSNumberFormatter()
            nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
            label.text = nf.stringFromNumber(labelPos + dataOrigin.y)
            self.addSubview(label)
        }
    }
    
    // quantization function for y grid space
    private func quantizeSpace(space: CGFloat) -> CGFloat {
        // for quantize digit to desired value
        func quantizeDigit(digit: Int) -> Int {
            switch (digit) {
            case 1...2:
                return 2
            case 3...5:
                return 5
            case 5...9:
                return 10
            default:
                return digit
            }
        }
        
        // get positive int part
        var spaceAbs = space
        if (space < 0.0) {
            spaceAbs = -space
        }
        var intPart: Int = Int(spaceAbs)
        
        if (intPart == 0) {
            var fracPart = spaceAbs
            var supZeros: CGFloat = 1.0
            while (fracPart < 1.0) {
                fracPart *= 10.0
                supZeros *= 10.0
            }
            var firstDigit: Int = Int(fracPart)
            firstDigit = quantizeDigit(firstDigit)
            return (CGFloat(firstDigit) / supZeros)
        } else {
            // obtain the first digit of integer part and quantize it
            var supZeros: Int = 1
            while (intPart > 9) {
                intPart /= 10
                supZeros *= 10
            }
            intPart = quantizeDigit(intPart)
            return CGFloat(intPart * supZeros)
        }
    }
    
    
    // Draw dataStore line from x = dataOrigin.x, at most (xDataLength + 1) points
    func drawDataStore() {
        
        var startDataIndex: Int = Int(dataOrigin.x)
        var dataLength: Int = Int(xDataLength) + 1
        dataLength = dataLength > (dataStore.count - startDataIndex) ? (dataStore.count - startDataIndex) : dataLength
        
        // check data length when only drawing some samples
        if dataLength <= 2 * drawPointInterval {
            return
        }
        
        // only draw some sample when there are too many points
        var pixelOnScreen: CGFloat = drawingWidth
        pixelOnScreen = pixelOnScreen > 0.0 ? pixelOnScreen : 10.0
        var dataDistByPixel: CGFloat = CGFloat(xDataLength + 1) / CGFloat(drawPointInterval) / pixelOnScreen
        
        var xAxisData: [CGFloat] = []
        var yAxisData: [CGFloat] = []
        
        // for testing
        /*
            1) plot one point per 'drawPointInterval' points
            2) sample rate gets lower when "drawPointInterval" points are drawn at one pixel
        */
        if dataDistByPixel > 1.0 {
            
            // draw one data every two pixels
            for var pixelIndex: Int = 0; CGFloat(pixelIndex) < pixelOnScreen; pixelIndex++ {
                
                // sampl'/'/ e points (pixel --> data)
                var xDataStart = startDataIndex + Int(round(dataDistByPixel * CGFloat(drawPointInterval) * CGFloat(pixelIndex)))
                
                // out of range
                if xDataStart >= (startDataIndex + dataLength) {
                    break
                } else if xDataStart < 0 {
                    continue
                }
                
                xAxisData.append(CGFloat(xDataStart))
                yAxisData.append(dataStore[xDataStart])
            }
            
        } else {
            
            // draw all data
            var xDataIndex = startDataIndex + drawPointInterval - abs(startDataIndex % drawPointInterval)
            for ; xDataIndex < (startDataIndex + dataLength); xDataIndex += drawPointInterval {
                
                if xDataIndex >= 0 {
                    
                    xAxisData.append(CGFloat(xDataIndex))
                    yAxisData.append(dataStore[xDataIndex])
                }
            }
        }
        
        
        if (xAxisData.count <= 1) {
            return
        }
        
        //println(xDataLength)
        drawStrokeBasedLine(scaleDataXAxis(xAxisData), yAxis: scaleDataYAxis(yAxisData))
        //drawLayerBasedLine(scaleDataXAxis(xAxisData), yAxis: scaleDataYAxis(yAxisData))
        
        if (dotsVisible) {
            drawDataDots(scaleDataXAxis(xAxisData), yAxis: scaleDataYAxis(yAxisData))
        }
    }
    


    
    // Draw layer-based line with animation support (based on drawing coordinate sytem)
    func drawLayerBasedLine(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>) {
        
        var path = CGPathCreateMutable()
        var yDrawValue: CGFloat = yAxis[0]
        if yDrawValue > drawingHeight {
            yDrawValue = drawingHeight
        } else if yDrawValue < 0.0 {
            yDrawValue = 0.0
        }
        CGPathMoveToPoint(path, nil, axisInset, self.bounds.height - yDrawValue - axisInset)
        for index in 1 ..< xAxis.count {
            var xValue = xAxis[index] + axisInset
            yDrawValue = yAxis[index]
            if yDrawValue > drawingHeight {
                yDrawValue = drawingHeight
            } else if yDrawValue < 0.0 {
                yDrawValue = 0.0
            }
            var yValue = self.bounds.height - yDrawValue - axisInset
            CGPathAddLineToPoint(path, nil, xValue, yValue)
        }
        
        var layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path
        layer.strokeColor = lineColor.CGColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
        
        
        // animate line drawing
        if animationEnabled {
            var animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = animationDuration
            animation.fromValue = 0
            animation.toValue = 1
            layer.addAnimation(animation, forKey: "strokeEnd")
        }
        
        // record the current line layer
        lineLayer = layer
    }
    
    // Draw stroke-based line without animation support (based on drawing coordinate sytem)
    func drawStrokeBasedLine(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>) {

        var context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        for index in 0 ..< xAxis.count - 1 {
            LCContextMoveToPoint(context, x: xAxis[index], y: yAxis[index])
            LCContextAddLineToPoint(context, x: xAxis[index + 1], y: yAxis[index + 1])
        }
        CGContextStrokePath(context)

    }

    
    // Draw small dot at every data point (based on drawing coordinate sytem)
    func drawDataDots(xAxis: Array<CGFloat>, yAxis: Array<CGFloat>) {
        for index in 0 ..< xAxis.count {
            var xValue = xAxis[index] + axisInset - outerRadius/2
            if yAxis[index] <= 0.0 || yAxis[index] >= drawingHeight {
                // not draw the dots outside the effective range
                continue
            }
            var yValue = self.bounds.height - yAxis[index] - axisInset - outerRadius/2
            
            // draw custom layer with another layer in the center
            var dotLayer = DotCALayer()
            dotLayer.dotInnerColor = lineColor
            dotLayer.innerRadius = innerRadius
            dotLayer.backgroundColor = dotsBackgroundColor.CGColor
            dotLayer.cornerRadius = outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: outerRadius, height: outerRadius)
            self.layer.addSublayer(dotLayer)
            
            // animate opacity
            if animationEnabled {
                var animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = animationDuration
                animation.fromValue = 0
                animation.toValue = 1
                dotLayer.addAnimation(animation, forKey: "opacity")
            }
            
            // record dot layers
            dotLayers.append(dotLayer)
        }
    }
    
    // Scale x data coordinates to drawing coordinates
    func scaleDataXAxis(data: Array<CGFloat>) -> Array<CGFloat> {
        var scaleFactor = drawingWidth / xDataLength
        var scaledDataXAxis: Array<CGFloat> = []
        for index in 0 ..< data.count {
            scaledDataXAxis.append(scaleFactor * (data[index] - dataOrigin.x))
        }
        return scaledDataXAxis
    }
    
    
    
    // Scale y data coordinates to drawing coordinates
    func scaleDataYAxis(data: Array<CGFloat>) -> Array<CGFloat> {
        var scaleFactor = drawingHeight / yDataLength
        var scaledDataYAxis: Array<CGFloat> = []
        for index in 0 ..< data.count {
            scaledDataYAxis.append(scaleFactor * (data[index] - dataOrigin.y))
        }
        return scaledDataYAxis
    }
    
    
    // Zoom in or out function
    func zoomInOutPlot(factor: CGFloat) {
        var zoomFactor = factor < 0.5 ? 0.5 : factor
        xDataLength = round(xDataLength / zoomFactor)
        xDataLength = xDataLength < 2.0 ? 2.0 : xDataLength
        yDataLength /= zoomFactor
        self.setNeedsDisplay()
    }
    
    
    
    // Add data to the plot
    func addData(data: Array<CGFloat>) {
        self.dataStore.extend(data)
    }
    
    // Add single data to the plot
    func addData(data: CGFloat) {
        self.dataStore.append(data)
    }
    
    
    // Make whole thing white again.
    func clearData() {
        dataStore.removeAll()
    }
    
    // Find closest point from one x value.
    func findClosestPoint(xValue: CGFloat) -> CGPoint? {
        
        var startDataIndex: Int = Int(dataOrigin.x)
        var dataLength: Int = Int(xDataLength) + 1
        dataLength = dataLength > (dataStore.count - startDataIndex) ? (dataStore.count - startDataIndex) : dataLength
        
        if (dataLength <= 1) {
            // println("At least 2 points are needed for touch event.")
            return nil
        }

        var scaledDataXAxis = scaleDataXAxis([dataOrigin.x + 0.0, dataOrigin.x + 1.0])
        var difference = scaledDataXAxis[1] - scaledDataXAxis[0]
        
        var dividend = (xValue - axisInset) / difference
        var closestXValue = Int(round(dividend)) + Int(dataOrigin.x)
        closestXValue = (closestXValue >= dataStore.count) ? (dataStore.count - 1) : closestXValue
        var closestYValue = dataStore[closestXValue]
        
        return CGPointMake(CGFloat(closestXValue), closestYValue)
    }

    
    // Listen on touch began event
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        // get drawing coordinates for the touched points
        for var index: Int = 0; index < touches.count; index++ {
            var point: AnyObject = touches.allObjects[index]
            
            var xDrawingPoint: CGFloat = xMtoD(point.locationInView(self).x)
            var xData: CGFloat = xDrawingPoint * xDataLength / drawingWidth
            xData = round(xData)     // quantize xData to integer
            var yDrawingPoint: CGFloat = yMtoD(point.locationInView(self).y)
            var yData: CGFloat = yDrawingPoint * yDataLength / drawingHeight
            
            //println("touch began at (x, y) = (\(xData), \(yData))")
            
            preTouchedPoint.append(CGPointMake(xDrawingPoint, yDrawingPoint))
            preTouchedData.append(CGPointMake(xData, yData))
        }
        
        touchXLock = false
        touchYLock = false
        
        // trigger one kind of touch event
        switch(touches.count) {
        case 1:
            oneTouchTrigger = true
            twoTouchTrigger = false
            break
            
        case 2:
            // when two touch points are too close, reset the event
            if abs(preTouchedPoint[0].x - preTouchedPoint[1].x) < drawingWidth / 20 {
                touchXLock = true
            }
            if abs(preTouchedPoint[0].y - preTouchedPoint[1].y) < drawingHeight / 20 {
                touchYLock = true
            }
            
            oneTouchTrigger = false
            twoTouchTrigger = true
            break
            
        default:
            break
        }
        
        delegate?.didSelectDataPoint(CGPointZero) // not need to know point coordinate
        //println("(LineChart) - Data Follow Mode: \(dataFollowMode)")
        
    }
    
    
    // Listen on touch move event
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var nowTouchedPoint: [CGPoint] = []
        var nowTouchedData: [CGPoint] = []
        
        // get drawing coordinates for the touched points
        for var index: Int = 0; index < touches.count; index++ {
            var point: AnyObject = touches.allObjects[index]
            
            var xDrawingPoint: CGFloat = xMtoD(point.locationInView(self).x)
            var xData: CGFloat = xDrawingPoint * xDataLength / drawingWidth
            xData = round(xData)     // quantize xData to integer
            var yDrawingPoint: CGFloat = yMtoD(point.locationInView(self).y)
            var yData: CGFloat = yDrawingPoint * yDataLength / drawingHeight
            
            //println("point \(index + 1), touch move to (x, y) = (\(xData), \(yData))")
            
            nowTouchedPoint.append(CGPointMake(xDrawingPoint, yDrawingPoint))
            nowTouchedData.append(CGPointMake(xData, yData))
        }
        
        switch(touches.count) {
        case 1:
            
            if oneTouchTrigger == true {
                
                // discard incorrect 1-point event (2-point event mistaken as 1-point event)
                if (abs(nowTouchedPoint[0].x - preTouchedPoint[0].x) > self.frame.width/5 || abs(nowTouchedPoint[0].y - preTouchedPoint[0].y) > self.frame.height/5) {
                    return
                }
                
                var xMoveDistance: CGFloat = nowTouchedData[0].x - preTouchedData[0].x
                var yMoveDistance: CGFloat = nowTouchedData[0].y - preTouchedData[0].y
                
                dataOrigin.x -= xMoveDistance
                dataOrigin.x = round(dataOrigin.x)
                //dataOrigin.x = dataOrigin.x < 0.0 ? 0.0 : round(dataOrigin.x)
                
                dataOrigin.y -= yMoveDistance
                //dataOrigin.y = dataOrigin.y < 0.0 ? 0.0 : dataOrigin.y
                
                //if (abs(xMoveDistance) < 1.0 && abs(yMoveDistance) < yDataLength / 100) {
                //    println("move distance is too small to show")
                //} else {
                self.setNeedsDisplay()
                //}
            }
            
            // re-trigger one touch event
            oneTouchTrigger = true
            twoTouchTrigger = false

            break
            
        case 2:
            
            if twoTouchTrigger == true {
                
                // when two touch points are too close, reset the event
                if abs(nowTouchedPoint[0].x - nowTouchedPoint[1].x) < drawingWidth / 20 {
                    touchXLock = true
                    println("touchXLock \(touchXLock)")
                }
                if abs(nowTouchedPoint[0].y - nowTouchedPoint[1].y) < drawingHeight / 20 {
                    touchYLock = true
                    println("touchYLock \(touchYLock)")
                }
                
                if touchXLock == false {
                    // update new x axis
                    var pointXDrawSpace: CGFloat = abs(nowTouchedPoint[0].x - nowTouchedPoint[1].x) / abs(preTouchedData[0].x - preTouchedData[1].x)
                    
                    xDataLength = round(drawingWidth / pointXDrawSpace)
                    xDataLength = xDataLength < 2.0 ? 2.0 : xDataLength
                    pointXDrawSpace = drawingWidth / xDataLength
                    
                    var preOriginXData: CGFloat = dataOrigin.x + preTouchedData[0].x
                    dataOrigin.x = preOriginXData - round(nowTouchedPoint[0].x / pointXDrawSpace)
                    //dataOrigin.x = dataOrigin.x < 0.0 ? 0.0 : round(dataOrigin.x)
                    dataOrigin.x = round(dataOrigin.x)
                    
                    nowTouchedData[0].x = round(nowTouchedPoint[0].x / pointXDrawSpace)
                    nowTouchedData[1].x = round(nowTouchedPoint[1].x / pointXDrawSpace)
                }

                if touchYLock == false {
                    // update new y axis
                    var pointYDrawSpace: CGFloat = abs(nowTouchedPoint[0].y - nowTouchedPoint[1].y) / abs(preTouchedData[0].y - preTouchedData[1].y)
                    
                    yDataLength = drawingHeight / pointYDrawSpace
                    
                    var preOriginYData: CGFloat = dataOrigin.y + preTouchedData[0].y
                    dataOrigin.y = preOriginYData - nowTouchedPoint[0].y / pointYDrawSpace
                    //dataOrigin.y = dataOrigin.y < 0.0 ? 0.0 : dataOrigin.y
                    
                    //println("Origin.Y \(dataOrigin.y), LengthY \(yDataLength)")

                    nowTouchedData[0].y = nowTouchedPoint[0].y / pointYDrawSpace
                    nowTouchedData[1].y = nowTouchedPoint[1].y / pointYDrawSpace

                }
                
                self.setNeedsDisplay()
            }
            
            // re-trigger two touch event
            oneTouchTrigger = false
            twoTouchTrigger = true
            
            break
        default:
            break
        }

        // update data coordinates for the touched points
        preTouchedPoint.removeAll()
        preTouchedData.removeAll()
        for var index: Int = 0; index < touches.count; index++ {
            preTouchedPoint.append(nowTouchedPoint[index])
            preTouchedData.append(nowTouchedData[index])
        }
        
    }
    
    
    // Listen on touch end event.
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        var nowTouchedPoint: [CGPoint] = []
        var nowTouchedData: [CGPoint] = []
        
        // get drawing coordinates for the touched points
        for var index: Int = 0; index < touches.count; index++ {
            var point: AnyObject = touches.allObjects[index]
            
            var xDrawingPoint: CGFloat = xMtoD(point.locationInView(self).x)
            var xData: CGFloat = xDrawingPoint * xDataLength / drawingWidth
            xData = round(xData)     // quantize xData to integer
            var yDrawingPoint: CGFloat = yMtoD(point.locationInView(self).y)
            var yData: CGFloat = yDrawingPoint * yDataLength / drawingHeight
            
            //println("point \(index + 1), touch ended at (x, y) = (\(xData), \(yData))")
            
        }
        
        // reset data and trigger states
        preTouchedPoint.removeAll()
        preTouchedData.removeAll()
        touchXLock = false
        touchYLock = false
        oneTouchTrigger = false
        twoTouchTrigger = false
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        var nowTouchedPoint: [CGPoint] = []
        var nowTouchedData: [CGPoint] = []
        
        // get drawing coordinates for the touched points
        for var index: Int = 0; index < touches.count; index++ {
            var point: AnyObject = touches.allObjects[index]
            
            var xDrawingPoint: CGFloat = xMtoD(point.locationInView(self).x)
            var xData: CGFloat = xDrawingPoint * xDataLength / drawingWidth
            xData = round(xData)     // quantize xData to integer
            var yDrawingPoint: CGFloat = yMtoD(point.locationInView(self).y)
            var yData: CGFloat = yDrawingPoint * yDataLength / drawingHeight
            
            println("point \(index + 1), touch cancelled at (x, y) = (\(xData), \(yData))")
            
        }
    }
    
}