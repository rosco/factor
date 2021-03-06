#include <sys/ucontext.h>

namespace factor
{

/* Fault handler information.  MacOSX version.
Copyright (C) 1993-1999, 2002-2003  Bruno Haible <clisp.org at bruno>
Copyright (C) 2003  Paolo Bonzini <gnu.org at bonzini>

Used under BSD license with permission from Paolo Bonzini and Bruno Haible,
2005-03-10:

http://sourceforge.net/mailarchive/message.php?msg_name=200503102200.32002.bruno%40clisp.org

Modified for Factor by Slava Pestov */
#define FRAME_RETURN_ADDRESS(frame) *((void **)(frame_successor(frame) + 1) + 2)

#define MACH_EXC_STATE_TYPE ppc_exception_state_t
#define MACH_EXC_STATE_FLAVOR PPC_EXCEPTION_STATE
#define MACH_EXC_STATE_COUNT PPC_EXCEPTION_STATE_COUNT
#define MACH_EXC_INTEGER_DIV EXC_PPC_ZERO_DIVIDE
#define MACH_THREAD_STATE_TYPE ppc_thread_state_t
#define MACH_THREAD_STATE_FLAVOR PPC_THREAD_STATE
#define MACH_THREAD_STATE_COUNT PPC_THREAD_STATE_COUNT

#if __DARWIN_UNIX03
	#define MACH_EXC_STATE_FAULT(exc_state) (exc_state)->__dar
	#define MACH_STACK_POINTER(thr_state) (thr_state)->__r1
	#define MACH_PROGRAM_COUNTER(thr_state) (thr_state)->__srr0
	#define UAP_PROGRAM_COUNTER(ucontext) \
		MACH_PROGRAM_COUNTER(&(((ucontext_t *)(ucontext))->uc_mcontext->__ss))
#else
	#define MACH_EXC_STATE_FAULT(exc_state) (exc_state)->dar
	#define MACH_STACK_POINTER(thr_state) (thr_state)->r1
	#define MACH_PROGRAM_COUNTER(thr_state) (thr_state)->srr0
	#define UAP_PROGRAM_COUNTER(ucontext) \
		MACH_PROGRAM_COUNTER(&(((ucontext_t *)(ucontext))->uc_mcontext->ss))
#endif

inline static cell fix_stack_pointer(cell sp)
{
	return sp;
}

}
