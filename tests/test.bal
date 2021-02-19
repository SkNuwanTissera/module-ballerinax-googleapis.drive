import ballerina/config;
import ballerina/test;
import ballerina/log;

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

########################
# Get Drive Information
# ######################

@test:Config {}
function testdriveGetAbout() {

    var res1 = driveClient->getAbout("*");
    var res2 = driveClient->getAbout("kind");
    var res3 = driveClient->getAbout("user");
    var res4 = driveClient->getAbout("storageQuota");
    log:print(res1.toString());

}

###################
# Get File By Id
# ################

@test:Config {}
function testGetFileById() {

    string id = "14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4";
    File | error file1 = driveClient->getFileById(id);
    _ = printFileasString(file1);

}

#####################
# Get File By Path
# ###################

// @test:Config {}
// function testgetFileByPath() {

//     string url = "https://drive.google.com/file/d/1Tu7cW3XyAYPqh9lDkDq-Pmtj11yYwI7y/view?usp=sharing";
//     File | error res1 = driveClient->getFileByPath(url);
//     _ = printFileasString(res1);

// }

################################
# Get File By ID with optionals
# #############################

GetFileOptional optional = {
    acknowledgeAbuse: false,
    fields: "*",
    includePermissionsForView : "published",
    supportsAllDrives : false
};

@test:Config {}
function testgetFileByIdwithOptionalParameters() {

    File | error res1 = driveClient->getFileById("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4", optional);
    _ = printFileasString(res1);

}

#####################
# Get File ID by Path
# ###################

@test:Config {}
function testGetFilebyPath(){

    // string url = "https://drive.google.com/file/d/1Tu7cW3XyAYPqh9lDkDq-Pmtj11yYwI7y/view?usp=sharing";
    // issue in doc urls ..check below
    // string url = https://docs.google.com/document/d/1WElgMovRkdtZTXuPrySHed7LY4jcrULIhAgJHUmVcLQ/edit?usp=sharing;

    // File|error res =  driveClient->getFileByPath(url);
    // _ = printFileasString(res);

}

DeleteFileOptional delete_optional = {

    supportsAllDrives : false
};

#######################
# Delete File by ID
# #####################

@test:Config {}
function testDeleteFileById(){

    json | error res = driveClient->deleteFileById("1mxq25NTkjxvL8PDRSTf_gvZ1KwdW0nVZ", delete_optional);
    _ = printJSONasString(res);

}

#######################
# Delete File by Path
# #####################

// @test:Config {}
// function testDeleteFileByPath(){
//     string path1 = "https://drive.google.com/file/d/1AFDfPqcCg-YHIuxwUqFOYp-PVR3wmByh/view?usp=sharing";
//     json | error res = driveClient->deleteFileByPath(path1, delete_optional);
//     if (res is json){
//         log:print(res.toString());
//     }

// }


############
# Copy File
# ##########

CopyFileOptional optionals2 = {"includePermissionsForView" : "published"};

File payload2 = {
    name : "Sk1235"
};

@test:Config {}
function testCopyFile(){
    File|error res = driveClient->copyFile("1JeL5t7O9HrpRnZEa24h-Fbbloy3s4Q-3" ,optionals2 ,payload2 );
    if (res is File){
        json|error file = res.cloneWithType(json);
        if (file is json) {
            log:print(file.toString());
        }
    }
}

############################
# Update Metadata in a file
# ##########################
# POST Request

UpdateFileMetadataOptional optionals3 = {
    addParents : "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"
};

File payload3 = {
    name : "hellothari555"
};


@test:Config {}
function testUpdateFiles() {

    File|error res = driveClient->updateFileMetadataById("1eMlLwzHggwVqKfbjWrTABDuV3ATtaBie", optionals3, payload3);
    error? err = printFileasString(res);
}


#########################
# Create Metadata file
# ######################

CreateFileOptional optionals4 = {
    ignoreDefaultVisibility : false
};

File payload4 = {
    mimeType : "application/vnd.google-apps.document",
    name : "nuwan123",
    parents : ["1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"]
};

@test:Config {}
function testCreateFile() {
    File|error res = driveClient->createMetaDataFile(optionals4, payload4);
    error? err = printFileasString(res);
}

###################
# Search for files
# #################

ListFilesOptional optional6 = {
    pageSize : 3
};

@test:Config {}
function testGetFiles() {

    stream<File>|error res = driveClient->getFiles(optional6);
    if (res is stream<File>){
        error? e = res.forEach(function (File file1) {
            _ = printFileasString(file1);
        });
    }

}


######################
# Update Existing File
# ####################
# PATCH Upload Request

UpdateFileMetadataOptional optionals9 = {
    addParents : "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"
};

File payload9 = {
    name : "hellothari555"
};

@test:Config {}
function testUpdateExistingFiles() {

    File|error res = driveClient->updateExistingFile("1eMlLwzHggwVqKfbjWrTABDuV3ATtaBie", optionals9, payload9);
    error? err = printFileasString(res);
}

######################
# New Upload File
# ####################

UpdateFileMetadataOptional optionalsssss = {
    addParents : "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"
};

File payload99 = {
    name : "test123.jpeg"
};

//string filePath = "./tests/bar.txt";
string filePath = "./tests/bar.jpeg";

@test:Config {}
function testNewUpload() {

    File|error res = driveClient->uploadFile(filePath, optionalsssss, payload99);
    error? err = printFileasString(res);
}