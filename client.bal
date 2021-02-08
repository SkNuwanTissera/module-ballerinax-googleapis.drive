// Client Class

import ballerina/http;
import ballerina/oauth2;

public client class Client {

    public http:Client httpClient;

    public function init(DriveConfiguration driveConfig) {
        oauth2:OutboundOAuth2Provider oauth2Provider = new (driveConfig.oauth2Config);
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);
        http:ClientSecureSocket? socketConfig = driveConfig?.secureSocketConfig;
        self.httpClient = new (DRIVE_URL, {
            auth: {
                authHandler: bearerHandler
            },
            secureSocket: socketConfig
        });

    }

    remote function getAbout(string? fields) returns @tainted json|error {
        return getDriveInfo(self.httpClient , fields);
    }
}

public type DriveConfiguration record {
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};

