import ballerina/config;
import ballerina/test;
import ballerina/log;

DriveConfiguration config = {
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

Client driveClient = new (config);

@test:Config {}
function testDriveGetAbout() {
    var res1 = driveClient->getAbout("*");
    // var res2 = driveClient->getAbout("kind");
    // var res3 = driveClient->getAbout("user");
    // var res4 = driveClient->getAbout("storageQuota");
    // refer https://developers.google.com/drive/api/v3/reference/about#resource
    log:print(res1.toString());
}

@test:Config {}
function testgetFileById() {}
