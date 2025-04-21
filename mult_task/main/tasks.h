#ifndef TASKS_H
#define TASKS_H

void start_tasks(void);   // Function to start all tasks

// Optional: you can also declare individual task functions if needed
void blink_task(void *pvParameter);
void print_task(void *pvParameter);

#endif // TASKS_H
