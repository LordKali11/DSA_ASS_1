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


function inputCarDetails() returns Car {
    Car car;
    string name = io:readln("Enter plate number: ");
    string make = io:readln("Enter make: ");
    string model = io:readln("Enter model: ");
    string year_string = check io:readln("Enter year: ");
    string daily_price_string = check io:readln("Enter daily price: ");
    string mileage_string = check io:readln("Enter mileage: ");
    string status = io:readln("Enter status (AVAILABLE/RENTED/MAINTENCE/UNAVAILABLE): ");
    int|error year = check int:fromString(year_string);
    float|error daily_price = check float:fromString(daily_price_string);
    float|error mileage = check float:fromString(mileage_string);
    car = {plate_number: name, make: make, model: model, year: year, daily_price: daily_price, mileage: mileage, status: status};
}
function addCar() returns CarResponse|error {
    Car car_request = inputCarDetails();
    CarResponse ep = check ep->AddCar(car_request);
    return check ep->AddCar(car);
}

function updateCar() returns CarResponse|error {
    CarUpdateRequest car_request = {};
    io:println("Enter plate number of the car to update:");
    car_request.plate_number = io:readln();
    io:println("Enter new status (AVAILABLE/RENTED/MAINTENCE/UNAVAILABLE):");
    car_request.status = io:readln();
    CarResponse ep = check ep->UpdateCar(car_request);
    return ep;
}

function RemoveCar() returns Carlist|error {
    RemoveCarRequest car_request = {};
    io:println("Enter plate number of the car to remove:");
    car_request.plate_number = io:readln();
    CarList ep = check ep->RemoveCar(car_request);
    return ep;
}

function searchCar() returns CarResponse|error {
    SearchRequest car_request = {};
    io:println("Enter plate number of the car to search:");
    car_request.plate_number = io:readln();
    CarResponse ep = check ep->SearchCar(car_request);
    return ep;
}

function addToCart() returns CartResponse|error {
    CartItem cart_request = {};
    io:println("Enter user ID:");
    cart_request.user_id = io:readln();
    io:println("Enter plate number of the car to add to cart:");
    cart_request.plate_number = io:readln();
    io:println("Enter start date (YYYY-MM-DD):");
    cart_request.start_date = io:readln();
    io:println("Enter end date (YYYY-MM-DD):");
    cart_request.end_date = io:readln();
    CartResponse ep = check ep->AddToCart(cart_request);
    return ep;
}

//Need to fix this function
function placeReservation() returns ReservationResponse|error {
    ReservationRequest reservation_request = {};
    io:println("Enter user ID:");
    reservation_request.user_id = io:readln();
    ReservationResponse ep = check ep->PlaceReservation(reservation_request);
    return ep;
}

function createUsers() returns UserCreationResponse|error {
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    while true {
        User user_request = {};
        io:println("Enter user ID (or 'exit' to finish):");
        user_request.user_id = io:readln();
        if user_request.user_id == "exit" {
            break;
        }
        io:println("Enter name:");
        user_request.name = io:readln();
        io:println("Enter email:");
        user_request.email = io:readln();
        io:println("Enter role (CUSTOMER/ADMIN):");
        user_request.role = io:readln();
        check createUsersStreamingClient->sendUser(user_request);
    }
    check createUsersStreamingClient->complete();
    UserCreationResponse? createUsersResponse = check createUsersStreamingClient->receiveUserCreationResponse();
    return createUsersResponse;
}

function listAvailableCars() returns error? {
    FilterRequest filter_request = {};
    stream<Car, error?> availableCarsStream = check ep->ListAvailableCars(filter_request);
    check availableCarsStream.forEach(function(Car value) {
        io:println(value);
    });
}

function listAllReservations() returns error? {
    Empty listAllReservationsRequest = {};
    stream<Reservation, error?> reservationsStream = check ep->ListAllReservations(listAllReservationsRequest);
    check reservationsStream.forEach(function(Reservation value) {
        io:println(value);
    });
}