# module-ballerinax-googleapis.drive
### Google Drive Connecter
Connector repository for Google Drive API V3.

Connects to Google Drive from Ballerina.

# Package Overview
The Google Drive connector allows you to access Google Drive operations through the Google Drive REST API. It also allows you to create, retreive, search, and delete drive files and folders.

## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Preview8          |
| Google Drive API            |             V3                  |

## Sample

Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for OAuth 2.0. Google Drive uses OAuth 2.0 to authenticate and authorize requests. The Google Drive connector can be minimally instantiated in the HTTP client config using the access token or the client ID, client secret, and refresh token.

**Obtaining Tokens to Run the Sample**

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token. 

**Add project configurations file**

Add the project configuration file by creating a `ballerina.conf` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous step to the `ballerina.conf` file.

```
ACCESS_TOKEN = "<access_token>"
CLIENT_ID = "<client_id">
CLIENT_SECRET = "<client_secret>"
REFRESH_TOKEN = "<refresh_token>"
REFRESH_URL = "<refresh_URL>"

```
**Example Code**

Creating a drive:driveClient by giving the HTTP client config details. 

```ballerina

    import ballerina/config;   
    import ballerinax/googleapis_drive as drive;

    drive:Configuration config = {
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

    drive:Client driveClient = new (config);

```

Get File By Id

```ballerina

    drive:File|error file = driveClient->getFileById(fileId);

```

Get files

```ballerina

    ListFilesOptional optional_search = {
        pageSize : 3
    };
    drive:File|error file = driveClient->getFiles(optional_search);

```


#### How to Get a Link for a file or folder in Google drive
1. Go to Gdrive https://drive.google.com/drive/u/0/my-drive
2. Right click on a folder or file.
3. Click 'Get link'. Then copy the link.