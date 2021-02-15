import ballerina/http;
import ballerina/encoding;
import ballerina/log;
import ballerina/stringutils;
// import ballerina/io;

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
    //httpRequest.setHeader(CONTENT_TYPE,"multipart/related");
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
            log:print("Hi from sendRequestWithPayload - " +jsonResponse.toString());
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
function prepareUrlWithUpdateOptional(string fileId , UpdateFileOptional? optional = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([DRIVE_PATH, FILES, fileId]);
    if (optional is UpdateFileOptional) {
        if (optional.uploadType is string) { // Required Query Param

            optionalMap[UPLOAD_TYPE] = optional.uploadType.toString();
            
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
    }
    return path;
}


function convertFiletoString(File file) returns string{
    string stringObj = EMPTY_STRING;
    json|error jsonObject = file.cloneWithType(json);
    if (jsonObject is json) {
        stringObj = jsonObject.toString();
    }  
    return stringObj;
}