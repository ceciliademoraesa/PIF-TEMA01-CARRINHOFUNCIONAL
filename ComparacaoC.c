#include <assert.h>
#include <math.h>
#include <stdio.h>

static double totalGlobal = 0.0;

static double acumularCarrinho(double precoA, int qtdA, double precoB, int qtdB) {
    totalGlobal += precoA * qtdA + precoB * qtdB;
    return totalGlobal;
}

static double totalPuro(double precoA, int qtdA, double precoB, int qtdB) {
    return precoA * qtdA + precoB * qtdB;
}

int main(void) {
    double primeiro = acumularCarrinho(25.0, 4, 120.0, 1);
    double segundo = acumularCarrinho(25.0, 4, 120.0, 1);
    double puro = totalPuro(25.0, 4, 120.0, 1);
    assert(fabs(primeiro - 220.0) < 1e-9);
    assert(fabs(segundo - 440.0) < 1e-9);
    assert(fabs(puro - 220.0) < 1e-9);
    printf("Funcao com estado: %.2f e %.2f\n", primeiro, segundo);
    printf("Funcao pura: %.2f\n", puro);
    return 0;
}
