%{
	int charCount = 0;
	int wordCount = 0;
	int numCount = 0;
	int mayusCount = 0;
	int minusCount = 0;
	int mixCount = 0;
	int sentenceCount = 0;
	int inSentence = 0;
%}

delim 	[ \t\n]+
mayus 	[A-Z]+
minus 	[a-z]+
num 	[0-9]+
word	[^ \t\n.]+
eos 	[.]

%%
{delim} {}

{mayus} {
	wordCount++;
	charCount += yyleng;
	mayusCount++;
	inSentence = 1;
}

{minus} {
	wordCount++;
	charCount += yyleng;
	minusCount++;
	inSentence = 1;
}

{num} {
	wordCount++;
	charCount += yyleng;
	numCount++;
	inSentence = 1;
}

{word} {
	wordCount++;
	mixCount++;
	charCount += yyleng;
	inSentence = 1;
}

{eos} {
	charCount++;
	if (inSentence) {
		sentenceCount++;
		inSentence = 0;
	}
}
%%

int main()
{
	yylex();

	printf("No. caracteres:\t%d\n", charCount);
	printf("No. palabras:\t%d\n", wordCount);
	printf("No. mixtas:\t%d\n", mixCount);
	printf("No. mayúsculas:\t%d\n", mayusCount);
	printf("No. minúsculas:\t%d\n", minusCount);
	printf("No. numéricas:\t%d\n", numCount);
	printf("No. frases:\t%d\n", sentenceCount);

	return 0;
}
