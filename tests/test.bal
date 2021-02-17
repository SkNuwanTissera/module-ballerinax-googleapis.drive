import ballerina/config;
import ballerina/test;
// import ballerina/log;
// import ballerina/io;
// import ballerina/file;

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
    refer https://developers.google.com/drive/api/v3/reference/about#resource
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

@test:Config {}
function testgetFileByPath() {

    string url = "https://drive.google.com/file/d/1Tu7cW3XyAYPqh9lDkDq-Pmtj11yYwI7y/view?usp=sharing";
    File | error res1 = driveClient->getFileByPath(url);
    _ = printFileasString(res1);

}

GetFileOptional optional = {
    acknowledgeAbuse: false,
    fields: "*",
    includePermissionsForView : "published",
    supportsAllDrives : false
};

################################
# Get File By ID with optionals
# #############################

@test:Config {}
function testgetFileByIdwithOptionalParameters() {

    File | error res1 = driveClient->getFileById("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4", optional);
    _ = printFileasString(res1);

}

#####################
# Get File ID by Path
# ###################

@test:Config {}
function testGetIDbyPath(){

    string url = "https://drive.google.com/file/d/1Tu7cW3XyAYPqh9lDkDq-Pmtj11yYwI7y/view?usp=sharing";
    // issue in doc urls ..check below
    // https://docs.google.com/document/d/1WElgMovRkdtZTXuPrySHed7LY4jcrULIhAgJHUmVcLQ/edit?usp=sharing

    File|error res =  driveClient->getFileByPath(url);
    _ = printFileasString(res);

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
    _ = printFileasString(res);

}

#######################
# Delete File by Path
# #####################

@test:Config {}
function testDeleteFileByPath(){
    string path1 = "https://drive.google.com/file/d/1AFDfPqcCg-YHIuxwUqFOYp-PVR3wmByh/view?usp=sharing";
    json | error res = driveClient->deleteFileByPath(path1, delete_optional);
    if (res is json){
        log:print(res.toString());
    }

}


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
    // File|error res = driveClient->copyFile("14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4");
    if (res is File){
        json|error file = res.cloneWithType(json);
        if (file is json) {
            log:print(file.toString());
        }
    }
}

######################
# Create Update file
# ####################

UpdateFileMetadataOptional optionals3 = {
    //uploadType : "media"
};

File payload3 = {
    name : "hellothari"
};


@test:Config {}
function testUpdateFiles() {
    // https://drive.google.com/file/d/1eMlLwzHggwVqKfbjWrTABDuV3ATtaBie/view?usp=sharing
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
    name : "hello123",
    parents : ["1kdk4AiOzq5xqdJ6hHjdMDDXZ67Pff1h2"]
};

@test:Config {}
function testCreateFile() {
    File|error res = driveClient->createMetaDataFile(optionals4, payload4);
    error? err = printFileasString(res);
}

################
# Upload a file
# ##############

// In simple upload, Send the file data in the request body
// In multipart upload, Request body has 2 parts (Metadata & Media)
// In resumable upload,There are two ways to upload. 

File fileContent = {
    mimeType : "application/vnd.google-apps.document",
    name : "hello123",
    parents : ["1kdk4AiOzq5xqdJ6hHjdMDDXZ67Pff1h2"]
};

UploadFileOptional optionals5 = {
    uploadType : SIMPLE,
    ignoreDefaultVisibility : false
};

@test:Config {}
function testUploadFile() {

    //create a file and upload
    // error? createFileResults = file:create("bar.txt");
    // boolean fileExists = check file:test("bar.txt", file:EXISTS);


    // log:print("bar.txt file exists: "+ fileExists.toString());
    File|error res = driveClient->uploadFile(optionals5, fileContent);
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