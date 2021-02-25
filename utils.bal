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
import ballerina/encoding;
import ballerina/log;
import ballerina/io;

function sendRequest(http:Client httpClient, string path) returns @tainted json | error {

    var httpResponse = httpClient->get(<@untainted>path);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }

}

function deleteRequest(http:Client httpClient, string path) returns @tainted boolean | error {

    var httpResponse = httpClient->delete(<@untainted>path);
    json resp = check checkAndSetErrors(httpResponse);
    return true;

}

function sendRequestWithPayload(http:Client httpClient, string path, json jsonPayload = ())
returns @tainted json | error {

    http:Request httpRequest = new;
    if (jsonPayload != ()) {
        httpRequest.setJsonPayload(<@untainted>jsonPayload);
    }
    var httpResponse = httpClient->post(<@untainted>path, httpRequest);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }

}

function updateRequestWithPayload(http:Client httpClient, string path, json jsonPayload = ())
returns @tainted json | error {

    http:Request httpRequest = new;
    if (jsonPayload != ()) {
        httpRequest.setJsonPayload(<@untainted>jsonPayload);
    }
    var httpResponse = httpClient->patch(<@untainted>path, httpRequest);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }

}

function uploadRequestWithPayload(http:Client httpClient, string path, json jsonPayload = ())
returns @tainted json | error {

    http:Request httpRequest = new;
    if (jsonPayload != ()) {
        httpRequest.setJsonPayload(<@untainted>jsonPayload);
    }
    var httpResponse = httpClient->post(<@untainted>path, httpRequest);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }
}

isolated function getDriveError(json|error errorResponse) returns error {
  if (errorResponse is json) {
        return error(errorResponse.toString());
  } else {
        return errorResponse;
  }
}


# Prepare Validate Status Code.
# 
# + response - JSON response fromthe request
# + statusCode - The Status code
# + return - Error Message
isolated function validateStatusCode(json response, int statusCode) returns error? {

    if (statusCode != http:STATUS_OK) {
        return getDriveError(response);
    }

}


# Prepare URL.
# 
# + paths - An array of paths prefixes
# + return - The prepared URL
isolated function prepareUrl(string[] paths) returns string {

    string url = EMPTY_STRING;
    if (paths.length() > 0) {
        foreach var path in paths {
            if (!path.startsWith(FORWARD_SLASH)) {
                url = url + FORWARD_SLASH;
            }
            url = url + path;
        }
    }
    return <@untainted>url;

}


# Prepare URL with encoded query.
# 
# + paths - An array of paths prefixes
# + queryParamNames - An array of query param names
# + queryParamValues - An array of query param values
# + return - The prepared URL with encoded query
isolated function prepareQueryUrl(string[] paths, string[] queryParamNames, string[] queryParamValues) 
returns string {

    string url = prepareUrl(paths);
    url = url + QUESTION_MARK;
    boolean first = true;
    int i = 0;
    foreach var name in queryParamNames {
        string value = queryParamValues[i];
        var encoded = encoding:encodeUriComponent(value, ENCODING_CHARSET);
        if (encoded is string) {
            if (first) {
                url = url + name + EQUAL + encoded;
                first = false;
            } else {
                url = url + AMPERSAND + name + EQUAL + encoded;
            }
        } else {
            log:printError(UNABLE_TO_ENCODE + value, err = encoded);
            break;
        }
        i = i + 1;
    }
    return url;

}

