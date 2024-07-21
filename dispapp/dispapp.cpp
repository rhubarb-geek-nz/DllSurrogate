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
		BSTR app = SysAllocString(L"RhubarbGeekNz.DllSurrogate");
		CLSID clsid;

		hr = CLSIDFromProgID(app, &clsid);

		SysFreeString(app);

		if (SUCCEEDED(hr))
		{
			DWORD ctx[] = { CLSCTX_LOCAL_SERVER, CLSCTX_INPROC_SERVER };
			int i = 0;

			while (i < sizeof(ctx) / sizeof(ctx[0]))
			{
				IHelloWorld* helloWorld = NULL;

				hr = CoCreateInstance(clsid, NULL, ctx[i], IID_IHelloWorld, (void**)&helloWorld);

				if (SUCCEEDED(hr))
				{
					BSTR result = NULL;
					int hint = argc > 1 ? atoi(argv[1]) : 1;

					hr = helloWorld->GetMessage(hint, &result);

					if (SUCCEEDED(hr))
					{
						printf("%08lx - %S\n", ctx[i], result);

						if (result)
						{
							SysFreeString(result);
						}
					}

					helloWorld->Release();
				}

				if (FAILED(hr))
				{
					fprintf(stderr, "%08lx - 0x%lx\n", ctx[i], (long)hr);
				}

				i++;
			}
		}

		CoUninitialize();
	}

	return FAILED(hr);
}
