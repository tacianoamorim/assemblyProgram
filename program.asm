#------------------------------------------------------------------------------------
# ALUNOS: Gustavo, João, Maurilio, Taciano
#------------------------------------------------------------------------------------

.data
	arquivoEntrada: .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.in" 
	arquivoSaida: .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.out"  
	
	# temporario
	mpi: .asciiz "\n->PROCESSAMENTO INICIADO "  
	mla: .asciiz "\n->LENDO O ARQUIVO " 
	mga: .asciiz "\n->GRAVANDO O ARQUIVO "
	mpt: .asciiz "\n->PROCESSANDO O TEXTO "	
	mpf: .asciiz "\n->PROCESSAMENTO FINALIZADO "  
	ml: .asciiz "\n->- - - - - - - - - - - - - - - - - - - - - - - - -  "  
	
	
	textoNovo: 		.space 65
	textoLido:  	.space 65
	
	tamanhoString:    .word 65	
 
	
.text
	# INICIA AS VARIAVEIS
	move $t2, $zero
	lw $t9, tamanhoString
	sub $t9, $t9, 1

	la $a0, mpi
	jal imprimirString			# Imprime PROCESSAMENTO INICIADO

	la $a0, mla
	jal imprimirString			# Imprime LENDO O ARQUIVO
	
	jal lerArquivoEntrada			# Le o conteudo do arquivo
	move $s7, $v1				# Transfere o texto

	la $a0, ml
	jal imprimirString			# Imprime Linha		
		
	la $a0, textoLido
	jal imprimirString			# Imprime a String		
	
	la $a0, ml
	jal imprimirString			# Imprime Linha				
		
	la $a0, mpt
	jal imprimirString			# Imprime PROCESSANDO O TEXTO
		
