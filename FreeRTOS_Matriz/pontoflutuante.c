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

#include "pontoflutuante.h"
#include "matrix.h"

//CONVERTE UM NÚMERO REAL FLOAT PARA UM NÚMERO BINÁRIO DE 16 BITS.
uint16_t converteParaPontoFixo(float num){
    uint8_t inteiro8bits = (uint8_t)num;
    float flutuante = num - (float) inteiro8bits;
    
    uint8_t flutuante8bits = flutuanteParaBinario(flutuante);
    uint16_t pontoFixo = inteiro8bits;
    pontoFixo = (pontoFixo << 8) + flutuante8bits;
    return pontoFixo;
}

//CONVERTE UM NÚMERO BINÁRIO DE 32 BITS PARA UM NÚMERO REAL.
float converteParaFloat(uint32_t num){
    uint16_t inteiro = num >> 16;
    uint16_t flutuante16bits = num;
    float flutuante = binarioParaFlutuante(flutuante16bits);
    
    float resultado = (float)inteiro + flutuante;
    return resultado;
}


//CONVERTE A PARTE FRACIONÁRIA DE UM NÚMERO PARA UM BINÁRIO DE 8 BITS.
uint8_t flutuanteParaBinario(float flutuante){
    uint8_t resultado = 0;

    float valor = flutuante;
    
    for(int i = 0; i < 8; i++){
        resultado = resultado << 1;
        valor *=2;
        int inteiro = (int) valor;
        resultado += inteiro;
        valor = valor - (float) inteiro;
        
    }
    return resultado;
}

//CONVERTE UM NÚMERO BINÁRIO DE 16 BITS PARA A PARTE FLUTUANTE DE UM NÚMERO REAL.
float binarioParaFlutuante(uint16_t flutuante){
    float buffer = 0.5;
    uint16_t myByte = flutuante;
    float resultado = 0;

    for(int i = 0; i < 16; i++){
        uint16_t aux = myByte & 0b1000000000000000;
        aux = aux >> 15;
        resultado += aux * buffer;
        buffer /=2;
        myByte = myByte << 1;
    }   
    return resultado;
}

void multiplica_hardware(float **mat1, float **mat2, float **mat3) {
  controlPrint("Iniciando multiplicacao das matrizes %u e %u em HARDWARE...\n", mat1, mat2);
    uint16_t a, b;
    uint32_t valorReg;

  for(int i = 0; i < MAX_MATRIX; i++) {
    for (int j = 0; j < MAX_MATRIX; j++) {
      controlPrint("Multiplicando linha %d de A pela coluna %d de B...\n", i, j);
      mat3[i][j] = 0;
      for (int k = 0; k < MAX_MATRIX; k++) {
        if(k%NUM_REG_CFS == 0 && k!=0){
          mat3[i][j] = converteParaFloat(NEORV32_CFS->REG[63]);
        }

        NEORV32_CFS->REG[k%NUM_REG_CFS] = 0;
        a = converteParaPontoFixo(mat1[i][k]);
        b = converteParaPontoFixo(mat2[k][j]);
        valorReg = (a << 16) | b;
        
        NEORV32_CFS->REG[k%NUM_REG_CFS] = valorReg; 
      }  
      mat3[i][j] += converteParaFloat(NEORV32_CFS->REG[63]);
    }
  }
}

void print(const char * string, float valor){
  int inteiro = (int) valor;
  int fracionario = (int)((valor - (int) valor)*1000);
  myPrint("%s %u.%u", string, inteiro, fracionario);
}

void longPrint(const char * string, double valor){
  int inteiro = (int) valor;
  int fracionario = (int)((valor - (int) valor)*1000000000);
  myPrint("%s %u.%u", string, inteiro, fracionario);
}
