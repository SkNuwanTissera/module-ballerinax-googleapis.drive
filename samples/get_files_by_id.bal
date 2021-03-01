import ballerina/log;
import ballerinax/googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

configurable string fileId = "1qlLs1eoaQDFwPSba-ddjsKdgzyUHwzZk";

###################################################################################
# Get files by ID
# ################################################################################
# More details : https://developers.google.com/drive/api/v3/reference/files/get
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

    drive:File | error testGetFile = driveClient->getFileById(fileId);

    //Print file ID
    if(testGetFile is drive:File){
        string id = testGetFile?.id.toString();
        log:print(id);
    } else {
        log:printError(testGetFile.message());
    }

}