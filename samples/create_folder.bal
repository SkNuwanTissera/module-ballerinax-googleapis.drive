import ballerina/log;
import ballerinax/googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

public function main() {

    drive:Configuration config = {
        clientConfig: {
            clientId: CLIENT_ID,
            clientSecret: CLIENT_SECRET,
            refreshUrl: REFRESH_URL,
            refreshToken: REFRESH_TOKEN
        }
    };

    drive:Client driveClient = new (config);

    drive:CreateFileOptional optionals = {
        ignoreDefaultVisibility : false
    };

    drive:File payload = {
        mimeType : "application/vnd.google-apps.folder",
        name : "folderInTheRoot"
    };
    
    drive:File|error res = driveClient->createMetaDataFile(optionals, payload);

    //Print folder ID
    if(res is drive:File){
        string id = res?.id.toString();
        log:print(id);
    } else {
        log:printError(res.message());
    }

}