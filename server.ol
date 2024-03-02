// This server file represents a SOAP API service for a rent company who allows
// to reserve a transfer from a `pickup address` to an `address` in a `pickup
// date`.
// 
// All the business logic used for creating or updating everything else linked
// to this rent company is ignored.

include "console.iol"
include "database.iol"
include "rent.iol"
include "runtime.iol"

type Params {
    location: string
    proto : string {
        wsdl: string
    }
}

service Rent(p: Params) {

    init {
        // Environment for database. Database driver can't be changed because we're
        // using UUID as id type and not all the Jolie supported database drivers
        // can support this datatype.
        getenv@Runtime("DB_USERNAME")(db_username)
        getenv@Runtime("DB_PASSWORD")(db_password)
        getenv@Runtime("DB_HOST")(db_host)
        getenv@Runtime("DB_NAME")(db_name)
        with (conn) {
            .username = db_username;
            .password = db_password;
            .host = db_host;
            .database = db_name;
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
