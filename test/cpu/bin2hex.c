#include <stdio.h>

int main(int argc, char const *argv[])
{
    if (argc != 3)
    {
        printf("Usage: %s <binfile> <hexfile>\n", argv[0]);
        return 1;
    }

    FILE *fBin = fopen(argv[1], "rb");
    if (!fBin)
    {
        printf("%s not exist\n", argv[1]);
        return 1;
    }

    FILE *fHex = fopen(argv[2], "w");
    if (!fHex)
    {
        printf("%s create with error\n", argv[1]);
        fclose(fBin);
        return 1;
    }

    __uint8_t instruction = 0;
    int n = 1;
    while (1)
    {
        fread(&instruction, sizeof(instruction), 1, fBin);
        if (feof(fBin))
            break;
        fprintf(fHex, "%02X", instruction);
        if (n % 4 == 0)
            fprintf(fHex, "\n");

        n++;
    }

    fclose(fBin);
    fclose(fHex);

    return 0;
}
