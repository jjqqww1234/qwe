// EnDecode.cpp : Defines the entry point for the DLL application.
//


#include "endecode.h"

BYTE cTable_src[256] = {
 27, 117,  25,  77,  99,  60, 239, 171,  15,  33,  87, 160,   1,  18, 114,  26,
218,  78, 243, 108, 254, 237,  42,   3, 236, 245, 178,  48, 110, 124,  23, 196,
 88, 104,  90,  11, 111, 235,  68, 241, 118,   6, 129, 125, 220,  41, 250, 140,
244, 100,  16, 149, 226, 189, 112, 133, 223, 240, 229,  58, 165,  72,  91,  93,
  9, 197,  34, 173, 174, 230, 208, 253,   8,  55,   2,  92, 143, 234,  84, 154,
204,  63,  32,  61,  64, 119, 180, 153, 138, 103, 201, 205,  59,  17, 221,  10,
 36, 113, 225,  82, 161,  70, 216, 146, 139, 232, 107,  66, 109, 252, 202, 145,
192,  81, 134,  96, 251, 181, 184,  69, 182, 214,  49, 198, 156, 147,  86, 219,
246,   5,  31, 167,  71, 248, 128, 121, 102, 162, 168, 227,  50,  14,   0, 238,
 56,  79,   4,  35, 212,  44, 222, 137, 175, 169,  98, 255, 209, 185, 155,  40,
135,  62, 127, 150, 152,  74,  97,  38, 159, 157, 120,  75, 210, 106, 200,  53,
148,  80, 179,  94,  22, 122, 228, 233,  39, 151,  47, 206, 101, 191, 231,  57,
126, 142,  76,  37, 187, 224,  29,  51, 215, 242, 141, 136, 183,  46, 144, 105,
123, 131, 130, 172,  54,  89,  21, 247,   7, 166,  28, 177, 163,  13,  43, 186,
164, 188, 211,  30,  24,  83, 115, 176,  19,  52, 170,  65, 207, 193,  67,  20,
217,  45, 213, 199,  95,  85, 194,  73, 116, 158, 203, 132, 249, 190, 195,  12
};

BYTE dTable_src[256] = {
160,  89,  12, 213, 208, 108,   7,  90, 215, 174, 197,  78,  99, 172, 196,   8,
 21, 112,  14,  36, 167, 137, 183,  70,  60,  15, 152,  80, 226,  51,  50,  38,
114, 126, 113, 255, 166, 207,  82, 131, 186,  42,  85, 243, 194,  95,  84,  62,
242, 169, 161, 132,  93, 138, 248, 245,  68,  66, 103,  58, 203,  25,  92,  26,
 46,  33,  74, 218,  43,  91,  10, 117, 238,  83,  87, 170,   0,  17, 105, 101,
 88,  19,  27, 235, 252, 232,   6, 102, 236, 139,  81, 146, 182, 178, 240,  47,
234,  49, 190, 115,  48, 241, 173, 247, 116, 244, 171,  30, 251, 205,  41,  73,
  2, 100, 221, 162,  45, 163, 214, 164,  20,  67,  53,  18, 157,  96,  69, 193,
 44, 155, 129, 120,  34, 199, 176,  13,  59, 185, 198,  76,  29, 122, 144, 239,
209, 123,  28, 118, 211,  56, 127, 230, 195, 210, 217,  16,  64,  55,  75, 220,
148,  86,  77, 225, 219,  39, 121, 227, 177,  71,  61, 202, 191,  31, 141,  57,
140, 206, 135, 147, 254,   4, 109, 179,  54, 107, 233, 212, 237,  63, 250, 201,
187, 165, 133,   1, 192, 253,  22, 125,  23, 228, 204, 184, 154, 222, 110,  40,
246,  94, 104, 200, 136, 134,  37,  79,   3,   5,  98,  65,  72,  52, 130,  24,
249,   9, 124, 145, 153, 159, 188, 156,  32, 111, 231,  97, 175, 119, 181, 142,
151, 224, 106, 223, 158,  11, 180, 229, 143,  35, 149, 168, 189, 216, 150, 128
};

