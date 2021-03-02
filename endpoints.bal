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

import ballerina/http;
import ballerina/log;

function getDriveInfo(http:Client httpClient, string? fields) returns @tainted About|error{
    string path = DRIVE_PATH + ABOUT + QUESTION_MARK + FIELDS + EQUAL + _ALL;
    if (fields is string) {
        path = DRIVE_PATH + ABOUT + QUESTION_MARK + FIELDS + EQUAL + fields;
    }
    json resp = check sendRequest(httpClient, path);
    About|error info = resp.cloneWithType(About);
    if(info is About){
        return info;
    } else {
        return error(ERR_DRIVE_INFO_RESPONSE, info);
    }
}

function getFileById(http:Client httpClient, string fileId, 
                    GetFileOptional? optional = ()) returns @tainted File|error {

    string path = prepareUrlWithFileOptional(fileId, optional);
    json resp = check sendRequest(httpClient, path);
    File|error file = resp.cloneWithType(File);
    if (file is File) {
        return file;
    } else {
        return error(ERR_FILE_RESPONSE, file);
    }

}

function getAllFiles(http:Client httpClient) returns @tainted stream<File>|error{

    string path = prepareUrl([DRIVE_PATH, FILES]);
    log:print(path.toString());
    json | error resp = sendRequest(httpClient, path);
    File[] files = [];
    if resp is json {
        FilesResponse|error res = resp.cloneWithType(FilesResponse);
        if (res is FilesResponse) {
            int i = files.length();
            foreach File item in res.files {
                files[i] = item;
                i = i + 1;
            }        
            stream<File> filesStream = (<@untainted>files).toStream();
            return filesStream;
        } else {
            return error(ERR_FILE_RESPONSE, res);
        }
    } else {
        return resp;
    }
}

function deleteFileById(http:Client httpClient, string fileId, 
                        DeleteFileOptional? optional = ()) returns @tainted boolean|error{

    string path = prepareUrlWithDeleteOptional(fileId, optional);
    boolean|error resp = deleteRequest(httpClient, path);
    return resp;

}

function copyFile(http:Client httpClient, string fileId, CopyFileOptional? optional = (), File? fileResource = ()) returns @tainted File|error {

    json payload = check fileResource.cloneWithType(json);
    string path = prepareUrlWithCopyOptional(fileId, optional);
    json|error resp = sendRequestWithPayload(httpClient, path, payload);
    if resp is json {
        File|error file = resp.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_FILE_RESPONSE, file);
        }
    } else {
        return resp;
    }

}

function updateFileById(http:Client httpClient, string fileId, UpdateFileMetadataOptional? optional = (), 
                        File? fileResource = ()) returns @tainted File|error {

    json payload = check fileResource.cloneWithType(json);
    string path = prepareUrlWithUpdateOptional(fileId, optional);
    json|error resp = updateRequestWithPayload(httpClient, path, payload);
    if resp is json { 
        File|error file = resp.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_FILE_RESPONSE, file);
        }
    } else {
        return resp;
    }

}

function createMetaDataFile(http:Client httpClient, CreateFileOptional? optional = (), 
                            File? fileData = ()) returns @tainted File|error {

    json payload = check fileData.cloneWithType(json);
    string path = prepareUrlwithMetadataFileOptional(optional);
    json|error resp = uploadRequestWithPayload(httpClient, path, payload);
        if resp is json {
        File|error file = resp.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_FILE_RESPONSE, file);
        }
    } else {
        return resp;
    }

}


function uploadFile(http:Client httpClient, string filePath, UpdateFileMetadataOptional? optional = (), 
                                File? fileMetadata = ()) returns @tainted File|error{
    
    string path = prepareUrl([UPLOAD, DRIVE_PATH, FILES]);
    log:print(path.toString());
    
    json resp = check uploadFiles(httpClient, path, filePath);
    
    //update metadata
    json|error respId = resp.id;
    string fileId = EMPTY_STRING;
    if(respId is json){
        fileId = respId.toString();
    }
    string newFileUrl = prepareUrlWithUpdateOptional(fileId, optional);
    json payload = check fileMetadata.cloneWithType(json);
    json|error changeResponse = updateRequestWithPayload(httpClient, newFileUrl, payload);

    if changeResponse is json {
        File|error file = changeResponse.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_FILE_RESPONSE, file);
        }
    } else {
        return changeResponse;
    } 
    
}

function getFiles(http:Client httpClient, ListFilesOptional? optional = ()) returns @tainted stream<File>|error{

    string path = prepareUrlwithFileListOptional(optional);

    json | error resp = sendRequest(httpClient, path);

    File[] files = [];
    if resp is json {
        FilesResponse|error res = resp.cloneWithType(FilesResponse);
        if (res is FilesResponse) {
            int i = files.length();
            foreach File item in res.files {
                files[i] = item;
                i = i + 1;
            }        
            stream<File> filesStream = (<@untainted>files).toStream();
            return filesStream;
        } else {
            return error(ERR_FILE_RESPONSE, res);
        }
    } else {
        return resp;
    }
}

function uploadFileUsingByteArray(http:Client httpClient, byte[] byteArray, UpdateFileMetadataOptional? optional = (), 
                                  File? fileMetadata = ()) returns @tainted File|error{
    
    string path = prepareUrl([UPLOAD, DRIVE_PATH, FILES]);
    log:print(path.toString());
    
    json resp = check uploadFileWithByteArray(httpClient, path, byteArray);
    
    //update metadata
    json|error respId = resp.id;
    string fileId = EMPTY_STRING;
    if(respId is json){
        fileId = respId.toString();
    }
    string newFileUrl = prepareUrlWithUpdateOptional(fileId, optional);
    json payload = check fileMetadata.cloneWithType(json);
    json|error changeResponse = updateRequestWithPayload(httpClient, newFileUrl, payload);

    if changeResponse is json {
        File|error file = changeResponse.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_FILE_RESPONSE, file);
        }
    } else {
        return changeResponse;
    } 
    
}