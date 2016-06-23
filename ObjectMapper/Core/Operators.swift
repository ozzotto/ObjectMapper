//
//  Operators.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-10-09.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2015 Hearst
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/**
* This file defines a new operator which is used to create a mapping between an object and a JSON key value.
* There is an overloaded operator definition for each type of object that is supported in ObjectMapper.
* This provides a way to add custom logic to handle specific types of objects
*/

infix operator <- {}

// MARK:- Objects with Basic types

/// Object of Basic type
public func <- <T>( left: inout T, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.basicType(field: &left, object: right.value())
	case .ToJSON:
		ToJSON.basicType(field: left, map: right)
	default: ()
	}
}

/// Optional object of basic type
public func <- <T>( left: inout T?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalBasicType(field: &left, object: right.value())
	case .ToJSON:
		ToJSON.optionalBasicType(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped optional object of basic type
public func <- <T>( left: inout T!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalBasicType(field: &left, object: right.value())
	case .ToJSON:
		ToJSON.optionalBasicType(field: left, map: right)
	default: ()
	}
}

// MARK:- Raw Representable types

/// Object of Raw Representable type
public func <- <T: RawRepresentable>( left: inout T, right: Map) {
	left <- (right, EnumTransform())
}

/// Optional Object of Raw Representable type
public func <- <T: RawRepresentable>( left: inout T?, right: Map) {
	left <- (right, EnumTransform())
}

/// Implicitly Unwrapped Optional Object of Raw Representable type
public func <- <T: RawRepresentable>( left: inout T!, right: Map) {
	left <- (right, EnumTransform())
}

// MARK:- Arrays of Raw Representable type

/// Array of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [T], right: Map) {
	left <- (right, EnumTransform())
}

/// Array of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [T]?, right: Map) {
	left <- (right, EnumTransform())
}

/// Array of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [T]!, right: Map) {
	left <- (right, EnumTransform())
}

// MARK:- Dictionaries of Raw Representable type

/// Dictionary of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [String: T], right: Map) {
	left <- (right, EnumTransform())
}

/// Dictionary of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [String: T]?, right: Map) {
	left <- (right, EnumTransform())
}

/// Dictionary of Raw Representable object
public func <- <T: RawRepresentable>( left: inout [String: T]!, right: Map) {
	left <- (right, EnumTransform())
}

// MARK:- Transforms

/// Object of Basic type with Transform
public func <- <Transform: TransformType>( left: inout Transform.Object, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.basicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

/// Optional object of basic type with Transform
public func <- <Transform: TransformType>( left: inout Transform.Object?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

/// Implicitly unwrapped optional object of basic type with Transform
public func <- <Transform: TransformType>( left: inout Transform.Object!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

/// Array of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(input: map.currentValue, transform: transform)
		FromJSON.basicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

/// Optional array of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

/// Implicitly unwrapped optional array of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [Transform.Object]!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONArrayWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

/// Dictionary of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [String: Transform.Object], right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(input: map.currentValue, transform: transform)
		FromJSON.basicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

/// Optional dictionary of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [String: Transform.Object]?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

/// Implicitly unwrapped optional dictionary of Basic type with Transform
public func <- <Transform: TransformType>( left: inout [String: Transform.Object]!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let values = fromJSONDictionaryWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: values)
	case .ToJSON:
		let values = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: values, map: map)
	default: ()
	}
}

private func fromJSONArrayWithTransform<Transform: TransformType>(input: AnyObject?, transform: Transform) -> [Transform.Object]? {
	if let values = input as? [AnyObject] {
		return values.flatMap { value in
			return transform.transformFromJSON(value)
		}
	} else {
		return nil
	}
}

private func fromJSONDictionaryWithTransform<Transform: TransformType>(input: AnyObject?, transform: Transform) -> [String: Transform.Object]? {
	if let values = input as? [String: AnyObject] {
		return values.filterMap { value in
			return transform.transformFromJSON(value)
		}
	} else {
		return nil
	}
}

private func toJSONArrayWithTransform<Transform: TransformType>(input: [Transform.Object]?, transform: Transform) -> [Transform.JSON]? {
	return input?.flatMap { value in
		return transform.transformToJSON(value)
	}
}

