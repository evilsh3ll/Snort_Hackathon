import re, os, subprocess

def extract_rule_id(rule_line):
	""" Estrae l'ID della regola dalla linea. """
	match = re.search(r'sid:\s*(\d+)', rule_line)
	return match.group(1) if match else None
def extract_msg(rule_line):
	""" Estrae il messaggio della regola dalla linea. """
	match = re.search(r'msg:\s*"([^"]*)"', rule_line)
	return match.group(1) if match else None

def check_snort_rules(rules_file, log_file):
	# Contatori per le regole
	sid_ftpbrute = 0
	rules_set = set()

    # Legge le regole
	with open(rules_file, 'r') as f:
		for line in f:
			rule_id=0
			msg=0
			if '21' in line and 'flags:P' in line and 'content' in line and "threshold" in line and 'count' in line and line.startswith("alert tcp"):
				#print("flag FPU: "+ line)
				rule_id = extract_rule_id(line)
				msg = extract_msg(line)
				if rule_id and msg and sid_ftpbrute==0:
					sid_ftpbrute=rule_id
					rules_set.add(rule_id+"|"+msg)
	# Controlla che le regole attive siano loggate negli alert
	if sid_ftpbrute !=0:
		with open(log_file, 'r') as f:
			for line in f:
				# se il set si svuota, esci
				if not rules_set:
					break
				# per ogni id, controlla se c'è nella linea e poi rimuovilo
				for rule in rules_set.copy():
					sid_r=rule.split("|")[0]
					msg_r=rule.split("|")[1]
					if sid_r in line and msg_r in line:
						rules_set.discard(rule)	
		if not rules_set:
			print("Livello 3 SUPERATO!")
			print("PASSWORD per il Livello 3: P@ck3TSh1ffeR")
			subprocess.run(['killall','bash','sleep'], capture_output=True, text=True)
			print("Processi del level3 killati. Puoi procedere con il livello successivo.")
			os._exit(0)
	print ("Livello 3 non ancora superato. Aspetta sempre 10-15sec che i log si aggiornino.")
	os._exit(0)

# Percorsi dei file
rules_file = '/etc/snort/rules/local.rules'
log_file = '/var/log/snort/alert'

# Errori
if not os.path.exists(rules_file) or not os.path.isfile(rules_file):
	print("ERRORE: non hai scritto il file delle regole Snort. Questo è necessario per la valutazione")
	os._exit(0)
if not os.path.exists(log_file) or not os.path.isfile(log_file):
	print("ERRORE: non hai avviato Snort con gli alert log verbosi <-A full>. Questo è necessario per la valutazione")
	os._exit(0)

check_snort_rules(rules_file, log_file)
