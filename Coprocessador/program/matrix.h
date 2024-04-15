/********************************************************************************
  MIT License

  Copyright (c) 2024 Daniel Contente, Hugo Nakamura, Isaac Soares, Mateus Messias. 

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
********************************************************************************/

#ifndef MATRIX_H
#define MATRIX_H

#include <neorv32.h>

#define MAX_MATRIX 40
#define NUM_REG_CFS 63
#define PRINT_ACTIVATED 0
#define myPrint neorv32_uart0_printf
#define controlPrint if(PRINT_ACTIVATED) myPrint 

float ** criarMatrizFloat(int tam);
uint32_t ** criarMatriz32Bits(int tam);
void destruirMatrizFloat(float ** matriz, int tam);
void destruirMatriz32Bits(uint32_t ** matriz, int tam);
void instanciaMatrizAleatoriamente(float ** matriz, int tam);
void instanciaMatrizIdentidade(float ** matriz, int tam);
void instanciaMatrizUnitaria(float ** matriz, int tam);
void imprimirMatrizFloat(float ** matriz, int tam);
void imprimirMatriz32Bits(uint32_t ** matriz, int tam);
float ** multiplicarMatriz(float ** matrizA, float ** matrizB, int tam);

#endif