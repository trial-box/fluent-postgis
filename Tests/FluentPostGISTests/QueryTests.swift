import XCTest
import FluentKit
import FluentBenchmark
import FluentPostgresDriver
import PostgresKit
import Foundation
@testable import FluentPostGIS

final class QueryTests: XCTestCase {
    var eventLoopGroup: EventLoopGroup!
    var threadPool: NIOThreadPool!
    var benchmarker: FluentBenchmarker {
        return .init(databases: self.dbs)
    }
    var dbs: Databases!
    var conn: Database {
<<<<<<< HEAD
        self.benchmarker.database
    }
    var db: Database {
=======
>>>>>>> 789cfa4... Finish tests refactor
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
    
    func testContains() throws {
<<<<<<< HEAD
=======
        final class UserArea: Model {
            static let schema = "user_area"
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
        
>>>>>>> 789cfa4... Finish tests refactor
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)
        
        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()
        
        let testPoint = GeometricPoint2D(x: 5, y: 5)
        let all = try UserArea.query(on: conn).filterGeometryContains(\.$area, testPoint).all().wait()
<<<<<<< HEAD
=======

>>>>>>> 789cfa4... Finish tests refactor
        XCTAssertEqual(all.count, 1)
    }
    
    func testContainsReversed() throws {
<<<<<<< HEAD
=======
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

>>>>>>> 789cfa4... Finish tests refactor
        try UserLocationMigration().prepare(on: conn).wait()
        defer { try! UserLocationMigration().revert(on: conn).wait() }

        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPoint = GeometricPoint2D(x: 5, y: 5)
        let user = UserLocation()
        user.location = testPoint
        _ = try user.save(on: conn).wait()

        let all = try UserLocation.query(on: conn).filterGeometryContains(polygon, \.$location).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testContainsWithHole() throws {
<<<<<<< HEAD
=======
        final class UserArea: Model {
            static let schema = "user_area"
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

>>>>>>> 789cfa4... Finish tests refactor
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }

        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let hole = GeometricLineString2D(points: [
            GeometricPoint2D(x: 2.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 2.5)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing, interiorRings: [hole])

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let testPoint = GeometricPoint2D(x: 5, y: 5)
        let all = try UserArea.query(on: conn).filterGeometryContains(\.$area, testPoint).all().wait()
        XCTAssertEqual(all.count, 0)

        let testPoint2 = GeometricPoint2D(x: 1, y: 5)
        let all2 = try UserArea.query(on: conn).filterGeometryContains(\.$area, testPoint2).all().wait()
        XCTAssertEqual(all2.count, 1)
    }

    func testCrosses() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_area"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5)
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryCrosses(\.$area, testPath).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testCrossesReversed() throws {
<<<<<<< HEAD
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }
=======
        final class UserLocation: Model {
            static let schema = "user_location"
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "path")
            var path: GeometricLineString2D
        }
        struct UserLocationMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("path", GeometricLineString2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema).delete()
            }
        }

        try UserLocationMigration().prepare(on: conn).wait()
        defer { try! UserLocationMigration().revert(on: conn).wait() }
>>>>>>> 789cfa4... Finish tests refactor

        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5)
<<<<<<< HEAD
            ])

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryCrosses(polygon, \.$path).all().wait()
=======
        ])

        let user = UserLocation()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserLocation.query(on: conn).filterGeometryCrosses(polygon, \.$path).all().wait()
>>>>>>> 789cfa4... Finish tests refactor
        XCTAssertEqual(all.count, 1)
    }

    func testDisjoint() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_area"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 11, y: 5)
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryDisjoint(\.$area, testPath).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testDisjointReversed() throws {
<<<<<<< HEAD
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }
=======
        final class UserLocation: Model {
            static let schema = "user_location"
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "path")
            var path: GeometricLineString2D
        }
        struct UserLocationMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("path", GeometricLineString2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema).delete()
            }
        }

        try UserLocationMigration().prepare(on: conn).wait()
        defer { try! UserLocationMigration().revert(on: conn).wait() }
>>>>>>> 789cfa4... Finish tests refactor

        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 11, y: 5)
<<<<<<< HEAD
            ])

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryDisjoint(polygon, \.$path).all().wait()
=======
        ])

        let user = UserLocation()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserLocation.query(on: conn).filterGeometryDisjoint(polygon, \.$path).all().wait()
