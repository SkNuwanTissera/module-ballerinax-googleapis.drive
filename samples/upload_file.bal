import ballerina/log;
import nuwantissera/module_ballerinax_googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

configurable string filePath = ?;

###################################################
# Upload file using Byte Array
# #################################################

public function main() {

    drive:Configuration config = {
        clientConfig: {
            clientId: CLIENT_ID,
            clientSecret: CLIENT_SECRET,
            refreshUrl: REFRESH_URL,
            refreshToken: REFRESH_TOKEN
        }
    };

    drive:UpdateFileMetadataOptional optionals_ = {
        addParents : parentFolder //Parent folderID
    };

    drive:File payload_ = {
        name : "test123.jpeg"
    };

    drive:File payload = {
        mimeType : "application/vnd.google-apps.folder",
        name : "folderInTheRoot"
    };
    
    drive:File|error res = driveClient->uploadFile(filePath, optionals_, payload_);

    //Print file ID
    if(res is drive:File){
        string id = res?.id.toString();
        log:print(id);
    } else {
        log:printError(res.message());
    }
}