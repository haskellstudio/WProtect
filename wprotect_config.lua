-- op1_type op2_type op3_type 字符串形式 有IMM REG MEM
-- 当操作数为MEM时 有 BASE1 INDEX1 SCALE1 LVAL1   1只是表示操作数为1 还是2 或者是3
-- 当操作数为REG时 有REG一个变量
-- 当操作数为IMM时 有IMM一个变量
-- Assemble 是最主要的函数  参数为一个字符串  就是代码

function rand_get_register()
    local r = Rand()%8
	if r == 0 then
	    return "eax"
	elseif r == 1 then
	    return "ecx"
	elseif r == 2 then
	    return "ebx"
	elseif r == 3 then
	    return "edx"
	elseif r == 4 then
	    return "esp"
	elseif r == 5 then
	    return "ebp"
	elseif r == 6 then 
	    return "esi"
	elseif r == 7 then
	    return "edi"
	end
end

function add_stack_trash()
    local stack_count = 0; 
	return function()
	local r = Rand()%4
	if r == 0 then
	    Assemble ("push " .. rand_get_register())
		stack_count = stack_count + 4;
	elseif r == 1 then
	    Assemble ("pushad")
		stack_count = stack_count + 32;
	elseif r == 2 then
	    rs = Rand () % 15;
		stack_count = stack_count + rs
		Assemble ("lea esp,[esp-".. string.format("0%x",rs) .. "]")
    elseif r == 3 then
	    Assemble ("pushfd")
		stack_count = stack_count + 4
	end
	return stack_count
	end
end

function trash_generate ()
    local t_f = add_stack_trash() 
	local r = Rand()%10
	local stack_trash = 0
    for i=1,r 
	do
	    stack_trash = t_f()
	end
	return stack_trash
end

function save_context()
    local a = Assemble;
	--a ("pushad")
	stack_diff = trash_generate()
    print ("stack diff:" .. stack_diff)
	a ("pushad ")
	
	GoodRegister = {
	eax = stack_diff + 4 ,    --栈底开始
	ecx = stack_diff + 8 ,
	edx = stack_diff + 12,
	ebx = stack_diff + 16,
	esp = stack_diff + 20,
	ebp = stack_diff + 24,
	esi = stack_diff + 28,
	edi = stack_diff + 32,
        ax = stack_diff + 4 ,    --栈底开始
	cx = stack_diff + 8 ,
	dx = stack_diff + 12,
	bx = stack_diff + 16,
	sp = stack_diff + 20,
	bp = stack_diff + 24,
	si = stack_diff + 28,
	di = stack_diff + 32,
	al = stack_diff + 4 ,    --栈底开始
	ah = stack_diff + 5 ,
	cl = stack_diff + 8 ,
	ch = stack_diff + 9 ,
	dl = stack_diff + 12 ,
	dh = stack_diff + 13 ,
	bl = stack_diff + 16 ,
	bh = stack_diff + 17 
	}       
	stack_diff = stack_diff + 32
	print ("stack diff+context:" .. stack_diff)
	stack_diff = trash_generate() + stack_diff
	print ("stack diff" .. stack_diff)
	return stack_diff
end

function get_register(Register)
      if Register ~= "" then  
      return ("dword ptr[esp+" .. string.format("0%x",(stack_diff - GoodRegister[Register])) .. "]") 
      else 
      return "";
      end
end

function renew_context()
     for k,v in pairs (GoodRegister) do
         if k ~= "esp" then
		    if get_register_size (k) == 32 then
            Assemble("mov ".. k .. "," .. get_register(k))
			end
         end
     end
     Assemble ("lea esp,[esp+" .. string.format("0%x",stack_diff) .. "]")
end

function rand_get_invalid_register(lock)
    local r = rand_get_register ()
    local b = true;
    while b do
      b = false
      for k,v in pairs (lock) do
--	    print ("invalid:" .. v)
        if r == v then
		   r = rand_get_register ()
           b = true
           break
        end
      end
    end
	return r
end