BYTE cTable_return[256] = {
141, 151,   7, 132,  73,  83,  91, 250, 156, 205, 157,  72, 170, 123,  99, 144,
148,  70,   3, 207, 229, 230,  30, 178, 120, 245, 254,  27,  92, 108, 163, 255,
248,  76,  65,  98, 134,  46, 239, 211, 137, 201,   1, 213, 240, 235, 169,  66,
183, 237,   8, 212, 232, 189,  80,  63, 172, 112, 119, 231,  51, 222, 173, 190,
252,  77, 198, 160, 214, 152, 168, 114,  12, 162, 106,  24,  75,  36, 196,  82,
199,  79, 117,  43, 202, 194, 217,  68, 216, 143, 111, 100, 206,  90, 110, 154,
227, 180,  45,   4,  38, 253,  19,  13, 175,  32, 115,  89,  64,  26, 200, 177,
138, 113,  14, 130, 191,   0,  86, 241,  50, 187,  33,  44,  17, 121, 131,  93,
 42, 128, 226, 219, 220,  57, 105,   6, 182, 215, 242, 238,  52,  59,  54, 208,
236,  29, 181, 166,  35, 126,  56, 186,  60, 185, 233, 203,  23, 107, 116, 124,
125, 224, 155, 221, 243, 184,  78,  47, 101, 149, 103,  49, 104,  15, 139, 164,
140, 147, 247,  84, 167, 118,  61, 102, 142, 249, 197, 161, 234,  34,  25, 171,
 62,  74, 193, 122, 209,  87,  69, 133, 192, 135,  11, 127,  10,  22, 225,  20,
176,  81,  67,  18, 218,  95, 223,  96, 165,  37,  55, 246, 159, 145, 195,   9,
 97,  28,  53, 204, 210,  58,  85,   2, 150, 244,  31,  41, 228, 129, 179, 158,
109, 188, 136,   5,  48, 174, 146,  71,  16,  40,  88,  39,  94, 153, 251,  21
};

BYTE dTable_return[256] = {
196, 202, 206, 148, 135, 111, 215, 186, 209, 192,  72, 211, 181, 248, 208,  46,
134, 225, 246,   7,  19, 234, 182, 203, 204, 219, 154, 132, 109,   1,  33, 224,
 34, 104, 218, 194, 131, 105, 156, 178, 152,  86, 200, 210, 244,  28, 189, 255,
 32,  16, 245,  67,  65,  71,   6,  52, 216,  61,  82,  57,  94, 127,   5, 207,
 60,  66,  55, 143, 160, 173, 164,  48, 199, 249,  70, 171, 144, 119, 174, 201,
177, 190,  62,  58, 172,  24,  75, 240,  17, 133,  89, 254,   8, 159, 139, 231,
 83, 228,   3,  93,  31,   4,  81, 106,  23, 128, 241,  96,  88, 138, 212,   2,
222, 163, 195, 253, 147,  40, 151, 197, 187, 124, 136, 108, 103,  84, 142,  97,
252, 242,  36,  76, 101,  79, 121, 175, 153,  95, 184, 166, 102,  11,   9, 235,
 50,  98, 237, 129, 236,  68, 247, 120,  45,  38, 179,  54, 193, 114, 213,  59,
169, 140,  78, 233,  41,  42,  85,  80, 137,  27, 158,  44, 188,  15, 155, 161,
145,  43, 226,  39, 205, 176, 117, 220, 107, 116,  64, 180, 112,  29,  90, 251,
126, 149,  30,  26, 125,  18, 110,  47,  25, 229,   0,  10, 113,  51,  53, 100,
157,  35,  74,  12,  77,  13, 239, 168, 227,  63, 150, 191, 170, 118,  91, 232,
217, 167, 115,  92,  87,  20,  22,  37, 162,  21, 243, 214, 165, 185, 146, 183,
 14,  99, 123,  69,  56, 238, 223,  73, 221, 250, 130,  49, 141, 198, 122, 230
};

