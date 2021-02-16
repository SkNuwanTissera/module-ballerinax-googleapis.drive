import ballerina/config;
import ballerina/test;
// import ballerina/log;
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

    // File | error res1 = driveClient->getFileByPath("https://drive.google.com/file/d/1mxq25NTkjxvL8PDRSTf_gvZ1KwdW0nVZ/view?usp=sharing");
    // if (res1 is File){
    //     log:print("@@@@@@@@@@@@@@@@@File Kind :: "+ res1.kind + " Name :: "+ res1.name);
    // }
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
function testGetIDbyPath(){
    string url = "https://drive.google.com/file/d/1j8sQMqEKx7yWCmtYtNK5iYCOE8A3joxj/view?usp=sharing";
    // string url = "https://drive.google.com/drive/folders/1U9xlZs0JbdxFgIDPRLJY1VmBQHzbrcju?usp=sharingaring";
    // string url = "https://docs.google.com/spreadsheets/d/1eGnZLdQjuzoKDlQNMKXrhi0Dp3hQ0hMMCT5lcGkUlPI/edit#gid=0";
    // File|error res =  driveClient->getFileByPath(url);

}

json requestBody = {
    name : "testballerinaconnecter.jpg",
    originalFilename : "testballerinaconnecter.jpg",
    description : "testballerinaconnecter"
};

// @test:Config {}
// function testCreateNewFile(){

//     File | error res = driveClient->createFile({"name": "cat.jpg"});
//     if (res is File){
//         log:print("File Kind :: "+ res.kind + " Name :: "+ res.name);
//     }
// }

DeleteFileOptional delete_optional = {

    supportsAllDrives : false
};

// @test:Config {}
// function testDeleteFileById(){

//     json | error res = driveClient->deleteFileById("1mxq25NTkjxvL8PDRSTf_gvZ1KwdW0nVZ", delete_optional);
//     if (res is json){
//         log:print(res.toString());
//     }

// }

// @test:Config {}
// function testDeleteFileByPath(){
//     string path1 = "https://drive.google.com/file/d/1AFDfPqcCg-YHIuxwUqFOYp-PVR3wmByh/view?usp=sharing";
//     json | error res = driveClient->deleteFileByPath(path1, delete_optional);
//     if (res is json){
//         log:print(res.toString());
//     }

// }

// CopyFileOptional optionals2 = {"includePermissionsForView" : "published"};

// File payload2 = {
//     name : "Sk1235"
// };

// @test:Config {}
// function testCopyFile(){
//     File|error res = driveClient->copyFile("1JeL5t7O9HrpRnZEa24h-Fbbloy3s4Q-3" ,optionals2 ,payload2 );
//     // File|error res = driveClient->copyFile("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4");
//     if (res is File){
//         json|error file = res.cloneWithType(json);
//         if (file is json) {
//             log:print(file.toString());
//         }
//     }
// }


// @test:Config {}
// function testgetFiles() {
//     stream<File>|error res = driveClient->getFiles();
//     if (res is stream<File>){
//         error? e = res.forEach(function (File file1) {
//             log:print(convertFiletoString(file1));
//         });
//     }
// }

UpdateFileOptional optionals3 = {
    uploadType : "media"
};

@test:Config {}
function testUpdateFiles() {
    // https://drive.google.com/file/d/1eMlLwzHggwVqKfbjWrTABDuV3ATtaBie/view?usp=sharing
    File|error res = driveClient->updateFile("1eMlLwzHggwVqKfbjWrTABDuV3ATtaBie", optionals3);
    _ = printFileasString(res);
}