# Prepare URL with optional parameters.
# 
# + fileId - File id
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlWithFileOptional(string fileId , GetFileOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId]);
    if (optional is GetFileOptional) {
        if (optional.acknowledgeAbuse is boolean) {
            optionalMap[ACKKNOWLEDGE_ABUSE] = optional.acknowledgeAbuse.toString();
        }
        if (optional.fields is string) {
            optionalMap[FIELDS] = optional.fields.toString();
        }
        if (optional.includePermissionsForView is string) {
            optionalMap[INCLUDE_PERMISSIONS_FOR_VIEW] = optional.includePermissionsForView.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;

}

# Prepare URL with File Watch optional parameters.
# 
# + fileId - File id
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlwithWatchFileOptional(WatchFileOptional? optional = (), string? fileId = ()) returns string{

    string[] value = [];
    map<string> optionalMap = {};

    string path = EMPTY_STRING;
    if(fileId is string) {
        path = prepareUrl([DRIVE_PATH, FILES, fileId, WATCH]);
    } else {
        path = prepareUrl([DRIVE_PATH, CHANGES, WATCH]);
    }

    if (optional is WatchFileOptional) {
        if (optional.acknowledgeAbuse is boolean) {
            optionalMap[ACKKNOWLEDGE_ABUSE] = optional.acknowledgeAbuse.toString();
        }
        if (optional.fields is string) {
            optionalMap[FIELDS] = optional.fields.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        if (optional.pageToken is string) {
            optionalMap[PAGE_TOKEN] = optional.pageToken.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;

}

# Prepare URL with optional parameters on Delete Request
# 
# + fileId - File id
# + optional - Delete Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlWithDeleteOptional(string fileId , DeleteFileOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId]);
    if (optional is DeleteFileOptional) {
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;

}


# Prepare URL with optional parameters on Copy Request
# 
# + fileId - File id
# + optional - Copy Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlWithCopyOptional(string fileId , CopyFileOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId, COPY]);
    if (optional is CopyFileOptional) {
        if (optional.fields is string) {
            optionalMap[FIELDS] = optional.fields.toString();
        }
        if (optional.ignoreDefaultVisibility is boolean) {
            optionalMap[IGNORE_DEFAULT_VISIBILITY] = optional.ignoreDefaultVisibility.toString();
        }
        if (optional.includePermissionsForView is string) {
            optionalMap[INCLUDE_PERMISSIONS_FOR_VIEW] = optional.includePermissionsForView.toString();
        }
        if (optional.keepRevisionForever is boolean) {
            optionalMap[KEEP_REVISION_FOREVER] = optional.keepRevisionForever.toString();
        }
        if (optional.ocrLanguage is string) {
            optionalMap[OCR_LANGUAGE] = optional.ocrLanguage.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;

}

# Prepare URL with optional parameters on Update Request
# 
# + fileId - File id
# + optional - Update Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlWithUpdateOptional(string fileId , UpdateFileMetadataOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId]);

    if (optional is UpdateFileMetadataOptional) {

        // Optional Query Params
        if (optional.addParents is string) {
            optionalMap[ADD_PARENTS] = optional.addParents.toString();
        }
        if (optional.includePermissionsForView is string) {
            optionalMap[INCLUDE_PERMISSIONS_FOR_VIEW] = optional.includePermissionsForView.toString();
        }
        if (optional.keepRevisionForever is boolean) {
            optionalMap[KEEP_REVISION_FOREVER] = optional.keepRevisionForever.toString();
        }
        if (optional.ocrLanguage is string) {
            optionalMap[OCR_LANGUAGE] = optional.ocrLanguage.toString();
        }
        if (optional.removeParents is string) {
            optionalMap[REMOVE_PARENTS] = optional.removeParents.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        if (optional.useContentAsIndexableText is boolean) {
            optionalMap[USE_CONTENT_AS_INDEXABLE_TEXT] = optional.useContentAsIndexableText.toString();
        }
            
    }

    foreach var val in optionalMap {
        value.push(val);
    }

    path = prepareQueryUrl([path], optionalMap.keys(), value);

    return path;

}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlwithMetadataFileOptional(CreateFileOptional? optional = ()) returns string {
    
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES]);
    if (optional is CreateFileOptional) {

        //Optional Params
        if (optional.ignoreDefaultVisibility is boolean) {
            optionalMap[IGNORE_DEFAULT_VISIBILITY] = optional.ignoreDefaultVisibility.toString();
        }
        if (optional.includePermissionsForView is string) {
            optionalMap[INCLUDE_PERMISSIONS_FOR_VIEW] = optional.includePermissionsForView.toString();
        }
        if (optional.keepRevisionForever is boolean) {
            optionalMap[KEEP_REVISION_FOREVER] = optional.keepRevisionForever.toString();
        }
        if (optional.ocrLanguage is string) {
            optionalMap[OCR_LANGUAGE] = optional.ocrLanguage.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        if (optional.useContentAsIndexableText is boolean) {
            optionalMap[USE_CONTENT_AS_INDEXABLE_TEXT] = optional.useContentAsIndexableText.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;

}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlwithFileListOptional(ListFilesOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES]);
    if (optional is ListFilesOptional) {

        //Optional Params
        if (optional.corpora is string){
           optionalMap[UPLOAD_TYPE] = optional.corpora.toString();
        }
        if (optional.driveId is string) {
            optionalMap[DRIVE_ID] = optional.driveId.toString();
        }
        if (optional.fields is string) {
            optionalMap[FIELDS] = optional.fields.toString();
        }
        if (optional.includeItemsFromAllDrives is boolean) {
            optionalMap[INCLUDE_ITEMS_FROM_ALL_DRIVES] = optional.includeItemsFromAllDrives.toString();
        }
        if (optional.includePermissionsForView is string) {
            optionalMap[INCLUDE_PERMISSIONS_FOR_VIEW] = optional.includePermissionsForView.toString();
        }
        if (optional.orderBy is string) {
            optionalMap[ORDER_BY] = optional.orderBy.toString();
        }
        if (optional.pageSize is int) {
            optionalMap[PAGE_SIZE] = optional.pageSize.toString();
        }
        if (optional.pageToken is string) {
            optionalMap[PAGE_TOKEN] = optional.pageToken.toString();
        }
        if (optional.q is string) {
            optionalMap[Q] = optional.q.toString();
        }
        if (optional.spaces is string) {
            optionalMap[SPACES] = optional.spaces.toString();
        }
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }

        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Upload files
# 
# + path - Formatted URI 
# + filePath - File path subjected to upload
# + return - Json response or Error
function uploadFiles(http:Client httpClient, string path, string filePath) returns @tainted json | error {

    http:Request httpRequest = new;
    byte[] fileContentByteArray = check io:fileReadBytes(filePath);
    httpRequest.setHeader(CONTENT_LENGTH ,fileContentByteArray.length().toString());
    httpRequest.setBinaryPayload(<@untainted> fileContentByteArray);

    var httpResponse = httpClient->post(<@untainted>path, httpRequest);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }

}

# Upload files using a byte Array
# 
# + path - Formatted URI 
# + byteArray - Byte Array subjected to upload
# + return - Json response or Error
function uploadFileWithByteArray(http:Client httpClient, string path, byte[] byteArray) returns @tainted json | error {

    http:Request httpRequest = new;
    httpRequest.setHeader(CONTENT_LENGTH ,byteArray.length().toString());
    httpRequest.setBinaryPayload(<@untainted> byteArray);

    var httpResponse = httpClient->post(<@untainted>path, httpRequest);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            if (validateStatusCodeRes is error) {
                return validateStatusCodeRes;
            }
            return jsonResponse;
        } else {
            return getDriveError(jsonResponse);
        }
    } else {
        return getDriveError(<json|error>httpResponse);
    }

}

function getIdFromFileResponse(File|error file) returns string {

    string fileOrFolderId = EMPTY_STRING;
    if(file is File){
        json|error created_response = file.cloneWithType(json); 
        if (created_response is json){
            json|error id = created_response.id;
            if(id is json) {
                log:print(id.toString());   
                return <@untainted> id.toString();
            }
        }
    }
    return fileOrFolderId;

}

# Check HTTP response and return JSON payload on success else an error.
# 
# + httpResponse - HTTP respone or HTTP payload or error
# + return - JSON result on success else an error
isolated function checkAndSetErrors(http:Response|http:PayloadType|error httpResponse) returns @tainted json|error {
    if (httpResponse is http:Response) {
        if (httpResponse.statusCode == http:STATUS_OK || httpResponse.statusCode == http:STATUS_CREATED) {
            json|error jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                return jsonResponse;
            } else {
                return error(JSON_ACCESSING_ERROR_MSG, jsonResponse);
            }
        } else if (httpResponse.statusCode == http:STATUS_NO_CONTENT) {
            return {};
        } else {
            json|error jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                json err = check jsonResponse.'error.message;
                return error(HTTP_ERROR_MSG + err.toString());
            } else {
                return error(ERR_EXTRACTING_ERROR_MSG, jsonResponse);
            }
        }
    } else {
        return error(HTTP_ERROR_MSG + (<error>httpResponse).message());
    }
}