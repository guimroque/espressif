#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_intr_alloc.h"

// GPIO where the LED is connected
#define LED_GPIO GPIO_NUM_2

// GPIO where the Button (BOOT) is connected
#define BUTTON_GPIO GPIO_NUM_0

// Interrupt handler (called when button changes state)
static void IRAM_ATTR button_isr_handler(void* arg)
{
    int button_state = gpio_get_level(BUTTON_GPIO);

    if (button_state == 0) { // Button pressed
        gpio_set_level(LED_GPIO, 1); // Turn on LED
    } else { // Button released
        gpio_set_level(LED_GPIO, 0); // Turn off LED
    }
}

void app_main(void)
{
    // Configure LED GPIO as output
    gpio_reset_pin(LED_GPIO);
    gpio_set_direction(LED_GPIO, GPIO_MODE_OUTPUT);

    // Configure Button GPIO as input
    gpio_reset_pin(BUTTON_GPIO);
    gpio_set_direction(BUTTON_GPIO, GPIO_MODE_INPUT);

    // Configure pull-up if necessary (ESP32 BOOT button usually has it)
    gpio_pullup_en(BUTTON_GPIO);
    gpio_pulldown_dis(BUTTON_GPIO);

    // Configure the interrupt type (trigger on both edges: press and release)
    gpio_set_intr_type(BUTTON_GPIO, GPIO_INTR_ANYEDGE);

    // Install the ISR service (ESP-IDF manages the interrupt)
    gpio_install_isr_service(0);

    // Attach the interrupt handler
    gpio_isr_handler_add(BUTTON_GPIO, button_isr_handler, NULL);

    // Main loop can be empty (or do other tasks)
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000)); // Just idle
    }
}
