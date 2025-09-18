import ballerina/http;
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
type MAINTENANCE_SCHEDULE record{
    string id?;
    string maintenance_frequency;
    time:Utc due_date;
};

type COMPONENTS record{
    string name;
    string description;
};
type TASK record{
    string? id;
    string description;
};
type WORKORDER record{
    string id?;
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
    time:Utc date_aquired;
    status current_status;
    COMPONENTS?[] components= [];
    MAINTENANCE_SCHEDULE?[] maintenance_schedules = [];
    WORKORDER?[] work_orders = [];
};

final table <ASSET> key(tag_id) assets_table = table [{
    tag_id: "asset-001",
    name: "Laptop",
    faculty: "Engineering",
    department: "Computer Science",
    date_aquired: time:utcNow(),
    current_status: ACTIVE
}];

service / on new http:Listener(9090) {

    resource function post addAsset(ASSET req ) returns string|error {
        if (assets_table.hasKey(req.tag_id)) {
            return error("Asset with tag_id " + req.tag_id + " already exists.");
        }
        else {
            assets_table.add(req);
            return "Assest has been added in the database";
        }
    }

    resource function post addComponent/[string tag_id](COMPONENTS component) returns string|error{
        if (assets_table.hasKey(tag_id)) {
            ASSET asset = assets_table.get(tag_id);
            asset.components.push(component);
            return "Component has been added to asset with tag_id " + tag_id;
        } else {
            return error("Asset with tag_id " + tag_id + " not found.");
        }
    }

    resource function post addMaintenanceSchedule/[string tag_id](MAINTENANCE_SCHEDULE schedule) returns string|error{
        if (assets_table.hasKey(tag_id)) {
            ASSET asset = assets_table.get(tag_id);
            asset.maintenance_schedules.push(schedule);
            return "Maintenance schedule has been added to asset with tag_id " + tag_id;
        } else {
            return error("Asset with tag_id " + tag_id + " not found.");
        }
    }

    resource function post workOrder/[string tag_id](WORKORDER work_order) returns string|error{
        if (assets_table.hasKey(tag_id)) {
            ASSET asset = assets_table.get(tag_id);
            asset.work_orders.push(work_order);
            return "Work order has been added to asset with tag_id " + tag_id;
        } else {
            return error("Asset with tag_id " + tag_id + " not found.");
        }
        
    }

    resource function post task/[string tag_id](TASK task) returns string|error {  
        if(assets_table.hasKey(tag_id)) {
            ASSET asset = assets_table.get(tag_id);
            if (asset.work_orders.length() > 0) {
                int lastIndex = asset.work_orders.length() - 1;
                WORKORDER? lastWorkOrderOpt = asset.work_orders[lastIndex];
                if lastWorkOrderOpt is WORKORDER {
                    lastWorkOrderOpt.TASK.push(task);
                    asset.work_orders[lastIndex] = lastWorkOrderOpt;
                    return "Task has been added to the latest work order of asset with tag_id " + tag_id;
                } else {
                    return error("Latest work order is null for asset with tag_id " + tag_id);
                }
            } else {
                return error("No work orders found for asset with tag_id " + tag_id);
            }
        } else {
            return error("Asset with tag_id " + tag_id + " not found.");
        }
    }

    
    resource function delete deleteAsset(string tag_id) returns string|error {
        if (assets_table.hasKey(tag_id)) {
            ASSET result = assets_table.remove(tag_id);
            return "Asset with tag_id " + result.tag_id + " has been deleted.";
        } else {
            return error("Asset with tag_id " + tag_id + " not found.");
        }
    }

    resource function delete deleteComponent/[string tag](string component_name) returns string|error {
        if (assets_table.hasKey(tag)) {
            ASSET asset = assets_table.get(tag);
            asset.components = from var item in asset.components
                               where item?.name != component_name
                               select item;
            return "Component " + component_name + " has been deleted from asset with " + tag;
        }
        else {
            return error("Asset with tag_id " + tag + " not found.");
        }      
    }

    resource function delete deleteMaintence/[string tag](string id) returns string|error {
        if (assets_table.hasKey(tag)) {
            ASSET asset = assets_table.get(tag);
            asset.maintenance_schedules = from var item in asset.maintenance_schedules
                                          where item?.id != id
                                          select item;
            return "Maintenance schedule with id " + id + " has been deleted from asset with tag_id " + tag;
        } else {
            return error("Asset with tag_id " + tag + " not found.");
        }
    }

    resource function delete WORKORDER/[string tag](string id) returns string|error {
        if assets_table.hasKey(tag) {
            ASSET asset = assets_table.get(tag);
            asset.work_orders = from var item in asset.work_orders
                               where item?.id != id
                               select item;
            return "Work order with id " + id + " has been deleted from asset with tag - " + tag;
        }   
        else {
            return error("Asset with tag_id " + tag + " not found.");
        }

    }

    resource function get all() returns ASSET[]|error{
        if (assets_table.length() == 0) {
            return error("No ASSET found in the database.");
        } else {
            return assets_table.toArray();
        }
    }

    resource function get assetsByFaculty/[string faculty]() returns ASSET[]|error {
        ASSET[] facultyAssets = [];
        if (assets_table.length() == 0) {
            return error("No ASSET found in the database.");
        }
        facultyAssets = from var asset in assets_table
                        where asset.faculty == faculty
                        select asset;
        return facultyAssets;               
    }

    
    resource function get checkOverdueItem() returns ASSET[] {
        ASSET[] overdueAssets = [];
        time:Utc currentDate = time:utcNow();
        foreach ASSET asset in assets_table {
            MAINTENANCE_SCHEDULE?[] schedules = asset.maintenance_schedules;
            foreach MAINTENANCE_SCHEDULE? schedule in schedules {
                if schedule?.due_date < currentDate {
                    overdueAssets.push(asset);
                    break;
                }            
            }
        }
        return overdueAssets;
    }
}   