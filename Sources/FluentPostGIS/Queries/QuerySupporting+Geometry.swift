import FluentSQL
import WKCodable

extension QueryBuilder {
    static func queryExpressionGeometry<T: GeometryConvertible>(_ geometry: T) -> SQLExpression {
        let geometryText = WKTEncoder().encode(geometry.geometry)
        return SQLFunction("ST_GeomFromEWKT", args: [SQLLiteral.string(geometryText)])
    }
    
    private static func key(_ key: FieldKey) -> String {
           switch key {
           case .id:
               return "id"
           case .string(let name):
               return name
           case .aggregate:
               return key.description
           }
       }
       
       static func path<F>(_ field: KeyPath<Model, F>) -> String where F: FieldProtocol {
           return Model.path(for: field).map(Self.key).joined(separator: "_")
       }
}
