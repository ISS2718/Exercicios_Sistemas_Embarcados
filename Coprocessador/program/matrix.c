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

#include "matrix.h"
#include "pontoflutuante.h"

float ** criarMatrizFloat(int tam){
    controlPrint("Tentando criar uma matriz...!\n");
    float ** matriz = (float **) malloc(tam * sizeof(float*));
    if(matriz == NULL){
        controlPrint("criarMatrizFloat(): erro ao alocar memoria para matriz.\n");
        return NULL;
    }

    int i;
    for(i = 0; i < tam; i++){
        matriz[i] = (float *) malloc(tam * sizeof(float));
        if(matriz[i] == NULL){
            controlPrint("criarMatrizFloat(): erro ao alocar memoria para LINHA da matriz.\n");
            return NULL;
        }
    }
    controlPrint("Matriz %u criada!\n\n", matriz);
    return matriz;
}

uint32_t ** criarMatriz32Bits(int tam){
    uint32_t ** matriz = (uint32_t **) malloc(tam * sizeof(uint32_t*));
    if(matriz == NULL){
        controlPrint("criarMatriz32Bits(): erro ao alocar memoria para matriz.\n");
        return NULL;
    }

    int i;
    for(i = 0; i < tam; i++){
        matriz[i] = (uint32_t *) malloc(tam * sizeof(uint32_t));
        if(matriz[i] == NULL){
            controlPrint("criarMatriz32Bits(): erro ao alocar memoria para LINHA da matriz.\n");
            return NULL;
        }
    }
    controlPrint("Matriz %u criada!\n\n", matriz);
    return matriz;
}

void destruirMatrizFloat(float ** matriz, int tam){
    controlPrint("Destruindo matriz float %u... ", matriz);
    int i;
    for(i = 0; i < tam; i++)
        free(matriz[i]);
    free(matriz);
    if(PRINT_ACTIVATED) controlPrint("Destruida!\n\n");
}

void destruirMatriz32Bits(uint32_t ** matriz, int tam){
    controlPrint("Destruindo matriz de 32 bits %u... ", matriz);
    int i;
    for(i = 0; i < tam; i++)
        free(matriz[i]);
    free(matriz);
    controlPrint("Destruida!\n\n");
}

void instanciaMatrizAleatoriamente(float ** matriz, int tam){
    if(matriz == NULL || *matriz == NULL){
        controlPrint("instanciaMatrizAleatoriamente(): matriz vazia.\n");
        return;
    }

    controlPrint("Instanciando matriz %u...\n", matriz);

    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++)
            matriz[i][j] = (i*j+1)%255 + 0.1241*i + 0.421*j + ((int)matriz%255)*0.527;
    }   
    controlPrint("Matriz %u instanciada!\n", matriz); 
}

void instanciaMatrizIdentidade(float ** matriz, int tam){
    if(matriz == NULL || *matriz == NULL){
        controlPrint("instanciaMatrizAleatoriamente(): matriz vazia.\n");
        return;
    }

    controlPrint("Instanciando matriz %u...\n", matriz);

    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++){
            if(i == j) matriz[i][j] = 1;
            else matriz[i][j] = 0;
        }
    }   
    controlPrint("Matriz %u instanciada!\n", matriz); 
}

void instanciaMatrizUnitaria(float ** matriz, int tam){
    if(matriz == NULL || *matriz == NULL){
        controlPrint("instanciaMatrizAleatoriamente(): matriz vazia.\n");
        return;
    }

    controlPrint("Instanciando matriz %u...\n", matriz);

    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++)
            matriz[i][j] = 1;
    }   
    controlPrint("Matriz %u instanciada!\n", matriz); 
}

void imprimirMatrizFloat(float ** matriz, int tam){
    if(matriz == NULL || *matriz == NULL){
        myPrint("imprimirMatrizFloat(): matriz vazia.\n");
        return;
    }

    myPrint("Imprimindo matriz float %u...\n", matriz);

    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++)
            print("", matriz[i][j]);
        myPrint("\n");
    }  
    myPrint("\n");
}

void imprimirMatriz32Bits(uint32_t ** matriz, int tam){
    if(matriz == NULL || *matriz == NULL){
        myPrint("imprimirMatriz32Bits(): matriz vazia.\n");
        return;
    }

    myPrint("Imprimindo matriz de 32 bits %u...\n", matriz);

    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++)
            myPrint("%u ", matriz[i][j]);
        myPrint("\n");
    }  
    myPrint("\n");
}

float ** multiplicarMatriz(float ** matrizA, float ** matrizB, int tam){
    if(matrizA == NULL || *matrizA == NULL){
        controlPrint("multiplicarMatriz(): matriz A vazia.\n");
        return NULL;
    }

    if(matrizB == NULL || *matrizB == NULL){
        controlPrint("multiplicarMatriz(): matriz B vazia.\n");
        return NULL;
    }

    controlPrint("Iniciando multiplicacao das matrizes %u e %u em SOFTWARE...\n", matrizA, matrizB);

    float ** matrizResultante = criarMatrizFloat(tam);
    uint32_t ** matrizResultante32Bits = criarMatriz32Bits(tam);
    
    int i, j, k;
    uint16_t valorMatrizA, valorMatrizB;

    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++){
            matrizResultante[i][j] = 0.0;
            controlPrint("Multiplicando linha %d de A pela coluna %d de B...\n", i, j);
            for(k = 0; k < tam; k++){
                valorMatrizA = converteParaPontoFixo(matrizA[i][k]);
                valorMatrizB = converteParaPontoFixo(matrizB[k][j]);
                matrizResultante32Bits[i][j] += valorMatrizA * valorMatrizB;
                matrizResultante[i][j] += matrizA[i][k]*matrizB[k][j];
            }
        }
    }

    for(i = 0; i < tam; i++){
        for(j = 0; j < tam; j++){
            float valorMatrizResultante = converteParaFloat(matrizResultante32Bits[i][j]);
            matrizResultante[i][j] = valorMatrizResultante;
        }
    }

    destruirMatriz32Bits(matrizResultante32Bits, tam);
    return matrizResultante;
}