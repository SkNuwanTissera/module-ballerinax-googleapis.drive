import ballerina/log;
import ballerina/http;
import ballerina/io;

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

function updateFileById(http:Client httpClient, string fileId, UpdateFileMetadataOptional? optional = (), File? fileResource = ()) returns @tainted File|error {

    json payload = check fileResource.cloneWithType(json);
    string path = prepareUrlWithUpdateOptional(fileId, optional);
    json|error resp = updateRequestWithPayload(httpClient, path, payload);
    if resp is json { //use a separate function for this
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


function updateExistingFileById(http:Client httpClient, string fileId, UpdateFileMetadataOptional? optional = (), File? fileResource = ()) returns @tainted File|error {

    json payload = check fileResource.cloneWithType(json);
    string path = prepareUrlWithUpdateExistingOptional(fileId, optional);
    json|error resp = updateRequestWithPayload(httpClient, path, payload);
    if resp is json { //use a separate function for this
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

function createMetaDataFile(http:Client httpClient, CreateFileOptional? optional = (), File? fileData = ()) returns @tainted File|error {

    json payload = check fileData.cloneWithType(json);
    string path = prepareUrlwithMetadataFileOptional(optional);
    json|error resp = uploadRequestWithPayload(httpClient, path, payload);
    return convertJSONtoFile(resp);

}


function uploadFile(http:Client httpClient, string filePath, UpdateFileMetadataOptional? optional = (), File? fileMetadata = ()) returns @tainted File|error{
    
    string path = prepareUrl([UPLOAD, DRIVE_PATH, FILES]);
    log:print(path.toString());

    byte[] fileContentByteArray = check io:fileReadBytes(filePath);
    
    json|error resp = uploadFiles(httpClient, path, filePath);
    if (resp is json){
        //update metadata
        string fileId = resp.id.toString();
        log:print(resp.id.toString());
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
    } else {
        return resp;
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