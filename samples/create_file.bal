import ballerina/log;
// import ballerinax/googleapis_drive as drive;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

public function main() {
    
    configurable string CLIENT_ID = ?;
    configurable string CLIENT_SECRET = ?;
    configurable string REFRESH_URL = ?;
    configurable string REFRESH_TOKEN = ?;

    Configuration config = {
        clientConfig: {
            clientId: CLIENT_ID,
            clientSecret: CLIENT_SECRET,
            refreshUrl: REFRESH_URL,
            refreshToken: REFRESH_TOKEN
        }
    };

    Client driveClient = new (config);

    CreateFileOptional optionals = {
        ignoreDefaultVisibility : false
    };

    File payload = {
        mimeType : "application/vnd.google-apps.folder",
        name : "folderInTheRoot"
    };

    @test:Config {}
    function testCreateFolder() {
        File|error res = driveClient->createMetaDataFile(optionals, payload);
        parentFolder = <@untainted> getIdFromFileResponse(res);
        error? err = printFileasString(res);
    }

}