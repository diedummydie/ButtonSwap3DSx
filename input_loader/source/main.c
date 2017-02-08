#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <3ds.h>

int main()
{
	gfxInitDefault();

	consoleInit(GFX_BOTTOM, NULL);

	u32 pid;

	nsInit();
<<<<<<< HEAD
	Result r = NS_LaunchTitle(0x0004000000123400LL, 3, &pid);
=======
	Result r = NS_LaunchTitle(0x40000096E7F00LL, 3, &pid);
>>>>>>> dfd6610787c1a128baa8b0c946f2adf359fbfdd8
	nsExit();
	if(r != 0)
	{
		printf("NS returned error %08lx\nPress Start to close.", r);
		// Main loop
		while (aptMainLoop())
		{
			gspWaitForVBlank();
			hidScanInput();

			u32 kDown = hidKeysDown();
			if (kDown & KEY_START)
				break; // break in order to return to hbmenu
					   // Flush and swap framebuffers
			gfxFlushBuffers();
			gfxSwapBuffers();
		}
	}

	// Exit services
	gfxExit();
	return 0;
}

