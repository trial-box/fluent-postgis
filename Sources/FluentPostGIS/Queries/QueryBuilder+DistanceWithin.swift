import FluentSQL
import WKCodable

extension QueryBuilder {
    @discardableResult
    public func filterGeometryDistanceWithin<F,V>(_ field: KeyPath<Model, F>, _ filter: V, _ value: Double) -> Self
        where F: FieldProtocol, V: GeometryConvertible
    {
        return queryFilterGeometryDistanceWithin(QueryBuilder.path(field),
                                                 QueryBuilder.queryExpressionGeometry(filter),
                                                 SQLLiteral.numeric(String(value)))
    }
}

extension QueryBuilder {
    func queryFilterGeometryDistanceWithin(_ path: String, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        applyFilter(function: "ST_DWithin", args: [SQLColumn(path), filter, value])
        return self
    }
}

extension QueryBuilder {
    func applyFilter(function: String, args: [SQLExpression]) {
        query.filters.append(.custom(SQLFunction(function, args: args)))
    }
    
    func applyFilter(function: String, path: String, value: SQLExpression) {
        applyFilter(function: function, args: [SQLColumn(path), value])
    }
    
    func applyFilter(function: String, value: SQLExpression, path: String) {
        applyFilter(function: function, args: [value, SQLColumn(path)])
    }
}
