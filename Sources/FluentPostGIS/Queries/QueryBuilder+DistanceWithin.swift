import FluentSQL
import WKCodable

extension QueryBuilder {
    @discardableResult
    public func filterGeometryDistanceWithin<F,V>(_ field: KeyPath<Model, F>, _ filter: V, _ value: Double) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryFilterGeometryDistanceWithin(QueryBuilder.path(field),
                                                 QueryBuilder.queryExpressionGeometry(filter),
                                                 SQLLiteral.numeric(String(value)))
        //return filterGeometryDistanceWithin(Database.queryField(.keyPath(key)), Database.queryFilterValueGeometry(filter),  Database.queryFilterValue([value]))
    }
    
  
    
    @discardableResult
    public func filterGeographyDistanceWithin<F,V>(_ field: KeyPath<Model, F>, _ filter: V, _ value: Double) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryFilterGeographyDistanceWithin(QueryBuilder.path(field),
                                                 QueryBuilder.queryExpressionGeometry(filter),
                                                 SQLLiteral.numeric(String(value)))
        //return filterGeographyDistanceWithin(Database.queryField(.keyPath(key)), Database.queryFilterValueGeographic(filter),  Database.queryFilterValue([value]))
    }
    
 
}

extension QueryBuilder {
    func queryFilterGeometryDistanceWithin(_ field: String, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        
        applyFilter(function: "ST_DWithin", args: [SQLColumn(field), filter, value])
        return self
    }
}

//extension QuerySupporting where QueryFilterValue: SQLExpression {
//    public static func queryFilterValueGeographic<T: GeometryConvertible>(_ geometry: T) -> QueryFilterValue {
//        let geometryText = WKTEncoder().encode(geometry.geometry)
//        return .function("ST_GeogFromText", [.expression(.literal(.string(geometryText)))])
//    }
//}

extension QueryBuilder {
    func queryFilterGeographyDistanceWithin(_ field: String, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        applyFilter(function: "ST_DWithin", args: [SQLColumn(field), filter, value])
        return self
    }
    
   
}