const BYTE cXorValue = 0x4D;

const WORD g_EndeKey = 0xA52E;

// 치환 테이블 인코딩 값
const BYTE g_HideTable = 0x97;
// 역치환 테이블 인코딩 값
const BYTE g_HideBackTable = 0x34;
#define _NEWENCMODE			0
//--------------------------


static unsigned char Decode6BitMask[5] = { 0xfc, 0xf8, 0xf0, 0xe0, 0xc0 };


/* **************************************************************************************

		Encode/Decode Routine for ANSI character

   ************************************************************************************** */
int WINAPI fnEncode6BitBuf(unsigned char *pszSrc, char *pszDest, int nSrcLen, int nDestLen)
{
	int				nDestPos	= 0;
	int				nRestCount	= 0;
	unsigned char	chMade = 0, chRest = 0;
	unsigned char	ch1 =0;

	for (int i = 0; i < nSrcLen; i++)
	{
		if (nDestPos >= nDestLen) break;

#ifdef _NEWENCMODE
		//---------------------------------------------------------------------
		// 치환
		ch1 = pszSrc[i];

		__asm {
			push edx
			mov dl , ch1
			rol	dl , 3
			mov ch1 , dl
			pop edx
		}

		ch1 = (unsigned char)(( cTable_src[ ch1 ] ^ g_HideTable ) ^ cXorValue);   // added by sonmg

		// XOR 연산
		pszSrc[i] = (unsigned char)(ch1 ^ ( HIBYTE(g_EndeKey) + LOBYTE(g_EndeKey) ));   // added by sonmg
		//---------------------------------------------------------------------
#endif

		chMade = (unsigned char)((chRest | (pszSrc[i] >> (2 + nRestCount))) & 0x3f);
		chRest = (unsigned char)(((pszSrc[i] << (8 - (2 + nRestCount))) >> 2) & 0x3f);

		nRestCount += 2;

		if (nRestCount < 6)
			pszDest[nDestPos++] = (char)(chMade + 0x3c);
		else
		{
			if (nDestPos < nDestLen - 1)
			{
				pszDest[nDestPos++]	= (char)(chMade + 0x3c);
				pszDest[nDestPos++]	= (char)(chRest + 0x3c);
			}
			else
				pszDest[nDestPos++] = (char)(chMade + 0x3c);

			nRestCount	= 0;
			chRest		= 0;
		}
	}

	if (nRestCount > 0)
		pszDest[nDestPos++] = (char)(chRest + 0x3c);

//	pszDest[nDestPos] = '\0';

	return nDestPos;
}

int  WINAPI fnDecode6BitBuf(char *pszSrc, char *pszDest, int nDestLen)
{
	int				nLen = strlen((const char *)pszSrc);
	int				nDestPos = 0, nBitPos = 2;
	int				nMadeBit = 0;
	unsigned char	ch, chCode, tmp = 0;

	for (int i = 0; i < nLen; i++)
	{
		if ( ((pszSrc[i] - 0x3c) >= 0) && ((pszSrc[i] - 0x3c) <= 64) )
			ch = (unsigned char)(pszSrc[i] - 0x3c);
		else
		{
			nDestPos = 0;
			break;
		}

		if (nDestPos >= nDestLen) break;

		if ((nMadeBit + 6) >= 8)
		{
			chCode = (unsigned char)(tmp | ((ch & 0x3f) >> (6 - nBitPos)));

#ifdef _NEWENCMODE
			//---------------------------------------------------------------------
			// XOR 연산
			chCode = chCode ^ (unsigned char)( HIBYTE(g_EndeKey) + LOBYTE(g_EndeKey) );   // added by sonmg

			// 역치환
			chCode = chCode ^ cXorValue;   // added by sonmg
			chCode = (unsigned char)(cTable_return[ chCode ] ^ g_HideBackTable);   // added by sonmg

			__asm {
				push edx
				mov dl , chCode
				ror	dl , 3
				mov chCode , dl
				pop edx
			}
			//---------------------------------------------------------------------
#endif

			pszDest[nDestPos++] = chCode;

			nMadeBit = 0;

			if (nBitPos < 6) 
				nBitPos += 2;
			else
			{
				nBitPos = 2;
				continue;
			}
		}

		tmp = (unsigned char)((ch << nBitPos) & Decode6BitMask[nBitPos - 2]);

		nMadeBit += (8 - nBitPos);
	}

//	pszDest[nDestPos] = '\0';

	return nDestPos;
}

