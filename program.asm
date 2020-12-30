#------------------------------------------------------------------------------------
# ALUNOS: Gustavo, João, Maurilio, Taciano
#------------------------------------------------------------------------------------

.data
	arquivoEntrada: .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.in" 
	arquivoSaida: .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.out"  
	
	mensagemFim: .asciiz "------------- FIM PROCESSAMENTO -------------------"  
	mensagemTeste: .asciiz " TESTO ALTERADO"  
	
	conteudoArquivo: .space  1024
	
.text

	jal lerArquivoEntrada			# Le o conteudo do arquivo
	move $s0, $v1				# Transfere o texto
	
	move $a0, $s0
	jal imprimirString			# Imprime a String
	
	move $a0, $s0				# Transfere o texto
	jal processarConteudoArquivo		# Processa a String
	move $s1, $v1				# Transfere o texto

	move $a0, $s1	
	jal imprimirString			# Imprime a String	
	
	move $a2, $v1
	jal gravarArquivoSaida			# Imprime a String
	
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
		la $a1, conteudoArquivo		# transfere o buffer para textFile 	
		li $a2, 1024   			# tamanho maximo do buffer
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
		move $v1, $a0	
		la $a0, mensagemTeste
		move $v1, $a0	
		
		jr $ra	
									

	#--------------------------------------------------------------------------------------
	# GRAVAR CONTEUDO NO ARQRUIVO DE SAIDA 
	# Recebe o valor no registrador $a2
	#--------------------------------------------------------------------------------------	
	gravarArquivoSaida:				# Funcao para gravar o arquivo de leitura 
	
		move $s2,$a2
	
		# Abre o arquivo
		li $v0, 13 			# syscall para abrir o arquivo 
		la $a0,arquivoSaida    		# nome do arquivo
		li $a1,1 			# 0: leitura 1: escrita
		syscall 
		move $s1,$v0			
		
		# Escreve o arquivo
		li $v0, 15 			# syscall para escrever do arquivo
		move $a0,$s1
		
		move $a1, $s2		# transfere o buffer para textFile 	
		li $a2, 1024   			# tamanho maximo do buffer
		syscall
		
		move $v1, $a1

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