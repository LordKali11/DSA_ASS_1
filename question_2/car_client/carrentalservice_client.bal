import ballerina/io;

CarRentalServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Car addCarRequest = {plate_number: "ballerina", make: "ballerina", model: "ballerina", year: 1, daily_price: 1, mileage: 1, status: "AVAILABLE"};
    CarResponse addCarResponse = check ep->AddCar(addCarRequest);
    io:println(addCarResponse);

    CarUpdateRequest updateCarRequest = {plate_number: "ballerina"};
    CarResponse updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println(updateCarResponse);

    RemoveCarRequest removeCarRequest = {plate_number: "ballerina"};
    CarList removeCarResponse = check ep->RemoveCar(removeCarRequest);
    io:println(removeCarResponse);

    SearchRequest searchCarRequest = {plate_number: "ballerina"};
    CarResponse searchCarResponse = check ep->SearchCar(searchCarRequest);
    io:println(searchCarResponse);

    CartItem addToCartRequest = {user_id: "ballerina", plate_number: "ballerina", start_date: "ballerina", end_date: "ballerina"};
    CartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    ReservationRequest placeReservationRequest = {user_id: "ballerina"};
    ReservationResponse placeReservationResponse = check ep->PlaceReservation(placeReservationRequest);
    io:println(placeReservationResponse);

    UserRequest getUserDetailsRequest = {user_id: "ballerina"};
    User getUserDetailsResponse = check ep->GetUserDetails(getUserDetailsRequest);
    io:println(getUserDetailsResponse);

    FilterRequest listAvailableCarsRequest = {};
    stream<Car, error?> listAvailableCarsResponse = check ep->ListAvailableCars(listAvailableCarsRequest);
    check listAvailableCarsResponse.forEach(function(Car value) {
        io:println(value);
    });

    Empty listAllReservationsRequest = {};
    stream<Reservation, error?> listAllReservationsResponse = check ep->ListAllReservations(listAllReservationsRequest);
    check listAllReservationsResponse.forEach(function(Reservation value) {
        io:println(value);
    });

    User createUsersRequest = {user_id: "ballerina", name: "ballerina", email: "ballerina", role: "CUSTOMER"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUser(createUsersRequest);
    check createUsersStreamingClient->complete();
    UserCreationResponse? createUsersResponse = check createUsersStreamingClient->receiveUserCreationResponse();
    io:println(createUsersResponse);
}