private func toJSONDictionaryWithTransform<Transform: TransformType>(input: [String: Transform.Object]?, transform: Transform) -> [String: Transform.JSON]? {
	return input?.filterMap { value in
		return transform.transformToJSON(value)
	}
}

// MARK:- Mappable Objects - <T: Mappable>

/// Object conforming to Mappable
public func <- <T: Mappable>( left: inout T, right: Map) {
	switch right.mappingType {
	case .FromJSON:
		FromJSON.object(field: &left, map: right)
	case .ToJSON:
		ToJSON.object(field: left, map: right)
	}
}

/// Optional Mappable objects
public func <- <T: Mappable>( left: inout T?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObject(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObject(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped optional Mappable objects
public func <- <T: Mappable>( left: inout T!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObject(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObject(field: left, map: right)
	default: ()
	}
}

// MARK:- Transforms of Mappable Objects - <T: Mappable>

/// Object conforming to Mappable that have transforms
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Transform.Object, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.basicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

/// Optional Mappable objects that have transforms
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Transform.Object?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

/// Implicitly unwrapped optional Mappable objects that have transforms
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Transform.Object!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
		FromJSON.optionalBasicType(field: &left, object: value)
	case .ToJSON:
		let value: Transform.JSON? = transform.transformToJSON(left)
		ToJSON.optionalBasicType(field: value, map: map)
	default: ()
	}
}

// MARK:- Dictionary of Mappable objects - Dictionary<String, T: Mappable>

/// Dictionary of Mappable objects <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, T>, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.objectDictionary(field: &left, map: right)
	case .ToJSON:
		ToJSON.objectDictionary(field: left, map: right)
	default: ()
	}
}

/// Optional Dictionary of Mappable object <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, T>?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectDictionary(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectDictionary(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, T>!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectDictionary(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectDictionary(field: left, map: right)
	default: ()
	}
}

/// Dictionary of Mappable objects <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, [T]>, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.objectDictionaryOfArrays(field: &left, map: right)
	case .ToJSON:
		ToJSON.objectDictionaryOfArrays(field: left, map: right)
	default: ()
	}
}

/// Optional Dictionary of Mappable object <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, [T]>?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectDictionaryOfArrays(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectDictionaryOfArrays(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable>
public func <- <T: Mappable>( left: inout Dictionary<String, [T]>!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectDictionaryOfArrays(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectDictionaryOfArrays(field: left, map: right)
	default: ()
	}
}

// MARK:- Dictionary of Mappable objects with a transform - Dictionary<String, T: Mappable>

/// Dictionary of Mappable objects <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, Transform.Object>, right: (Map, Transform)) {
	let (map, transform) = right
	if let object = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
		let value = fromJSONDictionaryWithTransform(input: object, transform: transform) ?? left
		FromJSON.basicType(field: &left, object: value)
	} else if map.mappingType == .ToJSON {
		let value = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.basicType(field: value, map: map)
	}
}

/// Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, Transform.Object>?, right: (Map, Transform)) {
	let (map, transform) = right
	if let object = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
		let value = fromJSONDictionaryWithTransform(input: object, transform: transform) ?? left
		FromJSON.optionalBasicType(field: &left, object: value)
	} else if map.mappingType == .ToJSON {
		let value = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: value, map: map)
	}
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, Transform.Object>!, right: (Map, Transform)) {
	let (map, transform) = right
	if let dictionary = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformedDictionary = fromJSONDictionaryWithTransform(input: dictionary, transform: transform) ?? left
		FromJSON.optionalBasicType(field: &left, object: transformedDictionary)
	} else if map.mappingType == .ToJSON {
		let value = toJSONDictionaryWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: value, map: map)
	}
}

