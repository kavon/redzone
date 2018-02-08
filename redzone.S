
#ifdef __linux__
  #define GSYM(X) X
#else
  #define GSYM(X) _ ## X
#endif

#define WORDS	2048
#define SPIN	20000
#define STOP	100000

	.text
	.p2align 3
	.globl	GSYM(testRedZone)
GSYM(testRedZone):
	subq 	$4, %rsp	// make some headroom so we don't overwrite ret addr

	movq 	%rsp, %rdi
	movq	$WORDS, %rsi
overwrite:
	movl	$0, (%rdi)
	subq	$4, %rdi
	decq	%rsi
	cmpq	$0, %rsi
	jne		overwrite

	// now we wait for the OS to preempt
	movq	$STOP, %rcx
waitLp:
	movq	$SPIN, %rdi
spin:
	pause
	pause
	pause
	pause
	decq	%rdi
	cmpq	$0, %rdi
	jne		spin

check:
	movq 	%rsp, %rdi
	movq	$WORDS, %rsi
readNext:
	movl	(%rdi), %edx
	cmpl	$0, %edx
	jne 	error

	subq	$4, %rdi
	decq	%rsi
	cmpq	$0, %rsi
	jne		readNext
	
	decq	%rcx
	cmpq	$0, %rcx
	je		done
	jmp		waitLp			// nothing bad was seen. wait some more.

error:						// return and report!
	movl	%edx, %eax
	jmp 	goBack

done:
	movl	$0, %eax
	jmp 	goBack

goBack:
	addq	$4, %rsp
	retq



