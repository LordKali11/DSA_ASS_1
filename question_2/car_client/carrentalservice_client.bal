import ballerina/io;

CarRentalServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {


}


function displayMenu() {
    io:println("Car Rental Service Menu:");
    io:println("1. Add Car");
    io:println("2. Update Car");
    io:println("3. Remove Car");
    io:println("4. Search Car");
    io:println("5. Add to Cart");
    io:println("6. Place Reservation");
    io:println("7. Create Users (Streaming)");
    io:println("8. List Available Cars (Query)");
    io:println("9. List All Reservations (Server Streaming)");
    io:println("10. Exit");
}

function adminPage() returns error? {
    io:println("Login Successful (Admin)");
    boolean run = true;
    while run {
        displayMenu();
        string option = io:readln("Enter Choice: ");
        match option {
            "1" => {
                CarResponse|error? addCarResponse = check addCar();
                io:println(addCarResponse);
            }
            "2" => {
                CarResponse|error? updateCarResponse = check updateCar();
                io:println(updateCarResponse);
            }
            "3" => {
                CarList|error? removeCarResponse = check RemoveCar();
                io:println(removeCarResponse);
            }
            "4" => {
                CarResponse|error? searchCarResponse = check searchCar();
                io:println(searchCarResponse);
            }
            "5" => {
                CartResponse|error? addToCartResponse = check addToCart();
                io:println(addToCartResponse);
            }
            "6" => {
                ReservationResponse|error? reservationResponse =  placeReservation();
                io:println(reservationResponse);
            }
            "7" => {
                UserCreationResponse? createUsersResponse = check createUsers();
                io:println(createUsersResponse);
            }
            "8" => {
                stream<Car, error?> availableCars =   listAvailableCars();
                check availableCars.forEach(function(Car car) {
                    io:println(car);
                });
            }
            "9" => {
                check listAllReservations();
            }
            "10" => {
                io:println("Thank you for using the system.");
                run = false;
            }
            
        }
    }

}

function CustomerPage() returns error? {
    io:println("Login Successful (Customer)");
    boolean run = true;
    while run {
        displayMenu();
        string option = io:readln("Enter Choice: ");
        match option {
            "1" => {
                CarResponse|error? searchCarResponse = check searchCar();
                io:println(searchCarResponse);
            }
            "2" => {
                CartResponse|error? addToCartResponse = check addToCart();
                io:println(addToCartResponse);
            }
            "3" => {
                ReservationResponse|error? reservationResponse =  placeReservation();
                io:println(reservationResponse);
            }
            "4" => {
                stream<Car, error?> availableCars =   listAvailableCars();
                check availableCars.forEach(function(Car car) {
                    io:println(car);
                });
            }
            "5" => {
                check listAllReservations();
            }
            "6" => {
                io:println("Thank you for using the system.");
                run = false;
            }
            _ => {
                io:println("Invalid option. Please try again.");
            }
        }
    }
}

function inputCarDetails() returns Car|error {
    Car car;
    string name = io:readln("Enter plate number: ");
    string make = io:readln("Enter make: ");
    string model = io:readln("Enter model: ");
    string year_string =  io:readln("Enter year: ");
    string daily_price_string = io:readln("Enter daily price: ");
    string mileage_string =  io:readln("Enter mileage: ");
    string status_string = io:readln("Enter status (AVAILABLE/RENTED/MAINTENCE/UNAVAILABLE): ");
    
    //TypeCasting
    int|error year = check int:fromString(year_string);
    float|error daily_price = check float:fromString(daily_price_string);
    float|error mileage = check float:fromString(mileage_string);
    CarStatus status = <CarStatus>status_string;
    
    car = {plate_number: name, make: make, model:model, year:check year, daily_price:check daily_price, mileage:check mileage, status: status};
    return car;
}


function addCar() returns CarResponse|error? {
    Car car_request = check inputCarDetails();
    CarResponse carResponse = check ep->AddCar(car_request);
    return carResponse;
}

function updateCar() returns CarResponse|error? {
    CarUpdateRequest car_request = {};
    io:println("Enter plate number of the car to update:");
    car_request.plate_number = io:readln();
    io:println("Enter new status (AVAILABLE/RENTED/MAINTENCE/UNAVAILABLE):");
    string status_string = io:readln();
    string daily_price_string = io:readln("Enter new daily price (or press enter to skip): ");
    string mileage_string = io:readln("Enter new mileage (or press enter to skip): ");

    //TypeCasting
    float|error daily_price = check float:fromString(daily_price_string);
    float|error mileage = check float:fromString(mileage_string);
    CarStatus status = <CarStatus>status_string;
    
    car_request.status = status;
    car_request.daily_price = daily_price is float ? daily_price : ();
    car_request.mileage = mileage is float ? mileage : ();

    CarResponse carResponse = check ep->UpdateCar(car_request);
    return carResponse;
}

function RemoveCar() returns CarList|error? {
    RemoveCarRequest car_request = {};
    io:println("Enter plate number of the car to remove:");
    car_request.plate_number = io:readln();
    CarList carList = check ep->RemoveCar(car_request);
    return carList;
}

function searchCar() returns CarResponse|error? {
    SearchRequest car_request = {};
    io:println("Enter plate number of the car to search:");
    car_request.plate_number = io:readln();
    CarResponse car = check ep->SearchCar(car_request);
    return car;
}

function addToCart() returns CartResponse|error? {
    CartItem cart_request = {};
    io:println("Enter user ID:");
    cart_request.user_id = io:readln();
    io:println("Enter plate number of the car to add to cart:");
    cart_request.plate_number = io:readln();
    io:println("Enter start date (YYYY-MM-DD):");
    cart_request.start_date = io:readln();
    io:println("Enter end date (YYYY-MM-DD):");
    cart_request.end_date = io:readln();
    CartResponse cartResponse = check ep->AddToCart(cart_request);
    return cartResponse;
}

//Need to fix this function
function placeReservation() returns ReservationResponse|error? {
    ReservationRequest reservation_request = {};
    reservation_request.user_id = io:readln("Enter user ID: ");
    ReservationResponse reservationResponse = check ep->PlaceReservation(reservation_request);
    return reservationResponse;
}

function createUsers() returns UserCreationResponse?|error? {
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
        string status_string = io:readln("Enter role (CUSTOMER/ADMIN):");
        UserRole status = <UserRole>status_string;
        user_request.role = status;
        check createUsersStreamingClient->sendUser(user_request);
    }
    check createUsersStreamingClient->complete();
    UserCreationResponse? createUsersResponse = check createUsersStreamingClient->receiveUserCreationResponse();
    return createUsersResponse;
}

function listAvailableCars() returns stream<Car, error?> {
    stream<Car,error?> availableCars = from var car in check ep->ListAvailableCars({})
                        where car.status == "AVAILABLE"
                        select car;
    return availableCars;
}

function listAllReservations() returns error? {
    Empty listAllReservationsRequest = {};
    stream<Reservation, error?> reservationsStream = check ep->ListAllReservations(listAllReservationsRequest);
    check reservationsStream.forEach(function(Reservation value) {
        io:println(value);
    });
}