/// Dictionary of Mappable objects <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, [Transform.Object]>, right: (Map, Transform)) {
	let (map, transform) = right
	if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformedDictionary = dictionary.map { (key, values) in
			return (key, fromJSONArrayWithTransform(input: values, transform: transform) ?? left[key] ?? [])
		}
		FromJSON.basicType(field: &left, object: transformedDictionary)
	} else if map.mappingType == .ToJSON {
		let transformedDictionary = left.map { (key, values) in
			return (key, toJSONArrayWithTransform(input: values, transform: transform) ?? [])
		}
		
		ToJSON.basicType(field: transformedDictionary, map: map)
	}
}

/// Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, [Transform.Object]>?, right: (Map, Transform)) {
	let (map, transform) = right
	if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformedDictionary = dictionary.map { (key, values) in
			return (key, fromJSONArrayWithTransform(input: values, transform: transform) ?? left?[key] ?? [])
		}
		FromJSON.optionalBasicType(field: &left, object: transformedDictionary)
	} else if map.mappingType == .ToJSON {
		let transformedDictionary = left?.map { (key, values) in
			return (key, toJSONArrayWithTransform(input: values, transform: transform) ?? [])
		}
		
		ToJSON.optionalBasicType(field: transformedDictionary, map: map)
	}
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: Mappable> with a transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Dictionary<String, [Transform.Object]>!, right: (Map, Transform)) {
	let (map, transform) = right
	if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformedDictionary = dictionary.map { (key, values) in
			return (key, fromJSONArrayWithTransform(input: values, transform: transform) ?? left?[key] ?? [])
		}
		FromJSON.optionalBasicType(field: &left, object: transformedDictionary)
	} else if map.mappingType == .ToJSON {
		let transformedDictionary = left?.map { (key, values) in
			return (key, toJSONArrayWithTransform(input: values, transform: transform) ?? [])
		}
		
		ToJSON.optionalBasicType(field: transformedDictionary, map: map)
	}
}

// MARK:- Array of Mappable objects - Array<T: Mappable>

/// Array of Mappable objects
public func <- <T: Mappable>( left: inout Array<T>, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.objectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.objectArray(field: left, map: right)
	default: ()
	}
}

/// Optional array of Mappable objects
public func <- <T: Mappable>( left: inout Array<T>?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectArray(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <- <T: Mappable>( left: inout Array<T>!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectArray(field: left, map: right)
	default: ()
	}
}

// MARK:- Array of Mappable objects with transforms - Array<T: Mappable>

/// Array of Mappable objects
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Array<Transform.Object>, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform) {
			FromJSON.basicType(field: &left, object: transformedValues)
		}
	case .ToJSON:
		let transformedValues = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: transformedValues, map: map)
	default: ()
	}
}

/// Optional array of Mappable objects
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Array<Transform.Object>?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: transformedValues)
	case .ToJSON:
		let transformedValues = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: transformedValues, map: map)
	default: ()
	}
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Array<Transform.Object>!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform)
		FromJSON.optionalBasicType(field: &left, object: transformedValues)
	case .ToJSON:
		let transformedValues = toJSONArrayWithTransform(input: left, transform: transform)
		ToJSON.optionalBasicType(field: transformedValues, map: map)
	default: ()
	}
}

// MARK:- Array of Array of Mappable objects - Array<Array<T: Mappable>>

/// Array of Array Mappable objects
public func <- <T: Mappable>( left: inout Array<Array<T>>, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.twoDimensionalObjectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.twoDimensionalObjectArray(field: left, map: right)
	default: ()
	}
}

/// Optional array of Mappable objects
public func <- <T: Mappable>( left:inout Array<Array<T>>?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalTwoDimensionalObjectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalTwoDimensionalObjectArray(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <- <T: Mappable>( left: inout Array<Array<T>>!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalTwoDimensionalObjectArray(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalTwoDimensionalObjectArray(field: left, map: right)
	default: ()
	}
}

// MARK:- Array of Array of Mappable objects - Array<Array<T: Mappable>> with transforms

/// Array of Array Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Array<Array<Transform.Object>>, right: (Map, Transform)) {
	let (map, transform) = right
	if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformed2DArray = original2DArray.flatMap { values in
			fromJSONArrayWithTransform(input: values, transform: transform)
		}
		FromJSON.basicType(field: &left, object: transformed2DArray)
	} else if map.mappingType == .ToJSON {
		let transformed2DArray = left.flatMap { values in
			toJSONArrayWithTransform(input: values, transform: transform)
		}
		ToJSON.basicType(field: transformed2DArray, map: map)
	}
}

