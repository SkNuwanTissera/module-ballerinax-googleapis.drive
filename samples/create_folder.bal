import ballerina/log;
import ballerinax/googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

###################################################################################
# Create folder 
###################################################################################
# Creates a new folder
# Specify the file Name inside the payload. Else it will be uploaded as Untitled 
# folder.
# Specify the mime type as application/vnd.google-apps.folder
# More details : https://developers.google.com/drive/api/v3/mime-types
# ################################################################################
# More details : https://developers.google.com/drive/api/v3/reference/files/create
# #################################################################################

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