import ballerina/grpc;
import ballerina/protobuf;

public const string CAR_RENTAL_DESC = "0A106361725F72656E74616C2E70726F746F120A6361725F72656E74616C22070A05456D70747922D0010A0343617212210A0C706C6174655F6E756D626572180120012809520B706C6174654E756D62657212120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121F0A0B6461696C795F7072696365180520012801520A6461696C79507269636512180A076D696C6561676518062001280152076D696C65616765122D0A0673746174757318072001280E32152E6361725F72656E74616C2E436172537461747573520673746174757322730A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512140A05656D61696C1803200128095205656D61696C12280A04726F6C6518042001280E32142E6361725F72656E74616C2E55736572526F6C655204726F6C652280010A08436172744974656D12170A07757365725F6964180120012809520675736572496412210A0C706C6174655F6E756D626572180220012809520B706C6174654E756D626572121D0A0A73746172745F64617465180320012809520973746172744461746512190A08656E645F646174651804200128095207656E644461746522F0010A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E496412170A07757365725F69641802200128095206757365724964122A0A056974656D7318032003280B32142E6361725F72656E74616C2E436172744974656D52056974656D73121F0A0B746F74616C5F7072696365180420012801520A746F74616C507269636512350A0673746174757318052001280E321D2E6361725F72656E74616C2E5265736572766174696F6E5374617475735206737461747573121D0A0A637265617465645F6174180620012809520963726561746564417422640A0B436172526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512210A0363617218032001280B320F2E6361725F72656E74616C2E4361725203636172226F0A14557365724372656174696F6E526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512230A0D75736572735F63726561746564180320012805520C75736572734372656174656422D5010A104361725570646174655265717565737412210A0C706C6174655F6E756D626572180120012809520B706C6174654E756D62657212240A0B6461696C795F70726963651802200128014800520A6461696C79507269636588010112320A0673746174757318032001280E32152E6361725F72656E74616C2E43617253746174757348015206737461747573880101121D0A076D696C65616765180420012801480252076D696C65616765880101420E0A0C5F6461696C795F707269636542090A075F737461747573420A0A085F6D696C6561676522350A1052656D6F76654361725265717565737412210A0C706C6174655F6E756D626572180120012809520B706C6174654E756D626572222E0A074361724C69737412230A046361727318012003280B320F2E6361725F72656E74616C2E43617252046361727322780A0D46696C7465725265717565737412170A046D616B65180120012809480052046D616B6588010112170A0479656172180220012805480152047965617288010112190A056D6F64656C180320012809480252056D6F64656C88010142070A055F6D616B6542070A055F7965617242080A065F6D6F64656C22320A0D5365617263685265717565737412210A0C706C6174655F6E756D626572180120012809520B706C6174654E756D626572226E0A0C43617274526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765122A0A056974656D7318032003280B32142E6361725F72656E74616C2E436172744974656D52056974656D73222D0A125265736572766174696F6E5265717565737412170A07757365725F696418012001280952067573657249642284010A135265736572766174696F6E526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512390A0B7265736572766174696F6E18032001280B32172E6361725F72656E74616C2E5265736572766174696F6E520B7265736572766174696F6E2A480A09436172537461747573120D0A09415641494C41424C451000120F0A0B554E415641494C41424C451001120F0A0B4D41494E54454E414E43451002120A0A0652454E54454410032A230A0855736572526F6C65120C0A08435553544F4D4552100012090A0541444D494E10012A4D0A115265736572766174696F6E537461747573120B0A0750454E44494E471000120D0A09434F4E4649524D45441001120D0A0943414E43454C4C45441002120D0A09434F4D504C45544544100332FC040A1043617252656E74616C5365727669636512340A06416464436172120F2E6361725F72656E74616C2E4361721A172E6361725F72656E74616C2E436172526573706F6E7365220012450A0B437265617465557365727312102E6361725F72656E74616C2E557365721A202E6361725F72656E74616C2E557365724372656174696F6E526573706F6E73652200280112440A09557064617465436172121C2E6361725F72656E74616C2E436172557064617465526571756573741A172E6361725F72656E74616C2E436172526573706F6E7365220012400A0952656D6F7665436172121C2E6361725F72656E74616C2E52656D6F7665436172526571756573741A132E6361725F72656E74616C2E4361724C697374220012430A114C697374417661696C61626C654361727312192E6361725F72656E74616C2E46696C746572526571756573741A0F2E6361725F72656E74616C2E4361722200300112410A0953656172636843617212192E6361725F72656E74616C2E536561726368526571756573741A172E6361725F72656E74616C2E436172526573706F6E73652200123D0A09416464546F4361727412142E6361725F72656E74616C2E436172744974656D1A182E6361725F72656E74616C2E43617274526573706F6E7365220012550A10506C6163655265736572766174696F6E121E2E6361725F72656E74616C2E5265736572766174696F6E526571756573741A1F2E6361725F72656E74616C2E5265736572766174696F6E526573706F6E7365220012450A134C697374416C6C5265736572766174696F6E7312112E6361725F72656E74616C2E456D7074791A172E6361725F72656E74616C2E5265736572766174696F6E22003001620670726F746F33";

