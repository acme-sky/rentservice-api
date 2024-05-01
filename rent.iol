
type RentRequest: void {
    .CustomerName:    string
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
