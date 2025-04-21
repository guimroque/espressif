#include "tasks.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include <stdio.h>

#define LED_GPIO GPIO_NUM_2

void blink_task(void *pvParameter)
{
    gpio_reset_pin(LED_GPIO);
    gpio_set_direction(LED_GPIO, GPIO_MODE_OUTPUT);

    while (1) {
    gpio_set_level(LED_GPIO, 1);
    vTaskDelay(pdMS_TO_TICKS(500));
    gpio_set_level(LED_GPIO, 0);
    vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void print_task(void *pvParameter)
{
    while (1) {
        printf("🖨️ Hello from Print Task!\n");
        vTaskDelay(pdMS_TO_TICKS(2000));
    }
}

void start_tasks(void)
{
    // Create Blink Task
    xTaskCreate(
        blink_task,
        "Blink Task",
        2048,
        NULL,
        5,
        NULL
    );

    // Create Print Task
    xTaskCreate(
        print_task,
        "Print Task",
        2048,
        NULL,
        5,
        NULL
    );
}
