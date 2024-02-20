#!/usr/bin/env bash

set -e

if [ -z "$KBC_DEVELOPERPORTAL_APP" ]; then
    echo "Error: APP_NAME environment variable is not set."
    exit 1
fi

# Obtain the component repository and log in
docker pull quay.io/keboola/developer-portal-cli-v2:latest

echo "Component properties to update: $KBC_DEVELOPERPORTAL_APP"
echo "KBC_DEVELOPERPORTAL_VENDOR: $KBC_DEVELOPERPORTAL_VENDOR"

update_property() {
    local app_id="$1"
    local prop_name="$2"
    local file_path="$3"
    local value=$(<"$file_path")
    echo "Updating $prop_name for $app_id"
    echo "$value"
    if [ ! -z "$value" ]; then
        docker run --rm \
            -e KBC_DEVELOPERPORTAL_USERNAME \
            -e KBC_DEVELOPERPORTAL_PASSWORD \
            quay.io/keboola/developer-portal-cli-v2:latest \
            update-app-property "$KBC_DEVELOPERPORTAL_VENDOR" "$app_id" "$prop_name" --value="$value"
        echo "Property $prop_name updated successfully for $app_id"
    else
        echo "$prop_name is empty for $app_id!"
        exit 1
    fi
}

update_property "$app_id" "longDescription" "component_config/component_long_description.md"
update_property "$app_id" "configurationSchema" "component_config/configSchema.json"
update_property "$app_id" "configurationRowSchema" "component_config/configRowSchema.json"
update_property "$app_id" "configurationDescription" "component_config/configuration_description.md"
update_property "$app_id" "shortDescription" "component_config/component_short_description.md"
update_property "$app_id" "logger" "component_config/logger"
update_property "$app_id" "loggerConfiguration" "component_config/loggerConfiguration.json"