function get_mem_code(base,index,scale,lval,lock_r)
   local mem_code = ""
   if SIZE == 8 then
       mem_code = "byte ptr["
   elseif SIZE == 16 then
       mem_code = "word_ptr["
   elseif SIZE == 32 then
       mem_code = "dword ptr["
   else
       mem_code = "["
   end
   
   local r_base = ""
   local r_index = ""
   local r_scale = ""
   local r_lval = ""

   if base ~= "" then
       r_base = rand_get_invalid_register(lock_r)
       Assemble ("mov " .. r_base .. "," .. get_register(base))
       lock_r[r_base] = r_base
   end
   
   if index ~= "" then
       r_index = rand_get_invalid_register(lock_r)
       Assemble ("mov " .. r_index .. "," .. get_register(index))
       lock_r[r_index] = r_index
   end
 
   if scale ~= 0 then
       r_scale = scale
   end
   
   if lval ~= 0 then
       r_lval = lval
   end
 
   if r_base ~= "" then
      mem_code = mem_code .. r_base
   end

   if r_base == "" and r_index ~= "" then
      mem_code = mem_code .. r_index
   elseif r_index ~= ""  then
      mem_code = mem_code .. "+" .. r_index
   end

   if r_scale ~= "" and r_scale ~= "00" then
      mem_code = mem_code .. "*" .. r_scale
   end
 
   if r_lval ~= "" and (r_base ~= "" or r_index ~= "") then
      mem_code = mem_code .. "+" .. r_lval
   else
      mem_code = mem_code .. r_lval
   end
   
   mem_code = mem_code  .. "]"
   return mem_code
end

function get_register_size(Register)
    if Register == "eax" then
        return 32
    elseif Register == "ebx" then
        return 32
    elseif Register == "ecx" then
        return 32
    elseif Register == "edx" then
        return 32
    elseif Register == "esp" then
        return 32
    elseif Register == "ebp" then
        return 32
    elseif Register == "esi" then
        return 32
    elseif Register == "edi" then
        return 32
    elseif Register == "ax" then
        return 16
    elseif Register == "bx" then
        return 16
    elseif Register == "cx" then
        return 16
    elseif Register == "dx" then
        return 16
    elseif Register == "sp" then
        return 16
    elseif Register == "bp" then
        return 16
    elseif Register == "si" then
        return 16
    elseif Register == "di" then
        return 16
    elseif Register == "al" then
        return 8
    elseif Register == "ah" then
        return 8
    elseif Register == "bl" then
        return 8
    elseif Register == "bh" then
        return 8
    elseif Register == "cl" then
        return 8
    elseif Register == "ch" then
        return 8
    elseif Register == "dl" then
        return 8
    elseif Register == "dh" then
        return 8
    end
