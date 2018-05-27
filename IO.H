.XLIST      ;   turn off listing
;;   header file for assembly language programs
;;   contains macro definitions for itoa, atoi, output, inputs and inputc
;;   author: R. Detmer

            EXTRN itoa_proc:far, atoi_proc:far, out_proc: far
            EXTRN ins_proc:far, inc_proc:far
m_error     MACRO msg
                  IF2
                  %OUT msg
                  .LALL

COMMENT *
        msg
* End COMMENT
            .ERR
            .SALL
            ENDIF
            ENDM

itoa        MACRO dest,source,xtra  ;; convert inteqer to ASCII string

            IFB   <source>
            m_error<missing operand(s) in ITOA>
            EXITM
            ENDIF

            IFNB   <xtra>
            m_error <extra operand(s) in lTOA>
            EXITM
            ENDIF

            push  ax	                             	 ;; save AX
            push  di	                             	 ;; save DI
            mov  ax,source	                  ;; copy source to AX
            lea	  di,dest	                     	 ;; destination address to DI
            call  itoa_proc	                  ;; call procedure
            pop	  di	                  ;; restore DI
            pop	  ax	                  ;; restore AX
            ENDM			

atoi	    MACRO source,xtra	   ;; convert ASCII string to integer in AX

            IFB	  <source>
 	    m_error <missing operand in ATOI>
            EXITM			
 	    ENDIF			
 	


            IFNB  <xtra>		
            m_error <extra operand(s) in ATOI>
 	    EXITM			
 	    ENDIF			
 	
            push  si	                              ;; save SI
 	    lea	  si,source	             ;; source address to 81
 	    call  atoi_proc	             ;; call procedure
            pop	  si	             ;; restore SI
 	    ENDM			

output	    MACRO string,length,xtra	              ;; display macro
            IFB	  <string>		
 	    m_error<missing operand in OUTPUT>
 	    EXITM			
 	    ENDIF			

 	    IFNB  <xtra>		
            m_error <extra operand(s)	in OUTPUT>
 	    EXITM			
 	    ENDIF			
 	
            push  ax	                              ;; save AX
            push  si	                              ;; save SI
 	    lea	  si,string	                      ;; load address of source string

            IFB	  <length>	                      ;; IF no length parameter
            mov   ax,0                                ;; set length to zero
 	    ELSE		                      ;; ELSE
            mov	  ax,length	                      ;; copy length to AX
 	    ENDIF
 	    call  out_proc                            ;; call proc9dure
	    pop	  si	                              ;; restore SI
	    pop	  ax	                              ;; restore AX
            ENDM

inputs	    MACRO dest,length,xtra	              ;; read string from keyboard
            
            IFB   <length>
            m_error <missing operand(s) in INPUTS> 
            EXITM
            ENDIF

            IFNB  <xtra>
            m_error <extra operand(s) in INPUTS>
            EXITM
            ENDIF
	
            push  di	                              ;; save ex
            lea	  di,dest	                      ;; destination address
	    mov	  cx,length 	                      ;; length of buffer
	    call  ins_proc	                      ;; call procedure
	    pop	  di	                              ;; restore DX
            ENDM

inputc	    MACRO xtra	                              ;; read character fram keyboard to AL
            IFNB  <xtra>
            m_error <extra operand(s) in INPUTC>
            EXITM
            ENDIF
	    call  inc_proc	                      ;; call procedure
	    ENDM
.SALL              ;; suppress macro expansion listings
.LIST	           ;; begin listing