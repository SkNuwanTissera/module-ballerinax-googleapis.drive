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
    json resp = check sendRequest(httpClient, path);
    log:print("#$#$"+resp.toString());
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

function deleteFileById(http:Client httpClient, string fileId, DeleteFileOptional? optional = ()) returns @tainted boolean|error{

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

function updateFileById(http:Client httpClient, string fileId, UpdateFileMetadataOptional? optional = (), File? fileResource = ()) returns @tainted File|error {

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

function createMetaDataFile(http:Client httpClient, CreateFileOptional? optional = (), File? fileData = ()) returns @tainted File|error {

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


function uploadFile(http:Client httpClient, string filePath, UpdateFileMetadataOptional? optional = (), File? fileMetadata = ()) returns @tainted File|error{
    
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

function watchFiles(http:Client httpClient, WatchFileOptional? optional = (), FileWatchResource? fileWatchRequest = (), string? fileId = ()) 
returns @tainted FileWatchResource|error {

    string path = EMPTY_STRING;
    if (fileId is string) {
        path = prepareUrlwithWatchFileOptional(optional,fileId);
    } else {
        path = prepareUrlwithWatchFileOptional(optional);
    }

    json payload = check fileWatchRequest.cloneWithType(json);

    json|error resp = sendRequestWithPayload(httpClient, path, payload);

    if resp is json {
        FileWatchResource|error res = resp.cloneWithType(FileWatchResource);
        if (res is FileWatchResource) {
            return res;
        } else {
            return error(ERR_FILE_RESPONSE, res);
        }
    } else {
        return resp;
    }
}

function stopWatch(http:Client httpClient, FileWatchResource? fileWatchRequest = ()) returns @tainted json|error {

    string path = prepareUrl([DRIVE_PATH, CHANNELS, STOP]);
    json payload = check fileWatchRequest.cloneWithType(json);
    json|error resp = sendRequestWithPayload(httpClient, path, payload);
    log:print("$$$$"+path);
    log:print("!!!!"+payload.toString());
    if (resp is json){
       log:print("^^^^"+resp.toString()); 
    }

    return resp;

}

function uploadFileUsingByteArray(http:Client httpClient, byte[] byteArray, UpdateFileMetadataOptional? optional = (), File? fileMetadata = ()) returns @tainted File|error{
    
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