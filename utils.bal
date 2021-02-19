import ballerina/http;
import ballerina/encoding;
import ballerina/log;
import ballerina/stringutils;
import ballerina/io;
import ballerina/file;

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

function deleteRequest(http:Client httpClient, string path) returns @tainted json | error {
    var httpResponse = httpClient->delete(<@untainted>path);
    log:print("#######%$#%#$"+path);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        json | http:ClientError jsonResponse = httpResponse.getJsonPayload();
        if (jsonResponse is json) {
            error? validateStatusCodeRes = validateStatusCode(jsonResponse, statusCode);
            log:print("$$$$$"+jsonResponse.toString());
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

function sendRequestWithPayload(http:Client httpClient, string path, json jsonPayload = ())
returns @tainted json | error {

    http:Request httpRequest = new;
    // httpRequest.setHeader(CONTENT_TYPE,"application/vnd.google-apps.photo");
    // httpRequest.setHeader(CONTENT_LENGTH,"2048");
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
        log:print("Hi from uploadRequestWithPayload - " +jsonPayload.toString());
        httpRequest.setJsonPayload(<@untainted>jsonPayload);
    }
    var httpResponse = httpClient->post(<@untainted>path, httpRequest);
    if (httpResponse is http:Response) {
        log:print("Hi from uploadRequestWithPayload - " +httpResponse.toString());
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
            log:printError("Unable to encode value: " + value, err = encoded);
            break;
        }
        i = i + 1;
    }
    return url;
}

# Get ID from URL
# URL can for a file, folder, blob(Text, images, videos, and PDFs), 
# or workspace document (Spreadsheets, Presentation, Document, etc..)
# 
# + url - url copied from google drive.
# + return - ID as string or Error
function getIdFromUrl(string url) returns string | error { 
    
    // use regex pattern 

    string id = EMPTY_STRING;
    int startIndex = 0;
    boolean isFile = stringutils:contains(url,_FILE);
    boolean isFolder = stringutils:contains(url,_FOLDER);
    boolean isWorkspaceDocument = stringutils:contains(url,_WORKSPACE_DOC);

    if (isFile){ 
        startIndex = stringutils:lastIndexOf(url,_FILE);
        id = url.substring(startIndex+INT_VALUE_8, startIndex+INT_VALUE_41);       
    } else if (isFolder){
        startIndex = stringutils:lastIndexOf(url,_FOLDER);
        id = url.substring(startIndex+INT_VALUE_8,startIndex+INT_VALUE_42);
    } else if (isWorkspaceDocument) {
        id = url.substring(INT_VALUE_39,INT_VALUE_83);
    } 
    return id;
}

# Prepare URL with optional parameters.
# 
# + fileId - File id
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithFileOptional(string fileId , GetFileOptional? optional = ()) returns string {
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
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters on Delete Request
# 
# + fileId - File id
# + optional - Delete Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithDeleteOptional(string fileId , DeleteFileOptional? optional = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId]);
    if (optional is DeleteFileOptional) {
        if (optional.supportsAllDrives is boolean) {
            optionalMap[SUPPORTS_ALL_DRIVES] = optional.supportsAllDrives.toString();
        }
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}


# Prepare URL with optional parameters on Copy Request
# 
# + fileId - File id
# + optional - Copy Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithCopyOptional(string fileId , CopyFileOptional? optional = ()) returns string {
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
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters on Update Request
# 
# + fileId - File id
# + optional - Update Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithUpdateOptional(string fileId , UpdateFileMetadataOptional? optional = ()) returns string {

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

    optionalMap.forEach(function(string val) {
        value.push(val);
    });

    path = prepareQueryUrl([path], optionalMap.keys(), value);

    return path;
}

function printFileasString(File|error file) {
    if (file is File){
        json|error jsonObject = file.cloneWithType(json);
        if (jsonObject is json) {
            log:print(jsonObject.toString());
        }  else {
            log:print(jsonObject.toString());
        }
    } else {
        log:print(file.message());
    }
}

function printJSONasString(json|error jsonObject) {

    if (jsonObject is json) {
        log:print(jsonObject.toString());
    }  else {
        log:print(jsonObject.message());
    }
    
}

function convertFiletoJSON(File|error file) returns json|error {
    if (file is File){
        json|error jsonObject = file.cloneWithType(json);
        if (jsonObject is map<json>) {
            return jsonObject;
        }  else {
            return getDriveError(jsonObject);
        }
    }
}

function convertJSONtoFile(json|error jsonObj) returns File|error{
    if jsonObj is json { //use a separate function for this
        File|error file = jsonObj.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_JSON_TO_FILE_CONVERT, file);
        }
    } else {
        return error(ERR_JSON_TO_FILE_CONVERT, jsonObj);
    }
}


# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlwithMetadataFileOptional(CreateFileOptional? optional = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES]);
    if (optional is CreateFileOptional) {
        //Required Param
        //optionalMap[UPLOAD_TYPE] = optional.uploadType.toString();
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
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlwithUploadOptional(UploadFileOptional? optional = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([UPLOAD, DRIVE_PATH, FILES]);
    if (optional is UploadFileOptional) {
        //Required Param
        if (optional.uploadType is string){
           optionalMap[UPLOAD_TYPE] = optional.uploadType.toString();
        }
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
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlwithFileListOptional(ListFilesOptional? optional = ()) returns string {
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

        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

function readFileAsByteArray(string filePath) returns @tainted error?{

    //create a file and upload
    error? createFileResults = file:create(filePath);
    if (createFileResults is error) {
        io:println(createFileResults.message());
    }

    //convert byte[] from file.
    stream<io:Block, io:Error?> blockStream = check io:fileReadBlocksAsStream(filePath, 2048);
}

# Prepare URL with optional parameters on Update Request
# 
# + fileId - File id
# + optional - Update Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithUpdateExistingOptional(string fileId , UpdateFileMetadataOptional? optional = ()) returns string {

    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([UPLOAD, DRIVE_PATH, FILES, fileId]);

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

    optionalMap.forEach(function(string val) {
        value.push(val);
    });

    path = prepareQueryUrl([path], optionalMap.keys(), value);

    return path;
}