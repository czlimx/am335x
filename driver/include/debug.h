#ifndef DEBUG_H_
#define DEBUG_H_

/* SSDK debug level */
#define SSDK_EMERG     0  /* System is unusable */
#define SSDK_ALERT     1  /* Action must be taken immediately */
#define SSDK_CRIT      2  /* Critical conditions */
#define SSDK_ERR       3  /* Error conditions */
#define SSDK_WARNING   4  /* Warning conditions */
#define SSDK_NOTICE    5  /* Normal, but significant, condition */
#define SSDK_INFO      6  /* Informational message */
#define SSDK_DEBUG     7  /* Debug-level message */

/* SSDK printf */
#if CONFIG_DEBUG
#if CONFIG_PRINTF_LIB
#include <stdio.h>
#else
#define printf(x...)
#endif
#define ssdk_printf(level, x...)    do { if ((level) <= CONFIG_DEBUG_LEVEL) {printf(x); } } while (0)
#define PANIC()         ssdk_panic((const uint8_t *)__FILE__, (int)__LINE__)
#define ASSERT(x)       do { if (!(x)) PANIC(); } while (0)

static void ssdk_panic(const uint8_t *filename, int linenum)
{
    ssdk_printf(SSDK_EMERG, "Assertion failed at file:%s line: %d\n",
                filename, linenum);
    __BKPT;
    for(;;);
}

#else
#define ssdk_printf(level, x...)
#define PANIC()
#define ASSERT(x)
#define hexdump(ptr, len)
#define hexdump8_ex(ptr, len, disp_addr)
#endif

#endif // !DEBUG_H_
