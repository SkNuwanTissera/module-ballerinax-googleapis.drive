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

    drive:CreateFileOptional optionals_create_file = {
        ignoreDefaultVisibility : false
    };

    drive:File payload_create_file = {
        mimeType : "application/vnd.google-apps.document",
        name : "nuwan123"
        //parents : [parentFolder]
    };

    drive:File|error res = driveClient->createMetaDataFile(optionals_create_file, payload_create_file);

    //Print file ID
    if(res is drive:File){
        string id = res?.id.toString();
        log:print(id);
    } else {
        log:printError(res.message());
    }

}