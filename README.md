# ACME Sky - Rent service 

## New rent
You can generate a new rent service with the same interface used by `server.ol`.

```
$ jolie2wsdl --namespace <namespace> --portName RentPort --portAddr <portaddr> --outputFile <file.wsdl> server.ol
```

Now you need to create a config file

```json
{
    "location": "<portaddr>", # You can't use socket://
    "proto": {
        "$": "soap",
        "wsdl": "<file.wsdl>"
    },
    "database": {
        "username": "<username>",
        "password": "<password>",
        "host": "<host>",
        "name": "<name>"
    }
}
```

Now run server

```
$ jolie --params config.json server.ol
```

## Test SOAP API

A request can be:

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rent="rent.uber.com.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <rent:BookRent>
         <CustomerName>Mario Rossi</CustomerName>
         <PickupAddress>Via Zamboni 33, Bologna</PickupAddress>
         <Address>Mura Anteo Zamboni 7, Bologna</Address>
         <PickupDate>2024-03-02T13:10:00Z</PickupDate>
      </rent:BookRent>
   </soapenv:Body>
</soapenv:Envelope>
```

## Deploy with Docker compose

First, build the local image

```
docker build -t acmesky-rentservice .
```

Then, fix `config.json` adding the right path `/etc/data` and database.host,
which is the container name for PostgreSQL.

```
{
    "location": "socket://localhost:8080",
    "proto": {
        "$": "soap",
        "wsdl": "/etc/data/rent.wsdl"
    },
    "database": {
        "username": "postgres",
        "password": "postgres",
        "host": "rent-postgres",
        "name": "postgres"
    }
}
```

Finally, run

```
docker compose up
```