end
function _3dnow()  OldCode()   end
function aaa()  OldCode()   end
function aad()  OldCode()   end
function aam()  OldCode()   end
function aas()  OldCode()   end
function adc()  OldCode()   end
function add()  OldCode()   end
function addpd()  OldCode()   end
function addps()  OldCode()   end
function addsd()  OldCode()   end
function addss()  OldCode()   end
function addsubpd()  OldCode()   end
function addsubps()  OldCode()   end
function _and()  OldCode()   end
function andpd()  OldCode()   end
function andps()  OldCode()   end
function andnpd()  OldCode()   end
function andnps()  OldCode()   end
function arpl()  OldCode()   end
function movsxd()  OldCode()   end
function bound()  OldCode()   end
function bsf()  OldCode()   end
function bsr()  OldCode()   end
function bswap()  OldCode()   end
function bt()  OldCode()   end
function btc()  OldCode()   end
function btr()  OldCode()   end
function bts()  OldCode()   end
function call()  OldCode()   end
function cbw()  OldCode()   end
function cwde()  OldCode()   end
function cdqe()  OldCode()   end
function clc()  OldCode()   end
function cld()  OldCode()   end
function clflush()  OldCode()   end
function clgi()  OldCode()   end
function cli()  OldCode()   end
function clts()  OldCode()   end
function cmc()  OldCode()   end
function cmovo()  OldCode()   end
function cmovno()  OldCode()   end
function cmovb()  OldCode()   end
function cmovae()  OldCode()   end
function cmovz()  OldCode()   end
function cmovnz()  OldCode()   end
function cmovbe()  OldCode()   end
function cmova()  OldCode()   end
function cmovs()  OldCode()   end
function cmovns()  OldCode()   end
function cmovp()  OldCode()   end
function cmovnp()  OldCode()   end
function cmovl()  OldCode()   end
function cmovge()  OldCode()   end
function cmovle()  OldCode()   end
function cmovg()  OldCode()   end
function cmp()  OldCode()   end
function cmppd()  OldCode()   end
function cmpps()  OldCode()   end
function cmpsb()  OldCode()   end
function cmpsw()  OldCode()   end
function cmpsd()  OldCode()   end
function cmpsq()  OldCode()   end
function cmpss()  OldCode()   end
function cmpxchg()  OldCode()   end
function cmpxchg8b()  OldCode()   end
function comisd()  OldCode()   end
function comiss()  OldCode()   end
function cpuid()  OldCode()   end
function cvtdq2pd()  OldCode()   end
function cvtdq2ps()  OldCode()   end
function cvtpd2dq()  OldCode()   end
function cvtpd2pi()  OldCode()   end
function cvtpd2ps()  OldCode()   end
function cvtpi2ps()  OldCode()   end
function cvtpi2pd()  OldCode()   end
function cvtps2dq()  OldCode()   end
function cvtps2pi()  OldCode()   end
function cvtps2pd()  OldCode()   end
function cvtsd2si()  OldCode()   end
function cvtsd2ss()  OldCode()   end
function cvtsi2ss()  OldCode()   end
function cvtss2si()  OldCode()   end
function cvtss2sd()  OldCode()   end
function cvttpd2pi()  OldCode()   end
function cvttpd2dq()  OldCode()   end
function cvttps2dq()  OldCode()   end
function cvttps2pi()  OldCode()   end
function cvttsd2si()  OldCode()   end
function cvtsi2sd()  OldCode()   end
function cvttss2si()  OldCode()   end
function cwd()  OldCode()   end
function cdq()  OldCode()   end
function cqo()  OldCode()   end
function daa()  OldCode()   end
function das()  OldCode()   end
function dec()  OldCode()   end
function div()  OldCode()   end
function divpd()  OldCode()   end
function divps()  OldCode()   end
function divsd()  OldCode()   end
function divss()  OldCode()   end
function emms()  OldCode()   end
function enter()  OldCode()   end
function f2xm1()  OldCode()   end
function fabs()  OldCode()   end
function fadd()  OldCode()   end
function faddp()  OldCode()   end
function fbld()  OldCode()   end
function fbstp()  OldCode()   end
function fchs()  OldCode()   end
function fclex()  OldCode()   end
function fcmovb()  OldCode()   end
function fcmove()  OldCode()   end
function fcmovbe()  OldCode()   end
function fcmovu()  OldCode()   end
function fcmovnb()  OldCode()   end
function fcmovne()  OldCode()   end
function fcmovnbe()  OldCode()   end
function fcmovnu()  OldCode()   end
function fucomi()  OldCode()   end
function fcom()  OldCode()   end
function fcom2()  OldCode()   end
function fcomp3()  OldCode()   end
function fcomi()  OldCode()   end
function fucomip()  OldCode()   end
function fcomip()  OldCode()   end
function fcomp()  OldCode()   end
function fcomp5()  OldCode()   end
function fcompp()  OldCode()   end
function fcos()  OldCode()   end
function fdecstp()  OldCode()   end
function fdiv()  OldCode()   end
function fdivp()  OldCode()   end
function fdivr()  OldCode()   end
function fdivrp()  OldCode()   end
function femms()  OldCode()   end
function ffree()  OldCode()   end
function ffreep()  OldCode()   end
function ficom()  OldCode()   end
function ficomp()  OldCode()   end
function fild()  OldCode()   end
function fncstp()  OldCode()   end
function fninit()  OldCode()   end
function fiadd()  OldCode()   end
function fidivr()  OldCode()   end
function fidiv()  OldCode()   end
function fisub()  OldCode()   end
function fisubr()  OldCode()   end
function fist()  OldCode()   end
function fistp()  OldCode()   end
function fisttp()  OldCode()   end
function fld()  OldCode()   end
function fld1()  OldCode()   end
function fldl2t()  OldCode()   end
function fldl2e()  OldCode()   end
function fldlpi()  OldCode()   end
function fldlg2()  OldCode()   end
function fldln2()  OldCode()   end
function fldz()  OldCode()   end
function fldcw()  OldCode()   end
function fldenv()  OldCode()   end
function fmul()  OldCode()   end
function fmulp()  OldCode()   end
function fimul()  OldCode()   end
function fnop()  OldCode()   end
function fpatan()  OldCode()   end
function fprem()  OldCode()   end
function fprem1()  OldCode()   end
function fptan()  OldCode()   end
function frndint()  OldCode()   end
function frstor()  OldCode()   end
function fnsave()  OldCode()   end
function fscale()  OldCode()   end
function fsin()  OldCode()   end
function fsincos()  OldCode()   end
function fsqrt()  OldCode()   end
function fstp()  OldCode()   end
function fstp1()  OldCode()   end
function fstp8()  OldCode()   end
function fstp9()  OldCode()   end
function fst()  OldCode()   end
function fnstcw()  OldCode()   end
function fnstenv()  OldCode()   end
function fnstsw()  OldCode()   end
function fsub()  OldCode()   end
function fsubp()  OldCode()   end
function fsubr()  OldCode()   end
function fsubrp()  OldCode()   end
function ftst()  OldCode()   end
function fucom()  OldCode()   end
function fucomp()  OldCode()   end
function fucompp()  OldCode()   end
function fxam()  OldCode()   end
function fxch()  OldCode()   end
function fxch4()  OldCode()   end
function fxch7()  OldCode()   end
function fxrstor()  OldCode()   end
function fxsave()  OldCode()   end
function fpxtract()  OldCode()   end
function fyl2x()  OldCode()   end
function fyl2xp1()  OldCode()   end
function haddpd()  OldCode()   end
function haddps()  OldCode()   end
function hlt()  OldCode()   end
function hsubpd()  OldCode()   end
function hsubps()  OldCode()   end
function idiv()  OldCode()   end
function _in()  OldCode()   end
function imul()  OldCode()   end
function inc()  OldCode()   end
function insb()  OldCode()   end
function insw()  OldCode()   end
function insd()  OldCode()   end
function int1()  OldCode()   end
function int3()  OldCode()   end
function int()  OldCode()   end
function into()  OldCode()   end
function invd()  OldCode()   end
function invlpg()  OldCode()   end
function invlpga()  OldCode()   end
function iretw()  OldCode()   end
function iretd()  OldCode()   end
function iretq()  OldCode()   end
function jo()  OldCode()   end
function jno()  OldCode()   end
function jb()  OldCode()   end
function jae()  OldCode()   end
function jz()  OldCode()   end
function jnz()  OldCode()   end
function jbe()  OldCode()   end
function ja()  OldCode()   end
function js()  OldCode()   end
function jns()  OldCode()   end
function jp()  OldCode()   end
function jnp()  OldCode()   end
function jl()  OldCode()   end
function jge()  OldCode()   end
function jle()  OldCode()   end
function jg()  OldCode()   end
function jcxz()  OldCode()   end
function jecxz()  OldCode()   end
function jrcxz()  OldCode()   end
function jmp()  OldCode()   end
function lahf()  OldCode()   end
function lar()  OldCode()   end
function lddqu()  OldCode()   end
function ldmxcsr()  OldCode()   end
function lds()  OldCode()   end
function lea()  OldCode()   end
function les()  OldCode()   end
function lfs()  OldCode()   end
function lgs()  OldCode()   end
function lidt()  OldCode()   end
function lss()  OldCode()   end
function leave()  OldCode()   end
function lfence()  OldCode()   end
function lgdt()  OldCode()   end
function lldt()  OldCode()   end
function lmsw()  OldCode()   end
function lock()  OldCode()   end
function lodsb()  OldCode()   end
function lodsw()  OldCode()   end
function lodsd()  OldCode()   end
function lodsq()  OldCode()   end
function loopnz()  OldCode()   end
function loope()  OldCode()   end
function loop()  OldCode()   end
function lsl()  OldCode()   end
function ltr()  OldCode()   end
function maskmovq()  OldCode()   end
function maxpd()  OldCode()   end
function maxps()  OldCode()   end
function maxsd()  OldCode()   end
function maxss()  OldCode()   end
function mfence()  OldCode()   end
function minpd()  OldCode()   end
function minps()  OldCode()   end
function minsd()  OldCode()   end
function minss()  OldCode()   end
function monitor()  OldCode()   end
function mov()
 
