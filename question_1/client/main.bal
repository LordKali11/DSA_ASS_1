import ballerina/http;
import ballerina/io;
import ballerina/time;
import ballerina/uuid;

enum status {
    ACTIVE,
    UNDER_REPAIR,
    DISPOSED,
    PENDING
};

enum maintenance_frequency {
    MONTHLY,
    QUARTERLY,
    YEARLY
};
type maintenance_schedule record{
    string id?;
    string maintenance_frequency;
    time:Utc due_date;
};

type COMPONENTS record{
    string? id ;
    string name;
    string description;
};
type TASK record{
    string? id;
    string description;
};
type WORKORDER record{
    string? id;
    time:Utc opendate?;
    status current_status = PENDING;
    TASK[] TASK = [];
    time:Utc closedate?;
};

type ASSET record{
    readonly string tag_id = uuid:createType1AsString();
    string name;
    string faculty;
    string department;
    time:Utc date_aquired = time:utcNow();
    status current_status;
    COMPONENTS?[] components= [];
    maintenance_schedule?[] maintenance_schedules = [];
    WORKORDER?[] work_orders = [];
};

http:Client endPoint = check new ("http://localhost:9090");
public function main() {
    int choice = checkpanic int:fromString(io:readln("1. Add New Asset\n2. Add Component to Asset\n3. Add Maintenance Schedule to Asset\n4. Add Work Order to Asset\n5. Add Task to Work Order\n6. Delete Asset\n7. Delete Component from Asset\n8. Delete Maintenance Schedule from Asset\n9. Delete Work Order from Asset\n10. View All Assets\n11. View Assets by Faculty\n12. Check Overdue Maintenance Items\nEnter your choice: "));
    if choice == 1 {
        ASSET asset = inputData();
        var res = addNewAsset(asset);
        if res is string {
            io:println(res);
        } else {
            io:println("Error: ", res.message());
        }
    } else if choice == 2 {
        string tag_id = io:readln("Enter Asset Tag ID: ");
        string name = io:readln("Enter Component Name: ");
        string description = io:readln("Enter Component Description: ");
        COMPONENTS component = {name: name, description: description};
        var res = addComponent(tag_id, component);
        if res is string {
            io:println(res);
        } else {
            io:println("Error: ", res.message());
        }
    } else if choice == 3 {
        string tag_id = io:readln("Enter Asset Tag ID: ");
        string freqStr = io:readln("Enter Maintenance Frequency (MONTHLY, QUARTERLY, YEARLY): ");
        maintenance_frequency freq = <maintenance_frequency>freqStr;
        string dueDateStr = io:readln("Enter Due Date (YYYY-MM-DDTHH:MM:SSZ): ");
        time:Utc due_date = checkpanic time:parse(dueDateStr);
        maintenance_schedule schedule = {maintenance_frequency: freqStr, due_date: due_date};
        var res = addMaintenanceSchedule(tag_id, schedule);
        if res is string {
            io:println(res);
        } else {
            io:println("Error: ", res.message());
        }
    } else if choice == 4 {
        string tag_id = io:readln("Enter Asset Tag ID: ");
        WORKORDER workorder = {opendate: time:utcNow()};
        var res = addWorkOrder(tag_id, workorder);
        if res is string {
            io:println(res);
        } else {
            io:println("Error: ", res.message());
        }
    } else if choice == 5 {
        string tag_id = io:readln("Enter Asset Tag ID: ");
        string workorder_id = io:readln("Enter Work Order ID: ");
        string description = io:readln("Enter Task Description: ");
        TASK task = {description: description};
        var res = addTask(tag_id, workorder_id, task);
        if res is string {
            io:println(res);
        }
    }
}

function inputData() returns ASSET {
    string name = io:readln("Enter Asset Name: ");
    string faculty = io:readln("Enter Faculty: ");
    string department = io:readln("Enter Department: ");
    string statusStr = io:readln("Enter Status (ACTIVE, UNDER_REPAIR, DISPOSED, PENDING): ");
    status current_status = <status>statusStr;

    ASSET asset = {
        name: name,
        faculty: faculty,
        department: department,
        current_status: current_status
    };

    return asset;
}

function addNewAsset(ASSET asset) returns string|error {
    string|error res = endPoint->post("/addAsset", asset);
    return res;
}

function addComponent(string tag_id, COMPONENTS component) returns string|error {
    string|error res = endPoint->post("/addComponent/" + tag_id, component);
    return res;
}

function addMaintenanceSchedule(string tag_id, maintenance_schedule schedule) returns string|error {
    string|error res = endPoint->post("/addMaintenanceSchedule/" + tag_id, schedule);
    return res;
}

function addWorkOrder(string tag_id, WORKORDER workorder) returns string|error {
    string|error res = endPoint->post("/WorkOrder/" + tag_id, workorder);
    return res;
}

function addTask(string tag_id, string workorder_id, TASK task) returns string|error {
    string|error res = endPoint->post("/task/" + tag_id + "/" + workorder_id, task);
    return res;
}

function deleteAsset(string tag_id) returns string|error {
    string|error res = endPoint->delete("/deleteAsset/" + tag_id);
    return res;
}

function deleteComponent(string tag, string component_name) returns string|error {
    string|error res = endPoint->delete("/deleteComponent/" + tag + "/" + component_name);
    return res;
}

function deleteMaintenance(string tag, string id) returns string|error {
    string|error res = endPoint->delete("/deleteMaintence/" + tag, id);
    return res;
}

function delelteWorkOrder(string tag, string workorder_id) returns string|error {
    string|error res = endPoint->delete("/deleteWorkOrder/" + tag + "/" + workorder_id);
    return res;
}
function getAll() returns ASSET[]|error {
    ASSET[]|error res = endPoint->get("/all");
    return res;
}

function getByFaculty(string faculty) returns ASSET[]|error {
    ASSET[]|error res = endPoint->get("/assestByFaculty/" + faculty);
    return res;
}

function checkOverdueItems() returns ASSET[]|error {
    ASSET[]|error res = endPoint->get("/checkOverdueItem");
    return res;
}


