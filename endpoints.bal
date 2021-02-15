import ballerina/log;
import ballerina/http;

function getDriveInfo(http:Client httpClient, string? fields) returns @tainted json|error{
    string path = DRIVE_PATH + ABOUT + QUESTION_MARK + FIELDS + EQUAL + _ALL;
    if (fields is string) {
        path = DRIVE_PATH + ABOUT + QUESTION_MARK + FIELDS + EQUAL + fields;
    }
    return sendRequest(httpClient, path);
}

function getFileById(http:Client httpClient, string fileId, GetFileOptional? optional = ()) returns @tainted File|error {

    string path = prepareUrlWithFileOptional(fileId, optional);
    json | error resp = sendRequest(httpClient, path);
    log:print(resp.toString());
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

// TO-DO : Needs Upload type support, Map input json body to file (ClonewithType)
function createNewFile(http:Client httpClient, json fileResource) returns @tainted File|error{
    
    string path = prepareQueryUrl([UPLOAD, DRIVE_PATH, FILES], [UPLOAD_TYPE] , [TYPE_MULTIPART]);
    json | error resp = sendRequestWithPayload(httpClient, path, fileResource);
    log:print(resp.toString());
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

function deleteFileById(http:Client httpClient, string fileId, DeleteFileOptional? optional = ()) returns @tainted json|error{

    string path = prepareUrlWithDeleteOptional(fileId, optional);
    json | error resp = deleteRequest(httpClient, path);
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

function updateFile(http:Client httpClient, string fileId, UpdateFileOptional? optional = (), File? fileResource = ()) returns @tainted File|error {

    json payload = check fileResource.cloneWithType(json);
    string path = prepareUrlWithCopyOptional(fileId, optional);
    log:print("##########" +path.toString());
    json|error resp = sendRequestWithPayload(httpClient, path, payload);
    if resp is json {
        log:print("##########" +resp.toString());
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


