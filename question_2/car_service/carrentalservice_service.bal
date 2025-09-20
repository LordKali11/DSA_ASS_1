import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: CAR_RENTAL_DESC}
service "CarRentalService" on ep {

    remote function AddCar(Car value) returns CarResponse|error {
    }

    remote function UpdateCar(CarUpdateRequest value) returns CarResponse|error {
    }

    remote function RemoveCar(RemoveCarRequest value) returns CarList|error {
    }

    remote function SearchCar(SearchRequest value) returns CarResponse|error {
    }

    remote function AddToCart(CartItem value) returns CartResponse|error {
    }

    remote function PlaceReservation(ReservationRequest value) returns ReservationResponse|error {
    }

    remote function GetUserDetails(UserRequest value) returns User|error {
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UserCreationResponse|error {
    }

    remote function ListAvailableCars(FilterRequest value) returns stream<Car, error?>|error {
    }

    remote function ListAllReservations(Empty value) returns stream<Reservation, error?>|error {
    }
}
