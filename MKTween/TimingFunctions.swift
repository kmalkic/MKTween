
public typealias TimingFunction = (_ time: Double, _ begin: Double, _ difference: Double, _ duration: Double) -> Double

public enum Timing {

    case linear
    case backOut
    case backIn
    case backInOut
    case bounceOut
    case bounceIn
    case bounceInOut
    case circleOut
    case circleIn
    case circleInOut
    case cubicOut
    case cubicIn
    case cubicInOut
    case elasticOut
    case elasticIn
    case elasticInOut
    case expoOut
    case expoIn
    case expoInOut
    case quadOut
    case quadIn
    case quadInOut
    case quartOut
    case quartIn
    case quartInOut
    case quintOut
    case quintIn
    case quintInOut
    case sineOut
    case sineIn
    case sineInOut
    case custom(TimingFunction)

    public func timingFunction() -> TimingFunction {

        switch self {
        case .linear: return Timing.Linear
        case .backOut: return Timing.BackOut
        case .backIn: return Timing.BackIn
        case .backInOut: return Timing.BackInOut
        case .bounceOut: return Timing.BounceOut
        case .bounceIn: return Timing.BounceIn
        case .bounceInOut: return Timing.BounceInOut
        case .circleOut: return Timing.CircleOut
        case .circleIn: return Timing.CircleIn
        case .circleInOut: return Timing.CircleInOut
        case .cubicOut: return Timing.CubicOut
        case .cubicIn: return Timing.CubicIn
        case .cubicInOut: return Timing.CubicInOut
        case .elasticOut: return Timing.ElasticOut
        case .elasticIn: return Timing.ElasticIn
        case .elasticInOut: return Timing.ElasticInOut
        case .expoOut: return Timing.ExpoOut
        case .expoIn: return Timing.ExpoIn
        case .expoInOut: return Timing.ExpoInOut
        case .quadOut: return Timing.QuadOut
        case .quadIn: return Timing.QuadIn
        case .quadInOut: return Timing.QuadInOut
        case .quartOut: return Timing.QuartOut
        case .quartIn: return Timing.QuartIn
        case .quartInOut: return Timing.QuartInOut
        case .quintOut: return Timing.QuintOut
        case .quintIn: return Timing.QuintIn
        case .quintInOut: return Timing.QuintInOut
        case .sineOut: return Timing.SineOut
        case .sineIn: return Timing.SineIn
        case .sineInOut: return Timing.SineInOut
        case let .custom(function): return function
        }
    }

    public func name() -> String {

        switch self {
        case .linear: return "Linear"
        case .backOut: return "BackOut"
        case .backIn: return "BackIn"
        case .backInOut: return "BackInOut"
        case .bounceOut: return "BounceOut"
        case .bounceIn: return "BounceIn"
        case .bounceInOut: return "BounceInOut"
        case .circleOut: return "CircleOut"
        case .circleIn: return "CircleIn"
        case .circleInOut: return "CircleInOut"
        case .cubicOut: return "CubicOut"
        case .cubicIn: return "CubicIn"
        case .cubicInOut: return "CubicInOut"
        case .elasticOut: return "ElasticOut"
        case .elasticIn: return "ElasticIn"
        case .elasticInOut: return "ElasticInOut"
        case .expoOut: return "ExpoOut"
        case .expoIn: return "ExpoIn"
        case .expoInOut: return "ExpoInOut"
        case .quadOut: return "QuadOut"
        case .quadIn: return "QuadIn"
        case .quadInOut: return "QuadInOut"
        case .quartOut: return "QuartOut"
        case .quartIn: return "QuartIn"
        case .quartInOut: return "QuartInOut"
        case .quintOut: return "QuintOut"
        case .quintIn: return "QuintIn"
        case .quintInOut: return "QuintInOut"
        case .sineOut: return "SineOut"
        case .sineIn: return "SineIn"
        case .sineInOut: return "SineInOut"
        case .custom: return "Custom"
        }
    }

	static private var Linear: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * time / d + b
	}
	
	static private var BackOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		let t = time / d - 1
		return c * (t * t * ((s + 1) * t + s) + 1) + b
	}
	
	static private var BackIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let s: Double = 1.70158
		let t = time / d
		return c * t * t * ((s + 1) * t - s) + b
	}
	
	static private var BackInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var s: Double = 1.70158
		var t = time / (d / 2)
		s *= (1.525)
		if (t < 1) { return c / 2 * (t * t * ((s + 1) * t - s)) + b }
		t -= 2
		s *= (1.525)
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	}
	
	static private var BounceOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
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
	
	static private var BounceIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c - Timing.BounceOut(d - time, 0, c, d) + b
	}
	
	static private var BounceInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		if (time < d / 2) { return Timing.BounceIn(time * 2, 0, c, d) * 0.5 + b }
		else { return Timing.BounceOut(time * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b }
	}
	
	static private var CircleOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d - 1
		return c * sqrt(1 - t * t) + b
	}
	
	static private var CircleIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d
		return -c * (sqrt(1 - t * t) - 1) + b
	}
	
	static private var CircleInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var t = time / (d / 2)
		if (t < 1) { return -c / 2 * (sqrt(1 - t * t) - 1) + b }
		t -= 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	}
	
	static private var CubicOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d - 1
		return c * (t * t * t + 1) + b
	}
	
	static private var CubicIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		let t = time / d
		return c * t * t * t + b
	}
	
	static private var CubicInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		var t = time / (d / 2)
		if (t < 1) { return c / 2 * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t + 2) + b
	}
	
	static private var ElasticOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
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
	
	static private var ElasticIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
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
	
	static private var ElasticInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
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
	
	static private var ExpoOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (time == d) ? b + c : c * (-pow(2, -10 * time / d) + 1) + b
	}
	
	static private var ExpoIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return (time == 0) ? b : c * pow(2, 10 * (time / d - 1)) + b
	}
	
	static private var ExpoInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		if (t == 0) { return b }
		if (t == d) { return b + c }
		t /= d / 2
		if (t < 1) { return c / 2 * pow(2, 10 * (t - 1)) + b }
        t -= 1
		return c / 2 * (-pow(2, -10 * t) + 2) + b
	}
	
	static private var QuadOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return -c * t * (t - 2) + b
	}
	
	static private var QuadIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t + b
	}
	
	static private var QuadInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t + b }
		t -= 1
		return -c / 2 * (t * (t - 2) - 1) + b
	}
	
	static private var QuartOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	}
	
	static private var QuartIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t * t * t + b
	}
	
	static private var QuartInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t + b }
		t -= 2
		return -c / 2 * (t * t * t * t - 2) + b
	}
	
	static private var QuintOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d
		return c * t * t * t * t * t + b
	}
	
	static private var QuintIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	}
	
	static private var QuintInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
        var t = time
		t /= d / 2
		if (t < 1) { return c / 2 * t * t * t * t * t + b }
		t -= 2
		return c / 2 * (t * t * t * t * t + 2) + b
	}
	
	static private var SineOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return c * sin(time / d * (.pi / 2)) + b
	}
	
	static private var SineIn: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c * cos(time / d * (.pi / 2)) + c + b
	}
	
	static private var SineInOut: TimingFunction = { (time: Double, b: Double, c: Double, d: Double) -> Double in
		
		return -c / 2 * (cos(.pi * time / d) - 1) + b
	}
}