/// Optional array of Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left:inout Array<Array<Transform.Object>>?, right: (Map, Transform)) {
	let (map, transform) = right
	if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformed2DArray = original2DArray.flatMap { values in
			fromJSONArrayWithTransform(input: values, transform: transform)
		}
		FromJSON.optionalBasicType(field: &left, object: transformed2DArray)
	} else if map.mappingType == .ToJSON {
		let transformed2DArray = left?.flatMap { values in
			toJSONArrayWithTransform(input: values, transform: transform)
		}
		ToJSON.optionalBasicType(field: transformed2DArray, map: map)
	}
}

/// Implicitly unwrapped Optional array of Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: Mappable>( left: inout Array<Array<Transform.Object>>!, right: (Map, Transform)) {
	let (map, transform) = right
	if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
		let transformed2DArray = original2DArray.flatMap { values in
			fromJSONArrayWithTransform(input: values, transform: transform)
		}
		FromJSON.optionalBasicType(field: &left, object: transformed2DArray)
	} else if map.mappingType == .ToJSON {
		let transformed2DArray = left?.flatMap { values in
			toJSONArrayWithTransform(input: values, transform: transform)
		}
		ToJSON.optionalBasicType(field: transformed2DArray, map: map)
	}
}

// MARK:- Set of Mappable objects - Set<T: Mappable where T: Hashable>

/// Set of Mappable objects
public func <- <T: Mappable where T: Hashable>( left: inout Set<T>, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.objectSet(field: &left, map: right)
	case .ToJSON:
		ToJSON.objectSet(field: left, map: right)
	default: ()
	}
}


/// Optional Set of Mappable objects
public func <- <T: Mappable where T: Hashable>( left: inout Set<T>?, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectSet(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectSet(field: left, map: right)
	default: ()
	}
}

/// Implicitly unwrapped Optional Set of Mappable objects
public func <- <T: Mappable where T: Hashable>( left: inout Set<T>!, right: Map) {
	switch right.mappingType {
	case .FromJSON where right.isKeyPresent:
		FromJSON.optionalObjectSet(field: &left, map: right)
	case .ToJSON:
		ToJSON.optionalObjectSet(field: left, map: right)
	default: ()
	}
}


// MARK:- Set of Mappable objects with a transform - Set<T: Mappable where T: Hashable>

/// Set of Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: protocol<Hashable, Mappable>>( left: inout Set<Transform.Object>, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform) {
			FromJSON.basicType(field: &left, object: Set(transformedValues))
		}
	case .ToJSON:
		let transformedValues = toJSONArrayWithTransform(input: Array(left), transform: transform)
		ToJSON.optionalBasicType(field: transformedValues, map: map)
	default: ()
	}
}


/// Optional Set of Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: protocol<Hashable, Mappable>>( left: inout Set<Transform.Object>?, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform) {
			FromJSON.basicType(field: &left, object: Set(transformedValues))
		}
	case .ToJSON:
		if let values = left {
			let transformedValues = toJSONArrayWithTransform(input: Array(values), transform: transform)
			ToJSON.optionalBasicType(field: transformedValues, map: map)
		}
	default: ()
	}
}

/// Implicitly unwrapped Optional set of Mappable objects with transform
public func <- <Transform: TransformType where Transform.Object: protocol<Hashable, Mappable>>( left: inout Set<Transform.Object>!, right: (Map, Transform)) {
	let (map, transform) = right
	switch map.mappingType {
	case .FromJSON where map.isKeyPresent:
		if let transformedValues = fromJSONArrayWithTransform(input: map.currentValue, transform: transform) {
			FromJSON.basicType(field: &left, object: Set(transformedValues))
		}
	case .ToJSON:
		if let values = left {
			let transformedValues = toJSONArrayWithTransform(input: Array(values), transform: transform)
			ToJSON.optionalBasicType(field: transformedValues, map: map)
		}
	default: ()
	}
}
