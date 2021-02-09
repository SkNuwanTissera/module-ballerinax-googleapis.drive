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

    // /drive/v3/files/14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4?acknowledgeAbuse=true
    // &includePermissionsForView=aaaaa&supportsAllDrives=true&supportsTeamDrives=true&alt=json
    // &fields=user&prettyPrint=true&quotaUser=bbbb&userIp=ccccccc&key=AIzaSyAa8yy0GdcGPHdtD083HiGGx_S0vMPScDM

    // /drive/v3/files/14THDSaX5oNy2D5n6PIecKIK2R1MXxezpCB8bc6yhlx4?acknowledgeAbuse=false
    // &supportsAllDrives=false&supportsTeamDrives=false&alt=json
    // &prettyPrint=false&key=AIzaSyAa8yy0GdcGPHdtD083HiGGx_S0vMPScDM
    string path = prepareUrlWithEventOptional(fileId, optional);
    log:print(path.toString());
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
    string path = DRIVE_PATH + FILES;
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

