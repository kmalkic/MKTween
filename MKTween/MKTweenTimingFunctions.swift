//
//  MKTweenTimingFunctions.swift
//  MKTween
//
//  Created by Kevin Malkic on 25 / 01 / 2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

public typealias MKTweenTimingFunction = (time: Double, begin: Double, difference: Double, duration: Double) -> Double

public struct MKTweenTiming {
	
	static public var Linear: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * t / d + b
	}
	
	static public var BackOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		t = t / d - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b
	}
	
	static public var BackIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		t /= d
		return c * t * t * ((s + 1) * t - s) + b
	}
	
	static public var BackInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		var s: Double = 1.70158
		t /= d / 2
		s *= (1.525)
		if (t < 1) { return c / 2 * (t * t * ((s + 1) * t - s)) + b }
		t -= 2
		s *= (1.525)
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	}
	
	static public var BounceOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		
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
	
	static public var BounceIn: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c - MKTweenTiming.BounceOut(time: d - t, begin: 0, difference: c, duration: d) + b
	}
	
	static public var BounceInOut: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		if (t < d / 2) { return MKTweenTiming.BounceIn(time: t * 2, begin: 0, difference: c, duration: d) * 0.5 + b }
		else { return MKTweenTiming.BounceOut(time: t * 2 - d, begin: 0, difference: c, duration: d) * 0.5 + c * 0.5 + b }
	}
	
	static public var CircleOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t = t / d - 1
		return c * sqrt(1 - t * t) + b
	}
	
	static public var CircleIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return -c * (sqrt(1 - t * t) - 1) + b
	}
	
	static public var CircleInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d / 2
		if (t < 1) { return -c / 2 * (sqrt(1 - t * t) - 1) + b }
		t -= 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	}
	
	static public var CubicOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t = t / d - 1
		return c * (t * t * t + 1) + b
	}
	
	static public var CubicIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return c * t * t * t + b
	}
	
	static public var CubicInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t + 2) + b
	}
	
	static public var ElasticOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		var s: Double = 0
		var a: Double = c
		if (t == 0) { return b }
		t /= d
		if (t == 1) { return b + c }
		let p: Double = d * 0.3
		if (a < fabs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * M_PI) * asin(c / a) }
		return a * pow(2, -10 * t) * sin((t * d - s) * (2 * M_PI) / p) + c + b
	}
	
	static public var ElasticIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		let p: Double = d * 0.3
		var s: Double = 0
		var a: Double = 0
		if (t == 0) { return b }
		t /= d
		if (t == 1) { return b + c }
		if (a < abs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * M_PI) * asin(c / a) }
		t -= 1
		return -(a * pow(2, 10 * t) * sin( (t * d - s) * (2 * M_PI) / p )) + b
	}
	
	static public var ElasticInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		let p: Double = d * (0.3 * 1.5)
		var s: Double = 0
		var a: Double = 0
		if (t == 0) { return b }
		t /= d / 2
		if (t == 2) { return b + c }
		if (a < abs(c)) { a = c; s = p / 4 }
		else { s = p / (2 * M_PI) * asin(c / a) }
		if (t < 1) { t -= 1; return -0.5 * (a * pow(2, 10 * t) * sin( (t * d - s) * (2 * M_PI) / p )) + b }
		t -= 1
		return a * pow(2, -10 * t) * sin( (t * d - s) * (2 * M_PI) / p ) * 0.5 + c + b
	}
	
	static public var ExpoOut: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b
	}
	
	static public var ExpoIn: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b
	}
	
	static public var ExpoInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		if (t == 0) { return b }
		if (t == d) { return b + c }
		t /= d / 2
		if (t < 1) { return c / 2 * pow(2, 10 * (t - 1)) + b }
		return c / 2 * (-pow(2, -10 * --t) + 2) + b
	}
	
	static public var QuadOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return -c * t * (t - 2) + b
	}
	
	static public var QuadIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return c * t * t + b
	}
	
	static public var QuadInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d / 2
		if (t < 1) { return c / 2 * t * t + b }
		--t
		return -c / 2 * (t * (t - 2) - 1) + b
	}
	
	static public var QuartOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	}
	
	static public var QuartIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return c * t * t * t * t + b
	}
	
	static public var QuartInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t + b }
		t -= 2
		return -c / 2 * (t * t * t * t - 2) + b
	}
	
	static public var QuintOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d
		return c * t * t * t * t * t + b
	}
	
	static public var QuintIn: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	}
	
	static public var QuintInOut: MKTweenTimingFunction = { (var t: Double, b: Double, c: Double, d: Double) -> Double in
		
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t * t * t + 2) + b
	}
	
	static public var SineOut: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * sin(t / d * (M_PI / 2)) + b
	}
	
	static public var SineIn: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c * cos(t / d * (M_PI / 2)) + c + b
	}
	
	static public var SineInOut: MKTweenTimingFunction = { (t: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c / 2 * (cos(M_PI * t / d) - 1) + b
	}
}


