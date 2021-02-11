import ballerina/config;
import ballerina/test;
import ballerina/log;
// import ballerina/io;

DriveConfiguration config = {
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

Client driveClient = new (config);

@test:Config {}
function testdriveGetAbout() {
    var res1 = driveClient->getAbout("*");
    // var res2 = driveClient->getAbout("kind");
    // var res3 = driveClient->getAbout("user");
    // var res4 = driveClient->getAbout("storageQuota");
    // refer https://developers.google.com/drive/api/v3/reference/about#resource
    // log:print(res1.toString());
}

@test:Config {}
function testgetFileById() {
    // File | error res1 = driveClient->getFileById("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4");
    // if (res1 is File){
    //     log:print("File Kind :: "+ res1.kind + " Name :: "+ res1.name);
    // }
}

@test:Config {}
function testgetFileByPath() {

    File | error res1 = driveClient->getFileByPath("https://drive.google.com/file/d/1ZiiFo9G4EHwlD2YHSGD4iOGvG73phlOX/view?usp=sharing");
    if (res1 is File){
        log:print("@@@@@@@@@@@@@@@@@File Kind :: "+ res1.kind + " Name :: "+ res1.name);
    }
}

GetFileOptional optional = {
    acknowledgeAbuse: false,
    fields: "*",
    includePermissionsForView : "published",
    supportsAllDrives : false
};

@test:Config {}
function testgetFileByIdwithOptionalParameters() {
    // File | error res1 = driveClient->getFileById("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4", optional);
    // if (res1 is File){
    //     log:print("File Kind :: "+ res1.kind + " Name :: "+ res1.name);
    // }
}

@test:Config {}
function testgetFiles() {
    // stream<File>|error res = driveClient->getFiles();
    // if (res is stream<File>){
    //     error? e = res.forEach(function (File file1) {
    //         log:print("File Kind :: "+ file1.kind + " Name :: "+ file1.name);
    //     });
    // }
}


