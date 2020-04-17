import XCTest
import FluentKit
import FluentBenchmark
import FluentPostgresDriver
import PostgresKit
import Foundation
@testable import FluentPostGIS

final class GeometryTests: XCTestCase {
    var eventLoopGroup: EventLoopGroup!
    var threadPool: NIOThreadPool!
    var benchmarker: FluentBenchmarker {
        return .init(databases: self.dbs)
    }
    var dbs: Databases!
    var conn: Database {
        self.benchmarker.database
    }
    var postgres: PostgresDatabase {
        self.conn as! PostgresDatabase
    }
    
    override func setUp() {
        let configuration = PostgresConfiguration(
            hostname: "localhost",
            username: "fluentpostgis",
            password: "fluentpostgis",
            database: "postgis_tests"
        )
        
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.threadPool = NIOThreadPool(numberOfThreads: 1)
        self.dbs = Databases(threadPool: threadPool, on: self.eventLoopGroup)
        self.dbs.use(.postgres(configuration: configuration), as: .psql)
    }
    
    func testPoint() throws {
        final class UserLocation: Model {
            static let schema = "user_location"
            
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "location")
            var location: GeometricPoint2D
        }
        
        struct UserLocationMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("location", GeometricPoint2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema).delete()
            }
        }
        
        
        try UserLocationMigration().prepare(on: conn).wait()
        defer { try! UserLocationMigration().revert(on: conn).wait() }

        let point = GeometricPoint2D(x: 1, y: 2)

        let user = UserLocation()
        user.location = point
        _ = try user.save(on: conn).wait()

        let fetched = try UserLocation.find(1, on: conn).wait()
        XCTAssertEqual(fetched?.location, point)

        let all = try UserLocation.query(on: conn).filterGeometryDistanceWithin(\.$location, user.location, 1000).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testLineString() throws {
        final class UserPath: Model {
            static var schema: String = "user_path"
            
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "path")
            var path: GeometricLineString2D
        }
        struct UserPathMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserPath.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("path", GeometricLineString2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserPath.schema).delete()
            }
        }

        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }

        let point = GeometricPoint2D(x: 1, y: 2)
        let point2 = GeometricPoint2D(x: 2, y: 3)
        let point3 = GeometricPoint2D(x: 3, y: 2)
        let lineString = GeometricLineString2D(points: [point, point2, point3, point])

        let user = UserPath()
        user.path = lineString
        _ = try user.save(on: conn).wait()

        let fetched = try UserPath.find(1, on: conn).wait()
        XCTAssertEqual(fetched?.path, lineString)
    }

    func testPolygon() throws {
        final class UserArea: Model {
            static var schema: String = "user_area"
            
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "area")
            var area: GeometricPolygon2D
        }
        struct UserAreaMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserArea.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("area", GeometricPolygon2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserArea.schema).delete()
            }
        }

        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }

        let point = GeometricPoint2D(x: 1, y: 2)
        let point2 = GeometricPoint2D(x: 2, y: 3)
        let point3 = GeometricPoint2D(x: 3, y: 2)
        let lineString = GeometricLineString2D(points: [point, point2, point3, point])
        let polygon = GeometricPolygon2D(exteriorRing: lineString, interiorRings: [lineString, lineString])

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let fetched = try UserArea.find(1, on: conn).wait()
        XCTAssertEqual(fetched?.area, polygon)
    }

    func testGeometryCollection() throws {
        final class UserCollection: Model {
            static var schema: String = "user_collection"
            
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "collection")
            var collection: GeometricGeometryCollection2D
        }
        struct UserCollectionMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserCollection.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("collection", GeometricGeometryCollection2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserCollection.schema).delete()
            }
        }

        try UserCollectionMigration().prepare(on: conn).wait()
        defer { try! UserCollectionMigration().revert(on: conn).wait() }

        let point = GeometricPoint2D(x: 1, y: 2)
        let point2 = GeometricPoint2D(x: 2, y: 3)
        let point3 = GeometricPoint2D(x: 3, y: 2)
        let lineString = GeometricLineString2D(points: [point, point2, point3, point])
        let polygon = GeometricPolygon2D(exteriorRing: lineString, interiorRings: [lineString, lineString])
        let geometries: [GeometryCollectable] = [point, point2, point3, lineString, polygon]
        let geometryCollection = GeometricGeometryCollection2D(geometries: geometries)

        let user = UserCollection()
        user.collection = geometryCollection
        _ = try user.save(on: conn).wait()

        let fetched = try UserCollection.find(1, on: conn).wait()
        XCTAssertEqual(fetched?.collection, geometryCollection)
    }
}
