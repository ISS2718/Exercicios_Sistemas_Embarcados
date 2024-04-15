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

#include <neorv32.h>
#include "./matrix.h"
#include "./pontoflutuante.h"

#define BAUD_RATE 19200 //UART BAUD RATE


int main() {
  float ** matrizA = criarMatrizFloat(MAX_MATRIX);
  instanciaMatrizIdentidade(matrizA, MAX_MATRIX);

  float ** matrizB = criarMatrizFloat(MAX_MATRIX);
  instanciaMatrizUnitaria(matrizB, MAX_MATRIX);

  uint64_t inicio = neorv32_mtime_get_time();

  float ** matrizC = multiplicarMatriz(matrizA, matrizB, MAX_MATRIX);

  uint64_t tempo  = neorv32_mtime_get_time() - inicio;

  longPrint("TEMPO SOFTWARE: ", ((double)tempo)/50000000);
  myPrint("\n");
  
  destruirMatrizFloat(matrizA, MAX_MATRIX);
  destruirMatrizFloat(matrizB, MAX_MATRIX);
  destruirMatrizFloat(matrizC, MAX_MATRIX);

//------------------------------------------------------------

  float **mat1, **mat2, **mat3;
  
  mat1 = criarMatrizFloat(MAX_MATRIX);
  mat2 = criarMatrizFloat(MAX_MATRIX);
  mat3 = criarMatrizFloat(MAX_MATRIX);

  instanciaMatrizIdentidade(mat1, MAX_MATRIX);
  instanciaMatrizUnitaria(mat2, MAX_MATRIX);
  
  inicio = neorv32_mtime_get_time();
  multiplica_hardware(mat1, mat2, mat3);
  tempo = neorv32_mtime_get_time() - inicio;

  imprimirMatrizFloat(mat3, MAX_MATRIX);

  longPrint("TEMPO HARDWARE: ", ((double)tempo)/50000000);
  myPrint("\n");
  
  destruirMatrizFloat(mat1, MAX_MATRIX);
  destruirMatrizFloat(mat2, MAX_MATRIX);
  destruirMatrizFloat(mat3, MAX_MATRIX);

  myPrint("\n");
  myPrint("Fim do programa! :)");

  return 0;
}