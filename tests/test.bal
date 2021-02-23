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

import ballerina/test;
import ballerina/log;

configurable string ACCESS_TOKEN = ?;
configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

Configuration config = {
    baseUrl: DRIVE_URL,
    clientConfig: {
        accessToken: ACCESS_TOKEN,
        clientId: CLIENT_ID,
        clientSecret: CLIENT_SECRET,
        refreshUrl: REFRESH_URL,
        refreshToken: REFRESH_TOKEN
    
        
    }
};

Client driveClient = new (config);

string fileId = EMPTY_STRING;
string parentFolder = EMPTY_STRING;

########################
# Get Drive Information
# ######################

@test:Config {}
function testdriveGetAbout() {

    json|error res1 = driveClient->getAbout("*");
    json|error res2 = driveClient->getAbout("kind");
    json|error res3 = driveClient->getAbout("user");
    json|error res4 = driveClient->getAbout("storageQuota");
    if (res1 is json){
        log:print(res1.toString());
    }

}

###################
# Get File By Id
# ################

@test:Config {
    dependsOn: "testCreateFile()"
}
function testGetFileById() {

    File | error testGetFile = driveClient->getFileById(fileId);
    error? err = printFileasString(testGetFile);

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
function testGetFileByIdwithOptionalParameters() {

    File | error res1 = driveClient->getFileById(fileId, optional);
    error? err = printFileasString(res1);

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
    error? err = printJSONasString(res);

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
    name : "nuwan123"
    //parents : [parentFolder]
};

@test:Config {
    dependsOn: ["testCreateFolder"]
}
function testCreateFile() {
    File|error res = driveClient->createMetaDataFile(optionals_create_file, payload_create_file);
    fileId = <@untainted> getIdFromFileResponse(res);
    error? err = printFileasString(res);
}



##############################
# Create Folder with Metadata
# ############################

CreateFileOptional optionals_create_folder = {
    ignoreDefaultVisibility : false
};

File payload_create_folder = {
    mimeType : "application/vnd.google-apps.folder",
    name : "folderInTheRoot"
};

@test:Config {}
function testCreateFolder() {
    File|error res = driveClient->createMetaDataFile(optionals_create_folder, payload_create_folder);
    parentFolder = <@untainted> getIdFromFileResponse(res);
    error? err = printFileasString(res);
}

###################
# Get files
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
            error? err = printFileasString(file);
        });
    }

}

##############
# Upload File
# ############

UpdateFileMetadataOptional optionals_ = {
    addParents : parentFolder //Parent folderID
};

File payload_ = {
    name : "test123.jpeg"
};

//string filePath = "./tests/resources/bar.txt";
string filePath = "./tests/resources/bar.jpeg";

@test:Config {
    dependsOn: ["testCreateFile"]
}
function testNewUpload() {

    File|error res = driveClient->uploadFile(filePath, optionals_, payload_);
    error? err = printFileasString(res);
}
