import Foundation

public class NSDecimalNumberTransform: TransformType {
    public typealias Object = Decimal
    public typealias JSON = String

    public init() {}

    public func transformFromJSON(_ value: AnyObject?) -> Decimal? {
        if let string = value as? String {
            return Decimal(string: string)
        }
        if let double = value as? Double {
			return Decimal(double)
        }
        return nil
    }

    public func transformToJSON(_ value: Decimal?) -> String? {
        guard let value = value else { return nil }
        return value.description
    }
}
