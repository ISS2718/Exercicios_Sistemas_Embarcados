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

/* Standard includes. */
#include <string.h>
#include <unistd.h>

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "matrix.h"
#include "pontoflutuante.h"

typedef struct{
    uint32_t linha;
    uint32_t coluna;
} TaskArgs;

float ** matrix1, ** matrix2, ** matrix3;
int liberaPrint = 0;

TaskArgs args[MAX_MATRIX*MAX_MATRIX];

int8_t mutex = 0;

uint64_t t_inicio, t_fim;

/*-----------------------------------------------------------*/

/**
 * Called by main when mainCREATE_SIMPLE_BLINKY_DEMO_ONLY is set to 1 in
 * main.c.
 */
void matrix_tasks( void );

/**
 * The tasks as described in the comments at the top of this file.
 */
static void imprimeMatrizResultante(void * sacanagem);
static void multiplicaLinhaColuna(void * args);

void matrix_tasks(void) {
    matrix1 = criarMatrizFloat(MAX_MATRIX);
    instanciaMatrizUnitaria(matrix1, MAX_MATRIX );
    imprimirMatrizFloat(matrix1, MAX_MATRIX);
    
    matrix2 = criarMatrizFloat(MAX_MATRIX);
    instanciaMatrizIdentidade(matrix2, MAX_MATRIX);
    imprimirMatrizFloat(matrix2, MAX_MATRIX);

    matrix3 = criarMatrizFloat(MAX_MATRIX);
    for (uint32_t i = 0; i < MAX_MATRIX; i++) {
        for (uint32_t j = 0; j < MAX_MATRIX; j++) {
            matrix3[i][j] = 0;
        }
    }
    

    for(uint32_t i = 0; i < MAX_MATRIX; i++){
        for(uint32_t j = 0; j < MAX_MATRIX; j++){
            args[(i*MAX_MATRIX) + j].linha = i;
            args[(i*MAX_MATRIX) + j].coluna = j;
            xTaskCreate(multiplicaLinhaColuna, "Linha x Coluna", configMINIMAL_STACK_SIZE, &args[(i*MAX_MATRIX)+j], 0, NULL);
        }
    }
    xTaskCreate(imprimeMatrizResultante, "Print Resultado", configMINIMAL_STACK_SIZE, NULL, 0, NULL);
    t_inicio = neorv32_mtime_get_time();
    vTaskStartScheduler();

    while(1){
        myPrint("ERRO: memória heap insuficiente!\n");
    };
}

static void multiplicaLinhaColuna(void * args){
    uint32_t linha = ((TaskArgs*)args)->linha;
    uint32_t coluna = ((TaskArgs*)args)->coluna;

    for(uint32_t k = 0; k < MAX_MATRIX; k++) {
        matrix3[linha][coluna] += matrix1[linha][k] * matrix2[k][coluna];
    }

    //região crítica...
    while (mutex);
    mutex = 1;
        liberaPrint++;
    mutex = 0;

    vTaskDelete(NULL);
}

static void imprimeMatrizResultante(void * sacanagem){
    (void) sacanagem;
    while(liberaPrint < MAX_MATRIX * MAX_MATRIX);
    t_fim = neorv32_mtime_get_time();
    imprimirMatrizFloat(matrix3, MAX_MATRIX);
    longPrint("TEMPO HARDWARE: ", ((double)(t_fim - t_inicio))/50000000);
    vTaskDelete(NULL);
}