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

    drive:UpdateFileMetadataOptional optionals_ = {
        addParents : parentFolder //Parent folderID
    };

    drive:File payload_ = {
        name : "test123.jpeg"
    };

    string filePath = "./tests/resources/bar.jpeg";

    drive:File payload = {
        mimeType : "application/vnd.google-apps.folder",
        name : "folderInTheRoot"
    };
    
    File|error res = driveClient->uploadFile(filePath, optionals_, payload_);
}