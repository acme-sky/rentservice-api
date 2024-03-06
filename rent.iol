
type RentRequest: void {
    .CustomerName:    string
    .CustomerSurname: string
    .PickupAddress:   string
    .PickupDate:      string
    .Address:         string
}

type RentResponse: void {
    .RentId?:        string
    .Error?:         string

    .Status:         string
}

interface RentInterface {
    RequestResponse:
        BookRent(RentRequest)(RentResponse)
}
