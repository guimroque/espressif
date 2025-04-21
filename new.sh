#!/bin/bash

# Script: new.sh
# Purpose: Create a new ESP-IDF project

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Error: Please provide a project name. Usage: ./new.sh <project_name>"
  exit 1
fi

echo "🚀 Creating new project: $PROJECT_NAME"

mkdir -p "$PROJECT_NAME/main"

# Root CMakeLists.txt
cat > "$PROJECT_NAME/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.5)

include(\$ENV{IDF_PATH}/tools/cmake/project.cmake)
project($PROJECT_NAME)
EOF

# main/CMakeLists.txt
cat > "$PROJECT_NAME/main/CMakeLists.txt" <<EOF
idf_component_register(SRCS "main.c"
                    INCLUDE_DIRS ".")
EOF

# main/main.c
cat > "$PROJECT_NAME/main/main.c" <<EOF
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void app_main(void)
{
    printf("Hello from $PROJECT_NAME!\\n");

    while (1) {
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
}
EOF

echo "✅ Project '$PROJECT_NAME' created successfully!"
echo "➡️ To start:"
echo "  cd $PROJECT_NAME"
echo "  idf.py build"
