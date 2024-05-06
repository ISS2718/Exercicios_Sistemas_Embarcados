/*
 * This code was modified by Daniel Contente, Hugo Nakamura, Isaac Soares, Mateus Messias.
 *
 * FreeRTOS V202212.00
 * Copyright (C) 2021 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * https://www.FreeRTOS.org
 * https://github.com/FreeRTOS
 *
 */

#include <stdint.h>

/* FreeRTOS kernel */
#include <FreeRTOS.h>
#include <task.h>

/* NEORV32 HAL */
#include <neorv32.h>
#include "matrix.h"

/* Platform UART configuration */
#define UART_BAUD_RATE (19200)         // transmission speed
#define UART_HW_HANDLE (NEORV32_UART0) // use UART0 (primary UART)

/* External definitions */
extern const unsigned __crt0_max_heap;          // may heap size from NEORV32 linker script
extern void matrix_tasks(void);                       // actual show-case application
extern void freertos_risc_v_trap_handler(void); // FreeRTOS core

/* Prototypes for the standard FreeRTOS callback/hook functions implemented
 * within this file. See https://www.freertos.org/a00016.html */
void vApplicationMallocFailedHook(void);
void vApplicationIdleHook(void);
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName);
void vApplicationTickHook(void);

/* Platform-specific prototypes */
static void prvSetupHardware(void);

int main( void ) {

  // setup hardware
	prvSetupHardware();

  // say hello
  neorv32_uart_printf(UART_HW_HANDLE, "Multiplicacao de Matrizes FreeRTOS\n");

  // run actual application code
  matrix_tasks();

  // we should never reach this
  neorv32_uart_printf(UART_HW_HANDLE, "FIM!\n");
  return -1;
}

//CPU
static void prvSetupHardware(void) {
  // install the freeRTOS kernel trap handler
  neorv32_cpu_csr_write(CSR_MTVEC, (uint32_t)&freertos_risc_v_trap_handler);

  // ----------------------------------------------------------
  // Peripheral setup
  // ----------------------------------------------------------

  // setup UART0 at default baud rate, no interrupts
  neorv32_uart_setup(UART_HW_HANDLE, UART_BAUD_RATE, 0);

  // ----------------------------------------------------------
  // Configuration checks
  // ----------------------------------------------------------

  // machine timer available?
  if (neorv32_mtime_available() == 0) {
    neorv32_uart_printf(UART_HW_HANDLE, "WARNING! MTIME machine timer not available!\n");
  }

  // general purpose timer available?
  if (neorv32_gptmr_available() == 0) {
    neorv32_uart_printf(UART_HW_HANDLE, "WARNING! GPTMR timer not available!\n");
  }

  // check heap size configuration
  uint32_t neorv32_max_heap = (uint32_t)&__crt0_max_heap;
  if ((uint32_t)&__crt0_max_heap != (uint32_t)configTOTAL_HEAP_SIZE){
    neorv32_uart_printf(UART_HW_HANDLE,
                        "WARNING! Incorrect 'configTOTAL_HEAP_SIZE' configuration!\n"
                        "FreeRTOS configTOTAL_HEAP_SIZE: %u bytes\n"
                        "NEORV32 makefile heap size:     %u bytes\n\n",
                        (uint32_t)configTOTAL_HEAP_SIZE, neorv32_max_heap);
  }

  // check clock frequency configuration
  uint32_t neorv32_clk_hz = (uint32_t)NEORV32_SYSINFO->CLK;
  if (neorv32_clk_hz != (uint32_t)configCPU_CLOCK_HZ) {
    neorv32_uart_printf(UART_HW_HANDLE,
                        "WARNING! Incorrect 'configCPU_CLOCK_HZ' configuration!\n"
                        "FreeRTOS configCPU_CLOCK_HZ: %u Hz\n"
                        "NEORV32 clock speed:         %u Hz\n\n",
                        (uint32_t)configCPU_CLOCK_HZ, neorv32_clk_hz);
  }
}


/******************************************************************************
 * Handle NEORV32-/application-specific interrupts.
 ******************************************************************************/
void freertos_risc_v_application_interrupt_handler(void) {

  // mcause identifies the cause of the interrupt
  uint32_t mcause = neorv32_cpu_csr_read(CSR_MCAUSE);

  if (mcause == GPTMR_TRAP_CODE) { // is GPTMR interrupt
    neorv32_gptmr_trigger_matched(); // clear GPTMR timer-match interrupt
    //neorv32_uart_printf(UART_HW_HANDLE, "GPTMR IRQ Tick\n");
  }
  else { // undefined interrupt cause
    neorv32_uart_printf(UART_HW_HANDLE, "\n<NEORV32-IRQ> Unexpected IRQ! cause=0x%x </NEORV32-IRQ>\n", mcause); // debug output
  }
}


/******************************************************************************
 * Handle NEORV32-/application-specific exceptions.
 ******************************************************************************/
void freertos_risc_v_application_exception_handler(void) {

  // mcause identifies the cause of the exception
  uint32_t mcause = neorv32_cpu_csr_read(CSR_MCAUSE);

  // mepc identifies the address of the exception
  uint32_t mepc = neorv32_cpu_csr_read(CSR_MEPC);

  // debug output
  neorv32_uart_printf(UART_HW_HANDLE, "\n<NEORV32-EXC> mcause = 0x%x @ mepc = 0x%x </NEORV32-EXC>\n", mcause,mepc); // debug output
}


/******************************************************************************
 * Assert terminator.
 ******************************************************************************/
void vAssertCalled(void) {

  int i;

	taskDISABLE_INTERRUPTS();

	/* Clear all LEDs */
  neorv32_gpio_port_set(0);

  neorv32_uart_puts(UART_HW_HANDLE, "FreeRTOS_FAULT: vAssertCalled called!\n");

	while(1) {
		for (i=0; i<(configCPU_CLOCK_HZ/100); i++) {
			__asm volatile( "nop" );
		}
		neorv32_gpio_pin_toggle(0);
		neorv32_gpio_pin_toggle(1);
	}
}

void vApplicationMallocFailedHook(void) {
	taskDISABLE_INTERRUPTS();

  neorv32_uart_puts(UART_HW_HANDLE,
                    "FreeRTOS_FAULT: vApplicationMallocFailedHook "
                    "(increase 'configTOTAL_HEAP_SIZE' in FreeRTOSConfig.h)\n");

	__asm volatile("ebreak"); // trigger context switch

	while(1);
}


/******************************************************************************
 * Hook for the idle process.
 ******************************************************************************/
void vApplicationIdleHook(void) {
  neorv32_cpu_sleep(); // cpu wakes up on any interrupt request
}


/******************************************************************************
 * Hook for task stack overflow.
 ******************************************************************************/
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName) {

	(void)pcTaskName;
	(void)pxTask;

	taskDISABLE_INTERRUPTS();

  neorv32_uart_printf(UART_HW_HANDLE,
                      "FreeRTOS_FAULT: vApplicationStackOverflowHook "
                      "(increase 'configISR_STACK_SIZE_WORDS' in FreeRTOSConfig.h)\n");

	__asm volatile("ebreak"); // trigger context switch

	while(1);
}


/******************************************************************************
 * Hook for the application tick (unused).
 ******************************************************************************/
void vApplicationTickHook(void) {

  __asm volatile( "nop" ); // nothing to do here yet
}
