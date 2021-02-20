// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/encoding;
import ballerina/log;
import ballerina/stringutils;
import ballerina/io;

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