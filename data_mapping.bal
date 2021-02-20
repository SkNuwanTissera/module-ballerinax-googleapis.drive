# Log File as String
# 
# + file - File object
# + return - Error if exists 
function printFileasString(File|error file) returns error?{
    if (file is File){
        json|error jsonObject = file.cloneWithType(json);
        if (jsonObject is json) {
            log:print(jsonObject.toString());
        }  else {
            log:printError(ERR_FILE_TO_STRING_CONVERSION + jsonObject.toString(), err = jsonObject);
            return error(ERR_FILE_TO_STRING_CONVERSION, jsonObject);
        }
    } else {
        log:printError(ERR_FILE_TO_STRING_CONVERSION + jsonObject.toString(), err = jsonObject);
        return error(ERR_FILE_TO_STRING_CONVERSION, jsonObject);
    }
}

function printJSONasString(json|error jsonObject) returns error?{

    if (jsonObject is json) {
        log:print(jsonObject.toString());
    }  else {
        log:printError(ERR_JSON_TO_STRING_CONVERSION + jsonObject.toString(), err = jsonObject);
        return error(ERR_JSON_TO_STRING_CONVERSION, jsonObject);
    }
    
}

function convertFiletoJSON(File|error file) returns json|error {
    if (file is File){ 
        json|error jsonObject = file.cloneWithType(json);
        if (jsonObject is map<json>) {
            return jsonObject;
        }  else {
            return getDriveError(jsonObject);
        }
    } else {
        log:printError(ERR_FILE_TO_JSON_CONVERSION + jsonObject.toString(), err = jsonObject);
        return error(ERR_FILE_TO_JSON_CONVERSION, jsonObject);
    }
}

function convertJSONtoFile(json|error jsonObj) returns File|error{
    if jsonObj is json { 
        File|error file = jsonObj.cloneWithType(File);
        if (file is File) {
            return file;
        } else {
            return error(ERR_JSON_TO_FILE_CONVERT, file);
        }
    } else {
        return error(ERR_JSON_TO_FILE_CONVERT, jsonObj);
    }
}