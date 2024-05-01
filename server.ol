// This server file represents a SOAP API service for a rent company who allows
// to reserve a transfer from a `pickup address` to an `address` in a `pickup
// date`.
// 
// All the business logic used for creating or updating everything else linked
// to this rent company is ignored.

include "console.iol"
include "database.iol"
include "rent.iol"
include "time.iol"

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


        install(SQLException => {
            println@Console("Error on database: \"" + SQLException.message + "\"")()
        })

        connect@Database(conn)(void)

        println@Console("Server running...")()
    }

    inputPort RentPort {
        Location: p.location
        Protocol: p.proto
        Interfaces: RentInterface
    }

    execution: concurrent

    main {
        BookRent(request)(response) {
            scope(rent) {
                println@Console("Received a new request...")()

                response.Status = "ERROR"
                install(
                    // This `ParseError` error type has a `string` content
                    ParseError => 
                        println@Console("Got an error: \"" + rent.ParseError + "\".")()
                        response.Error = rent.ParseError,
                    SQLException =>
                        println@Console("Got an error: \"" + rent.SQLException.message + "\".")()
                        response.Error = "SQL Exception",
                    InvalidTimestamp =>
                        println@Console("Got an error: \"Invalid Timestamp\".")()
                        response.Error = "Invalid Timestamp"
                )

                if (request.CustomerName == "") {
                    throw(ParseError, "Empty CustomerName")
                } else if (request.PickupAddress == "") {
                    throw(ParseError, "Empty PickupAddress")
                } else if (request.PickupDate == "") {
                    throw(ParseError, "Empty PickupDate")
                } else if (request.Address == "") {
                    throw(ParseError, "Empty Address")
                }


                // Used to verify the correctness
                timestamp = request.PickupDate
                timestamp.format = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                getTimestampFromString@Time(timestamp)()

                updateRequest = "INSERT INTO reservation("+
                                "customer_name, pickup_address, address, pickup_date, created_at)"+
                                "VALUES(:customer_name, :pickup_address, :address, '" + request.PickupDate + "', NOW())"
                updateRequest.customer_name = request.CustomerName
                updateRequest.pickup_address = request.PickupAddress
                updateRequest.address = request.Address


                update@Database(updateRequest)(ret)

                if (ret == 1) {
                    query@Database("SELECT id FROM reservation ORDER BY created_at DESC LIMIT 1")(queryResponse)
                    response.RentId = queryResponse.row[0].id
                } else {
                    throw(SQLException)
                }

                response.Status = "OK"
            }
        }
    }
}