int WINAPI fnEncode6BitBuf_old(unsigned char *pszSrc, char *pszDest, int nSrcLen, int nDestLen)
{
	int				nDestPos	= 0;
	int				nRestCount	= 0;
	unsigned char	chMade = 0, chRest = 0;

	for (int i = 0; i < nSrcLen; i++)
	{
		if (nDestPos >= nDestLen) break;
		
		chMade = (unsigned char)((chRest | (pszSrc[i] >> (2 + nRestCount))) & 0x3f);
		chRest = (unsigned char)(((pszSrc[i] << (8 - (2 + nRestCount))) >> 2) & 0x3f);

		nRestCount += 2;

		if (nRestCount < 6)
			pszDest[nDestPos++] = (char)(chMade + 0x3c);
		else
		{
			if (nDestPos < nDestLen - 1)
			{
				pszDest[nDestPos++]	= (char)(chMade + 0x3c);
				pszDest[nDestPos++]	= (char)(chRest + 0x3c);
			}
			else
				pszDest[nDestPos++] = (char)(chMade + 0x3c);

			nRestCount	= 0;
			chRest		= 0;
		}
	}

	if (nRestCount > 0)
		pszDest[nDestPos++] = (char)(chRest + 0x3c);

//	pszDest[nDestPos] = '\0';

	return nDestPos;
}

int  WINAPI fnDecode6BitBuf_old(char *pszSrc, char *pszDest, int nDestLen)
{
	int				nLen = strlen((const char *)pszSrc);
	int				nDestPos = 0, nBitPos = 2;
	int				nMadeBit = 0;
	unsigned char	ch, chCode, tmp = 0;

	for (int i = 0; i < nLen; i++)
	{
		if ((pszSrc[i] - 0x3c) >= 0)
			ch = (unsigned char)(pszSrc[i] - 0x3c);
		else
		{
			nDestPos = 0;
			break;
		}

		if (nDestPos >= nDestLen) break;

		if ((nMadeBit + 6) >= 8)
		{
			chCode = (unsigned char)(tmp | ((ch & 0x3f) >> (6 - nBitPos)));
			pszDest[nDestPos++] = chCode;

			nMadeBit = 0;

			if (nBitPos < 6) 
				nBitPos += 2;
			else
			{
				nBitPos = 2;
				continue;
			}
		}

		tmp = (unsigned char)((ch << nBitPos) & Decode6BitMask[nBitPos - 2]);

		nMadeBit += (8 - nBitPos);
	}

//	pszDest[nDestPos] = '\0';

	return nDestPos;
}

int WINAPI fnEncodeMessage(_LPTDEFAULTMESSAGE lptdm, char *pszBuf, int nLen)
{ 
	return fnEncode6BitBuf((unsigned char *)lptdm, pszBuf, sizeof(_TDEFAULTMESSAGE), nLen); 
}


CDecodedString * WINAPI fnDecodeString( char *src )
{
	int destLen = int( (strlen( src )) * 3 / 4 ) + 2;

	CDecodedString *d = new CDecodedString( destLen );
	d->m_pData[ fnDecode6BitBuf( src, d->m_pData, destLen ) ] = '\0';

	return d;
}

void ChangeSpaceToNull(char *pszData)
{
	char *pszCheck = pszData;

	if (pszCheck)
	{
		while (*pszCheck)
		{
			if (*pszCheck == 0x20 && *(pszCheck + 1) == 0x20)
			{
				*pszCheck = '\0';
				return;
			}

			pszCheck++;
		}
	}
}