save_context()
   r2_reg = rand_get_register()
   while r2_reg == "esp" do
       r2_reg = rand_get_register()
   end

if op2_type == "REG" then
   if get_register(REG2) == 8 or get_register (REG2) == 16 then
        OldCode()
        return 
   end
   print ("reg:" .. REG2)
   get_register_size (REG2)
   Assemble ("mov ".. r2_reg .. "," .. get_register(REG2))
end

if op2_type == "IMM" then
   Assemble ("mov " .. r2_reg .. "," .. IMM2)
end

if op1_type == "REG" then
   if get_register(REG1) == 8 or get_register (REG1) == 16 then
        OldCode()
        return
   end
   Assemble ("mov " .. get_register(REG1) .. ",".. r2_reg)
end

local lock_r = {}
lock_r["esp"] = "esp"
lock_r[r2_reg] = r2_reg


if op1_type == "MEM" then
   if SIZE == 8 or SIZE == 16 then
        OldCode()
        return
   end
   Assemble ("mov " .. get_mem_code(BASE1,INDEX1,SCALE1,LVAL1,lock_r) .. "," .. r2_reg )
end

renew_context()
--rand_get_invalid_register(lock_r)


 

--print (Rand())
--trash_generate()
--Assemble ("mov eax,1")
--print (op1_type)
--if op1_type == "REG" then
--print ("REG is:".. REG1)
--elseif op1_type == "IMM" then
--print ("IMM is:".. IMM1)
--elseif op1_type == "MEM" then
--print ("BASE is:" .. BASE1)
--print ("INDEX is:" .. INDEX1)
--print ("SCALE is:" .. SCALE1)
--print ("LVAL is:" .. LVAL1)
--end
--OldCode()   
end
function movapd()  OldCode()   end
function movaps()  OldCode()   end
function movd()  OldCode()   end
function movddup()  OldCode()   end
function movdqa()  OldCode()   end
function movdqu()  OldCode()   end
function movdq2q()  OldCode()   end
function movhpd()  OldCode()   end
function movhps()  OldCode()   end
function movlhps()  OldCode()   end
function movlpd()  OldCode()   end
function movlps()  OldCode()   end
function movhlps()  OldCode()   end
function movmskpd()  OldCode()   end
function movmskps()  OldCode()   end
function movntdq()  OldCode()   end
function movnti()  OldCode()   end
function movntpd()  OldCode()   end
function movntps()  OldCode()   end
function movntq()  OldCode()   end
function movq()  OldCode()   end
function movqa()  OldCode()   end
function movq2dq()  OldCode()   end
function movsb()  OldCode()   end
function movsw()  OldCode()   end
function movsd()  OldCode()   end
function movsq()  OldCode()   end
function movsldup()  OldCode()   end
function movshdup()  OldCode()   end
function movss()  OldCode()   end
function movsx()  OldCode()   end
function movupd()  OldCode()   end
function movups()  OldCode()   end
function movzx()  OldCode()   end
function mul()  OldCode()   end
function mulpd()  OldCode()   end
function mulps()  OldCode()   end
function mulsd()  OldCode()   end
function mulss()  OldCode()   end
function mwait()  OldCode()   end
function neg()  OldCode()   end
function nop()  OldCode()   end
function _not()  OldCode()   end
function _or()  OldCode()   end
function orpd()  OldCode()   end
function orps()  OldCode()   end
function out()  OldCode()   end
function outsb()  OldCode()   end
function outsw()  OldCode()   end
function outsd()  OldCode()   end
function outsq()  OldCode()   end
function packsswb()  OldCode()   end
function packssdw()  OldCode()   end
function packuswb()  OldCode()   end
function paddb()  OldCode()   end
function paddw()  OldCode()   end
function paddq()  OldCode()   end
function paddsb()  OldCode()   end
function paddsw()  OldCode()   end
function paddusb()  OldCode()   end
function paddusw()  OldCode()   end
function pand()  OldCode()   end
function pandn()  OldCode()   end
function pause()  OldCode()   end
function pavgb()  OldCode()   end
function pavgw()  OldCode()   end
function pcmpeqb()  OldCode()   end
function pcmpeqw()  OldCode()   end
function pcmpeqd()  OldCode()   end
function pcmpgtb()  OldCode()   end
function pcmpgtw()  OldCode()   end
function pcmpgtd()  OldCode()   end
function pextrw()  OldCode()   end
function pinsrw()  OldCode()   end
function pmaddwd()  OldCode()   end
function pmaxsw()  OldCode()   end
function pmaxub()  OldCode()   end
function pminsw()  OldCode()   end
function pminub()  OldCode()   end
function pmovmskb()  OldCode()   end
function pmulhuw()  OldCode()   end
function pmulhw()  OldCode()   end
function pmullw()  OldCode()   end
function pmuludq()  OldCode()   end
function pop()  OldCode()   end
function popa()  OldCode()   end
function popad()  OldCode()   end
function popfw()  OldCode()   end
function popfd()  OldCode()   end
function popfq()  OldCode()   end
function por()  OldCode()   end
function prefetch()  OldCode()   end
function prefetchnta()  OldCode()   end
function prefetcht0()  OldCode()   end
function prefetcht1()  OldCode()   end
function prefetcht2()  OldCode()   end
function psadbw()  OldCode()   end
function pshufd()  OldCode()   end
function pshufhw()  OldCode()   end
function pshuflw()  OldCode()   end
function pshufw()  OldCode()   end
function pslldq()  OldCode()   end
function psllw()  OldCode()   end
function pslld()  OldCode()   end
function psllq()  OldCode()   end
function psraw()  OldCode()   end
function psrad()  OldCode()   end
function psrlw()  OldCode()   end
function psrld()  OldCode()   end
function psrlq()  OldCode()   end
function psrldq()  OldCode()   end
function psubb()  OldCode()   end
function psubw()  OldCode()   end
function psubd()  OldCode()   end
function psubq()  OldCode()   end
function psubsb()  OldCode()   end
function psubsw()  OldCode()   end
function psubusb()  OldCode()   end
function psubusw()  OldCode()   end
function punpckhbw()  OldCode()   end
function punpckhwd()  OldCode()   end
function punpckhdq()  OldCode()   end
function punpckhqdq()  OldCode()   end
function punpcklbw()  OldCode()   end
function punpcklwd()  OldCode()   end
function punpckldq()  OldCode()   end
function punpcklqdq()  OldCode()   end
function pi2fw()  OldCode()   end
function pi2fd()  OldCode()   end
function pf2iw()  OldCode()   end
function pf2id()  OldCode()   end
function pfnacc()  OldCode()   end
function pfpnacc()  OldCode()   end
function pfcmpge()  OldCode()   end
function pfmin()  OldCode()   end
function pfrcp()  OldCode()   end
function pfrsqrt()  OldCode()   end
function pfsub()  OldCode()   end
function pfadd()  OldCode()   end
function pfcmpgt()  OldCode()   end
function pfmax()  OldCode()   end
function pfrcpit1()  OldCode()   end
function pfrspit1()  OldCode()   end
function pfsubr()  OldCode()   end
function pfacc()  OldCode()   end
function pfcmpeq()  OldCode()   end
function pfmul()  OldCode()   end
function pfrcpit2()  OldCode()   end
function pmulhrw()  OldCode()   end
function pswapd()  OldCode()   end
function pavgusb()  OldCode()   end
function push()  OldCode()   end
function pusha()  OldCode()   end
function pushad()  OldCode()   end
function pushfw()  OldCode()   end
function pushfd()  OldCode()   end
function pushfq()  OldCode()   end
function pxor()  OldCode()   end
function rcl()  OldCode()   end
function rcr()  OldCode()   end
function rol()  OldCode()   end
function ror()  OldCode()   end
function rcpps()  OldCode()   end
function rcpss()  OldCode()   end
function rdmsr()  OldCode()   end
function rdpmc()  OldCode()   end
function rdtsc()  OldCode()   end
function rdtscp()  OldCode()   end
function repne()  OldCode()   end
function rep()  OldCode()   end
function ret()  --OldCode() 
Assemble("lea esp,[esp+4]")
Assemble("jmp dword ptr [esp-4]")
end
function retf()  OldCode()   end
function rsm()  OldCode()   end
function rsqrtps()  OldCode()   end
function rsqrtss()  OldCode()   end
function sahf()  OldCode()   end
function sal()  OldCode()   end
function salc()  OldCode()   end
function sar()  OldCode()   end
function shl()  OldCode()   end
function shr()  OldCode()   end
function sbb()  OldCode()   end
function scasb()  OldCode()   end
function scasw()  OldCode()   end
function scasd()  OldCode()   end
function scasq()  OldCode()   end
function seto()  OldCode()   end
function setno()  OldCode()   end
function setb()  OldCode()   end
function setnb()  OldCode()   end
function setz()  OldCode()   end
function setnz()  OldCode()   end
function setbe()  OldCode()   end
function seta()  OldCode()   end
function sets()  OldCode()   end
function setns()  OldCode()   end
function setp()  OldCode()   end
function setnp()  OldCode()   end
function setl()  OldCode()   end
function setge()  OldCode()   end
function setle()  OldCode()   end
function setg()  OldCode()   end
function sfence()  OldCode()   end
function sgdt()  OldCode()   end
function shld()  OldCode()   end
function shrd()  OldCode()   end
function shufpd()  OldCode()   end
function shufps()  OldCode()   end
function sidt()  OldCode()   end
function sldt()  OldCode()   end
function smsw()  OldCode()   end
function sqrtps()  OldCode()   end
function sqrtpd()  OldCode()   end
function sqrtsd()  OldCode()   end
function sqrtss()  OldCode()   end
function stc()  OldCode()   end
function std()  OldCode()   end
function stgi()  OldCode()   end
function sti()  OldCode()   end
function skinit()  OldCode()   end
function stmxcsr()  OldCode()   end
function stosb()  OldCode()   end
function stosw()  OldCode()   end
function stosd()  OldCode()   end
function stosq()  OldCode()   end
function str()  OldCode()   end
function sub()  OldCode()   end
function subpd()  OldCode()   end
function subps()  OldCode()   end
function subsd()  OldCode()   end
function subss()  OldCode()   end
function swapgs()  OldCode()   end
function syscall()  OldCode()   end
function sysenter()  OldCode()   end
function sysexit()  OldCode()   end
function sysret()  OldCode()   end
function test()  OldCode()   end
function ucomisd()  OldCode()   end
function ucomiss()  OldCode()   end
function ud2()  OldCode()   end
function unpckhpd()  OldCode()   end
function unpckhps()  OldCode()   end
function unpcklps()  OldCode()   end
function unpcklpd()  OldCode()   end
function verr()  OldCode()   end
function verw()  OldCode()   end
function vmcall()  OldCode()   end
function vmclear()  OldCode()   end
function vmxon()  OldCode()   end
function vmptrld()  OldCode()   end
function vmptrst()  OldCode()   end
function vmresume()  OldCode()   end
function vmxoff()  OldCode()   end
function vmrun()  OldCode()   end
function vmmcall()  OldCode()   end
function vmload()  OldCode()   end
function vmsave()  OldCode()   end
function wait()  OldCode()   end
function wbinvd()  OldCode()   end
function wrmsr()  OldCode()   end
function xadd()  OldCode()   end
function xchg()  OldCode()   end
function xlatb()  OldCode()   end
function xor()  OldCode()   end
function xorpd()  OldCode()   end
function xorps()  OldCode()   end
function db()  OldCode()   end
function invalid()  OldCode()   end
function d3vil()  OldCode()   end
function na()  OldCode()   end
function grp_reg()  OldCode()   end
function grp_rm()  OldCode()   end
function grp_vendor()  OldCode()   end
function grp_x87()  OldCode()   end
function grp_mode()  OldCode()   end
function grp_osize()  OldCode()   end
function grp_asize()  OldCode()   end
function grp_mod()  OldCode()   end
function none()  OldCode()   end