#	move $a0, $s7				# Transfere o texto
	jal processarConteudoArquivo		# Processa a String
	
	la $a0, ml
	jal imprimirString			# Imprime Linha		
		
	la $a0, textoNovo
	jal imprimirString			# Imprime a String	

	la $a0, mga
	jal imprimirString			# Imprime GRAVANDO O ARQUIVO
	
	move $a2, $v1
	jal gravarArquivoSaida			# Grava o texto processando no arquivo
	
	la $a0, mpf
	jal imprimirString			# Imprime PROCESSAMENTO FINALIZADO
	
	jal encerrarPrograma			# Finaliza o programa

	
	#--------------------------------------------------------------------------------------
	# LE CONTEUDO DO ARQRUIVO DE ENTRADA 
	# Retorna valor no registrador $v1
	#--------------------------------------------------------------------------------------	
	lerArquivoEntrada:				# Funcao para abrir o arquivo de leitura 
		# Abre o arquivo
		li $v0, 13 			# syscall para abrir o arquivo 
		la $a0,arquivoEntrada    	# nome do arquivo
		li $a1,0 			# 0: leitura 1: escrita
		syscall 			
		
		move $s0, $v0 			# salva a descrição do arquivo

		# Ler o arquivo
		move $a0, $s0 
		li $v0, 14 			# syscall para ler do arquivo
		la $a1, textoLido		# transfere o buffer para textFile 	
		la $a2, tamanhoString  			# tamanho maximo do buffer
		syscall
		
		move $v1, $a1

		# fechar o arquivo
		li $v0, 16			# syscall para fechar o arquivo 
		move $a0, $s0
		syscall	
		
		jr $ra				# retorna para a  

	
	#--------------------------------------------------------------------------------------
	# PROCESSA A STRING 
	# Recebe o valor no registrador $a0
	# Retorna valor no registrador $v1
	#--------------------------------------------------------------------------------------	
	processarConteudoArquivo:
		move $s1, $a0
		
		jal converteTexto
		
		#la $a0, textoNovo	
		#jal imprimirString			# Imprime a String	

		#move $v1, $s2
		
		jr $ra	
			
	#--------------------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA 
	# Recebe o valor no registrador 
	# Retorna valor no registrador $v1
	#--------------------------------------------------------------------------------------		
	converteTexto:
		lb $t1, textoLido($t2) #LOAD BYTE a BYTE#================== MAGICA ======================
		
		sge $t4, $t1, 97 # PELA TABELA ASCII
		sle $t5, $t2, 122 # OS MINUSCULOS
		and $t3, $t4, $t5 # ESTAO ENTRE [97;122]# T3 = LETRA MINUSCULA ???
		beq $t3, 1, minusculo #CONVERTE!
		
		sge $t4, $t1, 65 # PELA TABELA ASCII
		sle $t5, $t2, 90 # OS MAIUSCULOS
		and $t3, $t4, $t5 # ESTAO ENTRE [65;90]# T3 = LETRA MAISCULA ???
		beq $t3, 1, maisculo #CONVERTE!

		bne $t2, $a0, converteTexto # SE NAO CHEGOU NO LIMITE, CONTINUA		

		# SE CHEGOU NO LIMITE
		move $v1, $t1
		jr $ra
		
	#--------------------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA 
	# Recebe o valor no registrador $
	# Retorna valor no registrador $
	#--------------------------------------------------------------------------------------				
	maisculo:
		add $t1, $t1, 32 # CONVERSAO MAIUSCULO MINUSCULO
		j atualizaTexto # RETORNA


	#--------------------------------------------------------------------------------------
	# RETORNA A LETRA MINUSCULA 
	# Recebe o valor no registrador $
	# Retorna valor no registrador $
	#--------------------------------------------------------------------------------------	
	minusculo:
		sub $t1, $t1, 32 # CONVERSAO MAIUSCULO MINUSCULO
		j atualizaTexto # RETORNA	

	#--------------------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA 
	# Recebe o valor no registrador $
	# Retorna valor no registrador $
	#--------------------------------------------------------------------------------------			
	atualizaTexto:
		sub $t7, $t9, $t2 # SUBTRAI O INDEXADOR DE SALVAMENTO ( PERCEBA QUE ESSE ESQUEMA INVERTE A STRING! )
		sb $t1, textoNovo($t7) # SALVA (INVERTIDO)
		addi $t2, $t2, 1 # INCREMENTA O INDEXADOR DE LEITURA!
		addi $a0, $t9, 1 # UM REGISTRADOR PERMANENTE PARA GUARDAR O LIMITE SUPERIOR
		bne $t2, $a0, converteTexto # SE NAO CHEGOU NO LIMITE, CONTINUA		


	#--------------------------------------------------------------------------------------
	# GRAVAR CONTEUDO NO ARQRUIVO DE SAIDA 
	# Recebe o valor no registrador $a2
	#--------------------------------------------------------------------------------------	
	gravarArquivoSaida:		# Funcao para gravar o arquivo de leitura 
	
		move $s2,$a2
	
		# Abre o arquivo
		li $v0, 13 			# syscall para abrir o arquivo 
		la $a0,arquivoSaida 		# nome do arquivo
		li $a1,1 			# 0: leitura 1: escrita
		syscall 
		move $s1,$v0			
		
		# Escreve o arquivo
		li $v0, 15 			# syscall para escrever do arquivo
		move $a0,$s1
		
		la $a1, textoNovo		# transfere o buffer para textFile 	
		la $a2, 65  		# tamanho maximo do buffer
		syscall
		
		#move $v1, $a1

		# fechar o arquivo
		li $v0, 16			# syscall para fechar o arquivo 
		move $a0, $s1
		syscall	
		jr $ra				# retorna para a  
	
			
	#--------------------------------------------------------------------------------------
	# IMPRIME UM TEXTO
	# Imprime o que estiver no registrador $a0
	#--------------------------------------------------------------------------------------					
	imprimirString: 
		# Imprime o conteudo do arquivo
		li $v0, 4			# syscall para impressao
		syscall 
		jr $ra	
		

	#--------------------------------------------------------------------------------------
	# ENCERRA O PROGRAMA 
	#--------------------------------------------------------------------------------------	
	encerrarPrograma: 
		li $v0, 10
		syscall 	