>>>>>>> 789cfa4... Finish tests refactor
        XCTAssertEqual(all.count, 1)
    }

    func testEquals() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_area"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryEquals(\.$area, polygon).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testIntersects() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_area"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5)
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryIntersects(\.$area, testPath).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testIntersectsReversed() throws {
<<<<<<< HEAD
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }
=======
        final class UserLocation: Model {
            static let schema = "user_location"
            @ID(custom: "id", generatedBy: .database)
            var id: Int?
            @Field(key: "path")
            var path: GeometricLineString2D
        }
        struct UserLocationMigration: Migration {
            func prepare(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema)
                    .field("id", .int, .identifier(auto: true))
                    .field("path", GeometricLineString2D.dataType)
                    .create()
            }
            func revert(on database: Database) -> EventLoopFuture<Void> {
                return database.schema(UserLocation.schema).delete()
            }
        }

        try UserLocationMigration().prepare(on: conn).wait()
        defer { try! UserLocationMigration().revert(on: conn).wait() }
>>>>>>> 789cfa4... Finish tests refactor

        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5)
<<<<<<< HEAD
            ])

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryIntersects(polygon, \.$path).all().wait()
=======
        ])

        let user = UserLocation()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserLocation.query(on: conn).filterGeometryIntersects(polygon, \.$path).all().wait()
>>>>>>> 789cfa4... Finish tests refactor
        XCTAssertEqual(all.count, 1)
    }

    func testOverlaps() throws {
<<<<<<< HEAD
=======
        final class UserPath: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5),
            GeometricPoint2D(x: 6, y: 6),
            GeometricPoint2D(x: 0, y: 0),
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let testPath2 = GeometricLineString2D(points: [
            GeometricPoint2D(x: 16, y: 0),
            GeometricPoint2D(x: 5, y: 5),
            GeometricPoint2D(x: 6, y: 6),
            GeometricPoint2D(x: 2, y: 0),
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryOverlaps(\.$path, testPath2).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testOverlapsReversed() throws {
<<<<<<< HEAD
=======
        final class UserPath: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }

        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 15, y: 0),
            GeometricPoint2D(x: 5, y: 5),
            GeometricPoint2D(x: 6, y: 6),
            GeometricPoint2D(x: 0, y: 0),
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let testPath2 = GeometricLineString2D(points: [
            GeometricPoint2D(x: 16, y: 0),
            GeometricPoint2D(x: 5, y: 5),
            GeometricPoint2D(x: 6, y: 6),
            GeometricPoint2D(x: 2, y: 0),
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryOverlaps(testPath2, \.$path).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testTouches() throws {
<<<<<<< HEAD
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }
        
=======
        final class UserPath: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 1, y: 1),
            GeometricPoint2D(x: 0, y: 2)
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let testPoint = GeometricPoint2D(x: 0, y: 2)

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryTouches(\.$path, testPoint).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testTouchesReversed() throws {
<<<<<<< HEAD
        try UserPathMigration().prepare(on: conn).wait()
        defer { try! UserPathMigration().revert(on: conn).wait() }
        
=======
        final class UserPath: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        let testPath = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 1, y: 1),
            GeometricPoint2D(x: 0, y: 2)
<<<<<<< HEAD
            ])
=======
        ])
>>>>>>> 789cfa4... Finish tests refactor

        let testPoint = GeometricPoint2D(x: 0, y: 2)

        let user = UserPath()
        user.path = testPath
        _ = try user.save(on: conn).wait()

        let all = try UserPath.query(on: conn).filterGeometryTouches(testPoint, \.$path).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testWithin() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)
        let hole = GeometricLineString2D(points: [
            GeometricPoint2D(x: 2.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 2.5)])
        let polygon2 = GeometricPolygon2D(exteriorRing: hole)

        let user = UserArea()
        user.area = polygon2
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryWithin(\.$area, polygon).all().wait()
        XCTAssertEqual(all.count, 1)
    }

    func testWithinReversed() throws {
<<<<<<< HEAD
        try UserAreaMigration().prepare(on: conn).wait()
        defer { try! UserAreaMigration().revert(on: conn).wait() }
        
=======
        final class UserArea: Model {
            static let schema = "user_path"
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

>>>>>>> 789cfa4... Finish tests refactor
        let exteriorRing = GeometricLineString2D(points: [
            GeometricPoint2D(x: 0, y: 0),
            GeometricPoint2D(x: 10, y: 0),
            GeometricPoint2D(x: 10, y: 10),
            GeometricPoint2D(x: 0, y: 10),
            GeometricPoint2D(x: 0, y: 0)])
        let polygon = GeometricPolygon2D(exteriorRing: exteriorRing)
        let hole = GeometricLineString2D(points: [
            GeometricPoint2D(x: 2.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 2.5),
            GeometricPoint2D(x: 7.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 7.5),
            GeometricPoint2D(x: 2.5, y: 2.5)])
        let polygon2 = GeometricPolygon2D(exteriorRing: hole)

        let user = UserArea()
        user.area = polygon
        _ = try user.save(on: conn).wait()

        let all = try UserArea.query(on: conn).filterGeometryWithin(polygon2, \.$area).all().wait()
        XCTAssertEqual(all.count, 1)
    }
}