public isolated client class CarRentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CAR_RENTAL_DESC);
    }

    isolated remote function AddCar(Car|ContextCar req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function AddCarContext(Car|ContextCar req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(CarUpdateRequest|ContextCarUpdateRequest req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        CarUpdateRequest message;
        if req is ContextCarUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function UpdateCarContext(CarUpdateRequest|ContextCarUpdateRequest req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        CarUpdateRequest message;
        if req is ContextCarUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns CarList|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarList>result;
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextCarList|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarList>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchRequest|ContextSearchRequest req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function SearchCarContext(SearchRequest|ContextSearchRequest req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(CartItem|ContextCartItem req) returns CartResponse|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CartResponse>result;
    }

    isolated remote function AddToCartContext(CartItem|ContextCartItem req) returns ContextCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(ReservationRequest|ContextReservationRequest req) returns ReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        ReservationRequest message;
        if req is ContextReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(ReservationRequest|ContextReservationRequest req) returns ContextReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        ReservationRequest message;
        if req is ContextReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ReservationResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("car_rental.CarRentalService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }

    isolated remote function ListAvailableCars(FilterRequest|ContextFilterRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        FilterRequest message;
        if req is ContextFilterRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRentalService/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailableCarsContext(FilterRequest|ContextFilterRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        FilterRequest message;
        if req is ContextFilterRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRentalService/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function ListAllReservations(Empty|ContextEmpty req) returns stream<Reservation, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRentalService/ListAllReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ReservationStream outputStream = new ReservationStream(result);
        return new stream<Reservation, grpc:Error?>(outputStream);
    }

    isolated remote function ListAllReservationsContext(Empty|ContextEmpty req) returns ContextReservationStream|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRentalService/ListAllReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ReservationStream outputStream = new ReservationStream(result);
        return {content: new stream<Reservation, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserCreationResponse() returns UserCreationResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserCreationResponse>payload;
        }
    }

    isolated remote function receiveContextUserCreationResponse() returns ContextUserCreationResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserCreationResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class CarStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Car value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Car value;|} nextRecord = {value: <Car>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class ReservationStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Reservation value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Reservation value;|} nextRecord = {value: <Reservation>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextReservationStream record {|
    stream<Reservation, error?> content;
    map<string|string[]> headers;
|};

public type ContextCarStream record {|
    stream<Car, error?> content;
    map<string|string[]> headers;
|};

public type ContextCarList record {|
    CarList content;
    map<string|string[]> headers;
|};

public type ContextSearchRequest record {|
    SearchRequest content;
    map<string|string[]> headers;
|};

public type ContextReservationResponse record {|
    ReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextCarUpdateRequest record {|
    CarUpdateRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextReservationRequest record {|
    ReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextCartItem record {|
    CartItem content;
    map<string|string[]> headers;
|};

public type ContextCarResponse record {|
    CarResponse content;
    map<string|string[]> headers;
|};

public type ContextCartResponse record {|
    CartResponse content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextReservation record {|
    Reservation content;
    map<string|string[]> headers;
|};

public type ContextUserCreationResponse record {|
    UserCreationResponse content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextFilterRequest record {|
    FilterRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CarList record {|
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchRequest record {|
    string plate_number = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ReservationResponse record {|
    boolean success = false;
    string message = "";
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    string email = "";
    UserRole role = CUSTOMER;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CarUpdateRequest record {|
    string plate_number = "";
    float daily_price?;
    CarStatus status?;
    float mileage?;
|};

isolated function isValidCarupdaterequest(CarUpdateRequest r) returns boolean {
    int _daily_priceCount = 0;
    if r?.daily_price !is () {
        _daily_priceCount += 1;
    }
    int _statusCount = 0;
    if r?.status !is () {
        _statusCount += 1;
    }
    int _mileageCount = 0;
    if r?.mileage !is () {
        _mileageCount += 1;
    }
    if _daily_priceCount > 1 || _statusCount > 1 || _mileageCount > 1 {
        return false;
    }
    return true;
}

isolated function setCarUpdateRequest_DailyPrice(CarUpdateRequest r, float daily_price) {
    r.daily_price = daily_price;
}

isolated function setCarUpdateRequest_Status(CarUpdateRequest r, CarStatus status) {
    r.status = status;
}

isolated function setCarUpdateRequest_Mileage(CarUpdateRequest r, float mileage) {
    r.mileage = mileage;
}

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarRequest record {|
    string plate_number = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ReservationRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CartItem record {|
    string user_id = "";
    string plate_number = "";
    string start_date = "";
    string end_date = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CarResponse record {|
    boolean success = false;
    string message = "";
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CartResponse record {|
    boolean success = false;
    string message = "";
    CartItem[] items = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Reservation record {|
    string reservation_id = "";
    string user_id = "";
    CartItem[] items = [];
    float total_price = 0.0;
    ReservationStatus status = PENDING;
    string created_at = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UserCreationResponse record {|
    boolean success = false;
    string message = "";
    int users_created = 0;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Car record {|
    string plate_number = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    float mileage = 0.0;
    CarStatus status = AVAILABLE;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type FilterRequest record {|
    string make?;
    string model?;
    int year?;
|};

isolated function isValidFilterrequest(FilterRequest r) returns boolean {
    int _makeCount = 0;
    if r?.make !is () {
        _makeCount += 1;
    }
    int _modelCount = 0;
    if r?.model !is () {
        _modelCount += 1;
    }
    int _yearCount = 0;
    if r?.year !is () {
        _yearCount += 1;
    }
    if _makeCount > 1 || _modelCount > 1 || _yearCount > 1 {
        return false;
    }
    return true;
}

isolated function setFilterRequest_Make(FilterRequest r, string make) {
    r.make = make;
}

isolated function setFilterRequest_Model(FilterRequest r, string model) {
    r.model = model;
}

isolated function setFilterRequest_Year(FilterRequest r, int year) {
    r.year = year;
}

public enum CarStatus {
    AVAILABLE, UNAVAILABLE, MAINTENANCE, RENTED
}

public enum UserRole {
    CUSTOMER, ADMIN
}

public enum ReservationStatus {
    PENDING, CONFIRMED, CANCELLED, COMPLETED
}
