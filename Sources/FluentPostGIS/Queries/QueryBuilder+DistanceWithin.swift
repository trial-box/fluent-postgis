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
    public func filterGeometryDistanceWithin<Joined, Field, V>(
        _ joined: Joined.Type,
        _ field: KeyPath<Joined, Field>,
        _ filter: V,
        _ value: Double
    ) -> Self
        where Joined: Schema, Field: QueryableProperty, V: GeometryConvertible, Field.Model == Joined
    {

        return queryFilterGeometryDistanceWithin(
            .path(
                Joined.path(for: field), schema: Joined.schemaOrAlias),
            QueryBuilder.queryExpressionGeometry(filter),
            SQLLiteral.numeric(String(value)))
    }
    
    @discardableResult
    public func filterGeographyDistanceWithin<Joined, Field, V>(
        _ joined: Joined.Type,
        _ field: KeyPath<Joined, Field>,
        _ filter: V,
        _ value: Double
    ) -> Self
        where Joined: Schema, Field: QueryableProperty, V: GeometryConvertible, Field.Model == Joined
    {

        return queryFilterGeographyDistanceWithin(
            .path(
                Joined.path(for: field), schema: Joined.schemaOrAlias),
            QueryBuilder.queryExpressionGeography(filter),
            SQLLiteral.numeric(String(value)))
    }
  
    
    @discardableResult
    public func filterGeographyDistanceWithin<F,V>(_ field: KeyPath<Model, F>, _ filter: V, _ value: Double) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryFilterGeographyDistanceWithin(QueryBuilder.path(field),
                                                 QueryBuilder.queryExpressionGeography(filter),
                                                 SQLLiteral.numeric(String(value)))
        //return filterGeographyDistanceWithin(Database.queryField(.keyPath(key)), Database.queryFilterValueGeographic(filter),  Database.queryFilterValue([value]))
    }
    
 
}

extension QueryBuilder {
    func queryFilterGeometryDistanceWithin(_ field: String, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        
        applyFilter(function: "ST_DWithin", args: [SQLColumn(field), filter, value])
        return self
    }
    
    func queryFilterGeometryDistanceWithin(_ field: DatabaseQuery.Field, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        applyFilter(function: "ST_DWithin", args: [SQLColumn(field.description), filter, value])
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
        let field: SQLExpression = SQLRaw(field)
        applyFilter(function: "ST_DWithin", args: [field, filter, value])
        return self
    }
    
    func queryFilterGeographyDistanceWithin(_ field: DatabaseQuery.Field, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        let fieldExpression: String
        switch field {
        case .custom(_):
            fieldExpression = field.description
        case .path(let keys, let schema):
            fieldExpression = "\"\(schema)\".\"\(keys.first!)\""
        }
        applyFilter(function: "ST_DWithin", args: [SQLRaw(fieldExpression), filter, value])
        return self
    }
    
   
}

