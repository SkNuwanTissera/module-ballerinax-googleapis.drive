import ballerina/log;
import ballerinax/googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;
configurable string fileId = ?;

###################################################################################
# Copy file by ID
###################################################################################
# Creates a copy of a file and applies any requested updates with patch semantics. 
# **Folders cannot be copied
# ################################################################################
# More details : https://developers.google.com/drive/api/v3/reference/files/copy
# #################################################################################
# 

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

    drive:CopyFileOptional optionals_copy_file = {"includePermissionsForView" : "published"};

    drive:File payload_copy_file = {
        name : "testfile.pdf" //New name
    };

    drive:File|error res = driveClient->copyFile(fileId ,optionals_copy_file ,payload_copy_file );

    //Print file ID
    if(res is drive:File){
        string id = res?.id.toString();
        log:print(id);
    } else {
        log:printError(res.message());
    }
    
}