//
//  MKTweenTimingFunctions.swift
//  MKTween
//
//  Created by Kevin Malkic on 25 / 01 / 2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

public typealias MKTweenTimingFunction = (_ time: Double, _ begin: Double, _ difference: Double, _ duration: Double) -> Double

public struct MKTweenTiming {
	
	static public var Linear: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * time / d + b
	}
	
	static public var BackOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		let t = time / d - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b
	}
	
	static public var BackIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		let t = time / d
		return c * t * t * ((s + 1) * t - s) + b
	}
	
	static public var BackInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var s: Double = 1.70158
		var t = time / (d / 2)
		s *= (1.525)
		if (t < 1) { return c / 2 * (t * t * ((s + 1) * t - s)) + b }
		t -= 2
		s *= (1.525)
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	}
	
	static public var BounceOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var t = time / d
		
		if (t < (1 / 2.75)) {
			
			return c * (7.5625 * t * t) + b
			
		} else if (t < (2 / 2.75)) {
			
			t -= (1.5 / 2.75)
			
			return c * (7.5625 * t * t + 0.75) + b
			
		} else if (t < (2.5 / 2.75)) {
			
			t -= (2.25 / 2.75)
			
			return c * (7.5625 * t * t + 0.9375) + b
			
		} else {
			
			t -= (2.625 / 2.75)
			
			return c * (7.5625 * t * t + 0.984375) + b
		}
	}
	
	static public var BounceIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c - MKTweenTiming.BounceOut(d - time, 0, c, d) + b
	}
	
	static public var BounceInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		if (time < d / 2) { return MKTweenTiming.BounceIn(time * 2, 0, c, d) * 0.5 + b }
		else { return MKTweenTiming.BounceOut(time * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b }
	}
	
	static public var CircleOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d - 1
		return c * sqrt(1 - t * t) + b
	}
	
	static public var CircleIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d
		return -c * (sqrt(1 - t * t) - 1) + b
	}
	
	static public var CircleInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var t = time / (d / 2)
		if (t < 1) { return -c / 2 * (sqrt(1 - t * t) - 1) + b }
		t -= 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	}
	
	static public var CubicOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d - 1
		return c * (t * t * t + 1) + b
	}
	
	static public var CubicIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d
		return c * t * t * t + b
	}
	
	static public var CubicInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var t = time / (d / 2)
		if (t < 1) { return c / 2 * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t + 2) + b
	}
	
	static public var ElasticOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var s: Double = 0
		var a: Double = c
        var t = time
		if (t == 0) { return b }
		t /= d
		if (t == 1) { return b + c }
		let p: Double = d * 0.3
		if (a < fabs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * .pi) * asin(c / a) }
		return a * pow(2, -10 * t) * sin((t * d - s) * (2 * .pi) / p) + c + b
	}
	
	static public var ElasticIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let p: Double = d * 0.3
		var s: Double = 0
		var a: Double = 0
        var t = time
		if (t == 0) { return b }
		t /= d
		if (t == 1) { return b + c }
		if (a < abs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * .pi) * asin(c / a) }
		t -= 1
		return -(a * pow(2, 10 * t) * sin( (t * d - s) * (2 * .pi) / p )) + b
	}
	
	static public var ElasticInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let p: Double = d * (0.3 * 1.5)
		var s: Double = 0
		var a: Double = 0
        var t = time
		if (t == 0) { return b }
		t /= d / 2
		if (t == 2) { return b + c }
		if (a < abs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * .pi) * asin(c / a) }
		if (t < 1) { t -= 1; return -0.5 * (a * pow(2, 10 * t) * sin( (t * d - s) * (2 * .pi) / p )) + b }
		t -= 1
		return a * pow(2, -10 * t) * sin( (t * d - s) * (2 * .pi) / p ) * 0.5 + c + b
	}
	
	static public var ExpoOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (time == d) ? b + c : c * (-pow(2, -10 * time / d) + 1) + b
	}
	
	static public var ExpoIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (time == 0) ? b : c * pow(2, 10 * (time / d - 1)) + b
	}
	
	static public var ExpoInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		if (t == 0) { return b }
		if (t == d) { return b + c }
		t /= d / 2
		if (t < 1) { return c / 2 * pow(2, 10 * (t - 1)) + b }
        t -= 1
		return c / 2 * (-pow(2, -10 * t) + 2) + b
	}
	
	static public var QuadOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return -c * t * (t - 2) + b
	}
	
	static public var QuadIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t + b
	}
	
	static public var QuadInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t + b }
		t -= 1
		return -c / 2 * (t * (t - 2) - 1) + b
	}
	
	static public var QuartOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	}
	
	static public var QuartIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t * t * t + b
	}
	
	static public var QuartInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t + b }
		t -= 2
		return -c / 2 * (t * t * t * t - 2) + b
	}
	
	static public var QuintOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t * t * t * t + b
	}
	
	static public var QuintIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	}
	
	static public var QuintInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t * t * t + 2) + b
	}
	
	static public var SineOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * sin(time / d * (.pi / 2)) + b
	}
	
	static public var SineIn: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c * cos(time / d * (.pi / 2)) + c + b
	}
	
	static public var SineInOut: MKTweenTimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c / 2 * (cos(.pi * time / d) - 1) + b
	}
}


