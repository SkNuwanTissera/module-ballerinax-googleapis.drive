import ballerina/log;
import nuwantissera/googleapis_drive as drive;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REFRESH_URL = ?;
configurable string REFRESH_TOKEN = ?;

###################################################################################
# Get files
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

    drive:ListFilesOptional optional_search = {
        pageSize : 3
    };
    
    stream<drive:File>|error res = driveClient->getFiles(optional_search);
    if (res is stream<drive:File>){
        error? e = res.forEach(function (drive:File file) {
            json|error jsonObject = file.cloneWithType(json);
            if (jsonObject is json) {
                log:print(jsonObject.toString());
            }
        });
    }

}