import ballerina/grpc;

listener grpc:Listener ep = new (9090);

table<Car> key(plate_number) cars_table = table[];
table<CartItem> key(user_id) cart_table = table[];
table<User> key(user_id) users_table = table[];
table<Reservation> key(reservation_id) reservations_table = table[];



@grpc:Descriptor {value: CAR_RENTAL_DESC}
service "CarRentalService" on ep {

    remote function AddCar(Car value) returns CarResponse|error {
        if (cars_table.hasKey(value.plate_number)) {
            return {message: "Car with ID " + value.plate_number + " already exists."};
        }
        else if (!cars_table.hasKey(value.plate_number)) {
            cars_table.add(value);
            return {message: "Car with ID " + value.plate_number + " added successfully."};
        }
        else{
            return error("Failed to add car.");
        }
    }

    remote function UpdateCar(CarUpdateRequest value) returns CarResponse|error {
        if (cars_table.hasKey(value.plate_number)){
            Car car = cars_table.get(value.plate_number);
            cars_table.put(car);
            return {message: "Car with ID " + value.plate_number + " updated successfully."};
        }
        else {
            return {message: "Car with ID " + value.plate_number + " does not exist."};
        }
    }

    remote function RemoveCar(RemoveCarRequest value) returns CarList|error {
        if (cars_table.hasKey(value.plate_number)){
            Car car = cars_table.remove(value.plate_number);
            return {cars: cars_table.toArray()};
        }
        else {
            return error("Car with ID " + value.plate_number + " does not exist.");
        }
    }

    remote function SearchCar(SearchRequest value) returns CarResponse|error {
        if (cars_table.hasKey(value.plate_number)){
            Car car = cars_table.get(value.plate_number);
            return {message: "Car found: " + car.make + " " + car.model + " (" + car.year.toString() + ")" + 
                    ", Available: " + car.status.toString() + "Daily Price: $" + car.daily_price.toString() + "Mileage: " + car.mileage.toString()};
        }
        else {
            return {message: "Car with ID " + value.plate_number + " does not exist."};
        }
    }

    remote function AddToCart(CartItem value) returns CartResponse|error {
        if (!users_table.hasKey(value.user_id)){
            return error("User with ID " + value.user_id + " does not exist.");
        }
        else if (!cars_table.hasKey(value.plate_number)){
            return error("Car with ID " + value.plate_number + " does not exist.");
        }
        else {
            cart_table.add(value);
            return {message: "Car with ID " + value.plate_number + " added to cart for user " + value.user_id + "."};
        }
    }


    //Need to fix this function
    remote function PlaceReservation(ReservationRequest value) returns ReservationResponse|error {
        if (!users_table.hasKey(value.user_id)){
            return error("User with ID " + value.user_id + " does not exist.");
        }
        else if (!cart_table.hasKey(value.user_id)){
            return error("Cart is empty for user " + value.user_id + ".");
        }
        else {
            float total_price = 0;
            return {message: "Reservation placed successfully. Total price: $" + total_price.toString()};
        }
        
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UserCreationResponse|error {
        User[] users = [];
        check clientStream.forEach(function (User user) {
            users_table.add(user);
            users.push(user);
        });
        return {message:"Users created successfully."};
    }

    remote function ListAvailableCars(FilterRequest value) returns stream<Car, error?>|error {
        var availableCars = stream from Car car in cars_table
                              where car.status == AVAILABLE
                              select car;
        
        return availableCars;
    }

    remote function ListAllReservations(Empty value) returns stream<Reservation, error?>|error {
        stream<Reservation, error?> allReservations = stream from Reservation res in reservations_table
                                                        select res;
        return allReservations;
    }
}
