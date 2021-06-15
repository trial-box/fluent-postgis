import FluentSQL
import WKCodable

extension QueryBuilder {
    static func queryExpressionGeometry<T: GeometryConvertible>(_ geometry: T) -> SQLExpression {
        let geometryText = WKTEncoder().encode(geometry.geometry)
        return SQLFunction("ST_GeomFromEWKT", args: [SQLLiteral.string(geometryText)])
    }
    
    static func queryExpressionGeography<T: GeometryConvertible>(_ geometry: T) -> SQLExpression {
        let geometryText = WKTEncoder().encode(geometry.geometry)
        return SQLLiteral.string(geometryText)
    }
    
//    private static func key(_ key: FieldKey) -> String {
//        switch key {
//        case .id:
//            return "id"
//        case .string(let name):
//            return name
//        case .aggregate:
//            return key.description
//        }
//    }
    
    static func path<F>(_ field: KeyPath<Model, F>) -> String where F: QueryableProperty {
        return Model.path(for: field).map(\.description).joined(separator: "_")
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

// *ask* - work out which is the correct SRID
// ST_DWithin(b.geom,'SRID=3857;POINT(3072163.4 7159374.1)',                     4000)
// ST_DWithin("addresses."coordinate", 'SRID=4326;Point(38.824972 -104.340629)', 5000.0)

