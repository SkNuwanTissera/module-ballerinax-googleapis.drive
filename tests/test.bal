// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

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

string? fileId = "";
string? parentFolder = "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5";

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

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testGetFileById() {

    File | error testGetFile = driveClient->getFileById(fileId?);
    _ = printFileasString(testGetFile);

}

################################
# Get File By ID with optionals
# #############################

GetFileOptional optional = {
    acknowledgeAbuse: false,
    fields: "*",
    supportsAllDrives : false
};

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testgetFileByIdwithOptionalParameters() {

    File | error res1 = driveClient->getFileById(fileId, optional);
    _ = printFileasString(res1);

}

DeleteFileOptional delete_optional = {

    supportsAllDrives : false
};

#######################
# Delete File by ID
# #####################

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testDeleteFileById(){

    json | error res = driveClient->deleteFileById(fileId, delete_optional);
    _ = printJSONasString(res);

}

############
# Copy File
# ##########

CopyFileOptional optionals_copy_file = {"includePermissionsForView" : "published"};

File payload_copy_file = {
    name : "testfile.pdf" //New name
};

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testCopyFile(){
    File|error res = driveClient->copyFile(fileId ,optionals_copy_file ,payload_copy_file );
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

UpdateFileMetadataOptional optionals_file_metadata = {
    addParents : parentFolder
};

File payload__file_metadata = {
    name : "test"
};


@test:Config {
    dependsOn: ["testCreateFile"]
}
function testUpdateFiles() {

    File|error res = driveClient->updateFileMetadataById(fileId, optionals_file_metadata, payload__file_metadata);
    error? err = printFileasString(res);
}


#########################
# Create Metadata file
# ######################

CreateFileOptional optionals_create_file = {
    ignoreDefaultVisibility : false
};

File payload_create_file = {
    mimeType : "application/vnd.google-apps.document",
    name : "nuwan123",
    parents : ["1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"]
};

@test:Config {}
function testCreateFile() {
    File|error res = driveClient->createMetaDataFile(optionals_create_file, payload_create_file);
    error? err = printFileasString(res);
}



##############################
# Create Folder with Metadata
# ############################

CreateFileOptional optionals_create_folder = {
    ignoreDefaultVisibility : false
};

File payload_create_folder = {
    mimeType : "application/vnd.google-apps.document",
    name : "folderInTheRoot"
};

@test:Config {}
function testCreateFolder() {
    File|error res = driveClient->createMetaDataFile(optionals_create_folder, payload_create_folder);
    if(res is File){
        parentFolder = res?.id;
    }
    error? err = printFileasString(res);
}



###################
# Search for files
# #################

ListFilesOptional optional_search = {
    pageSize : 3
};

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testGetFiles() {

    stream<File>|error res = driveClient->getFiles(optional_search);
    if (res is stream<File>){
        error? e = res.forEach(function (File file) {
            _ = printFileasString(file);
        });
    }

}

######################
# Update Existing File
# ####################
# PATCH Upload Request

UpdateFileMetadataOptional optionals = {
    addParents : "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5"
};

File payload = {
    name : "test123"
};

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testUpdateExistingFiles() {

    File|error res = driveClient->updateExistingFile(fileId, optionals, payload);
    error? err = printFileasString(res);
}

##############
# Upload File
# ############

UpdateFileMetadataOptional optionals_ = {
    addParents : "1D1orlhRlo8PaovrJt5nf5IihOp-Y7cY5" //change folder
};

File payload_ = {
    name : "test123.jpeg"
};

//string filePath = "./tests/bar.txt";
string filePath = "./tests/bar.jpeg";
//string filePath = "./tests/test.mp4";

@test:Config {}
function testNewUpload() {

    File|error res = driveClient->uploadFile(filePath, optionals_, payload_);
    error? err = printFileasString(res);
}