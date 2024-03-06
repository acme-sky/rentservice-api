// This server file represents a SOAP API service for a rent company who allows
// to reserve a transfer from a `pickup address` to an `address` in a `pickup
// date`.
// 
// All the business logic used for creating or updating everything else linked
// to this rent company is ignored.

include "console.iol"
include "database.iol"
include "rent.iol"

// Database driver can't be changed because we're using UUID as id type and
// not all the Jolie supported database drivers support this datatype.
type DatabaseParam {
    username: string
    password: string
    host: string
    name: string
}

type Params {
    location: string
    proto: string {
        wsdl: string
    }
    database: DatabaseParam
}

service Rent(p: Params) {

    init {
        with (conn) {
            .username = p.database.username;
            .password = p.database.password;
            .host = p.database.host;
            .database = p.database.name;
            .driver = "postgresql"
        }
    }

    inputPort RentPort {
        Location: p.location
        Protocol: p.proto
        Interfaces: RentInterface
    }

    main {
        install(SQLException => {
            println@Console("Error on database: \"" + main.SQLException.message + "\"")()
        })

        connect@Database(conn)(void)

        println@Console("Server running...")()

        while (1) {
            [BookRent(request)(response) {
                println@Console("Received a new request...")()
                response.RentID = "00000000-0000-0000-0000-000000000000"
            }]
        }
    }
}
