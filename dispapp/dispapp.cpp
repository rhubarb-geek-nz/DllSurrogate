/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

#include <objbase.h>
#include <stdio.h>
#include <displib_h.h>

int main(int argc, char** argv)
{
	HRESULT hr = CoInitializeEx(NULL, COINIT_MULTITHREADED);

	if (SUCCEEDED(hr))
	{
		DWORD ctx[] = { CLSCTX_LOCAL_SERVER, CLSCTX_INPROC_SERVER };
		int i = 0;

		while (i < sizeof(ctx) / sizeof(ctx[0]))
		{
			IHelloWorld* helloWorld = NULL;

			hr = CoCreateInstance(CLSID_CHelloWorld, NULL, ctx[i], IID_IHelloWorld, (void**)&helloWorld);

			if (SUCCEEDED(hr))
			{
				int hint = 1;

				while (hint < 6)
				{
					BSTR result = NULL;

					hr = helloWorld->GetMessage(hint, &result);

					if (SUCCEEDED(hr))
					{
						printf("%08lx - %S\n", ctx[i], result);

						if (result)
						{
							SysFreeString(result);
						}
					}
					else
					{
						break;
					}

					hint++;
				}

				helloWorld->Release();
			}

			if (FAILED(hr))
			{
				fprintf(stderr, "%08lx - 0x%lx\n", ctx[i], (long)hr);
			}

			i++;
		}

		CoUninitialize();
	}

	return FAILED(hr);
}
